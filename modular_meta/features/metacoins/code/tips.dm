GLOBAL_DATUM_INIT(metacoin_tips, /datum/metacoin_tips, new)

/datum/metacoin_tips
	var/cost = 11
	var/amount = 10
	var/cursor_icon = 'modular_meta/features/metacoins/icons/tip_cursor.dmi' // shiny bait for the clicky finger
	/// How long an armed tip waits for a click
	var/picking_duration = 30 SECONDS // then the coin goes back in the pocket

/// Returns a chat link that tips the mentor for a mentorhelp answer.
/datum/metacoin_tips/proc/get_mentorhelp_link(mentor_ckey)
	return "<a href='byond://?src=[REF(src)];tip_mentor=[mentor_ckey]'>\[Tip\]</a>"

/// Returns a chat link that tips the admin who ended an ahelp ticket.
/datum/metacoin_tips/proc/get_ahelp_link(admin_ckey)
	return "<a href='byond://?src=[REF(src)];tip_admin=[admin_ckey]'>\[Tip\]</a>"

/datum/metacoin_tips/Topic(href, list/href_list)
	. = ..()
	if(isnull(usr.client))
		return
	if(href_list["tip_mentor"])
		tip_mentor(usr.client, ckey(href_list["tip_mentor"]))
	else if(href_list["tip_admin"])
		tip_admin(usr.client, ckey(href_list["tip_admin"]))

/datum/metacoin_tips/proc/tip_mentor(client/sender, mentor_ckey)
	if(GLOB.mentor_datums[mentor_ckey] || GLOB.admin_datums[mentor_ckey])
		send_tip(sender, mentor_ckey, tipped_for = "a mentorhelp answer", confirm_in_chat = TRUE)

/// Arms a one-click tip: the next click on a character tips its player, any other click keeps the coins.
/datum/metacoin_tips/proc/start_picking(client/sender)
	if(isnewplayer(sender.mob)) // lobby clicks skip intercepts
		to_chat(sender, span_warning("Nobody to click in the lobby. The tip menu still works."))
		return FALSE
	if(sender.mob.click_intercept || (sender.click_intercept && sender.click_intercept != src))
		to_chat(sender, span_warning("Finish what you are clicking first."))
		return FALSE
	if(sender.mouse_override_icon && sender.mouse_override_icon != cursor_icon) // pet paw and friends
		to_chat(sender, span_warning("Finish what you are clicking first."))
		return FALSE
	sender.click_intercept = src
	sender.mouse_override_icon = cursor_icon
	sender.mob.update_mouse_pointer()
	addtimer(CALLBACK(src, PROC_REF(stop_picking), sender), picking_duration, TIMER_UNIQUE|TIMER_OVERRIDE)
	to_chat(sender, span_notice("Click whoever you want to tip. Click anything else to keep your coins."))
	return TRUE

/// Disarms the tip, leaving alone intercepts and cursors that other code put there since.
/datum/metacoin_tips/proc/stop_picking(client/sender)
	if(QDELETED(sender)) // logged off mid pick
		return
	if(sender.click_intercept == src)
		sender.click_intercept = null
	if(sender.mouse_override_icon == cursor_icon)
		sender.mouse_override_icon = null
		sender.mob.update_mouse_pointer()

/datum/metacoin_tips/proc/InterceptClickOn(mob/user, params, atom/target)
	var/client/sender = user.client
	stop_picking(sender)
	INVOKE_ASYNC(src, PROC_REF(tip_clicked), sender, target)
	return TRUE

/// Every click sounds the same and says nothing, so it never tells whether someone plays the character.
/datum/metacoin_tips/proc/tip_clicked(client/sender, atom/target)
	var/datum/metacoins_controller/controller = get_metacoins_controller()
	var/balance = controller.fetch_balance(sender.ckey)
	if(isnull(balance))
		to_chat(sender, span_warning("Database error. Try again later."))
		return
	if(balance < cost)
		to_chat(sender, span_warning("A tip costs [cost] metacoins."))
		return
	sender.mob.playsound_local(sender.mob, 'sound/effects/kaching.ogg', 40, TRUE, use_reverb = FALSE, pressure_affected = FALSE)
	if(!isliving(target))
		return
	var/mob/living/body = target
	if(isnull(body.mind) || !body.mind.key)
		return
	send_tip(sender, ckey(body.mind.key), tipped_for = null, confirm_in_chat = FALSE)

/datum/metacoin_tips/proc/tip_admin(client/sender, admin_ckey)
	if(GLOB.admin_datums[admin_ckey])
		send_tip(sender, admin_ckey, tipped_for = "an ahelp ticket", confirm_in_chat = TRUE)

