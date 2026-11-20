//ORIGINAL FILE: code/game/atoms_movable.dm
/atom/movable
	/// name of what we bloop with, null for the silent ones
	var/blooper
	/// bloop pitch
	var/blooper_pitch = 1

//ORIGINAL FILE: code/game/say.dm
/atom/movable/do_tts_message(message, language, message_mods, list/tts_filter, list/hearers)
	. = ..()
	// voice gets first dibs, bloops take the rest
	say_blooper(message, message_mods, hearers, radio = FALSE)

/**
 * bloops a message, unless a voice already speaks it
 *
 * arguments:
 * * message - what was said
 * * message_mods - its modifiers
 * * hearers - who heard it, only mobs get bloops
 * * radio - came over the radio
 */
/atom/movable/proc/say_blooper(message, list/message_mods, list/hearers, radio)
	// voice has the mic, hands talk, or a mystery speaker
	if((SStts.tts_enabled && voice) || isnull(blooper) || HAS_TRAIT(src, TRAIT_SIGN_LANG) || HAS_TRAIT(src, TRAIT_UNKNOWN_VOICE) || LAZYACCESS(message_mods, MODE_CUSTOM_SAY_ERASE_INPUT))
		return
	var/turf/source = get_turf(src)
	var/list/bloop_hearers = list()
	for(var/mob/hearer in hearers)
		// asleep, or talking into your own headset
		if(radio && (hearer == src || IS_UNCONSCIOUS(hearer)))
			continue
		// ghost ears catch the whole station, bloops stay local
		if(!radio && get_dist(hearer, source) > MESSAGE_RANGE)
			continue
		bloop_hearers += hearer
	// gas mask on? bloop through a sock
	var/list/voice_filters = list()
	get_tts_voice(voice_filters, list())
	var/muffled = length(voice_filter) > 0 || length(voice_filters) > 0
	var/datum/blooper/blooper_sounds = GLOB.bloopers[blooper]
	var/sound_file
	if(radio)
		sound_file = muffled ? blooper_sounds.radio_muffled_sound : blooper_sounds.radio_sound
	else
		sound_file = muffled ? blooper_sounds.muffled_sound : blooper_sounds.sound
	play_blooper(
		bloop_hearers,
		speaker = src,
		sound_file = sound_file,
		pitch = blooper_pitch,
		message = message,
		radio = radio,
	)
