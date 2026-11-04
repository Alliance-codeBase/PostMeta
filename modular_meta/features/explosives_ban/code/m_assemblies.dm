//ORIGINAL FILE: code/modules/assembly/assembly.dm
/obj/item/assembly/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(is_inside_explosive(src) && ui.user.refuse_explosives())
		return TRUE
	return ..()

//ORIGINAL FILE: code/modules/assembly/signaler.dm
/obj/item/assembly/signaler/receive_signal(datum/signal/signal)
	if(isnull(signal) || signal.data["code"] != code || !is_inside_explosive(src))
		return ..()
	var/mob/sender = get(signal.source, /mob)
	if(!isnull(sender) && sender.refuse_explosives())
		return FALSE
	return ..()
