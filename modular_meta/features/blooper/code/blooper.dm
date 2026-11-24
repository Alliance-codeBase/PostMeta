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
	/// blooper types to voice a message instead, one picked per message
	var/list/collection

/// the blooper that voices one message for the chosen name, a collection hands it to a random member
/proc/pick_blooper_voice(blooper_name)
	var/datum/blooper/voice = GLOB.bloopers[blooper_name]
	// a plain voice speaks for itself
	if(isnull(voice.collection))
		return voice
	var/datum/blooper/member_type = pick(voice.collection)
	return GLOB.bloopers[initial(member_type.name)]

// Code for bloopers

/// bloopers by name
GLOBAL_LIST_INIT(bloopers, init_bloopers())

/// one of each blooper, keyed by name
/proc/init_bloopers()
	var/list/bloopers = list()
	for(var/blooper_type in subtypesof(/datum/blooper))
		var/datum/blooper/blooper = new blooper_type
		bloopers[blooper.name] = blooper
	return bloopers

/// letters per bloop
#define BLOOPER_CHARACTERS_PER_BLOOP 4
/// bloops per message, tops
#define BLOOPER_MAX_BLOOPS 10
/// gap between bloops
#define BLOOPER_INTERVAL (0.15 SECONDS)
/// The +/- modifier for the pitch.
#define BLOOPER_PITCH_VARIANCE 0.2

/**
 * bloops a message at hearers, one per few letters
 *
 * arguments:
 * * hearers - mobs that get the sound
 * * speaker - who bloops, null for a plain sound
 * * sound_file - one bloop
 * * pitch - frequency multiplier
 * * message - its length sets the bloop count
 * * radio - over the radio, straight into the ear and quieter
 */
/proc/play_blooper(list/hearers, atom/movable/speaker, sound_file, pitch, message, radio)
	var/bloop_count = min(round(length_char(message) / BLOOPER_CHARACTERS_PER_BLOOP) + 1, BLOOPER_MAX_BLOOPS) // Limit this for performance. Less timers.
	for(var/i in 1 to bloop_count)
		// a little wobble, nobody likes a dial tone
		var/bloop_pitch = pitch + BLOOPER_PITCH_VARIANCE * (rand() - 0.5)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(bloop), hearers, speaker, sound_file, bloop_pitch, radio), (i - 1) * BLOOPER_INTERVAL)

#undef BLOOPER_CHARACTERS_PER_BLOOP
#undef BLOOPER_MAX_BLOOPS
#undef BLOOPER_INTERVAL
#undef BLOOPER_PITCH_VARIANCE

/// bloop loudness before the listener's slider
#define BLOOPER_VOLUME 60
/// 3/4 of the local bloops, like radio TTS out of the box
#define BLOOPER_RADIO_VOLUME (BLOOPER_VOLUME * 0.75)
/// your own bloops, 60 of 85 like your own TTS voice
#define BLOOPER_SELF_VOLUME (BLOOPER_VOLUME * 60 / 85)

/// one bloop for everyone in hearers, args as in [/proc/play_blooper]
/proc/bloop(list/hearers, atom/movable/speaker, sound_file, pitch, radio)
	var/turf/source = get_turf(speaker)
	// gibbed mid-sentence, the rest goes unsaid
	if(!isnull(speaker) && isnull(source))
		return
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
			vol = volume,
			vary = TRUE,
			frequency = pitch,
			max_distance = SOUND_RANGE,
			volume_preference = /datum/preference/numeric/volume/sound_blooper_volume,
		)

#undef BLOOPER_VOLUME
#undef BLOOPER_RADIO_VOLUME
#undef BLOOPER_SELF_VOLUME
