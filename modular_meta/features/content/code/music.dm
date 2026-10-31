/datum/chase_music_handler
	var/mob/living/carbon/human/music_owner
	var/atom/movable/chase_threat

	var/const/VERY_CLOSE = 103
	var/const/CHASE_INTRO  = 104
	var/const/CHASE_LOOP = 105

	var/current_step = 0
	var/intro_playing = FALSE
	var/chase_looped_playing = FALSE

/datum/chase_music_handler/New(mob/living/carbon/human/target_human, atom/movable/target_threat)
	music_owner = target_human
	chase_threat = target_threat
	START_PROCESSING(SSfastprocess, src)

/datum/chase_music_handler/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	stop_all_music()
	music_owner = null
	chase_threat = null
	return ..()

/datum/chase_music_handler/process(delta_time)
	if(!music_owner || !music_owner.client || !chase_threat || QDELETED(chase_threat))
		qdel(src)
		return

	var/current_distance = get_dist(music_owner, chase_threat)

	if(intro_playing || chase_looped_playing)
		return

	if(current_distance > 10)
		if(current_step != 0)
			current_step = 0
			stop_ambient_channel()

	else if(current_distance <= 10 && current_distance > 3)
		if(current_step != 1)
			current_step = 1
			play_ambient_step('modular_meta/features/content/sound/veryclose.ogg')

	else if(current_distance <= 3)
		switch_to_final_chase()

/datum/chase_music_handler/proc/play_ambient_step(sound_file)
	if(!music_owner || !music_owner.client)
		return
	var/sound/ambient_sound = sound(sound_file, repeat = TRUE, channel = CHASE_LOOP, volume = 80)
	ambient_sound.environment = -1
	music_owner.client << ambient_sound

/datum/chase_music_handler/proc/stop_ambient_channel()
	if(!music_owner || !music_owner.client)
		return
	var/sound/mute_sound = sound(channel = CHASE_LOOP)
	mute_sound.status = SOUND_MUTE
	music_owner.client << mute_sound

/datum/chase_music_handler/proc/switch_to_final_chase()
	intro_playing = TRUE
	current_step = 2

	stop_ambient_channel()

	var/sound/intro_sound = sound('modular_meta/features/content/sound/chase_intro.ogg', repeat = FALSE, channel = CHASE_INTRO, volume = 100)
	intro_sound.environment = -1
	music_owner.client << intro_sound

	var/intro_duration = 120

	addtimer(CALLBACK(src, PROC_REF(start_chase_loop)), intro_duration)

/datum/chase_music_handler/proc/start_chase_loop()
	if(!music_owner || !music_owner.client || QDELETED(src))
		return
	intro_playing = FALSE
	chase_looped_playing = TRUE

	var/sound/chase_loop = sound('modular_meta/features/content/sound/chase.ogg', repeat = TRUE, channel = CHASE_LOOP, volume = 100)
	chase_loop.environment = -1
	music_owner.client << chase_loop

/datum/chase_music_handler/proc/stop_all_music()
	if(!music_owner || !music_owner.client)
		return
	for(var/active_channel in list(VERY_CLOSE, CHASE_INTRO, CHASE_LOOP))
		var/sound/mute_sound = sound(channel = active_channel)
		mute_sound.status = SOUND_MUTE
		music_owner.client << mute_sound

/mob/living/carbon/human
	var/datum/chase_music_handler/active_chase_music

/mob/living/carbon/human/proc/start_chase_music(atom/movable/threat)
	if(!threat)
		return
	if(active_chase_music)
		stop_chase_music()
	active_chase_music = new(src, threat)

/mob/living/carbon/human/proc/stop_chase_music()
	if(active_chase_music)
		qdel(active_chase_music)
		active_chase_music = null
