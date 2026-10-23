/datum/preference/metacoin_autobuy
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_PLAYER
	savefile_key = "metacoin_autobuy"

/datum/preference/metacoin_autobuy/create_default_value()
	return list()

/datum/preference/metacoin_autobuy/is_valid(value)
	return islist(value)

/// Hidden from the preferences menu, so it is changed only through the shop and its checks.
/datum/preference/metacoin_autobuy/is_accessible(datum/preferences/preferences)
	..()
	return FALSE

/// Keeps only listing ids mapped to a variant or to no variant, since the savefile can be edited outside the game.
/datum/preference/metacoin_autobuy/deserialize(input, datum/preferences/preferences)
	var/list/autobuy_variants = list()
	if(!islist(input))
		return autobuy_variants
	for(var/listing_id in input)
		if(!istext(listing_id))
			continue
		var/variant = input[listing_id]
		if(isnull(variant) || istext(variant))
			autobuy_variants[listing_id] = variant
	return autobuy_variants

/proc/cmp_metacoin_listing_price_descending(datum/metacoinshop/listing/first, datum/metacoinshop/listing/second)
	return second.price - first.price

/// Returns the preround listing with this id if players can have it auto-bought, or null otherwise.
/datum/metacoin_shop_controller/proc/autobuy_listing(listing_id)
	var/datum/metacoinshop/listing/listing = preround_catalog[listing_id]
	if(isnull(listing) || !listing.autobuy_supported)
		return null
	return listing

/// Returns the player's auto-buy listing ids mapped to the chosen variant, leaving out listings that are gone or cannot be auto-bought.
/datum/metacoin_shop_controller/proc/get_autobuy_variants(client/player_client)
	RETURN_TYPE(/list)
	var/list/saved_variants = player_client.prefs.read_preference(/datum/preference/metacoin_autobuy)
	var/list/autobuy_variants = list()
	for(var/listing_id in saved_variants)
		if(autobuy_listing(listing_id))
			autobuy_variants[listing_id] = saved_variants[listing_id]
	return autobuy_variants

/datum/metacoin_shop_controller/proc/enable_autobuy(client/player_client, listing_id, variant)
	var/datum/metacoinshop/listing/listing = autobuy_listing(listing_id)
	if(isnull(listing))
		return list("ok" = FALSE, "error" = "unknown_item")
	if(!listing.is_valid_variant(variant))
		return list("ok" = FALSE, "error" = "invalid_variant")

	var/list/autobuy_variants = get_autobuy_variants(player_client)
	autobuy_variants[listing_id] = variant
	save_autobuy_variants(player_client, autobuy_variants)
	return list("ok" = TRUE)

/datum/metacoin_shop_controller/proc/disable_autobuy(client/player_client, listing_id)
	var/list/autobuy_variants = get_autobuy_variants(player_client)
	autobuy_variants -= listing_id
	save_autobuy_variants(player_client, autobuy_variants)
	return list("ok" = TRUE)

/datum/metacoin_shop_controller/proc/save_autobuy_variants(client/player_client, list/autobuy_variants)
	player_client.prefs.write_preference(GLOB.preference_entries[/datum/preference/metacoin_autobuy], autobuy_variants)
	player_client.prefs.save_preferences()

/// Returns the listings for these auto-buy ids, from the most expensive down.
/datum/metacoin_shop_controller/proc/autobuy_listings(list/autobuy_variants)
	var/list/listings = list()
	for(var/listing_id in autobuy_variants)
		listings += preround_catalog[listing_id]
	return sort_list(listings, GLOBAL_PROC_REF(cmp_metacoin_listing_price_descending))

/// Buys the auto-buy listings of every ready player right before the shop closes, after all manual purchases.
/// Players go in random order, so once antag tokens can be auto-bought, the slots left after manual purchases go to auto-buyers fairly.
/// Metacoin queries block without sleeping, so the async call finishes before the ticker leaves pregame.
/datum/metacoin_shop_controller/proc/on_entering_setup(datum/source)
	SIGNAL_HANDLER
	var/list/clients_by_ckey = list()
	for(var/mob/dead/new_player/player as anything in shuffle(GLOB.new_player_list))
		if(player.ready == PLAYER_READY_TO_PLAY && player.client && length(get_autobuy_variants(player.client)))
			clients_by_ckey[ckey(player.client.ckey)] = player.client
	if(length(clients_by_ckey))
		INVOKE_ASYNC(src, PROC_REF(run_autobuy), clients_by_ckey)

