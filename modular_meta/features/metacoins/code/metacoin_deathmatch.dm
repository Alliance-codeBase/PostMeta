/// Tries to charge the player for current entry fee before adding them to players list.
/datum/deathmatch_lobby/proc/pay_fee(mob/player)
	if(!player?.ckey)
		return FALSE

	var/already_paid = fees_paid[player.ckey] || 0
	if(entry_fee <= already_paid)
		return TRUE

	var/to_pay = entry_fee - already_paid
	var/datum/metacoins_controller/controller = get_metacoins_controller()
	var/list/take_result = controller.take_metacoins(player.ckey, to_pay)
	if(!take_result["ok"])
		var/static/list/error_messages = list(
			"db_unavailable" = "Metacoin database is unavailable.",
			"db_failed" = "Metacoin database is unavailable.",
		)
		var/error = take_result["error"]
		var/message = error_messages[error] || "Failed to pay lobby entry fee."
		if(error == "not_enough")
			message = "Not enough metacoins for entry fee ([entry_fee])."
		to_chat(player, span_warning(message))
		return FALSE

	fees_paid[player.ckey] = already_paid + to_pay
	prize_pool += to_pay
	to_chat(player, span_boldnicegreen("Entry fee paid: [to_pay] metacoins."))
	return TRUE

/// Returns paid fee to the player while lobby is not in active match state.
/datum/deathmatch_lobby/proc/refund_fee(target_ckey, reason)
	if(!target_ckey)
		return FALSE

	var/paid_amount = fees_paid[target_ckey] || 0
	if(paid_amount <= 0)
		fees_paid -= target_ckey
		return TRUE
	// plain values, destroy refunds too so the lobby may be gone when the query wakes up
	INVOKE_ASYNC(get_metacoins_controller(), TYPE_PROC_REF(/datum/metacoins_controller, refund_deathmatch_fee), target_ckey, paid_amount, reason)

	prize_pool = max(prize_pool - paid_amount, 0)
	fees_paid -= target_ckey
	return TRUE

/// Gives a deathmatch entry fee back and tells the player, async since the query can sleep
/datum/metacoins_controller/proc/refund_deathmatch_fee(target_ckey, paid_amount, reason)
	if(!add_metacoins(target_ckey, paid_amount))
		return

	var/mob/player_mob = get_mob_by_ckey(target_ckey)
	if(player_mob)
		to_chat(player_mob, span_notice("Entry fee refunded: [paid_amount] metacoins. [reason]"))

/// Pays prize pool to winner. If payout fails, tries to refund everyone.
/datum/deathmatch_lobby/proc/pay_pool(winner_ckey, mob/winner)
	if(prize_pool <= 0)
		return

	var/payout_amount = prize_pool
	var/list/paid_snapshot = fees_paid?.Copy() || list()
	var/datum/metacoins_controller/wallet = get_metacoins_controller()
	// plain values, end_game() deletes the lobby right after this
	INVOKE_ASYNC(wallet, TYPE_PROC_REF(/datum/metacoins_controller, pay_deathmatch_pool), winner_ckey, winner ? winner.real_name : winner_ckey, payout_amount, paid_snapshot, players + observers)
	prize_pool = 0
	fees_paid = list()

/// Pays the deathmatch prize pool to the winner or refunds every entry fee if that fails, async since the queries can sleep
/datum/metacoins_controller/proc/pay_deathmatch_pool(winner_ckey, winner_name, payout_amount, list/paid_snapshot, list/audience_ckeys)
	var/announcement
	if(winner_ckey && add_metacoins(winner_ckey, payout_amount))
		announcement = span_boldnicegreen("[winner_name] received [payout_amount] metacoins from the prize pool.")
		to_chat(get_mob_by_ckey(winner_ckey), span_boldnicegreen("You won [payout_amount] metacoins from this deathmatch prize pool."))
	else
		for(var/paid_ckey in paid_snapshot)
			var/paid_amount = paid_snapshot[paid_ckey] || 0
			if(paid_amount <= 0)
				continue
			add_metacoins(paid_ckey, paid_amount)
		announcement = span_warning("Prize payout failed, entry fees were refunded when possible.")

	for(var/audience_ckey in audience_ckeys)
		to_chat(get_mob_by_ckey(audience_ckey), announcement)
