//ORIGINAL FILE: code/game/machinery/hologram.dm
/obj/machinery/holopad/activate_holo(mob/living/user)
	var/obj/effect/overlay/holo_pad_hologram/hologram = ..()
	// no power, no hologram
	if(isnull(hologram))
		return
	// the hologram squeaks like its caller
	hologram.copy_blooper_from(user)
	return hologram
