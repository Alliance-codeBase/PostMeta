/// what the character bloops with
/datum/preference/choiced/blooper
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "blooper"
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	should_update_preview = FALSE

/datum/preference/choiced/blooper/init_possible_values()
	// by name, so a collection lands right under its sounds
	return sort_list(assoc_to_keys(GLOB.blooper_voices))

/datum/preference/choiced/blooper/apply_to_human(mob/living/carbon/human/target, value)
	target.set_blooper(value)

/// bloop pitch
/datum/preference/numeric/blooper_pitch
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "blooper_pitch"
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	minimum = 0.5
	maximum = 2
	step = 0.1
	should_update_preview = FALSE

/datum/preference/numeric/blooper_pitch/create_default_value()
	return /atom/movable::blooper_pitch

/datum/preference/numeric/blooper_pitch/apply_to_human(mob/living/carbon/human/target, value)
	target.set_blooper_pitch(value)

/// bloop volume
/datum/preference/numeric/volume/sound_blooper_volume
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "sound_blooper_volume"
	savefile_identifier = PREFERENCE_PLAYER

/// bloop preview button
/datum/preference_middleware/blooper
	action_delegations = list(
		"play_blooper" = PROC_REF(preview_blooper),
	)

/// bloops a sample line at whoever pressed play
/datum/preference_middleware/blooper/proc/preview_blooper(list/params, mob/user)
	var/datum/blooper/blooper_sounds = pick(GLOB.blooper_voices[preferences.read_preference(/datum/preference/choiced/blooper)])
	play_blooper(
		list(user),
		speaker = null,
		sound_file = blooper_sounds.sound,
		pitch = preferences.read_preference(/datum/preference/numeric/blooper_pitch),
		message = "Так звучит мой голос. Нравится?", // bloops can't read, but they count vowels and hear a question
		radio = FALSE,
		whisper = FALSE,
	)
	return TRUE
