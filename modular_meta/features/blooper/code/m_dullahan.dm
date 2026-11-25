//ORIGINAL FILE: code/modules/mob/living/carbon/human/species_types/dullahan.dm
/obj/item/dullahan_relay/on_prefs_loaded(mob/living/carbon/human/headless)
	. = ..()
	var/obj/item/bodypart/head/detached_head = loc
	// no head, no squeak
	if(!istype(detached_head))
		return
	// the head does the talking, so it gets the squeak too
	detached_head.copy_blooper_from(headless)
