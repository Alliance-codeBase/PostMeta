/// Chat Sounds with configurable inputs.
/datum/blooper
	var/name // The string name of the blooper.
	var/sound // The path to the sound file to play.
	/// through a gas mask and co
	var/muffled_sound
	/// band-limited and crunchy
	var/radio_sound
	/// gas mask over the radio, the worst of both
	var/radio_muffled_sound
	/// labels like [BLOOPER_TAG_META], the picker sorts by them
	var/list/tags

/// one voice of several bloopers, every message picks one of them
/datum/blooper_collection
	/// what the picker calls it
	var/name
	/// blooper types to pick from
	var/list/bloopers

// Code for bloopers

/// the picker's voices by name, each a list of bloopers, every message picks one
GLOBAL_LIST_INIT(blooper_voices, init_blooper_voices())

/// a voice for each blooper and each collection, keyed by name
/proc/init_blooper_voices()
	var/list/voices = list()
	var/list/bloopers_by_type = list()
	for(var/blooper_type in subtypesof(/datum/blooper))
		var/datum/blooper/blooper = new blooper_type
		bloopers_by_type[blooper_type] = blooper
		// a lone blooper is a voice of one
		voices[blooper.name] = list(blooper)
	for(var/collection_type in subtypesof(/datum/blooper_collection))
		var/datum/blooper_collection/collection = new collection_type
		var/list/members = list()
		for(var/member_type in collection.bloopers)
			members += bloopers_by_type[member_type]
		voices[collection.name] = members
	return voices

/// keys of one bloop in a line, play_blooper writes them, bloop reads them
#define BLOOP_PITCH "pitch"
#define BLOOP_LOUDNESS "loudness"
#define BLOOP_GAP "gap"

/// gap between bloops
#define BLOOPER_INTERVAL (0.15 SECONDS)
/// extra breath after a comma, dash, colon or semicolon
#define BLOOPER_COMMA_PAUSE (0.15 SECONDS)
/// extra breath after a sentence
#define BLOOPER_SENTENCE_PAUSE (0.3 SECONDS)
/// The +/- modifier for the pitch.
#define BLOOPER_PITCH_VARIANCE 0.2
/// ! stacks up to this many
#define BLOOPER_MAX_EXCLAMATIONS 3
/// loudness each ! adds, up close !!! hits the volume ceiling of 100
#define BLOOPER_EXCLAMATION_LOUDNESS 0.3
/// pitch each ! adds to the whole phrase, has to beat the wobble to be heard
#define BLOOPER_EXCLAMATION_LIFT 0.1

/**
 * bloops a message at hearers, one bloop per vowel, punctuation sets pauses and intonation
 *
 * arguments:
 * * hearers - mobs that get the sound
 * * speaker - who bloops, null for a plain sound
 * * sound_file - one bloop
 * * pitch - frequency multiplier
 * * message - its vowels set the bloop count, its punctuation the tune
 * * radio - over the radio, straight into the ear and quieter
 *
 * returns the bloops still to come, cut the list to shut the line up
 */
