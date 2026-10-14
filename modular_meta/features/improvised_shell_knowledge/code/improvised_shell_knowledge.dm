/datum/crafting_recipe/improvisedslug
	name = "Improvised Shotgun Shell"
	result = /obj/item/ammo_casing/shotgun/improvised
	reqs = list(
		/obj/item/stack/sheet/iron = 2,
		/obj/item/stack/cable_coil = 1,
		/datum/reagent/fuel = 10,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 1.2 SECONDS
	category = CAT_WEAPON_AMMO
	crafting_flags = CRAFT_MUST_BE_LEARNED

/obj/item/book/granter/crafting_recipe/improvised_shotgun_shell
	name = "improvised shell fabrication notes"
	desc = "Handwritten notes describing how to turn scrap into a crude shotgun shell."
	crafting_recipe_types = list(/datum/crafting_recipe/improvisedslug)

/datum/modpack/improvised_shell_knowledge/initialize()
	. = ..()
	if(.)
		return
	GLOB.rarity_loot += list(
		list(/obj/item/book/granter/crafting_recipe/improvised_shotgun_shell = 1),
	)
