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
