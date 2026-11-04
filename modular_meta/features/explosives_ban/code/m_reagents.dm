/proc/reagent_types_in(list/datum/reagents/holders)
	var/list/reagent_types = list()
	for(var/datum/reagents/holder as anything in holders)
		for(var/datum/reagent/reagent as anything in holder.reagent_list)
			reagent_types |= reagent.type
	return reagent_types

/proc/get_possible_explosive_reactions(list/reagent_types, atom/container)
	var/static/list/explosive_reaction_types = typecacheof(list(
		/datum/chemical_reaction/reagent_explosion,
		/datum/chemical_reaction/foam,
		/datum/chemical_reaction/smoke_powder,
		/datum/chemical_reaction/smoke_powder_smoke,
		/datum/chemical_reaction/gunpowder,
		/datum/chemical_reaction/methamphetamine,
		/datum/chemical_reaction/teslium,
		/datum/chemical_reaction/nitrous_oxide,
		/datum/chemical_reaction/slime/slimeexplosion,
	))
	var/list/datum/chemical_reaction/possible_reactions = list()
	for(var/reaction_type in explosive_reaction_types)
		var/datum/chemical_reaction/reaction = GLOB.chemical_reactions_list[reaction_type]
		if(isnull(reaction) || (isliving(container) && !reaction.mob_react))
			continue
		if(!isnull(reaction.required_container) && !istype(container, reaction.required_container))
			continue
		if(length(reaction.required_reagents - reagent_types) || length(reaction.required_catalysts - reagent_types))
			continue
		possible_reactions += reaction
	return possible_reactions

/datum/reagents/proc/refuse_explosive_transfer(datum/reagents/target_holder, datum/reagent/target_id, atom/target_atom, mob/transferred_by)
	if(!ismob(transferred_by) || !transferred_by.is_explosives_banned())
		return FALSE
	if(istype(target_atom, /obj/effect/decal/cleanable))
		return FALSE
	var/list/target_reagent_types = reagent_types_in(list(target_holder))
	var/list/transferred_reagent_types = isnull(target_id) ? reagent_types_in(list(src)) : list(target_id)
	var/list/reactions_before = get_possible_explosive_reactions(target_reagent_types, target_atom)
	var/list/reactions_after = get_possible_explosive_reactions(target_reagent_types | transferred_reagent_types, target_atom)
	if(!length(reactions_after - reactions_before))
		return FALSE
	return transferred_by.refuse_explosives()
