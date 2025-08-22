/datum/chemical_reaction/novichok
    results = list(/datum/reagent/toxin/novichok = 3)
    required_reagents = list(
        /datum/reagent/fluorine = 1,
        /datum/reagent/ammonia = 1,
        /datum/reagent/toxin/cyanide = 1,
        /datum/reagent/toxin/fentanyl = 1
    )
    mix_message = "The solution clouds into a faint gray liquid."
    is_cold_recipe = TRUE
    required_temp = 374
    optimal_temp = 420
    overheat_temp = NO_OVERHEAT
    optimal_ph_min = 7
    optimal_ph_max = 8
    determin_ph_range = 3
    temp_exponent_factor = 0.7
    ph_exponent_factor = 2
    thermic_constant = -300
    H_ion_release = 3.2
    rate_up_lim = 10
    purity_min = 0.4
    reaction_flags = REACTION_PH_VOL_CONSTANT
    reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DAMAGING | REACTION_TAG_OXY | REACTION_TAG_TOXIN