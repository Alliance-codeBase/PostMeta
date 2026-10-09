/obj/item/sledgehammer
	name = "Sledgehammer"
	desc = "A mad engineer's choice"
	icon = 'modular_meta/features/uplink_items/icons/weapon/sledgehammer/obj/weapons/sledgehammer.dmi'
	icon_state = "sledgehammer"
	base_icon_state = "sledgehammer"
	lefthand_file = 'modular_meta/features/uplink_items/icons/weapon/sledgehammer/mob/inhands/weapons/hammers_lefthand.dmi'
	righthand_file = 'modular_meta/features/uplink_items/icons/weapon/sledgehammer/mob/inhands/weapons/hammers_righthand.dmi'
	force = 10
	throwforce = 10
	demolition_mod = 3.2
	w_class = WEIGHT_CLASS_HUGE
	attack_verb_continuous = list("attacks", "smashes", "slams", "breaks", "wrecks", "obliterates")
	attack_verb_simple = list("attack", "smash",  "slam", "wreck", "break", "obliterate")
	hitsound = 'sound/items/weapons/genhit3.ogg'
	sharpness = NONE
	armor_type = /datum/armor/item_fireaxe
	wound_bonus = -15
	//exposed_wound_bonus = 20
	//force_unwielded = 5
	//force_wielded = 22
	var/charge_bonus = 0
	var/next_charge
	var/charging = FALSE
	var/mouse_held = FALSE
	var/max_charge = 6
	var/min_charge = 1
	var/force_per_charge = 9
	var/wound_bonus_per_charge = 1.5
	var/force_wielded = 18
	var/force_unwielded = 10
	attack_speed = 1.5 SECONDS
	var/static/list/slam_verbs = list("slams", "smashes", "rams")
	var/static/list/phrases = list(
	"Your grip is still unsteady.",
	"You tighten your grip on the sledgehammer.",
	"You draw the sledgehammer back.",
	"The weight settles into your hands.",
	"Your arms tense for a crushing blow.",
	"You're ready to strike with full force.",
)

