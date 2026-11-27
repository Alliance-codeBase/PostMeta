//ORIGINAL FILE: code/game/atoms_movable.dm
/atom/movable
	// Bloopers
	/// voice name from the picker, a key of [GLOB.blooper_voices]
	var/blooper
	/// The pitch pre-variation.
	var/blooper_pitch = 1
	/// what's left of the last line on each channel, a frequency or "out loud", the next line talks over it
	var/list/unsaid_bloops

/// squeaks like source from now on, for clones, holograms and other borrowed bodies
/atom/movable/proc/copy_blooper_from(atom/movable/source)
	blooper = source.blooper
	blooper_pitch = source.blooper_pitch

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
 * * hearers - who heard it, bloops go to the mobs behind them
 * * frequency - the radio frequency it came over, null when said out loud
 */
/atom/movable/proc/say_blooper(message, list/message_mods, list/hearers, frequency)
	// a live voice has the mic, hands talk, or a mystery speaker
	if((SStts.tts_enabled && !SStts.tts_failing && voice) || isnull(blooper) || HAS_TRAIT(src, TRAIT_SIGN_LANG) || HAS_TRAIT(src, TRAIT_UNKNOWN_VOICE) || LAZYACCESS(message_mods, MODE_CUSTOM_SAY_ERASE_INPUT))
		return
	var/radio = !isnull(frequency)
	var/turf/source = get_turf(src)
	var/list/bloop_hearers = list()
	for(var/atom/movable/hearing_movable as anything in hearers)
		// dullahan heads and holopads hear on someone's behalf
		var/mob/hearer = hearing_movable.get_listening_mob()
		if(isnull(hearer))
			continue
		// asleep, talking into your own headset, or a ghost tuned to every channel at once
		if(radio && (hearer == src || IS_UNCONSCIOUS(hearer) || isobserver(hearer)))
			continue
		// ghost ears catch the whole station, bloops stay local
		if(!radio && get_dist(hearing_movable, source) > MESSAGE_RANGE)
			continue
		bloop_hearers |= hearer
	// silicon radio chatter passes nobody in
	if(!length(bloop_hearers))
		return
	// gas mask on? bloop through a sock
	var/list/voice_filters = list()
	get_tts_voice(voice_filters, list())
	var/muffled = length(voice_filters) > 0
	var/list/voice_and_pitch = get_speaking_blooper()
	var/datum/blooper/blooper_sounds = pick(GLOB.blooper_voices[voice_and_pitch[1]])
	var/sound_file
	if(radio)
		sound_file = muffled ? blooper_sounds.radio_muffled_sound : blooper_sounds.radio_sound
	else
		sound_file = muffled ? blooper_sounds.muffled_sound : blooper_sounds.sound
	var/list/bloops = play_blooper(
		bloop_hearers,
		speaker = src,
		sound_file = sound_file,
		pitch = voice_and_pitch[2],
		message = message,
		radio = radio,
		whisper = !!LAZYACCESS(message_mods, WHISPER_MODE),
	)
	// one line at a time per channel, an open intercom on another frequency won't cut the headset
	var/channel = radio ? "[frequency]" : "out loud"
	var/list/unsaid = LAZYACCESS(unsaid_bloops, channel)
	LAZYCLEARLIST(unsaid)
	LAZYSET(unsaid_bloops, channel, bloops)

/// the voice and pitch a line bloops with, as list(voice, pitch)
/atom/movable/proc/get_speaking_blooper()
	return list(blooper, blooper_pitch)

//ORIGINAL FILE: code/modules/mob/living/carbon/human/human_say.dm
/mob/living/carbon/human/get_speaking_blooper()
	var/voice_name = get_voice()
	if(voice_name == real_name)
		return ..()
	// a borrowed name borrows its owner's squeak, npcs nobody played never got one
	for(var/mob/living/carbon/human/voice_owner as anything in GLOB.human_list)
		if(voice_owner.real_name == voice_name && !isnull(voice_owner.blooper))
			return list(voice_owner.blooper, voice_owner.blooper_pitch)
	// nobody goes by that name, so the name rolls a squeak of its own, the same one every line
	var/name_hash = md5(voice_name)
	return list(
		GLOB.blooper_voices[hex2num(copytext(name_hash, 1, 5)) % length(GLOB.blooper_voices) + 1],
		BLOOPER_PITCH_AT_STEP(hex2num(copytext(name_hash, 5, 9)) % BLOOPER_PITCH_STEPS + 1),
	)

//ORIGINAL FILE: code/controllers/subsystem/tts.dm
/datum/controller/subsystem/tts
	/// the last finished request failed, the voice server is down and bloops talk for everyone
	var/tts_failing = FALSE

/datum/tts_request/requests_errored()
	. = ..()
	var/datum/http_response/primary_response = get_primary_response()
	// speech only checks the transport, a server answering 500 is just as dead
	SStts.tts_failing = . || primary_response.status_code != 200
