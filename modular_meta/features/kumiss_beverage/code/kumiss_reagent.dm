// Kumiss

/datum/reagent/consumable/kumiss
	name = "Kumiss"
	description = "Сәлем, қымыз ішіңіз."
	color = "#c7c7c7ff"
	quality = DRINK_VERYGOOD
	overdose_threshold = 50
	taste_description = "Қазақстан"
	ph = 7
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/cup/glass/bottle/kumiss
	var/hymningrn = FALSE

/datum/reagent/consumable/kumiss/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjustToxLoss(-0.5, updating_health = FALSE, required_biotype = affected_biotype)
	need_mob_update += affected_mob.adjustOrganLoss(ORGAN_SLOT_LIVER, -0.5 * REM * seconds_per_tick, required_organ_flag = ORGAN_ORGANIC)
	for(var/datum/reagent/toxin/R in affected_mob.reagents.reagent_list)
		affected_mob.reagents.remove_reagent(R.type, 1.5 * REM * seconds_per_tick)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH
	//тут надо добавить замену частых слов на казахские но это я делать не буду так что пока что эффект кваса

/datum/reagent/consumable/kumiss/overdose_process(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(hymningrn == FALSE)
		hymningrn = TRUE
		to_chat(affected_mob, span_warning("Қымыз тым көп іштім деп ойлаймын..."))
		to_chat(affected_mob, span_warning("You feel something coming from inside you..."))
		sleep(200)
		to_chat(affected_mob, span_warning("You can no longer resist!"))
		sleep(200)
		to_chat(affected_mob, span_warning("You feel the Қазақстан as it absorbs every last bit of Kumiss in you to empower!"))
		affected_mob.reagents.remove_reagent(type, 1000 * REM * seconds_per_tick)
		sleep(100)
		to_chat(affected_mob, span_warning("It works! IT WORKS! Қазақстан IS STRONGER THAN EVER BEFORE! YOU CAN NO LONGER HOLD IT..."))
		sleep(20)
		// гимн поехал
		affected_mob.say("Алтын күн аспаны,", forced = /datum/reagent/consumable/kumiss)
		sleep(2)
		affected_mob.say("Алтын дән даласы,", forced = /datum/reagent/consumable/kumiss)
		sleep(2)
		affected_mob.say("Ерліктің дастаны –", forced = /datum/reagent/consumable/kumiss)
		sleep(2)
		affected_mob.say("Еліме қарашы!", forced = /datum/reagent/consumable/kumiss)
		sleep(2)
		affected_mob.say("Ежелден ер деген,", forced = /datum/reagent/consumable/kumiss)
		sleep(2)
		affected_mob.say("Даңқымыз шықты ғой,", forced = /datum/reagent/consumable/kumiss)
		sleep(2)
		affected_mob.say("Намысын бермеген,", forced = /datum/reagent/consumable/kumiss)
		sleep(2)
		affected_mob.say("Қазағым мықты ғой!", forced = /datum/reagent/consumable/kumiss)
		sleep(20)
		affected_mob.say("Менің елім, менің елім,", forced = /datum/reagent/consumable/kumiss)
		sleep(2)
		affected_mob.say("Гүлің болып егілемін,", forced = /datum/reagent/consumable/kumiss)
		sleep(2)
		affected_mob.say("Жырың болып төгілемін, елім!", forced = /datum/reagent/consumable/kumiss)
		sleep(2)
		affected_mob.say("Туған жерім менің — Қазақстаным!", forced = /datum/reagent/consumable/kumiss)
		sleep(20)
		affected_mob.say("Ұрпаққа жол ашқан,", forced = /datum/reagent/consumable/kumiss)
		sleep(2)
		affected_mob.say("Кең байтақ жерім бар.", forced = /datum/reagent/consumable/kumiss)
		sleep(2)
		affected_mob.say("Бірлігі жарасқан,", forced = /datum/reagent/consumable/kumiss)
		sleep(2)
		affected_mob.say("Тәуелсіз елім бар.", forced = /datum/reagent/consumable/kumiss)
		sleep(2)
		affected_mob.say("Қарсы алған уақытты,", forced = /datum/reagent/consumable/kumiss)
		sleep(2)
		affected_mob.say("Мәңгілік досыӊдай.", forced = /datum/reagent/consumable/kumiss)
		sleep(2)
		affected_mob.say("Біздің ел бақытты,", forced = /datum/reagent/consumable/kumiss)
		sleep(2)
		affected_mob.say("Біздің ел осындай!", forced = /datum/reagent/consumable/kumiss)
		//affected_mob.dust()
		sleep(200)
		hymningrn = FALSE

//Пьём кумысс без админов еее

/datum/chemical_reaction/consumable/kumiss
	results = list(/datum/reagent/consumable/kumiss = 3)
	required_reagents = list(/datum/reagent/consumable/sugar = 1, /datum/reagent/consumable/milk = 1)
	required_catalysts = list(/datum/reagent/consumable/enzyme = 5)
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_OTHER

