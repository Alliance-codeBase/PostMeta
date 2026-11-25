//ORIGINAL FILE: code/game/atoms_movable.dm
/atom/movable
	// Bloopers
	/// The current mob's stored ID for their blooper. ID of a datum.
	var/blooper
	/// The pitch pre-variation.
	var/blooper_pitch = 1
	/// what's left of the last line on each channel, a frequency or "out loud", the next line talks over it
	var/list/unsaid_bloops

//ORIGINAL FILE: code/game/say.dm
/atom/movable/do_tts_message(message, language, message_mods, list/tts_filter, list/hearers)
	. = ..()
	// voice gets first dibs, bloops take the rest
	say_blooper(message, message_mods, hearers, frequency = null)

/**
 * bloops a message, unless a voice already speaks it
 *
 * arguments:
 * * message - what was said
 * * message_mods - its modifiers
 * * hearers - who heard it, only mobs get bloops
 * * frequency - the radio frequency it came over, null when said out loud
 */
/atom/movable/proc/say_blooper(message, list/message_mods, list/hearers, frequency)
	// voice has the mic, hands talk, or a mystery speaker
	if((SStts.tts_enabled && voice) || isnull(blooper) || HAS_TRAIT(src, TRAIT_SIGN_LANG) || HAS_TRAIT(src, TRAIT_UNKNOWN_VOICE) || LAZYACCESS(message_mods, MODE_CUSTOM_SAY_ERASE_INPUT))
		return
	var/radio = !isnull(frequency)
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
	// silicon radio chatter passes nobody in
	if(!length(bloop_hearers))
		return
	// gas mask on? bloop through a sock
	var/list/voice_filters = list()
	get_tts_voice(voice_filters, list())
	var/muffled = length(voice_filter) > 0 || length(voice_filters) > 0
	var/datum/blooper/blooper_sounds = pick(GLOB.blooper_voices[blooper])
	var/sound_file
	if(radio)
		sound_file = muffled ? blooper_sounds.radio_muffled_sound : blooper_sounds.radio_sound
	else
		sound_file = muffled ? blooper_sounds.muffled_sound : blooper_sounds.sound
	var/list/bloops = play_blooper(
		bloop_hearers,
		speaker = src,
		sound_file = sound_file,
		pitch = blooper_pitch,
		message = message,
		radio = radio,
	)
	// one line at a time per channel, an open intercom on another frequency won't cut the headset
	var/channel = radio ? "[frequency]" : "out loud"
	var/list/unsaid = LAZYACCESS(unsaid_bloops, channel)
	LAZYCLEARLIST(unsaid)
	LAZYSET(unsaid_bloops, channel, bloops)
