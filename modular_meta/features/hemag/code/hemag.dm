/obj/item/card/emag/hemag
	color = rgb(75, 150, 255)
	name = "Holograpic Card"
	desc = "Holographic Emag, doesn't looks that here for long"

/obj/item/card/emag/hemag/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	..()
	to_chat(user, span_danger("[src] vanishes to nothing!"))
	qdel(src)
	return
