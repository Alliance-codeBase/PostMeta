/datum/disease/cordafungi
        form = "Disease"
        name = "Corda"
        max_stages = 5
        spread_text = "Airborne"
        cure_text = "Pest spray & cyanide"
        cures = list(/datum/reagent/toxin/cyanide,   /datum/reagent/toxin/pestkiller)
        agent = "Cordius Fungi"
        viable_mobtypes = list(/mob/living/carbon/human)
        cure_chance = 8
        desc = "Strange shroom that turns humans into maniacs"
        required_organ = ORGAN_SLOT_BRAIN
        severity = DISEASE_SEVERITY_BIOHAZARD
        bypasses_immunity = TRUE // А как там извините бешенство распростроняется, напомните

/datum/disease/cordafungi/stage_act(seconds_per_tick, times_fired) 
        . = ..()
        if(!.)
                return

        if(SPT_PROB(stage * 2, seconds_per_tick))
                affected_mob.emote("gasp")
                to_chat(affected_mob, span_danger("You're head hurts..."))

        switch(stage)
                if(2)
                        if(SPT_PROB(1, seconds_per_tick))
                                to_chat(affected_mob, span_danger("You feel stranger than before..."))
                        if(SPT_PROB(5, seconds_per_tick))
                                to_chat(affected_mob, span_danger("Your thoughts are confused."))
                if(4)
                        var/need_mob_update = FALSE
                        if(SPT_PROB(1, seconds_per_tick))
                                to_chat(affected_mob, span_userdanger("You're muscles collapses in a sharp pain!"))
                                affected_mob.set_dizzy_if_lower(15 SECONDS)
                        if(SPT_PROB(1, seconds_per_tick))
                                to_chat(affected_mob, span_danger("You feel PAIN!"))
                                need_mob_update += affected_mob.adjustOxyLoss(10, updating_health = FALSE)
                                affected_mob.emote("gasp")
                        if(SPT_PROB(5, seconds_per_tick))
                                to_chat(affected_mob, span_danger("You feel like your skin falls off."))
                                need_mob_update += affected_mob.adjustBruteLoss(15, updating_health = FALSE)
                                affected_mob.emote("scream")
                        if(need_mob_update)
                                affected_mob.updatehealth()
                if(5)
                        var/need_mob_update = FALSE
                        if(SPT_PROB(1, seconds_per_tick))
                                to_chat(affected_mob, span_userdanger("[pick("You feel weak... Maybe rest will help?", "You're muscles collapses in a sharp pain.")]"))
                                need_mob_update += affected_mob.adjustStaminaLoss(70, updating_stamina = FALSE)
                        if(SPT_PROB(5, seconds_per_tick))
                                need_mob_update += affected_mob.adjustStaminaLoss(100, updating_stamina = FALSE)
                                affected_mob.visible_message(span_warning("[affected_mob] faints!"), span_userdanger("You feel like it's over... But it's not"))
                                affected_mob.AdjustSleeping(3 SECONDS)
                        if(SPT_PROB(1, seconds_per_tick))
                                to_chat(affected_mob, span_userdanger("I MUST BITE THEM ALL!"))
                                affected_mob.adjust_confusion_up_to(0 SECONDS, 5 SECONDS)
                        if(SPT_PROB(5, seconds_per_tick))
                                affected_mob.vomit(VOMIT_CATEGORY_DEFAULT, lost_nutrition = 20)
                        if(SPT_PROB(1.5, seconds_per_tick))
                                to_chat(affected_mob, span_warning("<i>[pick("Your stomach silently rumbles...", "Your stomach seizes up and falls limp, muscles dead and lifeless.", "You could eat a crayon")]</i>"))
                                affected_mob.overeatduration = max(affected_mob.overeatduration - (10 SECONDS), 0)
                                affected_mob.adjust_nutrition(-100)
                        if(SPT_PROB(7.5, seconds_per_tick))
                                to_chat(affected_mob, span_danger("[pick("You feel uncomfortably hot...", "You feel like unzipping your jumpsuit...", "You feel like taking off some clothes...")]"))
                                affected_mob.adjust_bodytemperature(40)
                        if(need_mob_update)
                                affected_mob.updatehealth()

