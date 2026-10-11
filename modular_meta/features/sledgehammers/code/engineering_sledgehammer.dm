// Code by headband0536, sprites by Simpleton

/obj/item/sledgehammer/engineering
	name = "breaching sledgehammer"
	desc = "A demolition sledgehammer with a pick and a forked claw welded on, the kind firefighters call \"the irons\". Drive the claw into an airlock seam, put your weight behind it, and the airlock gives, powered or not."
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
	lore = "\
		Engineering asked for something that opens an airlock when the power is out, the access is wrong \
		and the jaws of life are on the other side of the fire.<br>\
		<br>\
		R&D welded a forcible entry bar onto a standard demolition hammer and called it a day. \
		The jaws of life are a precision instrument. This is not.<br>\
		<br>\
		It ships with a two-page guide on authorized use. The first page has never been read. \
		The second page is blank."
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
	. += span_notice("Wield it and use it on an airlock outside of combat mode to force it open.")

/obj/item/sledgehammer/engineering/proc/on_interacting_with_atom(datum/source, mob/living/user, atom/target, list/modifiers)
	SIGNAL_HANDLER

	if(user.combat_mode || !is_type_in_typecache(target, forceable_door_types) || !HAS_TRAIT(src, TRAIT_WIELDED))
		return NONE
	var/obj/machinery/door/door = target
	INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/machinery/door, try_to_crowbar), src, user, TRUE)
	return ITEM_INTERACT_SUCCESS

/datum/design/engineering_sledgehammer
	name = "Breaching Sledgehammer"
	desc = "A demolition sledgehammer with a forcible entry claw. Forces open airlocks, powered or not."
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
