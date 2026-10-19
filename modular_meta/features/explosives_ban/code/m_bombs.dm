//ORIGINAL FILE: code/game/objects/items/devices/transfer_valve.dm
/obj/item/transfer_valve/is_explosive()
	return ready()

/obj/item/transfer_valve/try_attach_tank(obj/item/tank/new_tank, mob/user)
	if(user.refuse_explosives())
		return FALSE
	return ..()

/obj/item/transfer_valve/try_attach_assembly(obj/item/assembly/assembly, mob/user)
	if(user.refuse_explosives())
		return FALSE
	return ..()

/obj/item/transfer_valve/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(action == "toggle" && !valve_open && ui.user.refuse_explosives())
		return TRUE
	return ..()

//ORIGINAL FILE: code/game/objects/items/tanks/tanks.dm
/obj/item/tank/is_explosive()
	return !isnull(tank_assembly)

/obj/item/tank/bomb_assemble(obj/item/assembly_holder/assembly, mob/living/user)
	if(user.refuse_explosives())
		return
	return ..()

//ORIGINAL FILE: code/game/machinery/syndicatebomb.dm
/obj/machinery/syndicatebomb/is_explosive()
	return TRUE

/obj/machinery/syndicatebomb/interact(mob/user)
	if(!active && user.refuse_explosives())
		return
	return ..()

//ORIGINAL FILE: code/modules/projectiles/guns/special/blastcannon.dm
/obj/item/gun/blastcannon/try_fire_gun(atom/target, mob/living/user, params)
	if(!isnull(bomb) && user.refuse_explosives())
		return FALSE
	return ..()
