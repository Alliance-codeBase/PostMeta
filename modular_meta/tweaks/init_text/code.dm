/datum/preference/toggle/show_init_stats
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "show_init_stats"
	savefile_identifier = PREFERENCE_PLAYER
	default_value = TRUE

/datum/preference/toggle/show_init_stats/apply_to_client_updated(client/client, value)
	if(client.lobby_menu)
		client.lobby_menu.send_init_text()

/datum/lobby_menu/proc/get_init_text()
	if(SSticker.HasRoundStarted())
		return null
	if(!client.prefs.read_preference(/datum/preference/toggle/show_init_stats))
		return null
	return SStitle.init_text

/datum/lobby_menu/proc/send_init_text()
	send_update(list("initText" = get_init_text()))

/datum/asset/simple/namespaced/init_text_font
	assets = list(
		"Grand9K_Pixel_Rus.ttf" = file("interface/fonts/Grand9K_Pixel_Rus.ttf"),
		"PixCyrillic.ttf" = file("interface/fonts/PixCyrillic.ttf"),
	)
	parents = list(
		"init_text_fonts.css" = file("tgui/packages/tgui-lobby/styles/init_text_fonts.css"),
	)

/datum/lobby_menu/initialize_browser()
	. = ..()
	window.send_asset(get_asset_datum(/datum/asset/simple/namespaced/init_text_font))