/obj/item/sledgehammer/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/two_handed, \
		force_wielded = force_wielded, \
		force_unwielded = force_unwielded, \
		icon_wielded = "[base_icon_state]1", \
		attacksound = SFX_SWING_HIT, \
	)

	AddElement(/datum/element/examine_lore, lore = "\
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
		The hammer remains in production. Replacement handles are sold separately.")

/obj/item/sledgehammer/afterattack(atom/target, mob/living/user, list/modifiers, list/attack_modifiers)
	var/mob/living/target_mob = target
	var/atom/throw_target =  get_edge_target_turf(target_mob, get_dir(src, get_step_away(target_mob, src)))
	if(QDELETED(target_mob))
		return
	if(HAS_TRAIT(src, TRAIT_WIELDED) && isliving(target_mob))
		switch(charge_bonus)
			if(1)
				target_mob.throw_at(throw_target, 1, speed = 0.5)
			if(2)
				target_mob.throw_at(throw_target, 2, speed = 0.7)
			if(3)
				target_mob.throw_at(throw_target, 3, speed = 0.9)
			if(4)
				target_mob.throw_at(throw_target, 4, speed = 1.1)
				target_mob.Stun(0.2 SECONDS)
			if(5)
				target_mob.throw_at(throw_target, 4, speed = 1.3)
				target_mob.Stun(0.5 SECONDS)
				target_mob.Knockdown(2 SECONDS)
			if(6)
				target_mob.throw_at(throw_target, 6, 2)
				target_mob.Stun(1.5 SECONDS)
				target_mob.Knockdown(4 SECONDS)

	if(!HAS_TRAIT(src, TRAIT_WIELDED)) //destroys windows and grilles in one hit
		return

	if(target.resistance_flags & INDESTRUCTIBLE)
		return
	if(QDELETED(target))
		return
	if(istype(target, /obj/structure/window) || istype(target, /obj/structure/grille))
		target.atom_destruction("sledgehammer")
		user.do_attack_animation(target, used_item = src)
		user.changeNext_move(attack_speed)
		return TRUE


	charge_bonus = 0
	force = HAS_TRAIT(src, TRAIT_WIELDED) ? force_wielded : force_unwielded
	throwforce = /obj/item/sledgehammer::throwforce
	wound_bonus = /obj/item/sledgehammer::wound_bonus

/obj/item/sledgehammer/update_icon_state()
	icon_state = base_icon_state
	return ..()

/obj/item/sledgehammer/attack(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	hitsound = pick(
		'sound/items/weapons/genhit1.ogg',
		'sound/items/weapons/genhit2.ogg',
		'sound/items/weapons/genhit3.ogg',
	)

	if(HAS_TRAIT(src, TRAIT_WIELDED) && isliving(target))
		wound_bonus = 15
		force = force_wielded
		if(issilicon(target))
			hitsound = pick(
				'modular_meta/features/uplink_items/sound/sledgehammer/metal_hit.ogg',
				'modular_meta/features/uplink_items/sound/sledgehammer/metal_hit2.ogg',
			)
		if(iscarbon(target))
			if(charge_bonus >= 1)
				hitsound = 'modular_meta/features/uplink_items/sound/sledgehammer/heavy_hit.ogg'
				if(charge_bonus >= 5)
					hitsound = 'modular_meta/features/uplink_items/sound/sledgehammer/flesh_hit3.ogg'

		switch(charge_bonus)

			if(1)
				force += force_per_charge
				throwforce += force_per_charge
				wound_bonus += wound_bonus_per_charge
			if(2)
				force += force_per_charge * 2
				throwforce += force_per_charge * 2
				wound_bonus += wound_bonus_per_charge * 2
			if(3)
				force += force_per_charge * 3
				throwforce += force_per_charge *3
				wound_bonus += wound_bonus_per_charge * 3
			if(4)
				force += force_per_charge * 4
				throwforce += force_per_charge *4
				wound_bonus += wound_bonus_per_charge *4
			if(5)
				force += force_per_charge * 5
				throwforce += force_per_charge *5
				wound_bonus += wound_bonus_per_charge * 5
			if(6)
				force += force_per_charge * 6
				throwforce += force_per_charge * 6
				wound_bonus += wound_bonus_per_charge * 6
	..()


/obj/item/sledgehammer/pre_attack(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(.)
		return .

	// silicon dismantling device 3000
	if(issilicon(target))
		force += 25

	if(ismecha(target))
		force += 25
		playsound(target, pick('sound/effects/meteorimpact.ogg', 'sound/effects/bang.ogg'), 50)


	if(istype(target, /turf/closed/wall/r_wall))
		var/turf/closed/wall/wall = target
		wall.add_dent(WALL_DENT_HIT)
		wall.Shake(1, 3, 0.1 SECONDS, 0.1 SECONDS)
		user.changeNext_move(attack_speed)
		user.do_attack_animation(target, used_item = src)

		user.visible_message(
			span_danger("[user] [pick(slam_verbs)] [src] against [target]!"),
			span_danger("You slam [src] against [target]!"),
			)

		playsound(target, pick('sound/effects/meteorimpact.ogg', 'sound/effects/bang.ogg'), 50)
		if(prob(25))
			wall.dismantle_wall(TRUE)
		return TRUE


	else if(istype(target, /turf/closed/wall))
		var/turf/closed/wall/wall = target
		wall.add_dent(WALL_DENT_HIT)
		wall.Shake(null, 3, 0.1 SECONDS, 0.1 SECONDS)
		user.changeNext_move(attack_speed)
		user.do_attack_animation(target, used_item = src)

		user.visible_message(
			span_danger("[user] [pick(slam_verbs)] [src] against [target]!"),
			span_danger("You slam [src] against [target]!"),
			)


		playsound(target, pick('sound/effects/meteorimpact.ogg', 'sound/effects/bang.ogg'), 50)
		if(prob(40))
			wall.dismantle_wall(TRUE)
		return TRUE

	if(!iscarbon(target))
		return FALSE


	var/mob/living/carbon/person_about_to_die_horribly = target
	var/mob/living/carbon/madman = user
	var/obj/item/bodypart/head/head = person_about_to_die_horribly.get_bodypart(BODY_ZONE_HEAD)

	if(!person_about_to_die_horribly)
		return

	if(!head)
		return

	if((person_about_to_die_horribly.stat == SOFT_CRIT || person_about_to_die_horribly.stat == HARD_CRIT || madman.grab_state == GRAB_NECK) && check_zone(madman.zone_selected) == BODY_ZONE_HEAD)
		bash_head(person_about_to_die_horribly, madman)
		return TRUE // cancels attack chain after headbash

	return FALSE


/obj/item/sledgehammer/equipped(mob/user, slot, initial = FALSE)
	. = ..()

	if(slot != ITEM_SLOT_HANDS)
		return

	if(!user.client)
		return

	RegisterSignal(user.client, COMSIG_CLIENT_MOUSEDOWN, PROC_REF(on_mouse_down))
	RegisterSignal(user.client, COMSIG_CLIENT_MOUSEUP, PROC_REF(on_mouse_up))


/obj/item/sledgehammer/dropped(mob/user, silent = FALSE)
	if(user.client)
		//UnregisterSignal(user, COMSIG_MOB_KEYDOWN)
		UnregisterSignal(user.client, COMSIG_CLIENT_MOUSEDOWN)
		UnregisterSignal(user.client, COMSIG_CLIENT_MOUSEUP)
		charge_bonus = 0
	return ..()


/obj/item/sledgehammer/proc/on_mouse_up(client/player, object, location, control, params)
	SIGNAL_HANDLER

	var/list/mods = params2list(params)
	if(mods[BUTTON] == RIGHT_CLICK)
		mouse_held = FALSE
		to_chat(player.mob, span_notice("[phrases[charge_bonus]]"))

/obj/item/sledgehammer/proc/on_mouse_down(client/player, object, location, control, params)
	SIGNAL_HANDLER

	var/list/mods = params2list(params)
	if(mods[BUTTON] != RIGHT_CLICK)
		return

	var/mob/living/user = player.mob
	if(!iscarbon(user) || user.get_active_held_item() != src || charging)
		return

	INVOKE_ASYNC(src, PROC_REF(begin_charging_attack), user)

/obj/item/sledgehammer/proc/begin_charging_attack(mob/living/carbon/user)
	user = loc

	if(charging)
		return

	if(!(ismob(user)))
		return
	if(!(HAS_TRAIT(src, TRAIT_WIELDED)))
		balloon_alert(user, "wield first!")
		return stop_charging_attack()
	if((user.incapacitated))
		return

	charging = TRUE
	mouse_held = TRUE

	charge_bonus = 0
	next_charge = world.time + 1 SECONDS
	do_after(user, 6 SECONDS, src, extra_checks = CALLBACK(src, PROC_REF(charge_tick), user), timed_action_flags = IGNORE_USER_LOC_CHANGE | IGNORE_SLOWDOWNS)
	charging = FALSE
	mouse_held = FALSE

/obj/item/sledgehammer/proc/stop_charging_attack(mob/living/carbon/user)
	user = loc

/obj/item/sledgehammer/proc/charge_tick(mob/living/carbon/user)
	if(!mouse_held)
		return FALSE

	while(world.time >= next_charge && charge_bonus < max_charge)
		charge_bonus++
		charge_bonus = clamp(charge_bonus, min_charge, max_charge)
		user.playsound_local(user, 'sound/vehicles/mecha/skyfall_power_up.ogg', 15)
		Shake(null, 5, 0.1 SECONDS, 0.1 SECONDS)
		next_charge += 1 SECONDS
	return TRUE

/obj/item/sledgehammer/proc/bash_head(mob/living/carbon/target, mob/living/user)
	var/obj/item/bodypart/head/head = target.get_bodypart(BODY_ZONE_HEAD)
	user.spin(spintime = 2 SECONDS, speed = 1)

	user.visible_message(
		span_danger("[user] winds up [src], preparing to crush [target]'s head!"),
		span_alert("You wind up [src], preparing to crush [target]'s head!"),
	)

	if(!do_after(user, 2.5 SECONDS, target))
		return
	if(QDELETED(target) || QDELETED(head) || head.owner != target)
		return

	user.do_attack_animation(target, used_item = src)
	playsound(target, pick('modular_meta/features/uplink_items/sound/sledgehammer/flesh_hit1.ogg', 'modular_meta/features/uplink_items/sound/sledgehammer/flesh_hit2.ogg'), 80, TRUE)
	target.apply_damage(force * 3, BRUTE, head, wound_bonus = 50, attacking_item = src)
	head.throw_range = 6
	head.throw_speed = 1
	RegisterSignal(head, COMSIG_MOVABLE_MOVED, PROC_REF(head_trail))
	head.dismember(silent = FALSE)
	charge_bonus = 0
	addtimer(CALLBACK(src, PROC_REF(rm_signal), head), 2 SECONDS)

/obj/item/sledgehammer/proc/head_trail(obj/item/bodypart/head/head, atom/old_loc)
	SIGNAL_HANDLER

	var/turf/tile = get_turf(head)
	var/trail_dir = get_dir(old_loc, tile)

	if(!isopenturf(tile) || !trail_dir)
		return

	var/obj/effect/decal/cleanable/blood/trail_holder/blood_trail = locate() in tile
	if(!blood_trail)
		blood_trail = new(tile)

	if(QDELETED(blood_trail))
		return

	if(ISDIAGONALDIR(trail_dir))
		trail_dir = -trail_dir

	blood_trail.add_dir_to_trail(trail_dir, blood_to_add = BLOOD_AMOUNT_PER_DECAL)

/obj/item/sledgehammer/proc/rm_signal(obj/item/bodypart/head/head)
	UnregisterSignal(head, COMSIG_MOVABLE_MOVED)

// not including detailed instructions on wall destruction, as well as the finish off, as deep-lore element explains it just enough,
// also understanding mechanics through lore is much better, than just adding a blatant to_chat() with everything required
/obj/item/sledgehammer/examine(mob/user)
	. = ..()
	. += span_notice("Right-click with this in-hand to prepare a charged strike, the more progress bar is completed on the hammer, the harder will be the blow")
