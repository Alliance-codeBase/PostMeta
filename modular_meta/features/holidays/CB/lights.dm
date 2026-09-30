
/obj/machinery/light/Initialize(mapload)
	. = ..()

	if(check_holidays(CONTAINMENT_BREACH_DAY))
		bulb_colour = "#88837f"
		bulb_power =  0.6
