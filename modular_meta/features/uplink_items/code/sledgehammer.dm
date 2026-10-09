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
	demolition_mod = 1.25
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
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
	var/knockback_bonus
	var/max_charge = 6
	var/min_charge = 1
	var/force_per_charge = 6
	var/wound_bonus_per_charge = 1.5
	var/force_wielded = 18
	var/force_unwielded = 10
	var/static/list/phrases = list(
	"Your grip is still unsteady.",
	"You tighten your grip on the sledgehammer.",
	"You draw the sledgehammer back.",
	"The weight settles into your hands.",
	"Your arms tense for a crushing blow.",
	"You're ready to bring the sledgehammer down.",
)

/obj/item/sledgehammer/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/two_handed, \
		force_wielded = force_wielded, \
		force_unwielded = force_unwielded, \
		icon_wielded = "[base_icon_state]1", \
		attacksound = SFX_SWING_HIT, \
	)

/obj/item/sledgehammer/afterattack(mob/living/target_mob, mob/living/user, list/modifiers, list/attack_modifiers)
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

	charge_bonus = 0
	force = HAS_TRAIT(src, TRAIT_WIELDED) ? force_wielded : force_unwielded

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

/obj/item/sledgehammer/pickup(mob/user)
	. = ..()
	if(user.client)
		//RegisterSignal(user, COMSIG_MOB_KEYDOWN, PROC_REF(on_key_down))
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
	do_after(user, 6 SECONDS, src, extra_checks = CALLBACK(src, PROC_REF(charge_tick), user), timed_action_flags = IGNORE_USER_LOC_CHANGE)
	charging = FALSE
	mouse_held = FALSE

/obj/item/sledgehammer/proc/stop_charging_attack(mob/living/carbon/user)
	user = loc

/obj/item/sledgehammer/proc/charge_tick(mob/living/carbon/user)
	if(!mouse_held)
		return FALSE

	while(world.time >= next_charge)
		charge_bonus++
		charge_bonus = clamp(charge_bonus, min_charge, max_charge)
		next_charge = world.time + 1 SECONDS
		to_chat(user, "debug: current charge is [charge_bonus]")
	return TRUE
