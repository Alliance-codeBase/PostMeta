/// a bloop sound and its prerendered filtered takes
/datum/blooper
	/// shown in the prefs
	var/name
	/// the clean take
	var/sound
	/// through a gas mask and co
	var/muffled_sound
	/// band-limited and crunchy
	var/radio_sound
	/// gas mask over the radio, the worst of both
	var/radio_muffled_sound

/datum/blooper/beep
	name = "Beep"
	sound = 'sound/machines/nuke/general_beep.ogg'
	muffled_sound = 'modular_meta/features/blooper/sound/beep_muffled.ogg'
	radio_sound = 'modular_meta/features/blooper/sound/beep_radio.ogg'
	radio_muffled_sound = 'modular_meta/features/blooper/sound/beep_radio_muffled.ogg'

/datum/blooper/bloop
	name = "Bloop"
	sound = 'sound/misc/bloop.ogg'
	muffled_sound = 'modular_meta/features/blooper/sound/bloop_muffled.ogg'
	radio_sound = 'modular_meta/features/blooper/sound/bloop_radio.ogg'
	radio_muffled_sound = 'modular_meta/features/blooper/sound/bloop_radio_muffled.ogg'

/datum/blooper/chirp
	name = "Chirp"
	sound = 'sound/runtime/chatter/griffin_1.ogg'
	muffled_sound = 'modular_meta/features/blooper/sound/chirp_muffled.ogg'
	radio_sound = 'modular_meta/features/blooper/sound/chirp_radio.ogg'
	radio_muffled_sound = 'modular_meta/features/blooper/sound/chirp_radio_muffled.ogg'

/datum/blooper/hoot
	name = "Hoot"
	sound = 'sound/runtime/chatter/owl_1.ogg'
	muffled_sound = 'modular_meta/features/blooper/sound/hoot_muffled.ogg'
	radio_sound = 'modular_meta/features/blooper/sound/hoot_radio.ogg'
	radio_muffled_sound = 'modular_meta/features/blooper/sound/hoot_radio_muffled.ogg'

/datum/blooper/quack
	name = "Quack"
	sound = 'sound/effects/quack.ogg'
	muffled_sound = 'modular_meta/features/blooper/sound/quack_muffled.ogg'
	radio_sound = 'modular_meta/features/blooper/sound/quack_radio.ogg'
	radio_muffled_sound = 'modular_meta/features/blooper/sound/quack_radio_muffled.ogg'

/datum/blooper/squeak
	name = "Squeak"
	sound = 'sound/items/toy_squeak/toysqueak1.ogg'
	muffled_sound = 'modular_meta/features/blooper/sound/squeak_muffled.ogg'
	radio_sound = 'modular_meta/features/blooper/sound/squeak_radio.ogg'
	radio_muffled_sound = 'modular_meta/features/blooper/sound/squeak_radio_muffled.ogg'

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
/// pitch spread around the speaker's own
#define BLOOPER_PITCH_VARIANCE 0.2

/**
 * bloops a message at hearers, one per few letters
 *
 * arguments:
 * * hearers - mobs that get the sound
 * * source - where it comes from, null for straight into the ear
 * * sound_file - one bloop
 * * pitch - frequency multiplier
 * * message - its length sets the bloop count
 */
/proc/play_blooper(list/hearers, turf/source, sound_file, pitch, message)
	// every few letters earn a bloop, novels get cut
	var/bloop_count = min(round(length_char(message) / BLOOPER_CHARACTERS_PER_BLOOP) + 1, BLOOPER_MAX_BLOOPS)
	for(var/i in 1 to bloop_count)
		// a little wobble, nobody likes a dial tone
		var/bloop_pitch = pitch + BLOOPER_PITCH_VARIANCE * (rand() - 0.5)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(bloop), hearers, source, sound_file, bloop_pitch), (i - 1) * BLOOPER_INTERVAL)

#undef BLOOPER_CHARACTERS_PER_BLOOP
#undef BLOOPER_MAX_BLOOPS
#undef BLOOPER_INTERVAL
#undef BLOOPER_PITCH_VARIANCE

/// bloop loudness before the listener's slider
#define BLOOPER_VOLUME 60

/// one bloop for everyone in hearers, args as in [/proc/play_blooper]
/proc/bloop(list/hearers, turf/source, sound_file, pitch)
	for(var/mob/listener as anything in hearers)
		listener.playsound_local(
			source,
			soundin = sound_file,
			vol = BLOOPER_VOLUME,
			vary = TRUE,
			frequency = pitch,
			max_distance = SOUND_RANGE,
			volume_preference = /datum/preference/numeric/volume/sound_blooper_volume,
		)

#undef BLOOPER_VOLUME
