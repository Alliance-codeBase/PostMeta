/client/proc/refuse_adminhelp()
	if(!is_banned_from(ckey, BAN_ADMINHELP))
		return FALSE
	to_chat(src, span_danger("Error: Admin-PM: You cannot send adminhelps (banned)."), confidential = TRUE)
	return TRUE

//ORIGINAL FILE: code/modules/admin/verbs/adminhelp.dm
/datum/admin_help_ui_handler/ui_interact(mob/user, datum/tgui/ui)
	if(user.client.refuse_adminhelp())
		return
	return ..()

/datum/admin_help_ui_handler/perform_adminhelp(client/user_client, message, urgent)
	if(user_client.refuse_adminhelp())
		return
	return ..()