/// Reads every balance in one query, queues what each player can afford, then charges everyone in one more query.
/datum/metacoin_shop_controller/proc/run_autobuy(list/clients_by_ckey)
	var/list/balances = wallet.fetch_balances(assoc_to_keys(clients_by_ckey))
	if(isnull(balances))
		for(var/target_ckey in clients_by_ckey)
			var/client/player_client = clients_by_ckey[target_ckey]
			to_chat(player_client.mob, span_warning("Auto-buy failed: [error_text("db_unavailable")]"))
		return

	var/list/orders_by_ckey = list()
	var/list/costs_by_ckey = list()
	for(var/target_ckey in clients_by_ckey)
		if(isnull(balances[target_ckey]))
			continue
		var/list/order = queue_autobuy(target_ckey, balances[target_ckey], get_autobuy_variants(clients_by_ckey[target_ckey]))
		orders_by_ckey[target_ckey] = order
		if(order["cost"])
			costs_by_ckey[target_ckey] = order["cost"]

	var/list/uncharged_reasons = charge_autobuy(costs_by_ckey, balances)
	for(var/target_ckey in uncharged_reasons)
		cancel_autobuy(target_ckey, orders_by_ckey[target_ckey], uncharged_reasons[target_ckey])
	for(var/target_ckey in orders_by_ckey)
		var/list/order = orders_by_ckey[target_ckey]
		report_autobuy(clients_by_ckey[target_ckey], order, balances[target_ckey] - order["cost"])

/// Queues the player's auto-buy listings for this round from the most expensive down while the balance lasts. Returns the queued listings, their total cost and why the rest were skipped.
/datum/metacoin_shop_controller/proc/queue_autobuy(target_ckey, balance, list/autobuy_variants)
	var/list/queued_listings = list()
	var/list/skipped = list()
	var/cost = 0
	for(var/datum/metacoinshop/listing/preround/listing as anything in autobuy_listings(autobuy_variants))
		var/variant = autobuy_variants[listing.id]
		var/error_code = listing.purchase_error(src, target_ckey, variant)
		if(isnull(error_code) && balance - cost < listing.price)
			error_code = "not_enough"
		if(error_code == "already_owned")
			continue
		if(error_code)
			skipped += "[listing.name] ([error_text(error_code)])"
			continue
		var/list/pending_items = pending_items_for(target_ckey)
		pending_items[listing.id] = variant
		queued_listings += listing
		cost += listing.price
	return list("listings" = queued_listings, "cost" = cost, "skipped" = skipped)

/// Charges every queued auto-buy in one query. Returns the ckeys that were not charged mapped to the error code.
/// When the update leaves someone out, the balances are read again to find who, which can be wrong if another server changes the same balance at that moment.
/datum/metacoin_shop_controller/proc/charge_autobuy(list/costs_by_ckey, list/balances_before)
	var/list/uncharged_reasons = list()
	if(!length(costs_by_ckey))
		return uncharged_reasons

	var/charged_count = wallet.take_metacoins_from_each(costs_by_ckey)
	if(isnull(charged_count))
		for(var/target_ckey in costs_by_ckey)
			uncharged_reasons[target_ckey] = "db_failed"
		return uncharged_reasons
	if(charged_count == length(costs_by_ckey))
		return uncharged_reasons

	var/list/balances_after = wallet.fetch_balances(assoc_to_keys(costs_by_ckey))
	if(isnull(balances_after))
		var/failure_log = "Metacoin auto-buy could not tell who was charged, purchases were kept for [english_list(assoc_to_keys(costs_by_ckey))]"
		log_game(failure_log)
		message_admins(failure_log)
		return uncharged_reasons

	for(var/target_ckey in costs_by_ckey)
		if(balances_after[target_ckey] > balances_before[target_ckey] - costs_by_ckey[target_ckey])
			uncharged_reasons[target_ckey] = "balance_changed"
	return uncharged_reasons

/// Takes back the queued listings of a player whose charge did not go through and lists them as skipped.
/datum/metacoin_shop_controller/proc/cancel_autobuy(target_ckey, list/order, error_code)
	var/list/pending_items = preround_pending_by_ckey[target_ckey]
	for(var/datum/metacoinshop/listing/listing as anything in order["listings"])
		pending_items -= listing.id
		order["skipped"] += "[listing.name] ([error_text(error_code)])"
	order["listings"] = list()
	order["cost"] = 0

/datum/metacoin_shop_controller/proc/report_autobuy(client/player_client, list/order, balance_after)
	var/mob/player_mob = player_client.mob
	var/list/bought_names = list()
	for(var/datum/metacoinshop/listing/listing as anything in order["listings"])
		listing.on_bought(src, ckey(player_client.ckey), player_mob, player_client, balance_after)
		bought_names += listing.name
	if(length(bought_names))
		notify_bought(player_mob, "Auto-bought [english_list(bought_names)] for [order["cost"]] metacoins. They will be delivered on first roundstart spawn.")
	if(length(order["skipped"]))
		to_chat(player_mob, span_warning("Auto-buy skipped: [english_list(order["skipped"])]"))
