//ORIGINAL FILE: code/modules/mob/living/living.dm
/// Says what was typed before going into crit.
/mob/living/carbon/human/set_stat(new_stat)
	if(stat == STABLE && (new_stat == SOFT_CRIT || new_stat == HARD_CRIT))
		force_say(FORCE_SAY_BLACKOUT, immediate = TRUE)
	return ..()
