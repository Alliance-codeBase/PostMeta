/datum/crafting_recipe/improvised_shotgun_shell
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
	crafting_flags = CRAFT_MUST_BE_LEARNED | CRAFT_SKIP_MATERIALS_PARITY

/obj/item/book/granter/crafting_recipe/improvised_shotgun_shell
	name = "improvised shell fabrication notes"
	desc = "Handwritten notes describing how to turn scrap into a crude shotgun shell."
	icon_state = "book1"
	remarks = list(
		"Someone clearly wrote these before the station fell apart.",
		"Ten pellets of scrap. It's not much, but it's not nothing either.",
		"Scrap iron for the casing, wire for the crimp, a splash of fuel for the kick. Nothing you can't find in maint.",
		"The screwdriver does most of the work. Don't ask how I know, my hand still hurts.",
		"I made a dozen of these. Half of them held together long enough to be a problem.",
		"It fits in a pipe gun. I checked. I wish I hadn't.",
	)
	crafting_recipe_types = list(/datum/crafting_recipe/improvised_shotgun_shell)

/obj/item/book/granter/crafting_recipe/improvised_shotgun_shell/recoil(mob/living/user)
	to_chat(user, span_warning("The book turns to dust in your hands."))
	qdel(src)

/datum/modpack/improvised_shells/initialize()
	. = ..()
	if(.)
		return
	GLOB.uncommon_loot += list(
		list(/obj/item/book/granter/crafting_recipe/improvised_shotgun_shell = 1),
	)
