/obj/item/card/emag/hemag
	color = rgb(75, 150, 255)
	name = "Holograpic Card"
	desc = "Holographic Emag, doesn't looks that here for long"

/obj/item/card/emag/hemag/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(SHOULD_SKIP_INTERACTION(interacting_with, src, user)) //Code Copy of Original Emag
		return NONE // lets us put things in bags without trying to emag them
	if(!can_emag(interacting_with, user))
		return ITEM_INTERACT_BLOCKING
	log_combat(user, interacting_with, "attempted to emag")
	if(interacting_with.emag_act(user, src))
		SSblackbox.record_feedback("tally", "atom_emagged", 1, interacting_with.type)
		to_chat(user, span_danger("[src] vanishes to nothing!")) //Aaaand, it's gone
		qdel(src)
		return ITEM_INTERACT_SUCCESS
	return NONE // In a perfect world this would be blocking, but this is not a perfect world
