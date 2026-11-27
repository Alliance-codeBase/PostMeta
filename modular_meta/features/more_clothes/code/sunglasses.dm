/obj/item/clothing/glasses/meson/sunglasses
	name = "meson HUD sunglasses"
	desc = "Sunglasses with an inbuilt scanner that can see through both walls and flooring."
	icon = 'modular_meta/features/more_clothes/icons/items/glasses.dmi'
	worn_icon = 'modular_meta/features/more_clothes/icons/on_mob/eyes.dmi'
	lefthand_file = 'modular_meta/features/more_clothes/icons/inhands/glasses_lefthand.dmi'
	righthand_file = 'modular_meta/features/more_clothes/icons/inhands/glasses_righthand.dmi'
	icon_state = "sunhudmes"
	inhand_icon_state = "sunhudmes"
	flags_cover = GLASSESCOVERSEYES
	flash_protect = FLASH_PROTECTION_WELDER
	tint = 1
	glass_colour_type = /datum/client_colour/glass_colour/green
	dog_fashion = /datum/dog_fashion/head

/datum/crafting_recipe/hudsunmes
	name = "Meson HUDsunglasses"
	result = /obj/item/clothing/glasses/meson/sunglasses
	time = 2 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/meson = 1,
				  /obj/item/clothing/glasses/sunglasses = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/hudsunmesremoval
	name = "Meson HUD removal"
	result = /obj/item/clothing/glasses/sunglasses
	time = 2 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/meson/sunglasses = 1)
	category = CAT_EQUIPMENT
	crafting_flags = parent_type::crafting_flags | CRAFT_SKIP_MATERIALS_PARITY
