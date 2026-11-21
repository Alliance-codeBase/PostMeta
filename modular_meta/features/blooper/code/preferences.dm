/// bloops instead of a voice
/datum/preference/toggle/blooper_voice
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "blooper_voice"
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	priority = PREFERENCE_PRORITY_LATE_BODY_TYPE // clears the voice from PREFERENCE_PRIORITY_BODY_TYPE
	default_value = FALSE
	can_randomize = FALSE
	should_update_preview = FALSE

/datum/preference/toggle/blooper_voice/is_accessible(datum/preferences/preferences)
	if(!SStts.tts_enabled)
		return FALSE
	return ..()

/datum/preference/toggle/blooper_voice/apply_to_human(mob/living/carbon/human/target, value)
	target.set_blooper_voice(value)

/// what the character bloops with
/datum/preference/choiced/blooper
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "blooper"
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	should_update_preview = FALSE

/datum/preference/choiced/blooper/init_possible_values()
	return assoc_to_keys(GLOB.bloopers)

/datum/preference/choiced/blooper/apply_to_human(mob/living/carbon/human/target, value)
	target.blooper = value

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
	target.blooper_pitch = value

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
	var/datum/blooper/blooper_sounds = GLOB.bloopers[preferences.read_preference(/datum/preference/choiced/blooper)]
	play_blooper(
		list(user),
		speaker = null,
		sound_file = blooper_sounds.sound,
		pitch = preferences.read_preference(/datum/preference/numeric/blooper_pitch),
		message = "Так звучит мой голос", // only the length counts, bloops can't read
		radio = FALSE,
	)
	return TRUE
