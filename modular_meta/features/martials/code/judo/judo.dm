#define THROW_COMBO "GD"
#define SPIN_COMBO "GGD"

/datum/martial_art/judo
	name = "corporate judo"
	id = "corporate judo"
	help_verb = "Remember the basics of judo"
	smashes_tables = FALSE
	display_combos = TRUE
	max_streak_length = 12
	combo_timer = 5 SECONDS
	grab_escape_chance_modifier = -10
	var/combo_tier = 0
	var/flow = 0

/datum/martial_art/judo/activate_style(mob/living/new_holder)
	. = ..()
	RegisterSignal(holder, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(check_baton))
	for(var/obj/item/item in new_holder.held_items)
		check_baton(equipped_item = item, slot = ITEM_SLOT_HANDS)
	to_chat(new_holder, span_userdanger("The nanites of this belt grant you mastery of corporate judo!"))

/datum/martial_art/judo/deactivate_style(mob/living/remove_from)
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
	if(attacker.body_position == LYING_DOWN)
		return MARTIAL_ATTACK_INVALID
	add_to_streak("G", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS

/datum/martial_art/judo/help_act(mob/living/attacker, mob/living/defender)
	add_to_streak("E", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS
	if(defender.body_position == LYING_DOWN)
		defender.Stun(0.5 SECONDS)
		return MARTIAL_ATTACK_SUCCESS
	attacker.changeNext_move(CLICK_CD_MELEE / 4)
	return MARTIAL_ATTACK_SUCCESS



/datum/martial_art/judo/reset_streak(mob/living/new_target)
	. = ..()
	combo_tier = 0
	flow = 0

/datum/martial_art/judo/proc/apply_flow_effect(mob/living/attacker)
	attacker.changeNext_move(CLICK_CD_MELEE / (1 + flow / 10))


/datum/martial_art/judo/proc/check_streak(mob/living/attacker, mob/living/defender)
	if(findtext(streak, THROW_COMBO))
		var/old_tier = combo_tier
		reset_streak()
		if(old_tier >= 1)
			return Throw(attacker, defender)

	if(findtext(streak, SPIN_COMBO))
		var/old_tier = combo_tier
		reset_streak()
		if(old_tier >= 2)
			return Throw2(attacker, defender)

	return FALSE

/datum/martial_art/judo/proc/Throw(mob/living/attacker, mob/living/defender)
	if(defender.body_position != STANDING_UP)
		return FALSE

	var/turf/behind_attacker = get_step(attacker, turn(attacker.dir, 180))
	var/turf/target_turf = defender.loc

	if(behind_attacker && !behind_attacker.density && !(locate(/obj/structure) in behind_attacker))
		target_turf = behind_attacker
		to_chat(attacker, "т1 Через себя")
	else
		to_chat(attacker, "т1 на месте")

	attacker.do_attack_animation(defender)
	playsound(attacker, 'sound/items/weapons/slam.ogg', 50, TRUE, -1)
	if(target_turf != defender.loc)
		defender.forceMove(target_turf)
		defender.SpinAnimation(5, 1)

	defender.Knockdown(5 SECONDS)
	log_combat(attacker, defender, "slammed (Judo)")
	combo_tier = 1
	flow++
	apply_flow_effect(attacker)
	return TRUE

/datum/martial_art/judo/proc/Throw2(mob/living/attacker, mob/living/defender)
	var/turf/behind_attacker = get_step(attacker, turn(attacker.dir, 180)) // клетка за спиной атакующего
	var/turf/target_turf = defender.loc // по умолчанию падает на месте
	if(defender.body_position != LYING_DOWN)
		if(behind_attacker && !behind_attacker.density && !(locate(/obj/structure) in behind_attacker))
			target_turf = behind_attacker
			to_chat(attacker, "т2 Через себя") //тест
		else
			to_chat(attacker, "т2 на месте") //тест

		attacker.do_attack_animation(defender)
		playsound(attacker, 'sound/items/weapons/slam.ogg', 50, TRUE, -1)
		if(target_turf != defender.loc)
			defender.forceMove(target_turf)
			defender.SpinAnimation(5, 1)
			defender.apply_damage(15, BRUTE)

	defender.Paralyze(7 SECONDS)
	defender.apply_damage(45, STAMINA)
	combo_tier = 2
	flow++
	apply_flow_effect(attacker)
	return TRUE

#undef THROW_COMBO
#undef SPIN_COMBO
