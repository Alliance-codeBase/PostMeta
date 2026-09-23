/obj/machinery/anomalous_coffeemachine
	name = "\improper SCP-294"
	desc = "A coffee machine with a keyboard. Insert three coins and name a liquid."
	icon = 'icons/obj/machines/vending.dmi'
	icon_state = "coffee"
	density = TRUE
	processing_flags = START_PROCESSING_MANUALLY
	var/list/coins = list()
	var/request = ""
	var/datum/anomalous_coffeemachine/drinks/pending
	var/deadline = 0

/obj/machinery/anomalous_coffeemachine/Destroy()
	for(var/obj/item/coin/coin as anything in coins)
		coin.forceMove(drop_location())
	QDEL_NULL(pending)
	return ..()

/obj/machinery/anomalous_coffeemachine/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/coin))
		return ..()
	if(!is_operational || length(coins) >= 3)
		balloon_alert(user, "coin slot closed!")
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(tool, src))
		return ITEM_INTERACT_BLOCKING
	coins += tool
	playsound(src, 'modular_meta/features/event/CB/sound/294/coin_drop.ogg', 40, FALSE)
	balloon_alert(user, "[length(coins)]/3 coins")
	SStgui.update_uis(src)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/anomalous_coffeemachine/ui_state(mob/user)
	return GLOB.physical_state

/obj/machinery/anomalous_coffeemachine/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/simple/scp294))

/obj/machinery/anomalous_coffeemachine/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SCP294", name)
		ui.open()

/obj/machinery/anomalous_coffeemachine/ui_data(mob/user)
	return list(
		"input" = request,
		"message" = !is_operational ? "NO POWER" : pending ? "DISPENSING..." : length(coins) < 3 ? "INSERT [3 - length(coins)] COINS" : "",
		"coins" = length(coins),
		"busy" = !isnull(pending),
		"ready" = is_operational && length(coins) >= 3,
	)

/obj/machinery/anomalous_coffeemachine/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(action == "cancel")
		playsound(src, 'modular_meta/features/event/CB/sound/interactions/Button2.ogg', 30, FALSE)
		if(!pending)
			request = ""
		ui.close()
		return TRUE
	if(action != "key" || !is_operational || pending || length(coins) < 3 || !ui.user.can_perform_action(src, SILENT_ADJACENCY))
		return FALSE

	var/key = params["key"]
	if(!istext(key))
		return FALSE
	switch(key)
		if("enter")
			request = trim(request)
			if(!length(request))
				return FALSE
			playsound(src, 'modular_meta/features/event/CB/sound/interactions/Button2.ogg', 30, FALSE)
			order(ui.user)
			return TRUE
		if("backspace")
			request = copytext(request, 1, max(1, length(request)))
		if("space")
			if(length(request) < 40)
				request += " "
		else
			if(length(key) != 1 || !findtext("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.-", key) || length(request) >= 40)
				return FALSE
			request += uppertext(key)
	playsound(src, 'modular_meta/features/event/CB/sound/interactions/Button.ogg', 25, FALSE)
	return TRUE

/obj/machinery/anomalous_coffeemachine/proc/order(mob/user)
	pending = find_drink(lowertext(request))
	var/wait = 3 SECONDS
	if(!pending)
		pending = new /datum/anomalous_coffeemachine/drinks
		wait = 20 SECONDS
		var/link = span_anomalous("<a href='byond://?src=[REF(src)];recipe=[REF(pending)];[HrefToken(forceGlobal = TRUE)]'>Set taste and effect</a>")
		message_admins("[ADMIN_LOOKUPFLW(user)] ordered the unknown drink '[request]' from SCP-294 [ADMIN_COORDJMP(src)]. [link] (20 seconds).")
		for(var/client/admin as anything in GLOB.admins)
			SEND_SOUND(admin, sound('sound/misc/server-ready.ogg', volume = 50))
	pending.label = request
	deadline = world.time + wait
	playsound(src, pending.anomaly ? 'modular_meta/features/event/CB/sound/294/dispense3.ogg' : pick(
		'modular_meta/features/event/CB/sound/294/dispense0.ogg',
		'modular_meta/features/event/CB/sound/294/dispense1.ogg',
		'modular_meta/features/event/CB/sound/294/dispense2.ogg',
	), 45, FALSE)
	log_game("[key_name(user)] ordered SCP-294 drink [request] at [AREACOORD(src)].")
	addtimer(CALLBACK(src, PROC_REF(dispense)), wait)

/obj/machinery/anomalous_coffeemachine/proc/dispense()
	if(!is_operational)
		QDEL_NULL(pending)
	else
		var/obj/item/reagent_containers/cup/glass/coffee_cup/scp294/cup = new(drop_location())
		cup.name = "cup of [lowertext(pending.label)]"
		var/volume = 30
		var/list/data
		if(ispath(pending.reagent, /datum/reagent/anomalous))
			var/datum/reagent/anomalous/reagent = GLOB.chemical_reagents_list[pending.reagent]
			volume = reagent.amount_spawned
			if(pending.taste)
				data = list("taste" = pending.taste)
		cup.reagents.add_reagent(pending.reagent, volume, data)
		qdel(pending)
		pending = null
		QDEL_LIST(coins)
	request = ""
	SStgui.update_uis(src)

/obj/machinery/anomalous_coffeemachine/Topic(href, list/href_list)
	if(!href_list["recipe"])
		return ..()
	if(!check_rights(R_ADMIN) || !usr.client.holder.CheckAdminHref(href, href_list))
		return
	var/datum/anomalous_coffeemachine/drinks/recipe = locate(href_list["recipe"])
	if(!recipe || recipe != pending || world.time >= deadline)
		return
	var/taste = tgui_input_text(usr, "Enter a taste for '[recipe.label]', e.g. 'a sugar cookie'.", "SCP-294", recipe.taste || /datum/reagent/anomalous::taste_description, max_length = 240, multiline = TRUE, timeout = deadline - world.time)
	if(isnull(taste) || QDELETED(src) || recipe != pending || world.time >= deadline)
		return
	var/list/effects = list("No effect" = /datum/reagent/anomalous)
	for(var/datum/reagent/anomalous/effect_type as anything in subtypesof(/datum/reagent/anomalous))
		effects[effect_type::name] = effect_type
	var/effect = tgui_input_list(usr, "Choose the effect of the first sip.", "SCP-294", effects, timeout = deadline - world.time)
	if(isnull(effect) || QDELETED(src) || recipe != pending || world.time >= deadline || !check_rights(R_ADMIN))
		return
	recipe.taste = taste
	recipe.reagent = effects[effect]
	message_admins("[key_name_admin(usr)] configured SCP-294 [recipe.label]: [effect]; [taste]")
	log_admin("[key_name(usr)] configured SCP-294 [recipe.label]: [effect]; [taste]")

/obj/item/reagent_containers/cup/glass/coffee_cup/scp294
	consumption_sound = 'modular_meta/features/event/CB/sound/294/slurp.ogg'
