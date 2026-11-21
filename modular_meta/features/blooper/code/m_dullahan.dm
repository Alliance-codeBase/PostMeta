//ORIGINAL FILE: code/modules/mob/living/carbon/human/species_types/dullahan.dm
/obj/item/dullahan_relay/on_prefs_loaded(mob/living/carbon/human/headless)
	SIGNAL_HANDLER
	. = ..()
	var/obj/item/bodypart/head/detached_head = loc
	// no head, no squeak
	if(!istype(detached_head))
		return
	// the head does the talking, so it gets the squeak too
	detached_head.blooper = headless.blooper
	detached_head.blooper_pitch = headless.blooper_pitch
