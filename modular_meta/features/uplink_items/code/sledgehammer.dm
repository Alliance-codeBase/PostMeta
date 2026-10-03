/obj/item/fireaxe/sledgehammer
	name = "Sledgehammer"
	desc = "A mad engineer's choice"
	icon = 'modular_meta/features/uplink_items/icons/weapon/sledgehammer/obj/weapons/sledgehammer.dmi'
	icon_state = "sledgehammer"
	base_icon_state = "sledgehammer"
	lefthand_file = 'modular_meta/features/uplink_items/icons/weapon/sledgehammer/mob/inhands/weapons/hammers_lefthand.dmi'
	righthand_file = 'modular_meta/features/uplink_items/icons/weapon/sledgehammer/mob/inhands/weapons/hammers_righthand.dmi'
	force = 5
	throwforce = 15
	demolition_mod = 1.25
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	attack_verb_continuous = list("attacks", "smashes", "slams", "breaks", "wrecks", "obliterates")
	attack_verb_simple = list("attack", "smash",  "slam", "wreck", "break", "obliterate")
	hitsound = 'sound/items/weapons/genhit3.ogg'
	sharpness = NONE
	armor_type = /datum/armor/item_fireaxe
	wound_bonus = -15
	exposed_wound_bonus = 20
	force_unwielded = 5
	force_wielded = 22
	var/charge_bonus = 0
	var/holding_key_right_now = FALSE
	var/next_charge
	var/knockback_bonus
	var/max_charge
	var/min_carge


/obj/item/fireaxe/sledgehammer/attack(mob/living/target_mob, mob/living/user, list/modifiers, list/attack_modifiers)
		hitsound = pick(
		'sound/items/weapons/genhit1.ogg',
		'sound/items/weapons/genhit2.ogg',
		'sound/items/weapons/genhit3.ogg',
	)
	return ..()

/obj/item/fireaxe/sledgehammer/afterattack(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	charge_bonus = 0
	if()


/obj/item/fireaxe/sledgehammer/key_down(key, client/user, full_key)
	. = ..()
	holding_key_right_now = TRUE
	if(key == "Z")
		begin_charging_attack()


/obj/item/fireaxe/sledgehammer/key_up(key, client/user, full_key)
	. =..()
	holding_key_right_now = FALSE
	if(key == "Z")
		stop_charging_attack()

/obj/item/fireaxe/sledgehammer/proc/begin_charging_attack(mob/living/carbon/user)
	user = loc

	if(!(ismob(user)))
		return
	if(!(HAS_TRAIT(src, TRAIT_WIELDED)))
		ballon_alert(user, "wield first!")
		return stop_charging_attack()
	if((user.incapacitated))
		return

	charge_bonus = 0
	next_charge = world.time + 1 SECONDS
	var/charging_attack = do_after(user, 6 SECONDS, src, extra_checks = CALLBACK(PROC_REF(charge_tick), user))
	var/static/list/phrases = list(
	"Your grip is still unsteady.",
	"You tighten your grip on the sledgehammer.",
	"You draw the sledgehammer back.",
	"The weight settles into your hands.",
	"Your arms tense for a crushing blow.",
	"You're ready to bring the sledgehammer down.",
)
/obj/item/fireaxe/sledgehammer/proc/stop_charging_attack(mob/living/carbon/user)
	user = loc

/obj/item/fireaxe/sledgehammer/proc/charge_tick(mob/living/carbon/user)
	if(world.time >= next_charge)
		charge_bonus++
		clamp(charge_bonus, min_charge, max_charge)
		next_charge = world.time + 1 SECONDS
		to_chat(user, "debug: current charge is [charge_bonus]")
	return TRUE
