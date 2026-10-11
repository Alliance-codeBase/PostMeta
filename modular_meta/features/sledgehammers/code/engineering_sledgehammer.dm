// Code by headband0536, sprites by Simpleton

/obj/item/sledgehammer/engineering
	name = "engineering sledgehammer"
	desc = "A heavy demolition hammer fitted with hydraulic prying jaws. Wielded with both hands, it forces open airlocks, even powered ones."
	icon = 'modular_meta/features/sledgehammers/icons/engineering_sledgehammer.dmi'
	lefthand_file = 'modular_meta/features/sledgehammers/icons/engineering_sledgehammer_lefthand.dmi'
	righthand_file = 'modular_meta/features/sledgehammers/icons/engineering_sledgehammer_righthand.dmi'
	worn_icon = 'modular_meta/features/sledgehammers/icons/engineering_sledgehammer_back.dmi'
	usesound = 'sound/items/tools/jaws_pry.ogg'
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 2.5,
	)
	var/static/list/forceable_door_types = typecacheof(list(
		/obj/machinery/door/airlock,
		/obj/machinery/door/firedoor,
		/obj/machinery/door/window,
	))

/obj/item/sledgehammer/engineering/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/cuffable_item)
	RegisterSignal(src, COMSIG_ITEM_INTERACTING_WITH_ATOM, PROC_REF(on_interacting_with_atom))

/obj/item/sledgehammer/engineering/examine(mob/user)
	. = ..()
	. += span_notice("Wield it and use it on a door outside of combat mode to force the door open.")

/obj/item/sledgehammer/engineering/proc/on_interacting_with_atom(datum/source, mob/living/user, atom/target, list/modifiers)
	SIGNAL_HANDLER

	if(user.combat_mode || !is_type_in_typecache(target, forceable_door_types) || !HAS_TRAIT(src, TRAIT_WIELDED))
		return NONE
	var/obj/machinery/door/door = target
	INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/machinery/door, try_to_crowbar), src, user, TRUE)
	return ITEM_INTERACT_SUCCESS

/datum/design/engineering_sledgehammer
	name = "Engineering Sledgehammer"
	desc = "A heavy demolition hammer with hydraulic prying jaws, able to force open powered airlocks."
	build_path = /obj/item/sledgehammer/engineering
	build_type = PROTOLATHE | AWAY_LATHE
	materials = /obj/item/sledgehammer/engineering::custom_materials
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/techweb_node/exp_tools/New()
	. = ..()
	unlocked_designs += /datum/design/engineering_sledgehammer
