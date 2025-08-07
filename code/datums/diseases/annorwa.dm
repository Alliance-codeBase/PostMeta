/datum/disease/annorwa
        form = "Disease"
        name = "AN-04"
        max_stages = 5
        spread_text = "Touch"
        cure_text = "Spaceacillin"
        cures = list(/datum/reagent/medicine/spaceacillin)
        agent = "Bacillus Cerebrus"
        viable_mobtypes = list(/mob/living/carbon/human)
        cure_chance = 2
        desc = "A virus that was made by syndicate to annoy crew"
        required_organ = ORGAN_SLOT_BRAIN
        severity = DISEASE_SEVERITY_MINOR
        bypasses_immunity = TRUE // Да

/datum/disease/annorwa/stage_act(seconds_per_tick, times_fired) 
        . = ..()
        if(!.)
                return

        if(SPT_PROB(stage * 2, seconds_per_tick))
                affected_mob.emote("faint")
                to_chat(affected_mob, span_danger("You wanna sleep..."))

        switch(stage)
                if(2)
                        if(SPT_PROB(1, seconds_per_tick))
                                to_chat(affected_mob, span_danger("You feel very weak..."))
                        if(SPT_PROB(5, seconds_per_tick))
                                to_chat(affected_mob, span_danger("You REALLY wanna sleep."))
                if(4)
                        var/need_mob_update = FALSE
                        if(SPT_PROB(1, seconds_per_tick))
                                to_chat(affected_mob, span_userdanger("You wanna sleep."))
                                affected_mob.set_dizzy_if_lower(15 SECONDS)
                        if(SPT_PROB(1, seconds_per_tick))
                                to_chat(affected_mob, span_danger("You feel really weak"))
                                need_mob_update += affected_mob.adjustStaminaLoss(100, updating_health = FALSE)
                                affected_mob.emote("Cough")
                        if(SPT_PROB(5, seconds_per_tick))
                                to_chat(affected_mob, span_danger("You feel eepy..."))
                                need_mob_update += affected_mob.adjustStaminaLoss(50, updating_health = FALSE)
                                affected_mob.emote("yawn")
                        if(need_mob_update)
                                affected_mob.updatehealth()
                if(5)
                        var/need_mob_update = FALSE
                        if(SPT_PROB(1, seconds_per_tick))
                                to_chat(affected_mob, span_userdanger("[pick("You feel weak... Maybe rest will help?", "You're muscles collapses in a sharp pain.")]"))
                                need_mob_update += affected_mob.adjustStaminaLoss(70, updating_stamina = FALSE)
                        if(SPT_PROB(5, seconds_per_tick))
                                need_mob_update += affected_mob.adjustStaminaLoss(100, updating_stamina = FALSE)
                                affected_mob.visible_message(span_warning("[affected_mob] faints!"), span_userdanger("You decide to take a nap."))
                                affected_mob.AdjustSleeping(20 SECONDS)
                        if(SPT_PROB(1, seconds_per_tick))
                                to_chat(affected_mob, span_userdanger("Zzzzz..."))
                                affected_mob.adjust_confusion_up_to(0 SECONDS, 300 SECONDS)
                        if(SPT_PROB(20, seconds_per_tick))
                                affected_mob.vomit(VOMIT_CATEGORY_DEFAULT, lost_nutrition = 1)
                        if(SPT_PROB(1.5, seconds_per_tick))
                                to_chat(affected_mob, span_warning("<i>[pick("Your stomach silently rumbles...", "Your stomach seizes up and falls limp, muscles dead and lifeless.", "You could eat a crayon")]</i>"))
                                affected_mob.overeatduration = max(affected_mob.overeatduration - (10 SECONDS), 0)
                                affected_mob.adjust_nutrition(-10)
                        if(SPT_PROB(7.5, seconds_per_tick))
                                to_chat(affected_mob, span_danger("[pick("You feel uncomfortably hot...", "You feel like unzipping your jumpsuit...", "You feel like taking off some clothes...")]"))
                                affected_mob.adjust_bodytemperature(40)
                        if(need_mob_update)
                                affected_mob.updatehealth()

// Да

/obj/item/reagent_containers/cup/bottle/annorwa
        name = "Annoying virus sample culture bottle"
        desc = "A small bottle. Contains a sample of Annorwa."
        spawned_disease = /datum/disease/annorwa