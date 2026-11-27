/obj/item/reagent_containers/Initialize(mapload, vol)
	.=..()

	AddComponent(/datum/component/liquids_interaction, TYPE_PROC_REF(/obj/item/reagent_containers, attack_on_liquids_turf))

/obj/item/reagent_containers/proc/attack_on_liquids_turf(obj/item/reagent_containers/my_beaker, turf/T, mob/living/user, obj/effect/abstract/liquid_turf/liquids)
	if(!user.Adjacent(T))
		return FALSE
	if(!my_beaker.is_open_container())
		return FALSE
	if(!user.Adjacent(T))
		return FALSE
	if(user.combat_mode)
		return FALSE
	if(liquids.fire_state) //Use an extinguisher first
		to_chat(user, "<span class='warning'>You can't scoop up anything while it's on fire!</span>")
		return TRUE
	if(liquids.liquid_group.expected_turf_height == 1)
		to_chat(user, "<span class='warning'>The puddle is too shallow to scoop anything up!</span>")
		return TRUE
	var/free_space = my_beaker.reagents.maximum_volume - my_beaker.reagents.total_volume
	if(free_space <= 0)
		to_chat(user, "<span class='warning'>You can't fit any more liquids inside [my_beaker]!</span>")
		return TRUE
	var/desired_transfer = my_beaker.amount_per_transfer_from_this
	if(desired_transfer > free_space)
		desired_transfer = free_space
	if(desired_transfer > liquids.liquid_group.reagents_per_turf)
		desired_transfer = liquids.liquid_group.reagents_per_turf
	liquids.liquid_group.trans_to_seperate_group(my_beaker.reagents, desired_transfer, liquids)
	to_chat(user, "<span class='notice'>You scoop up around [round(desired_transfer)] units of liquids with [my_beaker].</span>")
	user.changeNext_move(CLICK_CD_MELEE)
	return TRUE


/obj/item/reagent_containers/cup/bucket/attackby_secondary(obj/item/weapon, mob/user, params)
	. = ..()
	if(istype(weapon, /obj/item/mop))
		if(reagents.total_volume == volume)
			to_chat(user, "The [src.name] can't hold anymore liquids")
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

		var/obj/item/mop/attacked_mop = weapon

		if(attacked_mop.reagents.total_volume < 0.1)
			to_chat(user, span_warning("Your [attacked_mop.name] is already dry!"))
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

		to_chat(user, "You wring out the [attacked_mop.name] into the [src.name].")
		attacked_mop.reagents.trans_to(src, attacked_mop.max_reagent_volume * 0.25)
		attacked_mop.reagents.remove_all(attacked_mop.max_reagent_volume)
		return SECONDARY_ATTACK_CONTINUE_CHAIN
