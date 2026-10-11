#define THROW_COMBO "GD"
#define SPIN_COMBO "GGD"
#define WHEELTHROW_COMBO "GDH"
#define GROUND_COMBO "GG"
#define TWIST_COMBO "GD"
#define GB_SEGMENT_1 "EDEG"
#define GB_SEGMENT_2 "DDGE"
#define GB_SEGMENT_3 "DDGE"

/datum/martial_art/judo
	name = "corporate judo"
	id = "corporate judo"
	help_verb = "Remember the basics of judo"
	smashes_tables = FALSE
	display_combos = TRUE
	max_streak_length = 12
	combo_timer = 5 SECONDS
	grab_escape_chance_modifier = -10

/datum/martial_art/judo/activate_style(mob/living/new_holder)
	. = ..()
	new_holder.AddComponent(/datum/component/judo_state)
	RegisterSignal(holder, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(check_baton))
	for(var/obj/item/item in new_holder.held_items)
		check_baton(equipped_item = item, slot = ITEM_SLOT_HANDS)
	to_chat(new_holder, span_userdanger("The nanites of this belt grant you mastery of corporate judo!"))

/datum/martial_art/judo/deactivate_style(mob/living/remove_from)
	var/datum/component/judo_state/state = remove_from.GetComponent(/datum/component/judo_state)
	if(state)
		state.reset()
		qdel(state)
	UnregisterSignal(holder, COMSIG_MOB_EQUIPPED_ITEM)
	to_chat(remove_from, span_userdanger("You are forgetting the mastery of corporate judo..."))
	return ..()

/datum/martial_art/judo/proc/check_baton(datum/source, obj/item/equipped_item, slot)
	SIGNAL_HANDLER
	if(!istype(equipped_item, /obj/item/melee/baton))
		return
	if(slot != ITEM_SLOT_HANDS)
		return
	to_chat(holder, span_warning("Your hands are rejecting the [equipped_item] against your will!"))
	holder.dropItemToGround(equipped_item)

//ИНТЕНТЫ

