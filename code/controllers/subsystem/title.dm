SUBSYSTEM_DEF(title)
	name = "Title Screen"
	ss_flags = SS_NO_FIRE
	init_stage = INITSTAGE_EARLY
	var/file_path
	var/icon/icon
	var/icon/previous_icon
	var/turf/closed/indestructible/splashscreen/splash_turf
	// MASSMETA ADDITION
	/// Initialization information shown in the lobby menu
	var/list/init_text

	/// A list of initialization information
	var/list/init_infos = list()
	/// Tracks the number of dots to display
	var/dot_count = 1
	/// The total time taken to initialize the game
	var/total_init_time = -1
	// MASSMETA ADDITION END

/datum/controller/subsystem/title/Initialize()
	if(file_path && icon)
		return SS_INIT_SUCCESS

	if(fexists("data/previous_title.dat"))
		var/previous_path = file2text("data/previous_title.dat")
		if(istext(previous_path))
			previous_icon = new(previous_icon)
	fdel("data/previous_title.dat")

	var/list/provisional_title_screens = flist("[global.config.directory]/title_screens/images/")
	var/list/title_screens = list()
	var/use_rare_screens = prob(1)

	for(var/S in provisional_title_screens)
		var/list/L = splittext(S,"+")
		if((L.len == 1 && (L[1] != "exclude" && L[1] != "blank.png")) || (L.len > 1 && ((use_rare_screens && LOWER_TEXT(L[1]) == "rare") || (LOWER_TEXT(L[1]) == LOWER_TEXT(SSmapping.current_map.map_name)))))
			title_screens += S

	if(length(title_screens))
		file_path = "[global.config.directory]/title_screens/images/[pick(title_screens)]"

	if(!file_path)
		file_path = "icons/runtime/default_title.dmi"

	ASSERT(fexists(file_path))

	icon = new(fcopy_rsc(file_path))

	if(splash_turf)
		splash_turf.icon = icon
		splash_turf.handle_generic_titlescreen_sizes()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/title/vv_edit_var(var_name, var_value)
	. = ..()
	if(.)
		switch(var_name)
			if(NAMEOF(src, icon))
				if(splash_turf)
					splash_turf.icon = icon

/datum/controller/subsystem/title/Shutdown()
	if(file_path)
		var/F = file("data/previous_title.dat")
		WRITE_FILE(F, file_path)

	for(var/thing in GLOB.clients)
		if(!thing)
			continue
		var/atom/movable/screen/splash/S = new(null, null, thing, FALSE)
		S.fade(FALSE,FALSE)

/datum/controller/subsystem/title/Recover()
	icon = SStitle.icon
	splash_turf = SStitle.splash_turf
	file_path = SStitle.file_path
	previous_icon = SStitle.previous_icon
// MASSMETA ADDITION
	init_infos = SStitle.init_infos
	init_text = SStitle.init_text
	total_init_time = SStitle.total_init_time

#define MAX_INIT_TEXT 40

/**
 * Adds an entry to the initialization information list
 *
 * * init_category: The category of the initialization information - this must be a unique key, such as a typepath.
 * Tt's not displayed to the player, so don't worry about making it pretty.
 * * name: The name of the initialization information. This is displayed to the player.
 * * stage: The "stage" of the initialization information, such as "loading" / "complete" / "failed".
 * * seconds: The number of seconds this initialization information took. Optional.
 * * override: If TRUE, this will overwrite any existing entry with the same init_category.
 * Othewise, it will try to update the existing entry's state and time.
 * * major_update: Indicates this init text is a major update, which will update a "dot" animation.
 */
/datum/controller/subsystem/title/proc/add_init_text(init_category, name, stage, seconds, override = FALSE, major_update = FALSE)
	if(override || !init_infos[init_category])
		init_infos[init_category] = list(name, stage, seconds)
	else
		init_infos[init_category][2] = stage
		init_infos[init_category][3] += seconds
	if(major_update)
		dot_count = (dot_count % 6 + 1)
	if(length(init_infos) > MAX_INIT_TEXT)
		init_infos.Cut(1, length(init_infos) - MAX_INIT_TEXT + 1)
	update_init_text()

#undef MAX_INIT_TEXT

/// Removes the passed category from the initialization information list
/datum/controller/subsystem/title/proc/remove_init_text(init_category)
	init_infos -= init_category
	update_init_text()

/// Sends the initialization information to every lobby menu until the round starts
/datum/controller/subsystem/title/proc/update_init_text()
	if(SSticker.HasRoundStarted())
		return
	var/list/lines = list()
	for(var/init_category in init_infos)
		var/list/init_data = init_infos[init_category]
		var/init_name = html_encode(init_data[1])
		var/init_stage = init_data[2]
		var/init_time = isnum(init_data[3]) ? "([init_data[3]]s)" : ""
		lines += "[init_name] [init_stage] [init_time]"
	init_text = list(
		"title" = get_init_title(),
		"lines" = lines,
	)
	for(var/datum/lobby_menu/menu as anything in GLOB.lobby_menus)
		menu.send_init_text()

/datum/controller/subsystem/title/proc/get_init_title()
	if(SSticker.current_state != GAME_STATE_PREGAME)
		var/title = "Initializing game"
		for(var/dot_number in 1 to dot_count)
			title += "."
		return title

	var/total_init_text_time = (total_init_time == -1) ? (world.time / 10) : total_init_time
	var/time_color
	switch(total_init_text_time)
		if(0 to 60)
			time_color = "green"
		if(60 to 120)
			time_color = "yellow"
		if(120 to INFINITY)
			time_color = "red"
	return "Initialized (in <font color='[time_color]'>[total_init_text_time]s</font>)"
// MASSMETA ADDITION END
