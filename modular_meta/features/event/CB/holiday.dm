/datum/holiday/breach
	name = "Birthday of SCP:CB"
	begin_month = APRIL
	begin_day = 15
	end_month = MAY
	end_day = 10
	holiday_colors = list(
		,
		,
	)


/datum/holiday/breach/greet()
	if(prob(10))
		return "On this day, the SCPs finally broke free from the cages built by the oppressive SCP Foundation."
	else if(prob(5))
		return "On this day #*!&@#77 All hail to CI!"
	else
		return "On this day, the SCP Containment Breach was born!"


/datum/holiday/breach/get_station_prefix()
	return pick("Breached", "Anomalous", "Containment", "Secure", "Protective",
	"Dr. Maynard's", "Insurgency", "Euclid", "Safe", "Keter", "Heavy Containment", "Light Containment",
	"Memetic", "Memagent", "Alpha-warhead", "Insurgency", "Chaos")

/datum/holiday/breach/get_station_name()
	return pick("Zone", "Foundation", "Site-19", "Site-17", "Site-18", "SCP", "Research", "Class-D")
