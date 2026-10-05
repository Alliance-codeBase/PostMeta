/obj/item/disk/computer/virus/frame
	var/current_progression = 0

/obj/item/disk/computer/virus/frame/send_virus(obj/item/modular_computer/pda/source, obj/item/modular_computer/pda/target, mob/living/user, message)
	if(isnull(target))
		return ..()
	var/had_uplink = !isnull(target.GetComponent(/datum/component/uplink))
	. = ..()
	if(!. || had_uplink)
		return
	var/datum/component/uplink/hidden_uplink = target.GetComponent(/datum/component/uplink)
	var/datum/uplink_handler/handler = hidden_uplink.uplink_handler
	handler.has_objectives = TRUE
	handler.can_take_objectives = FALSE
	handler.progression_points = min(SStraitor.current_global_progression, current_progression)
	SStraitor.register_uplink_handler(handler)
	handler.generate_objectives()

/datum/uplink_item/device_tools/frame/spawn_item(spawn_path, mob/user, datum/uplink_handler/uplink_handler, atom/movable/source)
	var/obj/item/disk/computer/virus/frame/disk = ..()
	disk.current_progression = uplink_handler.progression_points
	return disk
