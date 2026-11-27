/obj/item/rag/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isturf(interacting_with))
		return ..()

	var/turf/target_turf = interacting_with
	if(QDELETED(target_turf.liquids) || QDELETED(target_turf.liquids.liquid_group))
		return ..()

	if(blood_level >= 10)
		balloon_alert(user, "[name] too dirty!")
		return ITEM_INTERACT_BLOCKING

	if(reagents.total_volume < 1)
		return soak_up_liquids(target_turf, user)
	return wipe_liquids(target_turf, user)

/obj/item/rag/proc/soak_up_liquids(turf/target_turf, mob/living/user)
	var/free_space = reagents.maximum_volume - reagents.total_volume
	if(free_space < 0.5)
		balloon_alert(user, "can't absorb more!")
		return ITEM_INTERACT_BLOCKING

	balloon_alert(user, "soaking up...")
	if(!do_after(user, 2 SECONDS, target = target_turf))
		return ITEM_INTERACT_BLOCKING

	var/obj/effect/abstract/liquid_turf/liquid = target_turf.liquids
	var/datum/liquid_group/liquid_group = liquid?.liquid_group
	if(QDELETED(liquid_group) || !length(liquid_group.members))
		balloon_alert(user, "it's dry here")
		return ITEM_INTERACT_BLOCKING

	liquid_group.total_reagent_volume = liquid_group.reagents.total_volume
	liquid_group.reagents_per_turf = liquid_group.total_reagent_volume / length(liquid_group.members)
	if(liquid_group.reagents_per_turf <= 0)
		balloon_alert(user, "it's dry here")
		return ITEM_INTERACT_BLOCKING

	free_space = reagents.maximum_volume - reagents.total_volume
	var/amount = min(liquid_group.reagents_per_turf, 5, free_space)
	if(amount <= 0)
		balloon_alert(user, "can't absorb more!")
		return ITEM_INTERACT_BLOCKING

	var/removes_tile = (amount >= liquid_group.reagents_per_turf)
	liquid_group.trans_to_seperate_group(reagents, amount, removes_tile ? liquid : null)
	if(removes_tile && !QDELETED(liquid_group))
		liquid_group.process_removal()

	blood_level = min(10, blood_level + 0.5)
	balloon_alert(user, "soaked up fluids")
	playsound(target_turf, 'sound/effects/slosh.ogg', 50, TRUE)
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/item/rag/proc/wipe_liquids(turf/target_turf, mob/living/user)
	var/datum/liquid_group/liquid_group = target_turf.liquids.liquid_group
	liquid_group.total_reagent_volume = liquid_group.reagents.total_volume
	liquid_group.reagents_per_turf = liquid_group.total_reagent_volume / max(1, length(liquid_group.members))

	if(liquid_group.reagents_per_turf > 10)
		balloon_alert(user, "too much liquid, soak it up first!")
		return ITEM_INTERACT_BLOCKING

	balloon_alert(user, "wiping")
	if(!do_after(user, 3.5 SECONDS, target = target_turf))
		return ITEM_INTERACT_BLOCKING

	var/obj/effect/abstract/liquid_turf/liquid = target_turf.liquids
	liquid_group = liquid?.liquid_group
	if(QDELETED(liquid_group) || !length(liquid_group.members))
		return ITEM_INTERACT_BLOCKING

	liquid_group.total_reagent_volume = liquid_group.reagents.total_volume
	liquid_group.reagents_per_turf = liquid_group.total_reagent_volume / length(liquid_group.members)
	liquid_group.remove_any(liquid, liquid_group.reagents_per_turf)

	blood_level = min(10, blood_level + 0.5)
	balloon_alert(user, "cleaned fluids")
	playsound(target_turf, 'sound/effects/slosh.ogg', 50, TRUE)
	update_appearance()
	return ITEM_INTERACT_SUCCESS
