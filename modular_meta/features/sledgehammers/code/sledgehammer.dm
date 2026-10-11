// Code by headband0536, sprites by Simpleton, sounds are mentioned in attributions.txt in their respectable folder

/obj/item/sledgehammer
	name = "sledgehammer"
	desc = "A heavy demolition hammer. Wielded with both hands, it smashes windows, grilles and plain walls."
	icon = 'modular_meta/features/sledgehammers/icons/sledgehammer.dmi'
	icon_state = "sledgehammer0"
	base_icon_state = "sledgehammer"
	lefthand_file = 'modular_meta/features/sledgehammers/icons/sledgehammer_lefthand.dmi'
	righthand_file = 'modular_meta/features/sledgehammers/icons/sledgehammer_righthand.dmi'
	worn_icon = 'modular_meta/features/sledgehammers/icons/sledgehammer_back.dmi'
	worn_icon_state = "sledgehammer"
	force = 8
	throwforce = 10
	demolition_mod = 1.5
	attack_speed = 1.2 SECONDS
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	obj_flags = CONDUCTS_ELECTRICITY
	resistance_flags = FIRE_PROOF
	armor_type = /datum/armor/item_fireaxe
	sharpness = NONE
	hitsound = SFX_SWING_HIT
	attack_verb_continuous = list("smashes", "slams", "bashes", "pounds")
	attack_verb_simple = list("smash", "slam", "bash", "pound")
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5)
	var/force_wielded = 20
	var/knockback_range = 1
	var/wall_hits_to_smash = 4
	var/reinforced_wall_hits_to_smash
	var/turf/closed/wall/dented_wall
	var/hits_on_dented_wall = 0
	var/static/list/slam_verbs = list("slams", "smashes", "rams")
	var/static/list/slam_sounds = list('sound/effects/meteorimpact.ogg', 'sound/effects/bang.ogg')
	var/static/list/metal_hitsounds = list(
		'modular_meta/features/sledgehammers/sound/metal_hit.ogg',
		'modular_meta/features/sledgehammers/sound/metal_hit2.ogg',
	)

/obj/item/sledgehammer/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/two_handed, \
		force_unwielded = force, \
		force_wielded = force_wielded, \
		icon_wielded = "[base_icon_state]1", \
	)

/obj/item/sledgehammer/update_icon_state()
	icon_state = "[base_icon_state]0"
	return ..()

/obj/item/sledgehammer/pre_attack(atom/target, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(.)
		return .
	if(ismecha(target))
		playsound(target, pick(slam_sounds), 50)
	if(!iswallturf(target) || !HAS_TRAIT(src, TRAIT_WIELDED))
		return FALSE
	slam_wall(target, user)
	return TRUE

/obj/item/sledgehammer/attack(mob/living/target_mob, mob/living/user, list/modifiers, list/attack_modifiers)
	hitsound = pick_hitsound(target_mob)
	return ..()

/obj/item/sledgehammer/afterattack(atom/target, mob/living/user, list/modifiers, list/attack_modifiers)
	if(!HAS_TRAIT(src, TRAIT_WIELDED) || QDELETED(target))
		return
	if(isliving(target))
		knock_back(target, user)
		return
	if(target.resistance_flags & INDESTRUCTIBLE)
		return
	if(istype(target, /obj/structure/window) || istype(target, /obj/structure/grille))
		target.atom_destruction(MELEE)

/obj/item/sledgehammer/proc/pick_hitsound(mob/living/target_mob)
	if(!HAS_TRAIT(src, TRAIT_WIELDED))
		return SFX_SWING_HIT
	if(issilicon(target_mob))
		return pick(metal_hitsounds)
	if(iscarbon(target_mob))
		return 'modular_meta/features/sledgehammers/sound/heavy_hit.ogg'
	return SFX_SWING_HIT

/obj/item/sledgehammer/proc/knock_back(mob/living/target, mob/living/user)
	if(target.anchored)
		return
	var/atom/throw_target = get_edge_target_turf(target, get_dir(user, target))
	fling(target, throw_target, user)

/obj/item/sledgehammer/proc/fling(mob/living/target, atom/throw_target, mob/living/user)
	target.safe_throw_at(throw_target, knockback_range, 1, user, gentle = TRUE)

/obj/item/sledgehammer/proc/hits_to_smash(turf/closed/wall/wall)
	return istype(wall, /turf/closed/wall/r_wall) ? reinforced_wall_hits_to_smash : wall_hits_to_smash

/obj/item/sledgehammer/proc/slam_wall(turf/closed/wall/wall, mob/living/user)
	user.changeNext_move(attack_speed)
	user.do_attack_animation(wall, used_item = src)
	playsound(wall, pick(slam_sounds), 50, TRUE)
	wall.Shake(pixelshifty = 3, duration = 0.1 SECONDS, shake_interval = 0.1 SECONDS)

	var/hits_needed = hits_to_smash(wall)
	if((wall.resistance_flags & INDESTRUCTIBLE) || isnull(hits_needed))
		user.visible_message(
			span_warning("[user] [pick(slam_verbs)] [src] against [wall], but it holds firm!"),
			span_warning("You slam [src] against [wall], but it is too sturdy to smash!"),
		)
		return

	if(wall != dented_wall)
		dented_wall = wall
		hits_on_dented_wall = 0
	hits_on_dented_wall++

	if(hits_on_dented_wall < hits_needed)
		wall.add_dent(WALL_DENT_HIT)
		user.visible_message(
			span_danger("[user] [pick(slam_verbs)] [src] against [wall]!"),
			span_danger("You slam [src] against [wall]!"),
			span_hear("You hear a booming smash!"),
		)
		return

	dented_wall = null
	hits_on_dented_wall = 0
	user.visible_message(
		span_danger("[user] smashes through [wall] with [src]!"),
		span_danger("You smash through [wall]!"),
		span_hear("You hear a wall come crashing down!"),
	)
	wall.dismantle_wall(devastated = TRUE)