/datum/metacoin_tips/proc/get_tippable_ckeys(client/viewer)
	var/list/player_ckeys = list()
	for(var/datum/mind/character as anything in SSticker.minds)
		if(character.key)
			player_ckeys |= ckey(character.key)
	player_ckeys |= GLOB.joined_player_list
	player_ckeys -= viewer.ckey
	for(var/player_ckey in player_ckeys.Copy())
		var/client/player_client = GLOB.directory[player_ckey]
		if(player_client && player_client.holder && player_client.holder.fakekey)
			player_ckeys -= player_ckey
	return player_ckeys

/datum/metacoin_tips/proc/get_tippable_characters(client/viewer)
	var/list/characters = list()
	for(var/datum/mind/character as anything in SSticker.minds)
		if(character.key && ckey(character.key) != viewer.ckey && (character.assigned_role.job_flags & JOB_CREW_MEMBER))
			characters += character
	return characters

/datum/metacoin_tips/proc/send_tip(client/sender, recipient_ckey, tipped_for, confirm_in_chat)
	if(recipient_ckey == sender.ckey)
		to_chat(sender, span_warning("You cannot tip yourself."))
		return
	var/datum/metacoins_controller/controller = get_metacoins_controller()
	var/list/take = controller.take_metacoins(sender.ckey, cost)
	if(!take["ok"])
		to_chat(sender, span_warning(take["error"] == "not_enough" ? "A tip costs [cost] metacoins." : "Database error. Try again later."))
		return
	if(!controller.add_metacoins(recipient_ckey, amount))
		refund_failed_tip(sender)
		return

	log_game("[key_name(sender)] tipped [recipient_ckey] [amount] metacoins[tipped_for ? " for [tipped_for]" : ""].")
	if(confirm_in_chat)
		sender.mob.playsound_local(sender.mob, 'sound/effects/kaching.ogg', 40, TRUE, use_reverb = FALSE, pressure_affected = FALSE)
		to_chat(sender, span_notice("Tip sent."))
	SStgui.update_user_uis(sender.mob)

	var/client/recipient = GLOB.directory[recipient_ckey]
	if(isnull(recipient))
		return
	recipient.mob.playsound_local(recipient.mob, 'sound/effects/coin2.ogg', 40, TRUE, use_reverb = FALSE, pressure_affected = FALSE)
	to_chat(recipient, span_boldnicegreen(tipped_for ? "You got tipped for [tipped_for]!" : "You got tipped!"))
	SStgui.update_user_uis(recipient.mob)

/datum/metacoin_tips/proc/refund_failed_tip(client/sender)
	var/datum/metacoins_controller/controller = get_metacoins_controller()
	controller.add_metacoins(sender.ckey, cost)
	to_chat(sender, span_warning("The tip failed, your metacoins are returned."))

/datum/metacoinshop/panel/tips
	interface_id = "MetaCoinTips"

/datum/metacoinshop/panel/tips/ui_data(mob/user)
	var/list/player_ckeys = GLOB.metacoin_tips.get_tippable_ckeys(owner)
	var/list/characters = list()
	for(var/datum/mind/character as anything in GLOB.metacoin_tips.get_tippable_characters(owner))
		characters += list(list("name" = character.name, "ref" = REF(character)))
	sortTim(player_ckeys, GLOBAL_PROC_REF(cmp_text_asc))
	sortTim(characters, GLOBAL_PROC_REF(cmp_assoc_list_name))
	return list(
		"players" = player_ckeys,
		"characters" = characters,
	)

/datum/metacoinshop/panel/tips/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(action == "tip_player")
		var/recipient_ckey = ckey(params["ckey"])
		if(recipient_ckey in GLOB.metacoin_tips.get_tippable_ckeys(owner))
			GLOB.metacoin_tips.send_tip(owner, recipient_ckey, tipped_for = null, confirm_in_chat = TRUE)
		return TRUE
	if(action == "pick_on_screen")
		if(GLOB.metacoin_tips.start_picking(owner))
			ui.close()
		return TRUE
	if(action == "tip_character")
		var/datum/mind/character = locate(params["ref"]) in GLOB.metacoin_tips.get_tippable_characters(owner)
		if(character)
			GLOB.metacoin_tips.send_tip(owner, ckey(character.key), tipped_for = null, confirm_in_chat = TRUE)
		return TRUE
	return FALSE

/client/proc/open_metacoin_tips()
	new /datum/metacoinshop/panel/tips(src, mob)

/client/verb/tip_on_screen()
	set name = "Tip"
	set category = "OOC"
	set desc = "Click a character to tip their player."

	GLOB.metacoin_tips.start_picking(src)
