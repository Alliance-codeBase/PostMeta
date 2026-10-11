/datum/status_effect/flow
	id = "judo_flow"
	duration = 10 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/flow
	var/flow_stacks = 0

/atom/movable/screen/alert/status_effect/flow
	name = "Flow State"
	desc = "You're in the zone. Your attacks are faster."
	icon_state = "flow"

/datum/status_effect/flow/on_apply()
	. = ..()
	flow_stacks = 1
	to_chat(owner, span_notice("Поток старт. Стаки: [flow_stacks]"))

/datum/status_effect/flow/on_remove()
	. = ..()
	to_chat(owner, span_warning("Поток минус"))

/datum/status_effect/flow/proc/add_stack()
	flow_stacks++
	duration = initial(duration) 
	to_chat(owner, span_notice("Поток плюс. Стаки: [flow_stacks]"))
