/obj/item/clothing/under/rank/security/breach
	icon = 'modular_meta/features/event/CB/icons/security_item.dmi'
	icon_state = "breach"
	worn_icon = 'modular_meta/features/event/CB/icons/security.dmi'
	abstract_type = /obj/item/clothing/under/rank/security
	armor_type = /datum/armor/clothing_under/rank_security
	strip_delay = 5 SECONDS
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	can_adjust = FALSE

/obj/item/clothing/head/helmet/swat/nanotrasen/breach
	name = "\improper Guard helmet"
	desc = "An extremely robust helmet with the SCP logo emblazoned on the top."
	icon_state = "swat"
	base_icon_state = "swat"
	inhand_icon_state = "swat_helmet"
	worn_icon = 'modular_meta/features/event/CB/icons/security.dmi'
	icon = 'modular_meta/features/event/CB/icons/security_item.dmi'

/datum/outfit/job/security/New()
	. = ..()
	if(check_holidays(CONTAINMENT_BREACH_DAY))
		uniform = /obj/item/clothing/under/rank/security/breach
		suit_store = /obj/item/gun/ballistic/automatic/wt550
		head = /obj/item/clothing/head/helmet/swat/nanotrasen/breach
		r_pocket = /obj/item/ammo_box/magazine/wt550m9
