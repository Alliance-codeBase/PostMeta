// Code by bruh24, sprites by DrNastiel, sounds are mentioned in attributions.txt in their respectable folder

/obj/item/sledgehammer/syndicate
	name = "Sledgehammer"
	desc = "A mad engineer's choice"
	icon = 'modular_meta/features/sledgehammers/icons/syndicate_sledgehammer.dmi'
	lefthand_file = 'modular_meta/features/sledgehammers/icons/syndicate_sledgehammer_lefthand.dmi'
	righthand_file = 'modular_meta/features/sledgehammers/icons/syndicate_sledgehammer_righthand.dmi'
	force = 10
	demolition_mod = 4
	attack_speed = 1.5 SECONDS
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = NONE
	obj_flags = NONE
	attack_verb_continuous = list("attacks", "smashes", "slams", "breaks", "wrecks", "obliterates")
	attack_verb_simple = list("attack", "smash", "slam", "wreck", "break", "obliterate")
	wound_bonus = -15
	force_wielded = 18
	wall_hits_to_smash = 2
	reinforced_wall_hits_to_smash = 4
	lore = "\
		Originally an ordinary demolition tool, this sturdy sledgehammer owes its commercial success \
		to an incident Nanotrasen would rather forget.<br>\
		<br>\
		A Tiger Cooperative member reportedly took a surplus hammer from a mining outpost's \
		equipment locker and used it to massacre the responding security detail. \
		Surviving footage shows him gripping it <b>with both hands</b>, \
		drawing back and holding his stance before delivering each crushing blow. \
		When the remaining personnel barricaded themselves inside, \
		he <span class='bolddanger'>battered through the walls</span>. \
		<b> Even reinforced sections eventually gave way to repeated, fully wound-up strikes. </b> <br>\
		<br>\
		One critically wounded officer tried to crawl away. The attacker stood over him \
		and raised the hammer for a final blow. \
		The impact <span class='bolddanger'>tore the officer's head from his shoulders</span>, \
		sending it down the corridor and leaving a thick streak of blood behind it. \
		The last distress call ended with hammering on the bridge door.<br>\
		<br>\
		Donk Co. acquired the surviving footage and commissioned a mass-produced version \
		with a reinforced handle and a heavier head. Officially, these improvements were intended \
		for demanding industrial applications. The demonstration video circulated through \
		Syndicate channels suggested otherwise.<br>\
		<br>\
		The hammer remains in production. Replacement handles are sold separately."
	var/charge = 0
	var/maximum_charge = 6
	var/charge_step_duration = 1 SECONDS
	var/charging = FALSE
	var/charge_button_held = FALSE
	var/next_charge_time
	var/force_per_charge = 9
	var/wielded_wound_bonus = 15
	var/wound_bonus_per_charge = 1.5
	var/silicon_force_penalty = 17
	var/charged_silicon_force_penalty = 42
	var/mecha_force_penalty = 10
	var/static/list/head_crush_sounds = list(
		'modular_meta/features/sledgehammers/sound/flesh_hit1.ogg',
		'modular_meta/features/sledgehammers/sound/flesh_hit2.ogg',
	)
	var/static/list/charge_phrases = list(
		"Your grip is still unsteady.",
		"You tighten your grip on the sledgehammer.",
		"You draw the sledgehammer back.",
		"The weight settles into your hands.",
		"Your arms tense for a crushing blow.",
		"You're ready to strike with full force.",
	)

/obj/item/sledgehammer/syndicate/examine(mob/user)
	. = ..()
	. += span_notice("Right-click with this in-hand to prepare a charged strike, the more progress bar is completed on the hammer, the harder will be the blow")

