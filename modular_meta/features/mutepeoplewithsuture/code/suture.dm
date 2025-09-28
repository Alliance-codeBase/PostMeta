/obj/item/stack/medical/suture/proc/try_mute(mob/living/mutedone, mob/living/user, healed_zone)
	var/x = mutedone.staminaloss //I skipped my math classes
	var/stamina_modifier = 5 / (x + 1) // trying some fancy math here, for the first time.
	to_chat(user, span_notice("muted"))
	if(DOING_INTERACTION_WITH_TARGET(user, mutedone))
		return FALSE
	if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		balloon_alert(user, "Sewing mouth shut...")
		to_chat(user, span_alert("You begin trying to suture up [mutedone]'s mouth"))
		to_chat(mutedone, span_big ("[user.p_theyre()] is trying to sew your mouth shut with [src]"))
		playsound(src, heal_begin_sound, 100)
		if(do_after(user, ((1.5 SECONDS + stamina_modifier) / (mouth_sewing_force) SECONDS), mutedone))
			playsound(src, heal_end_sound, 100)
			mutedone.apply_status_effect(/datum/status_effect/mouth_sewed_up)
			to_chat(mutedone, span_danger("mutedforreal"))
			log_combat(user, mutedone, "muted", src)
		return

/obj/item/stack/medical/suture/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		return NONE
	if(!try_mute(interacting_with, user))
		return NONE
	return ITEM_INTERACT_SUCCESS

/datum/status_effect/mouth_sewed_up
	id = "mouth_sewed_up"
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = /atom/movable/screen/alert/status_effect/mouth_sewed_up

/datum/status_effect/mouth_sewed_up/get_examine_text()
	. = ..()
	return span_danger("[owner.p_Their()] mouth appears to be sewed shut with some suture!")

/atom/movable/screen/alert/status_effect/mouth_sewed_up
	name = "Mute!"
	desc = "Whoops! Someone has sewed your mouth shut, \
			press resist to try break the suture by your mouth \
			or use any sharp item to tear it away!"
	icon_state = "mind_control"

/datum/status_effect/mouth_sewed_up/on_apply()
	if(ishuman(owner))
		owner.add_traits(list(TRAIT_MUTE), REF(src))
	return TRUE

/datum/status_effect/mouth_sewed_up/on_remove()
	if(ishuman(owner))
		owner.remove_traits(list(TRAIT_MUTE), REF(src))
	return TRUE

/// Used for removing the "muted" status effect from our "bedolajecka"
/obj/item/proc/try_remove_sutures(obj/item/item_used, mob/living/carbon/human/the_muted_one, mob/living/carbon/human/unmuter = usr)
	item_used = unmuter.get_active_held_item()
	if(!istype(the_muted_one, /mob/living/)) // just in case, duh
		return
	if(the_muted_one.has_status_effect(/datum/status_effect/mouth_sewed_up) && \
		item_used.get_sharpness() == SHARP_EDGED || item_used.get_sharpness() == SHARP_POINTY) //Yes, you can tear sutures with a pen, they're not that sturdy (at least, I believe so.)
		balloon_alert(unmuter, "Tearing away sutures...")
		if(do_after(unmuter, 1.5 SECONDS, the_muted_one))
			playsound(src, 'sound/items/weapons/slice.ogg', 55)
			the_muted_one.remove_status_effect(/datum/status_effect/mouth_sewed_up)
			the_muted_one.visible_message(
			message = span_danger("[unmuter] begins to cut sutures away from [the_muted_one.p_theirs()] mouth!"),
			self_message = span_danger("You begin to cut away sutures from [the_muted_one.p_theirs()]'s mouth!")
			)
	else
		to_chat(the_muted_one, span_alert("You try to remove sutures from your sewed mouth, but there's none... Wait, what?"))
		return

//looks sketchy, right?
/obj/item/pre_attack(atom/target, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(user.grab_state == GRAB_AGGRESSIVE \
		&& user.zone_selected == BODY_ZONE_PRECISE_MOUTH \
		&& user.pulling == target)
		if(!try_remove_sutures()) // I was high, don't mind me
			return SECONDARY_ATTACK_CALL_NORMAL
		try_remove_sutures(the_muted_one = target)
		return  COMPONENT_SKIP_ATTACK // To keep our target unattacked after removal of the sutures.

/obj/item/stack/medical/suture
	var/mouth_sewing_force = 2

/obj/item/stack/medical/suture/medicated
	mouth_sewing_force = 5


//TODO: Forbid felinids to use their mouth/bite attack as if restrained or as if their mouth has been covered by a mask.
