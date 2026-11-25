//ORIGINAL FILE: code/modules/research/xenobiology/crossbreeding/_status_effects.dm
/datum/status_effect/stabilized/cerulean/on_apply()
	. = ..()
	// the spare body wakes up with your squeak
	clone.copy_blooper_from(owner)

//ORIGINAL FILE: code/modules/bitrunning/components/avatar_connection.dm
/datum/component/avatar_connection/Initialize(
	datum/mind/old_mind,
	mob/living/old_body,
	obj/machinery/quantum_server/server,
	obj/machinery/netpod/pod,
	help_text,
	copy_body,
	)
	. = ..()
	// no connection, nobody to squeak like
	if(. == COMPONENT_INCOMPATIBLE)
		return
	var/mob/living/avatar = parent
	// the login already handed out a random squeak, swap it for the real one
	avatar.copy_blooper_from(old_body)

//ORIGINAL FILE: code/modules/mob/living/carbon/human/human_helpers.dm
/mob/living/carbon/human/make_full_human_copy(turf/location)
	var/mob/living/carbon/human/clone = ..()
	// a paradox clone with the wrong squeak gives itself away
	clone.copy_blooper_from(src)
	return clone

//ORIGINAL FILE: code/game/machinery/experimental_cloner/experimental_cloning_record.dm
/datum/experimental_cloning_record
	/// the subject's [/atom/movable/var/blooper]
	var/blooper
	/// the subject's [/atom/movable/var/blooper_pitch]
	var/blooper_pitch
	/// the subject's [/mob/living/var/blooper_voice]
	var/blooper_voice

/datum/experimental_cloning_record/create_profile(mob/living/carbon/human/subject)
	. = ..()
	blooper = subject.blooper
	blooper_pitch = subject.blooper_pitch
	blooper_voice = subject.blooper_voice

/datum/experimental_cloning_record/apply_profile(mob/living/carbon/human/subject)
	. = ..()
	// the vat grows the squeak back too
	subject.blooper = blooper
	subject.blooper_pitch = blooper_pitch
	subject.set_blooper_voice(blooper_voice)

//ORIGINAL FILE: code/modules/antagonists/wizard/grand_ritual/finales/immortality.dm
/datum/human_appearance_profile
	/// the source's [/atom/movable/var/blooper]
	var/blooper
	/// the source's [/atom/movable/var/blooper_pitch]
	var/blooper_pitch
	/// the source's [/mob/living/var/blooper_voice]
	var/blooper_voice

/datum/human_appearance_profile/copy_from(mob/living/carbon/human/target)
	. = ..()
	blooper = target.blooper
	blooper_pitch = target.blooper_pitch
	blooper_voice = target.blooper_voice

/datum/human_appearance_profile/apply_to(mob/living/carbon/human/target)
	. = ..()
	// back from the dead, squeak intact
	target.blooper = blooper
	target.blooper_pitch = blooper_pitch
	target.set_blooper_voice(blooper_voice)
