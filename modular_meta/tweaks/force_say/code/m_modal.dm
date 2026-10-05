//ORIGINAL FILE: code/modules/tgui_input/say_modal/modal.dm
/// Drops a late force reply from the window after an immediate force.
/datum/tgui_say/on_message(type, payload)
	if(type == "force" && !window_open)
		return TRUE
	return ..()
