/obj/machinery/computer/brig_physician
	name = "disobediency processing unit" // got no idea how to call it
	desc = "A terminal for processing post-mortem reports."
	icon_screen = "medcomp"
	icon_keyboard = "security_key"
	light_color = COLOR_SOFT_RED
	req_one_access = list(ACCESS_BRIG_PHYSICIAN, ACCESS_HOS)
	circuit = /obj/item/circuitboard/computer/brig_physician

/obj/machinery/computer/brig_physician/ui_status(mob/user, datum/ui_state/state)
	if(!allowed(user))
		return UI_CLOSE
	return ..()

/obj/machinery/computer/brig_physician/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EOC")
		ui.open()

/obj/item/circuitboard/computer/brig_physician
	name = "EoC Processing Unit"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/computer/brig_physician
