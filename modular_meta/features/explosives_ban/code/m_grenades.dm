/proc/is_explosive_grenade_type(obj/item/grenade/grenade_type)
	return grenade_type::ex_dev || grenade_type::ex_heavy || grenade_type::ex_light || grenade_type::ex_flame || grenade_type::shrapnel_type

//ORIGINAL FILE: code/game/objects/items/grenades/_grenade.dm
/obj/item/grenade/is_explosive()
	return is_explosive_grenade_type(type)

/obj/item/grenade/proc/refuse_arming(mob/user)
	return user.is_explosives_banned() && is_explosive() && user.refuse_explosives()

/obj/item/grenade/botch_check(mob/living/carbon/human/user)
	if(refuse_arming(user))
		return TRUE
	return ..()

/obj/item/grenade/suicide_act(mob/living/user)
	if(refuse_arming(user))
		return SHAME
	return ..()

//ORIGINAL FILE: code/game/objects/items/grenades/chem_grenade.dm
/obj/item/grenade/chem_grenade/is_explosive()
	var/list/datum/reagents/payload_holders = list()
	for(var/obj/item/beaker as anything in beakers)
		payload_holders += beaker.reagents
	var/list/payload_reagent_types = reagent_types_in(payload_holders)
	for(var/obj/item/beaker as anything in beakers)
		if(length(get_possible_explosive_reactions(payload_reagent_types, beaker)))
			return TRUE
	return FALSE

/obj/item/grenade/chem_grenade/screwdriver_act(mob/living/user, obj/item/tool)
	if(stage == GRENADE_WIRED && refuse_arming(user))
		return ITEM_INTERACT_BLOCKING
	return ..()

//ORIGINAL FILE: code/game/objects/items/grenades/clusterbuster.dm
/obj/item/grenade/clusterbuster/is_explosive()
	return ispath(payload, /obj/item/grenade/chem_grenade) || is_explosive_grenade_type(payload)

//ORIGINAL FILE: code/game/objects/items/grenades/plastic.dm
/obj/item/grenade/c4/is_explosive()
	return TRUE

/obj/item/grenade/c4/plant_c4(atom/bomb_target, mob/living/user)
	if(refuse_arming(user))
		return FALSE
	return ..()

/obj/item/grenade/c4/suicide_act(mob/living/user)
	if(refuse_arming(user))
		return SHAME
	return ..()

//ORIGINAL FILE: code/game/objects/items/grenades/ghettobomb.dm
/obj/item/grenade/iedcasing/attack_self(mob/user)
	if(refuse_arming(user))
		return
	return ..()

//ORIGINAL FILE: modular_meta/features/makeshift_grenade_trap/code/trap.dm
/datum/crafting_recipe/tripwire
	crafting_flags = parent_type::crafting_flags | CRAFT_COLLECT_REQUIREMENTS

/datum/crafting_recipe/tripwire/check_requirements(mob/user, list/collected_requirements)
	if(!user.is_explosives_banned())
		return ..()
	for(var/obj/item/grenade/grenade as anything in collected_requirements[/obj/item/grenade])
		if(grenade.is_explosive())
			return FALSE
	return ..()