/obj/item/sledgehammer/syndicate/pre_attack(atom/target, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(.)
		return .
	if(issilicon(target))
		MODIFY_ATTACK_FORCE(attack_modifiers, -(charge >= 3 ? charged_silicon_force_penalty : silicon_force_penalty))
	if(ismecha(target))
		MODIFY_ATTACK_FORCE(attack_modifiers, -mecha_force_penalty)
	if(!can_crush_head(target, user))
		return FALSE
	crush_head(target, user)
	return TRUE

/obj/item/sledgehammer/syndicate/attack(mob/living/target_mob, mob/living/user, list/modifiers, list/attack_modifiers)
	if(!HAS_TRAIT(src, TRAIT_WIELDED))
		return ..()
	MODIFY_ATTACK_FORCE(attack_modifiers, force_per_charge * charge)
	wound_bonus = wielded_wound_bonus + wound_bonus_per_charge * charge
	. = ..()
	wound_bonus = initial(wound_bonus)

/obj/item/sledgehammer/syndicate/afterattack(atom/target, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	charge = 0

/obj/item/sledgehammer/syndicate/fling(mob/living/target, atom/throw_target, mob/living/user)
	switch(charge)
		if(1)
			target.throw_at(throw_target, 1, 0.5)
		if(2)
			target.throw_at(throw_target, 2, 0.7)
		if(3)
			target.throw_at(throw_target, 3, 0.9)
		if(4)
			target.throw_at(throw_target, 4, 1.1)
			target.Stun(0.2 SECONDS)
		if(5)
			target.throw_at(throw_target, 4, 1.3)
			target.Stun(0.5 SECONDS)
			target.Knockdown(2 SECONDS)
		if(6)
			target.throw_at(throw_target, 6, 2)
			target.Stun(1.5 SECONDS)
			target.Knockdown(4 SECONDS)

/obj/item/sledgehammer/syndicate/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(!user.client)
		return
	if(slot != ITEM_SLOT_HANDS)
		UnregisterSignal(user.client, list(COMSIG_CLIENT_MOUSEDOWN, COMSIG_CLIENT_MOUSEUP))
		return
	RegisterSignal(user.client, COMSIG_CLIENT_MOUSEDOWN, PROC_REF(on_mouse_down), override = TRUE)
	RegisterSignal(user.client, COMSIG_CLIENT_MOUSEUP, PROC_REF(on_mouse_up), override = TRUE)

/obj/item/sledgehammer/syndicate/dropped(mob/user, silent = FALSE)
	if(user.client)
		UnregisterSignal(user.client, list(COMSIG_CLIENT_MOUSEDOWN, COMSIG_CLIENT_MOUSEUP))
	charge = 0
	return ..()

/obj/item/sledgehammer/syndicate/pick_hitsound(mob/living/target_mob)
	if(HAS_TRAIT(src, TRAIT_WIELDED) && iscarbon(target_mob) && charge >= 5)
		return 'modular_meta/features/sledgehammers/sound/flesh_hit3.ogg'
	return ..()

/obj/item/sledgehammer/syndicate/proc/on_mouse_down(client/source, atom/object, turf/location, control, params)
	SIGNAL_HANDLER

	var/list/mouse_modifiers = params2list(params)
	if(mouse_modifiers[BUTTON] != RIGHT_CLICK)
		return
	var/mob/living/user = source.mob
	if(!iscarbon(user) || user.get_active_held_item() != src || charging)
		return
	INVOKE_ASYNC(src, PROC_REF(charge_up), user)

/obj/item/sledgehammer/syndicate/proc/on_mouse_up(client/source, atom/object, turf/location, control, params)
	SIGNAL_HANDLER

	var/list/mouse_modifiers = params2list(params)
	if(mouse_modifiers[BUTTON] != RIGHT_CLICK)
		return
	charge_button_held = FALSE
	if(charge)
		to_chat(source.mob, span_notice(charge_phrases[charge]))

/obj/item/sledgehammer/syndicate/proc/charge_up(mob/living/carbon/user)
	if(!HAS_TRAIT(src, TRAIT_WIELDED))
		balloon_alert(user, "wield first!")
		return
	if(user.incapacitated)
		return

	charging = TRUE
	charge_button_held = TRUE
	charge = 0
	next_charge_time = world.time + charge_step_duration
	do_after(user, maximum_charge * charge_step_duration, src, extra_checks = CALLBACK(src, PROC_REF(charge_tick), user), timed_action_flags = IGNORE_USER_LOC_CHANGE | IGNORE_SLOWDOWNS)
	charging = FALSE
	charge_button_held = FALSE

/obj/item/sledgehammer/syndicate/proc/charge_tick(mob/living/carbon/user)
	if(!charge_button_held)
		return FALSE

	while(world.time >= next_charge_time && charge < maximum_charge)
		charge++
		user.playsound_local(user, 'sound/vehicles/mecha/skyfall_power_up.ogg', 15)
		Shake(pixelshifty = 5, duration = 0.1 SECONDS, shake_interval = 0.1 SECONDS)
		next_charge_time += charge_step_duration
	return TRUE

/obj/item/sledgehammer/syndicate/proc/can_crush_head(atom/target, mob/living/user)
	if(!iscarbon(target) || check_zone(user.zone_selected) != BODY_ZONE_HEAD || HAS_TRAIT(user, TRAIT_PACIFISM))
		return FALSE
	var/mob/living/carbon/victim = target
	var/obj/item/bodypart/head/head = victim.get_bodypart(BODY_ZONE_HEAD)
	if(isnull(head) || !head.can_dismember())
		return FALSE
	var/neck_grabbed = user.pulling == victim && user.grab_state >= GRAB_NECK
	return victim.stat == SOFT_CRIT || victim.stat == HARD_CRIT || neck_grabbed

/obj/item/sledgehammer/syndicate/proc/crush_head(mob/living/carbon/victim, mob/living/user)
	if(DOING_INTERACTION_WITH_TARGET(user, victim))
		return
	var/obj/item/bodypart/head/head = victim.get_bodypart(BODY_ZONE_HEAD)
	user.spin(spintime = 2 SECONDS, speed = 1)
	user.visible_message(
		span_danger("[user] winds up [src], preparing to crush [victim]'s head!"),
		span_alert("You wind up [src], preparing to crush [victim]'s head!"),
	)

	if(!do_after(user, 2.5 SECONDS, victim))
		return
	if(QDELETED(victim) || QDELETED(head) || head.owner != victim)
		return

	user.do_attack_animation(victim, used_item = src)
	playsound(victim, pick(head_crush_sounds), 80, TRUE)
	victim.apply_damage(force * 3, BRUTE, head, wound_bonus = 50, attacking_item = src)
	log_combat(user, victim, "crushed the head of", src)
	head.throw_range = 6
	head.throw_speed = 1
	RegisterSignal(head, COMSIG_MOVABLE_MOVED, PROC_REF(on_head_moved))
	head.dismember(silent = FALSE)
	charge = 0
	addtimer(CALLBACK(src, PROC_REF(stop_head_trail), head), 2 SECONDS)

/obj/item/sledgehammer/syndicate/proc/on_head_moved(obj/item/bodypart/head/head, atom/old_loc)
	SIGNAL_HANDLER

	var/turf/head_turf = get_turf(head)
	var/trail_direction = get_dir(old_loc, head_turf)
	if(!isopenturf(head_turf) || !trail_direction)
		return

	var/obj/effect/decal/cleanable/blood/trail_holder/blood_trail = locate() in head_turf
	if(!blood_trail)
		blood_trail = new(head_turf)
	if(QDELETED(blood_trail))
		return

	if(ISDIAGONALDIR(trail_direction))
		trail_direction = -trail_direction
	blood_trail.add_dir_to_trail(trail_direction, blood_to_add = BLOOD_AMOUNT_PER_DECAL)

/obj/item/sledgehammer/syndicate/proc/stop_head_trail(obj/item/bodypart/head/head)
	UnregisterSignal(head, COMSIG_MOVABLE_MOVED)
