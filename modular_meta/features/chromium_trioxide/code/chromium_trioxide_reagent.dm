/datum/reagent/toxin/chromium_trioxide
	name = "Chromium Trioxide"
	description = "A strong oxidizing toxin."
	color = "#B22222"
	toxpwr = 4
	metabolization_rate = 0.1 * REAGENTS_METABOLISM
	liver_damage_multiplier = 0
	ph = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/chromium_trioxide/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjustOrganLoss(ORGAN_SLOT_LUNGS, 3 * REM * seconds_per_tick)

