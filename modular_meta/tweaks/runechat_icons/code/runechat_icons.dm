/datum/chatmessage/proc/get_chat_icon(icon_state)
	var/static/list/chat_icons_by_state
	var/icon/chat_icon = LAZYACCESS(chat_icons_by_state, icon_state)
	if (isnull(chat_icon))
		var/chat_icons_file = 'icons/ui/chat/chat_icons.dmi'
		if (!icon_exists(chat_icons_file, icon_state))
			CRASH("Runechat icon state [icon_state] does not exist in [chat_icons_file]")
		chat_icon = icon(chat_icons_file, icon_state)
		LAZYSET(chat_icons_by_state, icon_state, chat_icon)
	return chat_icon
