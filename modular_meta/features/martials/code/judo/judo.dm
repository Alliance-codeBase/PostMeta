#define THROW_COMBO "GD"
#define SPIN_COMBO "GGD"
#define GROUND_COMBO "GG"

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

/datum/martial_art/judo/harm_act(mob/living/attacker, mob/living/defender)
	var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
	if(state && state.grabbed_mob == defender)
		return ground_harm(attacker, defender) // Если мы кого-то держим — выкручиваем руку
	if(defender.check_block(attacker, 10, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL
	add_to_streak("H", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS
	attacker.do_attack_animation(defender)
	var/picked_hit_type = pick("robust", "strike", "punch")
	var/bonus_damage = 9
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
	log_combat(attacker, defender, "attacked ([picked_hit_type]'d)(judo)")
	return MARTIAL_ATTACK_SUCCESS

/datum/martial_art/judo/disarm_act(mob/living/attacker, mob/living/defender)
	if(defender.check_block(attacker, 0, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL
	add_to_streak("D", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS
	if(attacker == defender)
		return MARTIAL_ATTACK_FAIL
	return MARTIAL_ATTACK_INVALID

/datum/martial_art/judo/grab_act(mob/living/attacker, mob/living/defender)
	if(attacker == defender)
		return MARTIAL_ATTACK_INVALID

	if(defender.check_block(attacker, 0, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	// Если ты лежишь, но цель стоит — можно сделать подсечку
	if(attacker.body_position == LYING_DOWN && defender.body_position == STANDING_UP)
		add_to_streak("G", defender)
		if(check_streak(attacker, defender))
			return MARTIAL_ATTACK_SUCCESS
		// Если комбо не сложилось — делаем подсечку
		attacker.do_attack_animation(defender)
		defender.visible_message(
			span_danger("[attacker] делает подсечку [defender] из партера!"),
			span_userdanger("[attacker] делает вам подсечку!"),
			span_hear("Вы слышите звук удара!"),
			null,
			attacker,
		)
		to_chat(attacker, span_danger("Вы делаете подсечку [defender]!"))
		defender.Knockdown(3 SECONDS)
		defender.apply_damage(10, BRUTE)
		log_combat(attacker, defender, "leg sweep from ground (Judo)")
		return MARTIAL_ATTACK_SUCCESS

	// Если ты лежишь, и цель лежит — можно бороться в партере
	if(attacker.body_position == LYING_DOWN && defender.body_position == LYING_DOWN)
		add_to_streak("G", defender)
		if(check_streak(attacker, defender))
			return MARTIAL_ATTACK_SUCCESS
		// Если комбо не сложилось — просто захват
		attacker.do_attack_animation(defender)
		defender.visible_message(
			span_danger("[attacker] борется с [defender] в партере!"),
			span_userdanger("[attacker] борется с вами в партере!"),
			span_hear("Вы слышите борьбу!"),
			null,
			attacker,
		)
		to_chat(attacker, span_danger("Вы боретесь с [defender] в партере!"))
		defender.apply_damage(5, STAMINA)
		return MARTIAL_ATTACK_SUCCESS

	// Если ты стоишь — стандартный граб
	if(attacker.body_position != LYING_DOWN)
		add_to_streak("G", defender)
		if(check_streak(attacker, defender))
			return MARTIAL_ATTACK_SUCCESS

	return MARTIAL_ATTACK_INVALID

/datum/martial_art/judo/help_act(mob/living/attacker, mob/living/defender)
	add_to_streak("E", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS
	if(defender.body_position == LYING_DOWN)
		defender.Stun(0.5 SECONDS)
		return MARTIAL_ATTACK_SUCCESS
	var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
	if(!state)
		return MARTIAL_ATTACK_SUCCESS
	attacker.changeNext_move(CLICK_CD_MELEE / (1 + state.get_flow() / 10) / 4)
	return MARTIAL_ATTACK_SUCCESS

/datum/martial_art/judo/reset_streak(mob/living/new_target)
	. = ..()

/datum/martial_art/judo/proc/apply_flow_effect(mob/living/attacker)
	var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
	if(!state)
		return
	attacker.changeNext_move(CLICK_CD_MELEE / (1 + state.get_flow() / 10))


/datum/martial_art/judo/proc/check_streak(mob/living/attacker, mob/living/defender)
	// Партер: работает, только если ОБА лежат
	if(attacker.body_position == LYING_DOWN && defender.body_position == LYING_DOWN && findtext(streak, GROUND_COMBO))
		reset_streak()
		return ground(attacker, defender)

	// T2: работает, если цель лежит или атакующий на T2
	if(findtext(streak, SPIN_COMBO))
		var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
		if(state && state.get_tier() >= 1)
			reset_streak()
			return Throw2(attacker, defender)
		else
			reset_streak()
			return FALSE

	// T1: работает всегда
	if(findtext(streak, THROW_COMBO))
		reset_streak()
		return Throw(attacker, defender)

	return FALSE


//стойка
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
		to_chat(attacker, "т1 Через себя")
	else
		to_chat(attacker, "т1 на месте")

	attacker.do_attack_animation(defender)
	playsound(attacker, 'sound/items/weapons/slam.ogg', 50, TRUE, -1)
	playsound(attacker, 'sound/items/style/combo_dull1.ogg', 50, TRUE, -1)
	if(target_turf != defender.loc)
		defender.forceMove(target_turf)
		defender.SpinAnimation(10, 1)

	defender.Knockdown(5 SECONDS)
	log_combat(attacker, defender, "slammed (Judo)")

	var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
	if(!state)
		return FALSE
	state.set_tier(1)
	state.increment_flow()
	state.refresh_timer(attacker, src)
	apply_flow_effect(attacker)
	return TRUE

/datum/martial_art/judo/proc/Throw2(mob/living/attacker, mob/living/defender)
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
			to_chat(attacker, "т2 Через себя")
		else
			to_chat(attacker, "т2 на месте")

		attacker.do_attack_animation(defender)
		playsound(attacker, 'sound/items/weapons/slam.ogg', 50, TRUE, -1)
		playsound(attacker, 'sound/items/style/combo_cool3.ogg', 50, TRUE, -1)

		if(target_turf != defender.loc)
			defender.forceMove(target_turf)
			defender.SpinAnimation(10, 1)
			defender.apply_damage(15, BRUTE)

		defender.Paralyze(7 SECONDS)

		var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
		if(!state)
			return FALSE
		state.set_tier(2)
		state.increment_flow()
		state.refresh_timer(attacker, src)
		apply_flow_effect(attacker)
		return TRUE

	else
		attacker.do_attack_animation(defender)
		playsound(attacker, 'sound/items/weapons/slam.ogg', 50, TRUE, -1)
		defender.apply_damage(45, STAMINA)
		to_chat(attacker, "т2 добивание")

		var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
		if(!state)
			return FALSE
		state.set_tier(2)
		state.increment_flow()
		state.refresh_timer(attacker, src)
		apply_flow_effect(attacker)
		return TRUE


// механ партера
/datum/martial_art/judo/proc/ground_tick(mob/living/attacker, mob/living/defender)
	var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
	if(!state || state.grabbed_mob != defender)
		return
	if(defender.body_position != LYING_DOWN)
		return

	defender.apply_damage(15, STAMINA)
	to_chat(attacker, span_notice("Вы продолжаете удерживать [defender]."))
	addtimer(CALLBACK(src, PROC_REF(ground_tick), attacker, defender), 1 SECONDS, TIMER_UNIQUE | TIMER_STOPPABLE)

/datum/martial_art/judo/proc/ground_harm(mob/living/attacker, mob/living/defender)
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
	defender.visible_message(
		span_danger("[attacker] выкручивает руку [defender]!"),
		span_userdanger("[attacker] выкручивает вам руку!"),
		span_hear("Вы слышите хруст!"),
		null,
		attacker,
	)
	to_chat(attacker, span_danger("Вы выкручиваете руку [defender]!"))

	defender.apply_damage(25, BRUTE, arm.body_zone)
	defender.apply_damage(30, STAMINA)
	return TRUE

/datum/martial_art/judo/proc/end_ground(mob/living/attacker, mob/living/defender)
	var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
	if(!state)
		return
	state.grabbed_mob = null
	state.grabbed_timer = null
	to_chat(attacker, span_notice("Вы отпускаете [defender]."))

// партер
/datum/martial_art/judo/proc/ground(mob/living/attacker, mob/living/defender)
	if(attacker.body_position != LYING_DOWN || defender.body_position != LYING_DOWN)
		return FALSE

	var/datum/component/judo_state/state = attacker.GetComponent(/datum/component/judo_state)
	if(!state)
		return FALSE

	// Если уже кого-то держим — не начинаем новое
	if(state.grabbed_mob)
		return FALSE

	state.grabbed_mob = defender

	attacker.do_attack_animation(defender)
	defender.visible_message(
		span_danger("[attacker] захватывает [defender] в партере!"),
		span_userdanger("[attacker] захватывает вас в партере!"),
		span_hear("Вы слышите борьбу!"),
		null,
		attacker,
	)
	to_chat(attacker, span_danger("Вы захватываете [defender]! Используйте Harm, чтобы выкрутить руку, или ждите, чтобы утомить."))

	defender.Paralyze(5 SECONDS)

	// Запускаем таймер удержания
	state.grabbed_timer = addtimer(CALLBACK(src, PROC_REF(end_ground), attacker, defender), 5 SECONDS, TIMER_UNIQUE | TIMER_STOPPABLE)

	// Запускаем тик стамины
	addtimer(CALLBACK(src, PROC_REF(ground_tick), attacker, defender), 1 SECONDS, TIMER_UNIQUE | TIMER_STOPPABLE)

	return TRUE

#undef THROW_COMBO
#undef SPIN_COMBO
#undef GROUND_COMBO
