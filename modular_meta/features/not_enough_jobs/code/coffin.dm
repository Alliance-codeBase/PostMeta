/obj/structure/closet/crate/coffin/phys_hazard
	name = "Metal Coffin"
	desc = "Highly-secure biological casket containing a deceased body"
	icon = 'modular_meta/features/not_enough_jobs/icons/phys_coffin.dmi'
	icon_state = "phys_coffin_steel_tape"
	base_icon_state = "phys_coffin_steel"
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	max_integrity = 125
	material_drop = /obj/item/stack/sheet/iron
	material_drop_amount = 5
	open_sound = 'modular_meta/features/antagonists/bloodsuckers/sounds/coffin_open.ogg'
	close_sound = 'modular_meta/features/antagonists/bloodsuckers/sounds/coffin_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50
	elevation_open = 0
	can_weld_shut = TRUE
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5)
	var/list/possible_icons = list(
	//	"phys_coffin",
		"phys_coffin_steel",
	//	"phys_coffin_blue",
	//	"phys_coffin_olive",
	//	"phys_coffin_sand",
	)
	var/tapes_removed = FALSE

/obj/structure/closet/crate/coffin/phys_hazard/Initialize(mapload)
	base_icon_state = pick(possible_icons)
	. = ..()

/obj/structure/closet/crate/coffin/phys_hazard/update_icon_state()
	. = ..()
	if(!tapes_removed)
		if(icon_state != "[base_icon_state]_tape_cut")
			icon_state = "[base_icon_state]_tape"
		return
	icon_state = "[base_icon_state][opened ? "_open" : ""]"

/obj/structure/closet/crate/coffin/phys_hazard/before_open(mob/living/user, force = FALSE)
	if(tapes_removed)
		return ..()
	if(icon_state != "[base_icon_state]_tape_cut")
		balloon_alert(user, "removing tapes..")
		if(do_after(user, 1.3 SECONDS, src))
			icon_state = "[base_icon_state]_tape_cut"
			playsound(src, 'sound/items/poster/poster_ripped.ogg', 75, FALSE)
			tapes_removed = TRUE
	return FALSE

