/datum/reagent/toxin/etymologypolymorphism
	name = "P.I.K.I.T.A Liquid"
	description = "Some sort of experimental psychoactive agent. Probably found near the sat."
	silent_toxin = TRUE
	color = "#AAAAAA77" //RGBA: 170, 170, 170, 77
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0
	ph = 5
	taste_description = "AI"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/etymologypolymorphism/on_mob_add(mob/living/carbon/affected_mob)
	. = ..()
	INVOKE_ASYNC(affected_mob, TYPE_PROC_REF(/atom/movable, say), "Пикита!", forced = /datum/reagent/toxin/etymologypolymorphism)

/datum/reagent/toxin/etymologypolymorphism/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	switch(current_cycle)
		if(5 to INFINITY)
			need_mob_update = affected_mob.adjust_organ_loss(ORGAN_SLOT_BRAIN, 1)
			switch(rand(1, 2))
				if(1)
					affected_mob.say(pick("Пипита", "Пикита", "Pikita", "Pipita", "Пипетка", "Кипита", "Пипоид", "Pipipipipipipipipipipupupakita!!", "Пипипипипипипипипипипупупакита!!", "Пепега", "Пепета"), forced = /datum/reagent/toxin/etymologypolymorphism)
				if(2)
					to_chat(affected_mob, span_warning("Your mind is stuck on this stupid word!"))
