/datum/status_effect/water_affected
	id = "wateraffected"
	alert_type = null

/datum/status_effect/water_affected/on_apply()
	//We should be inside a liquid turf if this is applied
	calculate_water_slow()
	return TRUE

/datum/status_effect/water_affected/proc/calculate_water_slow()
	var/turf/owner_turf = get_turf(owner)
	var/slowdown_amount = 0
	if(!QDELETED(owner_turf?.liquids) && !QDELETED(owner_turf.liquids.liquid_group))
		slowdown_amount = owner_turf.liquids.liquid_group.group_overlay_state * 0.5
	owner.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/status_effect/water_affected, multiplicative_slowdown = slowdown_amount)

/datum/movespeed_modifier/status_effect/water_affected
	id = MOVESPEED_ID_LIQUID
	variable = TRUE
	multiplicative_slowdown = 0

/datum/movespeed_modifier/status_effect/water_affected/New(mob/living/owner)
	. = ..()

	var/turf/T = get_turf(owner)
	var/slowdown_amount = T.liquids.liquid_group.group_overlay_state * 0.5
	multiplicative_slowdown = slowdown_amount

/datum/status_effect/water_affected/tick()
	var/turf/owner_turf = get_turf(owner)
	if(QDELETED(owner_turf) || QDELETED(owner_turf.liquids) || owner_turf.liquids.liquid_group.group_overlay_state == LIQUID_STATE_PUDDLE)
		qdel(src)
		return
	calculate_water_slow()
	//Make the reagents touch the person

	var/fraction = SUBMERGEMENT_PERCENT(owner, owner_turf.liquids)
	owner_turf.liquids.liquid_group.expose_members_turf(owner_turf.liquids)
	owner_turf.liquids.liquid_group.transfer_to_atom(owner_turf.liquids, ((SUBMERGEMENT_REAGENTS_TOUCH_AMOUNT * fraction / 20)), owner)

	return ..()

/datum/status_effect/water_affected/on_remove()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/status_effect/water_affected)

/datum/status_effect/ocean_affected
	id = "oceanaffected"
	alert_type = null

/datum/status_effect/ocean_affected/tick()
	var/turf/ocean_turf = get_turf(owner)
	if(!istype(ocean_turf, /turf/open/floor/plating/ocean))
		qdel(src)

	if(ishuman(owner))
		var/mob/living/carbon/human/arrived = owner
		if(!(arrived.wear_suit || arrived.wear_suit.item_flags & STOPSPRESSUREDAMAGE))
			arrived.adjust_fire_loss(5)
