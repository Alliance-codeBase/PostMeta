//ORIGINAL FILE: code/game/machinery/hologram.dm
/obj/machinery/holopad/activate_holo(mob/living/user)
	var/obj/effect/overlay/holo_pad_hologram/hologram = ..()
	// no power, no hologram
	if(isnull(hologram))
		return
	// the hologram squeaks like its caller
	hologram.blooper = user.blooper
	hologram.blooper_pitch = user.blooper_pitch
	return hologram
