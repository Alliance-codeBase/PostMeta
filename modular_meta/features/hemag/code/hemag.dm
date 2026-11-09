/obj/item/card/emag/hemag
	icon = 'modular_meta/features/hemag/preview.dmi'
	name = "Holograpic Card"
	desc = "Holographic Emag, doesn't looks that here for long"
	var/used = FALSE

/obj/item/card/emag/hemag/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(SHOULD_SKIP_INTERACTION(interacting_with, src, user)) //Code Copy of Original Emag
		return NONE // lets us put things in bags without trying to emag them
	if(!can_emag(interacting_with, user))
		return ITEM_INTERACT_BLOCKING
	log_combat(user, interacting_with, "attempted to emag")
	if(used)
		balloon_alert(user, "Nuh uh")
		return
	if(interacting_with.emag_act(user, src))
		used = TRUE
		SSblackbox.record_feedback("tally", "atom_emagged", 1, interacting_with.type)
		to_chat(user, span_danger("[src] vanishes to nothing!")) //Aaaand, it's gone
		playsound(src, 'sound/machines/wewewew.ogg', 100)
		animate(src, transform = matrix() * 1.5, time = 1 SECONDS, easing = SINE_EASING)
		animate(transform = matrix() * 0.1, time = 2 SECONDS, easing = SINE_EASING)
		QDEL_IN(src, 3 SECONDS)
		return ITEM_INTERACT_SUCCESS
	return NONE // In a perfect world this would be blocking, but this is not a perfect world

/datum/market_item/misc/hemag //idk what I'm cooking here, that should work, right?
	name = /obj/item/card/emag/hemag::name
	desc = "Rare key of almost any technology security system, too bad that it can handle only 1 use"
	item = /obj/item/card/emag/hemag
	price_min = 220 * 5
	price_max = CARGO_CRATE_VALUE * 10
	stock_max = 2
	availability_prob = 19
//Code reference: /datum/market_item/misc/self_surgery_skillchip
/datum/market_item/misc/hemag/buy(obj/item/market_uplink/uplink, mob/buyer, shipping_method, legal_status)
	. = ..()
	if(.)
		availability_prob *= 0.5
