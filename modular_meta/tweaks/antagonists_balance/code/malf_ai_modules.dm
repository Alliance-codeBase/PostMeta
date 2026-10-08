/datum/action/innate/ai/nuke_station
	name = "Doomsday Device"
	desc = "Activates the doomsday device. This is not reversible."
	button_icon = 'icons/obj/machines/nuke_terminal.dmi'
	button_icon_state = "nuclearbomb_timing"
	auto_use_uses = FALSE

/datum/action/innate/ai/nuke_station/Activate()
	if(!(GLOB.joined_player_list.len >= 25))
		to_chat(owner, span_alert("Not enough biological subjects onboard a Station."))
		return
	..()