/proc/play_blooper(list/hearers, atom/movable/speaker, sound_file, pitch, message, radio)
	// marks count only before a space or the end, 3.14 and кто-то don't break a phrase
	var/static/regex/phrase_ends = regex(@"([.,!?;:…—–-]+)(?:\s+|$)")
	var/static/regex/vowels = regex(@"[аеёиоуыэюяaeiouy]", "gi")
	var/static/regex/spaces = regex(@"\s+")
	var/static/regex/digits = regex(@"[0-9]")
	// digits read out in russian, один is two bloops and четыре is three
	var/static/list/digit_syllables = list("0" = 1, "1" = 2, "2" = 1, "3" = 1, "4" = 3, "5" = 1, "6" = 1, "7" = 1, "8" = 2, "9" = 2)
	// pitch of the last bloops, from the second to last to the last
	var/static/list/question_tune = list(1.15, 1.3)
	var/static/list/exclamation_tune = list(1.2)
	var/static/list/sentence_tune = list(0.85)
	var/list/bloops = list()
	var/text = html_decode(message)
	var/text_end = length(text) + 1
	var/phrase_start = 1
	while(phrase_start < text_end)
		var/phrase_stop = text_end
		var/next_phrase_start = text_end
		var/marks = ""
		if(phrase_ends.Find(text, phrase_start))
			phrase_stop = phrase_ends.index
			next_phrase_start = phrase_ends.index + length(phrase_ends.match)
			marks = phrase_ends.group[1]
		var/phrase = copytext(text, phrase_start, phrase_stop)
		phrase_start = next_phrase_start

		var/syllables = 0
		for(var/word in splittext(phrase, spaces))
			var/word_syllables = length_char(word) - length_char(replacetext(word, vowels, ""))
			var/digit_found = digits.Find(word)
			while(digit_found)
				word_syllables += digit_syllables[digits.match]
				digit_found = digits.Find(word, digit_found + 1)
			// "hm" has no vowels and still gets a bloop
			if(length(word))
				syllables += max(word_syllables, 1)

		var/exclamations = min(length(marks) - length(replacetext(marks, "!", "")), BLOOPER_MAX_EXCLAMATIONS)
		var/loudness = 1 + BLOOPER_EXCLAMATION_LOUDNESS * exclamations
		var/lift = 1 + BLOOPER_EXCLAMATION_LIFT * exclamations
		var/list/tail_tune = list()
		var/pause = 0
		// ?! asks first and shouts second
		if(findtext(marks, "?"))
			tail_tune = question_tune
			pause = BLOOPER_SENTENCE_PAUSE
		else if(exclamations)
			tail_tune = exclamation_tune
			pause = BLOOPER_SENTENCE_PAUSE
		else if(findtext(marks, ".") || findtext(marks, "…"))
			tail_tune = sentence_tune
			pause = BLOOPER_SENTENCE_PAUSE
		// a comma or a dash just takes a breath
		else if(length(marks))
			pause = BLOOPER_COMMA_PAUSE

		for(var/syllable in 1 to syllables)
			var/tune = lift
			var/tail_position = length(tail_tune) - (syllables - syllable)
			if(tail_position > 0)
				tune *= tail_tune[tail_position]
			var/gap = BLOOPER_INTERVAL
			if(syllable == syllables)
				gap += pause
			UNTYPED_LIST_ADD(bloops, list(
				// a little wobble, nobody likes a dial tone
				BLOOP_PITCH = pitch * tune + BLOOPER_PITCH_VARIANCE * (rand() - 0.5),
				BLOOP_LOUDNESS = loudness,
				BLOOP_GAP = gap,
			))
	bloop(hearers, speaker, sound_file, radio, bloops)
	return bloops

#undef BLOOPER_INTERVAL
#undef BLOOPER_COMMA_PAUSE
#undef BLOOPER_SENTENCE_PAUSE
#undef BLOOPER_PITCH_VARIANCE
#undef BLOOPER_MAX_EXCLAMATIONS
#undef BLOOPER_EXCLAMATION_LOUDNESS
#undef BLOOPER_EXCLAMATION_LIFT

/// bloop loudness before the listener's slider
#define BLOOPER_VOLUME 60
/// 3/4 of the local bloops, like radio TTS out of the box
#define BLOOPER_RADIO_VOLUME (BLOOPER_VOLUME * 0.75)
/// your own bloops, 60 of 85 like your own TTS voice
#define BLOOPER_SELF_VOLUME (BLOOPER_VOLUME * 60 / 85)

/**
 * the next bloop of a line for everyone in hearers, then queues the one after
 *
 * arguments:
 * * hearers, speaker, sound_file, radio - as in [/proc/play_blooper]
 * * bloops - the rest of the line, each with its pitch, loudness and the gap after it
 */
/proc/bloop(list/hearers, atom/movable/speaker, sound_file, radio, list/bloops)
	// said it all, or a newer line talked over it
	if(!length(bloops))
		return
	var/turf/source = get_turf(speaker)
	// gibbed mid-sentence, the rest goes unsaid
	if(!isnull(speaker) && isnull(source))
		return
	var/list/next_bloop = popleft(bloops)
	for(var/mob/listener as anything in hearers)
		var/volume = BLOOPER_VOLUME
		if(radio)
			volume = BLOOPER_RADIO_VOLUME
		// your own voice is quieter from the inside
		else if(listener == speaker)
			volume = BLOOPER_SELF_VOLUME
		listener.playsound_local(
			(radio ? null : source), // radio goes straight into the ear
			soundin = sound_file,
			vol = volume * next_bloop[BLOOP_LOUDNESS],
			vary = TRUE,
			frequency = next_bloop[BLOOP_PITCH],
			max_distance = SOUND_RANGE,
			volume_preference = /datum/preference/numeric/volume/sound_blooper_volume,
		)
	if(length(bloops))
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(bloop), hearers, speaker, sound_file, radio, bloops), next_bloop[BLOOP_GAP])

#undef BLOOPER_VOLUME
#undef BLOOPER_RADIO_VOLUME
#undef BLOOPER_SELF_VOLUME

#undef BLOOP_PITCH
#undef BLOOP_LOUDNESS
#undef BLOOP_GAP
