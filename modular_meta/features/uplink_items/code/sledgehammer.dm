/obj/item/sledgehammer
	name = "Sledgehammer"
	desc = "A mad engineer's choice"
	icon = 'modular_meta/features/uplink_items/icons/weapon/sledgehammer/obj/weapons/sledgehammer.dmi'
	icon_state = "sledgehammer"
	base_icon_state = "sledgehammer"
	lefthand_file = 'modular_meta/features/uplink_items/icons/weapon/sledgehammer/mob/inhands/weapons/hammers_lefthand.dmi'
	righthand_file = 'modular_meta/features/uplink_items/icons/weapon/sledgehammer/mob/inhands/weapons/hammers_righthand.dmi'
	force = 13
	throwforce = 24
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
	var/holding_key_right_now = FALSE
	var/next_charge
	var/knockback_bonus
	var/max_charge = 6
	var/min_charge = 1
	var/force_per_charge = 6
	var/wound_bonus_per_charge = 1.5

/obj/item/sledgehammer/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/two_handed, \
		force_multiplier = 5, \
		icon_wielded = "[base_icon_state]1", \
		attacksound = SFX_SWING_HIT, \
	)

/obj/item/sledgehammer/afterattack(mob/living/target_mob, mob/living/user, list/modifiers, list/attack_modifiers)
	if(QDELETED(target_mob))
		return

	if(HAS_TRAIT(src, TRAIT_WIELDED) && isliving(target_mob))

		switch(charge_bonus)
			if(1)
				hitsound = 'sound/items/weapons/genhit3.ogg'
			if(2)
				hitsound = 'sound/items/weapons/genhit3.ogg'
			if(3)
				hitsound = 'sound/items/weapons/genhit3.ogg'
			if(4)
				hitsound = 'sound/items/weapons/genhit3.ogg'
			if(5)
				hitsound = 'sound/items/weapons/genhit3.ogg'
				target_mob.Stun(0.5 SECONDS)
				target_mob.Knockdown(2 SECONDS)
			if(6)
				hitsound = 'sound/items/weapons/genhit3.ogg'
				target_mob.Stun(1.5 SECONDS)
				target_mob.Knockdown(4 SECONDS)


/obj/item/sledgehammer/attack(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	hitsound = pick(
		'sound/items/weapons/genhit1.ogg',
		'sound/items/weapons/genhit2.ogg',
		'sound/items/weapons/genhit3.ogg',
	)
	if(HAS_TRAIT(src, TRAIT_WIELDED) && isliving(target))
		var/atom/throw_target =  get_edge_target_turf(target, get_dir(src, get_step_away(target, src)))
		var/atom/movable/movable_target = target
		wound_bonus = 15
		force = 18
		if(issilicon(target))

			hitsound = pick(
				'modular_meta/features/uplink_items/sound/sledgehammer/metal_hit.ogg',
				'modular_meta/features/uplink_items/sound/sledgehammer/metal_hit2.ogg',
			)

			movable_target.throw_at(throw_target, 4, 2)
		if(iscarbon(target))
			movable_target.throw_at(throw_target, 6, 2)
			if(charge_bonus >= 3)
				hitsound = 'modular_meta/features/uplink_items/sound/sledgehammer/heavy_hit.ogg'

	..()

/obj/item/sledgehammer/key_down(key, client/user, full_key)
	. = ..()
	holding_key_right_now = TRUE
	if(key == "Z")
		begin_charging_attack()


/obj/item/sledgehammer/key_up(key, client/user, full_key)
	. =..()
	holding_key_right_now = FALSE
	if(key == "Z")
		stop_charging_attack()

/obj/item/sledgehammer/proc/begin_charging_attack(mob/living/carbon/user)
	user = loc

	if(!(ismob(user)))
		return
	if(!(HAS_TRAIT(src, TRAIT_WIELDED)))
		balloon_alert(user, "wield first!")
		return stop_charging_attack()
	if((user.incapacitated))
		return

	charge_bonus = 0
	next_charge = world.time + 1 SECONDS
	var/charging_attack = do_after(user, 6 SECONDS, src, extra_checks = CALLBACK(src, PROC_REF(charge_tick), user))
	var/static/list/phrases = list(
	"Your grip is still unsteady.",
	"You tighten your grip on the sledgehammer.",
	"You draw the sledgehammer back.",
	"The weight settles into your hands.",
	"Your arms tense for a crushing blow.",
	"You're ready to bring the sledgehammer down.",
)
/obj/item/sledgehammer/proc/stop_charging_attack(mob/living/carbon/user)
	user = loc

/obj/item/sledgehammer/proc/charge_tick(mob/living/carbon/user)
	if(!user.client?.keys_held["Alt"] || !user.client?.keys_held["Z"])
		return FALSE

	if(world.time >= next_charge)
		charge_bonus++
		charge_bonus = clamp(charge_bonus, min_charge, max_charge)
		next_charge = world.time + 1 SECONDS
		to_chat(user, "debug: current charge is [charge_bonus]")
	return TRUE
