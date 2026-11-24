"""
renders a blooper voice into modular_meta/features/blooper/sound: the clean take plus
its gas mask, radio and radio-through-a-gas-mask copies, all at one loudness; needs ffmpeg on PATH
"""

import argparse
import re
import subprocess
from pathlib import Path

SOUND_DIRECTORY = Path(__file__).resolve().parent.parent / "features" / "blooper" / "sound"

TARGET_LOUDNESS = -16
# clicks too short to reach the target stay quieter instead of getting squashed flat
MAXIMUM_LIMITING_DECIBELS = 6
LIMITER = "alimiter=limit=0.98:level=0:latency=1"
MONO = "aformat=sample_rates=44100:channel_layouts=mono"
# volumedetect works in 16 bit and never sees past 0 dB, astats does
PEAK_METER = "astats=measure_perchannel=none:measure_overall=Peak_level"
# five bloops 0.15 s apart, the way the game plays them, see BLOOPER_INTERVAL
BLOOP_TRAIN = "aecho=1:1:150|300|450|600:1|1|1|1,apad=pad_dur=0.5"

# same lowpass the tts puts on a gas mask
MUFFLED_FILTER = "lowpass=f=750,volume=2"
# phone band, six bits of sand and a hard clip on top
RADIO_FILTER = "highpass=f=300,lowpass=f=3000,acrusher=bits=6:mode=log:mix=0.6,asoftclip=type=hard:threshold=0.5"

FILTERS_BY_SUFFIX = {
    "_muffled": MUFFLED_FILTER,
    "_radio": RADIO_FILTER,
    # mask first, then the radio, the way the sound actually travels
    "_radio_muffled": f"{MUFFLED_FILTER},{RADIO_FILTER}",
}


def ffmpeg(*arguments):
    result = subprocess.run(["ffmpeg", "-hide_banner", "-y", *arguments], capture_output=True, encoding="utf-8", errors="replace")
    if result.returncode != 0:
        raise SystemExit(result.stderr)
    return result.stderr


def measure(source, audio_filter):
    """loudness of a bloop train in LUFS and peak of a single bloop in dBFS"""
    log = ffmpeg("-i", source, "-af", f"{MONO},{audio_filter},{PEAK_METER},{BLOOP_TRAIN},ebur128", "-f", "null", "-")
    loudness = float(re.findall(r"^\s+I:\s+(-?[0-9.]+)", log, re.MULTILINE)[-1])
    peak = float(re.search(r"Peak level dB: (-?[0-9.]+)", log).group(1))
    return loudness, peak


def render(source, audio_filter, output):
    loudness, peak = measure(source, audio_filter)
    maximum_gain = MAXIMUM_LIMITING_DECIBELS - peak
    gain = min(TARGET_LOUDNESS - loudness, maximum_gain)
    # the limiter eats some loudness, one more look wins it back
    loudness, _ = measure(source, f"{audio_filter},volume={gain}dB,{LIMITER}")
    gain = min(gain + TARGET_LOUDNESS - loudness, maximum_gain)
    ffmpeg("-i", source, "-af", f"{MONO},{audio_filter},volume={gain}dB,{LIMITER}", "-c:a", "libvorbis", "-q:a", "5", output)
    print(output)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", help="any sound ffmpeg can read")
    parser.add_argument("blooper_id", help="file name without extension, like quack")
    arguments = parser.parse_args()

    clean_take = SOUND_DIRECTORY / f"{arguments.blooper_id}.ogg"
    render(arguments.source, "anull", clean_take)
    # the radio crunch depends on how loud it is fed, so every copy is cut from the leveled clean take
    for suffix, audio_filter in FILTERS_BY_SUFFIX.items():
        render(clean_take, audio_filter, SOUND_DIRECTORY / f"{arguments.blooper_id}{suffix}.ogg")


if __name__ == "__main__":
    main()