/datum/martial_art/judo/harm_act(mob/living/attacker, mob/living/defender)
	var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
	if(!state)
		return MARTIAL_ATTACK_FAIL

	if(state.grabbed_mob == defender)
		if(state.get_tier() >= 1)
			add_to_streak("H", defender)
			if(findtext(streak, TWIST_COMBO))
				reset_streak()
				return twist(attacker, defender)
		return ground_harm(attacker, defender)

	if(defender.check_block(attacker, 10, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	add_to_streak("H", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS

	attacker.do_attack_animation(defender)
	var/picked_hit_type = pick("robust", "strike", "punch")
	var/bonus_damage = 12
	defender.apply_damage(bonus_damage, BRUTE)
	playsound(defender, 'sound/effects/hit_punch.ogg', 50, TRUE, -1)
	defender.visible_message(
		span_danger("[attacker] [picked_hit_type]ed [defender]!"),
		span_userdanger("You're [picked_hit_type]ed by [attacker]!"),
		span_hear("You hear a sickening sound of flesh hitting flesh!"),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)
	to_chat(attacker, span_danger("You [picked_hit_type] [defender]!"))
	log_combat(attacker, defender, "([picked_hit_type]'d)([src])")
	return MARTIAL_ATTACK_SUCCESS

/datum/martial_art/judo/disarm_act(mob/living/attacker, mob/living/defender)
	var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
	if(!state)
		return MARTIAL_ATTACK_FAIL

	if(defender.check_block(attacker, 0, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	add_to_streak("D", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS

	if(attacker == defender)
		return MARTIAL_ATTACK_FAIL
	return MARTIAL_ATTACK_INVALID

/datum/martial_art/judo/grab_act(mob/living/attacker, mob/living/defender)
	var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
	if(!state)
		return MARTIAL_ATTACK_FAIL

	if(attacker == defender)
		return MARTIAL_ATTACK_INVALID

	if(defender.check_block(attacker, 0, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	if(state.grabbed_mob)
		return MARTIAL_ATTACK_INVALID

	// Оба лежат — партер
	if(attacker.body_position == LYING_DOWN && defender.body_position == LYING_DOWN)
		add_to_streak("G", defender)
		if(check_streak(attacker, defender))
			return MARTIAL_ATTACK_SUCCESS
		defender.apply_damage(5, STAMINA)
		return MARTIAL_ATTACK_SUCCESS

	// Атакующий лежит, цель стоит
	if(attacker.body_position == LYING_DOWN)
		if(attacker.grab_state == GRAB_PASSIVE)
			defender.grabbedby(attacker, TRUE)
			return MARTIAL_ATTACK_SUCCESS
		else if(attacker.grab_state == GRAB_AGGRESSIVE)
			defender.Knockdown(3 SECONDS)
			return MARTIAL_ATTACK_SUCCESS
		return MARTIAL_ATTACK_SUCCESS

	// Атакующий стоит
	add_to_streak("G", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS

	return MARTIAL_ATTACK_INVALID

/datum/martial_art/judo/help_act(mob/living/attacker, mob/living/defender)
	var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
	if(!state)
		return MARTIAL_ATTACK_FAIL

	add_to_streak("E", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS

	if(defender.body_position == LYING_DOWN)
		defender.Stun(0.5 SECONDS)
		return MARTIAL_ATTACK_SUCCESS

	attacker.changeNext_move(CLICK_CD_MELEE / 4)
	return MARTIAL_ATTACK_SUCCESS

//ПРОВЕРКА КОМБО

/datum/martial_art/judo/proc/check_streak(mob/living/attacker, mob/living/defender)
	var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
	if(!state)
		return FALSE

	// Golden Blast: сегмент 3
	if(findtext(streak, GB_SEGMENT_1 + GB_SEGMENT_2 + GB_SEGMENT_3))
		reset_streak()
		return golden_blast_segment(attacker, defender, 3)

	// Golden Blast: сегмент 2
	if(findtext(streak, GB_SEGMENT_1 + GB_SEGMENT_2))
		reset_streak()
		return golden_blast_segment(attacker, defender, 2)

	// Golden Blast: сегмент 1
	if(findtext(streak, GB_SEGMENT_1))
		reset_streak()
		return golden_blast_segment(attacker, defender, 1)

	// T2 партер: вывих
	if(attacker.body_position == LYING_DOWN && defender.body_position == LYING_DOWN && findtext(streak, TWIST_COMBO))
		if(state.get_tier() >= 1)
			reset_streak()
			return twist(attacker, defender)
		else
			reset_streak()
			return FALSE

	// T1 партер: захват
	if(attacker.body_position == LYING_DOWN && defender.body_position == LYING_DOWN && findtext(streak, GROUND_COMBO))
		reset_streak()
		return ground(attacker, defender)

	// T3 стойка
	if(findtext(streak, WHEELTHROW_COMBO))
		if(state.get_tier() >= 2)
			reset_streak()
			return wheelthrow(attacker, defender)

	// T2 стойка
	if(findtext(streak, SPIN_COMBO))
		if(state.get_tier() >= 1)
			reset_streak()
			return Throw2(attacker, defender)
		else
			reset_streak()
			return FALSE

	// T1 стойка
	if(findtext(streak, THROW_COMBO))
		reset_streak()
		return Throw(attacker, defender)

	return FALSE

//СТОЙКА

/datum/martial_art/judo/proc/Throw(mob/living/attacker, mob/living/defender)
	if(defender.body_position != STANDING_UP)
		return FALSE

	var/turf/behind_attacker = get_step(attacker, turn(attacker.dir, 180))
	var/turf/target_turf = defender.loc
	var/has_obstacle = FALSE
	if(behind_attacker)
		for(var/atom/A in behind_attacker)
			if(A.density)
				has_obstacle = TRUE
				break
		if(behind_attacker.density)
			has_obstacle = TRUE
	if(!has_obstacle && behind_attacker)
		target_turf = behind_attacker

	attacker.do_attack_animation(defender)
	playsound(attacker, 'sound/items/weapons/slam.ogg', 50, TRUE, -1)
	playsound(attacker, 'sound/items/style/combo_dull1.ogg', 50, TRUE, -1)

	if(target_turf != defender.loc)
		defender.forceMove(target_turf)
		defender.SpinAnimation(10, 1)
		defender.dir = turn(defender.dir, 180)

	defender.Knockdown(5 SECONDS)
	log_combat(attacker, defender, "slammed ([src])")

	var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
	if(!state)
		return FALSE
	state.set_tier(1)
	state.refresh_timer(attacker, src)
	return TRUE

/datum/martial_art/judo/proc/Throw2(mob/living/attacker, mob/living/defender)
	// цель стоит
	if(defender.body_position != LYING_DOWN)
		var/turf/behind_attacker = get_step(attacker, turn(attacker.dir, 180))
		var/turf/target_turf = defender.loc
		var/has_obstacle = FALSE
		if(behind_attacker)
			for(var/atom/A in behind_attacker)
				if(A.density)
					has_obstacle = TRUE
					break
			if(behind_attacker.density)
				has_obstacle = TRUE
		if(!has_obstacle && behind_attacker)
			target_turf = behind_attacker

		attacker.do_attack_animation(defender)
		playsound(attacker, 'sound/items/weapons/slam.ogg', 50, TRUE, -1)
		playsound(attacker, 'sound/items/style/combo_cool3.ogg', 50, TRUE, -1)

		if(target_turf != defender.loc)
			defender.forceMove(target_turf)
			defender.SpinAnimation(10, 1)
			defender.dir = turn(defender.dir, 180)
			defender.apply_damage(15, OXY)

		defender.Paralyze(7 SECONDS)
		defender.Knockdown(7 SECONDS)
		log_combat(attacker, defender, "slammed T2 ([src])")

		var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
		if(!state)
			return FALSE
		state.set_tier(2)
		state.refresh_timer(attacker, src)
		return TRUE

	// цель лежит
	else
		attacker.do_attack_animation(defender)
		playsound(attacker, 'sound/items/weapons/slam.ogg', 50, TRUE, -1)
		playsound(attacker, 'sound/items/style/combo_cool3.ogg', 50, TRUE, -1)

		defender.SpinAnimation(10, 1)
		defender.dir = turn(defender.dir, 180)

		defender.apply_damage(45, STAMINA)
		defender.Paralyze(7 SECONDS)
		defender.Knockdown(7 SECONDS)
		log_combat(attacker, defender, "T2 ground strike ([src])")

		var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
		if(!state)
			return FALSE
		state.set_tier(2)
		state.refresh_timer(attacker, src)
		return TRUE

/datum/martial_art/judo/proc/wheelthrow(mob/living/attacker, mob/living/defender)
	if(attacker.body_position != LYING_DOWN)
		playsound(get_turf(attacker), 'sound/effects/magic/tail_swing.ogg', 40, TRUE)
		defender.SpinAnimation(10, 1)
	else
		playsound(get_turf(attacker), 'sound/items/weapons/slam.ogg', 40, TRUE)

	defender.apply_damage(120, STAMINA)
	defender.Knockdown(15 SECONDS)
	defender.set_confusion(10 SECONDS)
	var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
	if(!state)
		return FALSE
	state.set_tier(2)
	state.refresh_timer(attacker, src)
	log_combat(attacker, defender, "wheel throw / floor pin ([src])")
	return TRUE

//ПАРТЕР

/datum/martial_art/judo/proc/ground(mob/living/attacker, mob/living/defender)
	if(attacker.body_position != LYING_DOWN || defender.body_position != LYING_DOWN)
		return FALSE

	var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
	if(!state || state.grabbed_mob)
		return FALSE

	state.grabbed_mob = defender
	state.has_twisted = FALSE
	attacker.do_attack_animation(defender)
	to_chat(attacker, span_danger("Вы захватываете [defender]! Используйте Harm для вывиха."))
	attacker.Immobilize(5 SECONDS)
	defender.Immobilize(5 SECONDS)
	defender.drop_all_held_items()
	defender.apply_damage(10, STAMINA)

	state.grabbed_timer = addtimer(CALLBACK(src, PROC_REF(end_ground), attacker, defender), 5 SECONDS, TIMER_UNIQUE | TIMER_STOPPABLE)
	addtimer(CALLBACK(src, PROC_REF(ground_tick), attacker, defender), 1 SECONDS, TIMER_UNIQUE | TIMER_STOPPABLE)

	state.set_tier(1)
	state.refresh_timer(attacker, src)
	return TRUE

/datum/martial_art/judo/proc/ground_tick(mob/living/attacker, mob/living/defender)
	var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
	if(!state || state.grabbed_mob != defender)
		return
	if(defender.body_position != LYING_DOWN)
		end_ground(attacker, defender)
		return
	if(attacker.body_position != LYING_DOWN)
		end_ground(attacker, defender)
		return
	if(!attacker.Adjacent(defender))
		end_ground(attacker, defender)
		return

	defender.apply_damage(15, STAMINA)
	attacker.Immobilize(1 SECONDS)
	defender.Immobilize(1 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(ground_tick), attacker, defender), 1 SECONDS, TIMER_UNIQUE | TIMER_STOPPABLE)

/datum/martial_art/judo/proc/ground_harm(mob/living/attacker, mob/living/defender)
	var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
	if(!state || state.grabbed_mob != defender)
		return FALSE
	if(state.has_twisted)
		to_chat(attacker, "уже вывихнута")
		return FALSE
	state.has_twisted = TRUE

	var/obj/item/bodypart/arm = pick(list(
		defender.get_bodypart(BODY_ZONE_L_ARM),
		defender.get_bodypart(BODY_ZONE_R_ARM)
	))
	if(!arm)
		return FALSE

	attacker.do_attack_animation(defender)
	defender.apply_damage(25, BRUTE, arm.body_zone)
	defender.apply_damage(30, STAMINA)
	defender.Paralyze(5 SECONDS)
	end_ground(attacker, defender)
	return TRUE

/datum/martial_art/judo/proc/twist(mob/living/attacker, mob/living/defender)
	var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
	if(!state || state.grabbed_mob != defender)
		return FALSE

	var/obj/item/bodypart/arm = pick(list(
		defender.get_bodypart(BODY_ZONE_L_ARM),
		defender.get_bodypart(BODY_ZONE_R_ARM)
	))
	if(!arm)
		return FALSE

	attacker.do_attack_animation(defender)
	defender.apply_damage(25, BRUTE, arm.body_zone)
	defender.apply_damage(30, STAMINA)
	defender.Paralyze(5 SECONDS)
	end_ground(attacker, defender)
	state.set_tier(2)
	state.refresh_timer(attacker, src)
	return TRUE

/datum/martial_art/judo/proc/end_ground(mob/living/attacker, mob/living/defender)
	var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
	if(!state)
		return
	state.grabbed_mob = null
	state.grabbed_timer = null
	attacker.SetImmobilized(0)
	defender.SetImmobilized(0)

//Голденбласт
/datum/martial_art/judo/proc/golden_blast_segment(mob/living/attacker, mob/living/defender, segment)
	switch(segment)
		if(1)
			defender.Stun(2 SECONDS)
			defender.apply_damage(30, STAMINA)
			to_chat(attacker, span_notice("GB1: control initiated")) //тест
			do_sparks(5, FALSE, defender)
			defender.SpinAnimation(10, 1)
			defender.set_confusion(5 SECONDS)
			log_combat(attacker, defender, "golden blast1 ([src])")
		if(2)
			defender.Paralyze(3 SECONDS)
			defender.apply_damage(30, STAMINA)
			to_chat(attacker, span_notice("GB2: control intensified")) //тест
			do_sparks(5, FALSE, defender)
			defender.SpinAnimation(10, 1)
			defender.set_confusion(5 SECONDS)
			log_combat(attacker, defender, "golden blast2 ([src])")
		if(3)
			defender.Paralyze(5 SECONDS)
			defender.apply_damage(200, STAMINA)
			do_sparks(5, FALSE, defender)
			defender.SpinAnimation(10, 1)
			defender.Knockdown(30 SECONDS)
			defender.set_confusion(30 SECONDS)
			to_chat(attacker, span_notice("GB3: finisher")) //тест
			attacker.say("GOLDEN BLAST!")
			log_combat(attacker, defender, "golden blast3 ([src])")
	return TRUE

#undef THROW_COMBO
#undef SPIN_COMBO
#undef WHEELTHROW_COMBO
#undef GROUND_COMBO
#undef TWIST_COMBO
#undef GB_SEGMENT_1
#undef GB_SEGMENT_2
#undef GB_SEGMENT_3
