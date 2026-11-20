//ORIGINAL FILE: code/modules/antagonists/changeling/changeling.dm
/datum/changeling_profile
	/// stolen [/atom/movable/var/blooper]
	var/blooper
	/// stolen [/atom/movable/var/blooper_pitch]
	var/blooper_pitch
	/// stolen [/mob/living/carbon/human/var/blooper_voice]
	var/blooper_voice

/datum/antagonist/changeling/create_profile(mob/living/carbon/human/target, protect = 0)
	var/datum/changeling_profile/new_profile = ..()
	// the squeak gets stolen with the face
	new_profile.blooper = target.blooper
	new_profile.blooper_pitch = target.blooper_pitch
	new_profile.blooper_voice = target.blooper_voice
	return new_profile

/datum/antagonist/changeling/transform(mob/living/carbon/human/user, datum/changeling_profile/chosen_profile)
	. = ..()
	user.blooper = chosen_profile.blooper
	user.blooper_pitch = chosen_profile.blooper_pitch
	user.blooper_voice = chosen_profile.blooper_voice
