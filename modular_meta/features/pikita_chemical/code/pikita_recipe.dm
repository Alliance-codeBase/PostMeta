/datum/chemical_reaction/etymologypolymorphism
	results = list(/datum/reagent/toxin/etymologypolymorphism = 10)
	required_reagents = list(/datum/reagent/silicon = 5, /datum/reagent/iron = 5, /datum/reagent/toxin/mutagen = 5)
	mix_message = "The mixture glows brightly."
	is_cold_recipe = FALSE
	required_temp = 360
	optimal_temp = 600
	overheat_temp = 1200
	optimal_ph_min = 2
	optimal_ph_max = 9
	determin_ph_range = 3
	temp_exponent_factor = 1
	ph_exponent_factor = 1
	thermic_constant = 200
	H_ion_release = 0
	rate_up_lim = 10
	purity_min = 0.5
	reaction_flags = REACTION_PH_VOL_CONSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_CHEMICAL