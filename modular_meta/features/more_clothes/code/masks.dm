/obj/item/clothing/mask/gas/mime
	icon = 'modular_meta/features/more_clothes/icons/masks/masks.dmi'
	worn_icon = 'modular_meta/features/more_clothes/icons/masks/mask.dmi'

/obj/item/clothing/mask/gas/mime/Initialize(mapload)
	.=..()
	mimemask_designs += list(
		"Joker" = image(icon = 'modular_meta/features/more_clothes/icons/masks/masks.dmi', icon_state = "mimejoker")
		)
