// Set these to zero's to disable them completely
#define METACOIN_REWARD_ROUNDSTART_READY 10
#define METACOIN_REWARD_SURVIVE_EVAC 25
#define METACOIN_REWARD_IMPORTANT_JOBS 50
#define METACOIN_REWARD_ANTAG_GREENTEXT 50
#define METACOIN_IMPORTANT_JOBS list(JOB_CAPTAIN, JOB_HEAD_OF_PERSONNEL, JOB_HEAD_OF_SECURITY, JOB_RESEARCH_DIRECTOR, JOB_SECURITY_OFFICER_SUPPLY, JOB_SECURITY_OFFICER_SCIENCE, JOB_SECURITY_OFFICER_ENGINEERING, JOB_WARDEN, JOB_SECURITY_OFFICER, JOB_CHIEF_MEDICAL_OFFICER, JOB_DETECTIVE, JOB_CHIEF_ENGINEER ) // THIS SHALL BE IN CONFIG, BUT I'M VERY LAZY, OKAY?
#define METACOIN_ICON_PATH "icons/obj/economy.dmi"
#define METACOIN_ICON_STATE "coin_tails" // someone get us a nice lil' carp_coin sprite, or "masscoin"

GLOBAL_DATUM(metacoins_controller, /datum/metacoins_controller)

/proc/get_metacoins_controller()
	if(!GLOB.metacoins_controller)
		GLOB.metacoins_controller = new /datum/metacoins_controller()
		GLOB.metacoins_controller.register_round_callbacks()
	return GLOB.metacoins_controller

/datum/modpack/metacoins/initialize()
	. = ..()
	if(.)
		return
	get_metacoins_controller()
	get_metacoin_controller()

/datum/metacoins_controller
	var/list/round_award_log_by_ckey = list()
	var/list/awarded_sources_by_ckey = list()
	var/round_awards_applied = FALSE

/datum/metacoins_controller/proc/register_round_callbacks()
	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(on_round_start)))
	SSticker.OnRoundend(CALLBACK(src, PROC_REF(grant_round_end_rewards)))
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_LOGGED_IN, PROC_REF(on_mob_logged_in))

/datum/metacoins_controller/proc/on_mob_logged_in(datum/source, mob/logged_in)
	SIGNAL_HANDLER
	if(isliving(logged_in))
		logged_in.AddComponent(/datum/component/treatment_journal)

/datum/metacoins_controller/proc/on_round_start()
	round_awards_applied = FALSE
	round_award_log_by_ckey = list()
	awarded_sources_by_ckey = list()

	if(METACOIN_REWARD_ROUNDSTART_READY <= 0)
		return

	var/list/ready_ckeys = list()
	for(var/ready_ckey in GLOB.joined_player_list)
		if(!ready_ckey)
			continue
		ready_ckeys[ready_ckey] = TRUE

	for(var/player_ckey in ready_ckeys)
		award_metacoins(player_ckey, METACOIN_REWARD_ROUNDSTART_READY, "roundstart_ready", "Roundstart Ready")

/datum/metacoins_controller/proc/grant_round_end_rewards()
	if(round_awards_applied)
		return

	var/list/goal_bonus = goal_rewards()
	var/capture_bonus = capture_total()
	var/list/processed_ckeys = list()
	for(var/player_ckey in GLOB.joined_player_list)
		if(!player_ckey || processed_ckeys[player_ckey])
			continue

		processed_ckeys[player_ckey] = TRUE

		var/list/rewards = get_round_rewards(player_ckey)
		rewards += goal_payout(player_ckey, goal_bonus)
		if(capture_bonus > 0)
			rewards += capture_reward(player_ckey, capture_bonus)
		if(length(rewards))
			award_entries(player_ckey, rewards)

	round_awards_applied = TRUE
	pay_round_award_logs()

/datum/metacoins_controller/proc/pay_round_award_logs()
	for(var/player_ckey in round_award_log_by_ckey)
		var/list/unpaid_awards = get_unpaid_round_awards(player_ckey)
		if(length(unpaid_awards))
			pay_metacoins(player_ckey, sum_awards(unpaid_awards), group_by_reason(unpaid_awards))

/// Main proc for your awards. Integrate it wherever you like to
/// It all piles up into one fat check at round end, anything awarded after that is paid right away
///
/// Arguments:
/// * target_ckey - Player ckey that receives metacoins.
/// * reward_value - Direct amount, or an award typepath when resolve_from_award_type is TRUE.
/// * source - Source key for round log entries and per-round dedupe checks.
/// * reason - reason shown in reward chat message.
/// * allow_repeat - If TRUE, skips source dedupe and allows payout on every call.
/// * resolve_from_award_type - If TRUE, reward_value is resolved through the award datum's reward var.
/// * sound - If TRUE plays a sound, check notify_reward
/// Returns TRUE when payout is persisted, FALSE otherwise.
/datum/metacoins_controller/proc/award_metacoins(target_ckey, reward_value, source, reason, allow_repeat = FALSE, resolve_from_award_type = FALSE, sound = TRUE)
	var/amount
	if(resolve_from_award_type)
		amount = get_reward_amount(reward_value)
	else
		amount = reward_value
	if(!target_ckey || amount <= 0)
		return FALSE

	var/list/rewards = list(list(
		"amount" = amount,
		"source" = source || "unknown",
		"reason" = reason || "Reward",
		"by_award_type" = resolve_from_award_type,
	))
	return award_entries(target_ckey, rewards, allow_repeat, sound)

/datum/metacoins_controller/proc/award_entries(target_ckey, list/rewards, allow_repeat = FALSE, sound = TRUE)
	if(!target_ckey || !length(rewards))
		return FALSE

	var/list/source_awards
	if(!allow_repeat)
		source_awards = awarded_sources_by_ckey[target_ckey]
		if(!islist(source_awards))
			source_awards = list()
			awarded_sources_by_ckey[target_ckey] = source_awards

	var/total_amount = 0
	var/list/pay_rewards = list()
	for(var/list/reward_entry as anything in rewards)
		var/amount = reward_entry["amount"] || 0
		if(amount <= 0)
			continue

		var/sanitized_source = reward_entry["source"] || "unknown"
		var/sanitized_reason = reward_entry["reason"] || "Reward"
		if(!allow_repeat && source_awards[sanitized_source])
			continue

		pay_rewards += list(list(
			"amount" = amount,
			"source" = sanitized_source,
			"reason" = sanitized_reason,
			"by_award_type" = reward_entry["by_award_type"] || FALSE,
		))
		total_amount += amount

	if(total_amount <= 0)
		return FALSE

	if(round_awards_applied)
		INVOKE_ASYNC(src, PROC_REF(pay_metacoins), target_ckey, total_amount, pay_rewards, sound)

	if(!allow_repeat)
		for(var/list/reward_entry as anything in pay_rewards)
			source_awards[reward_entry["source"]] = TRUE

	for(var/list/reward_entry as anything in pay_rewards)
		add_round_award_log_entry(target_ckey, reward_entry["amount"], reward_entry["source"], reward_entry["reason"], paid = round_awards_applied)

	return TRUE

/// Pays metacoins to the balance right away and tells the player what for.
/datum/metacoins_controller/proc/pay_metacoins(target_ckey, total_amount, list/pay_rewards, sound = TRUE)
	if(!add_metacoins(target_ckey, total_amount))
		return FALSE

	notify_reward(target_ckey, total_amount, pay_rewards, sound)

	var/mob/player_mob = get_mob_by_ckey(target_ckey)
	if(player_mob)
		SStgui.update_user_uis(player_mob)

	return TRUE

/datum/metacoins_controller/proc/group_by_reason(list/rewards)
	var/list/amount_by_reason = list()
	for(var/list/reward as anything in rewards)
		amount_by_reason[reward["reason"]] += reward["amount"]
	var/list/grouped_rewards = list()
	for(var/reason in amount_by_reason)
		grouped_rewards += list(list("amount" = amount_by_reason[reason], "reason" = reason))
	return grouped_rewards

/datum/metacoins_controller/proc/get_round_rewards(target_ckey)
	var/list/rewards = list()
	if(METACOIN_REWARD_SURVIVE_EVAC > 0 && is_evacuation_condition_met(target_ckey))
		rewards += list(list(
			"amount" = METACOIN_REWARD_SURVIVE_EVAC,
			"source" = "survived_shift",
			"reason" = "Survived Shift",
		))
	if(METACOIN_REWARD_IMPORTANT_JOBS > 0 && is_important_role(target_ckey))
		rewards += list(list(
			"amount" = METACOIN_REWARD_IMPORTANT_JOBS,
			"source" = "social_role",
			"reason" = "Highly Important Role",
		))
	if(METACOIN_REWARD_ANTAG_GREENTEXT > 0 && is_antag_greentext(target_ckey))
		rewards += list(list(
			"amount" = METACOIN_REWARD_ANTAG_GREENTEXT,
			"source" = "antag_greentext",
			"reason" = "Antagonist Greentext",
		))
	return rewards

/datum/metacoins_controller/proc/get_reward_amount(award_type)
	if(!ispath(award_type, /datum/award))
		return 0

	var/datum/award/award_path = award_type
	var/reward = initial(award_path.reward)
	if(isnull(reward))
		reward = 50

	return reward

/datum/metacoins_controller/proc/get_round_bonus(target_ckey)
	if(!target_ckey)
		return 0

	var/list/award_log = round_award_log_by_ckey[target_ckey]
	if(!islist(award_log))
		return 0

	return sum_awards(award_log)

/datum/metacoins_controller/proc/sum_awards(list/awards)
	var/total_reward = 0
	for(var/list/award_entry as anything in awards)
		total_reward += award_entry["amount"]
	return total_reward

/// Log entries not paid yet, tips are paid right away
/datum/metacoins_controller/proc/get_unpaid_round_awards(target_ckey)
	var/list/unpaid_awards = list()
	for(var/list/award_entry as anything in round_award_log_by_ckey[target_ckey])
		if(!award_entry["paid"])
			unpaid_awards += list(award_entry)
	return unpaid_awards

/datum/metacoins_controller/proc/get_round_award_log(target_ckey)
	if(!target_ckey)
		return list()

	var/list/award_log = round_award_log_by_ckey[target_ckey]
	if(!islist(award_log))
		return list()

	return award_log.Copy()

/datum/metacoins_controller/proc/add_round_award_log_entry(target_ckey, amount, source, reason, paid)
	if(!target_ckey || amount <= 0)
		return

	var/list/award_log = round_award_log_by_ckey[target_ckey]
	if(!islist(award_log))
		award_log = list()
		round_award_log_by_ckey[target_ckey] = award_log

	award_log += list(list(
		"amount" = amount,
		"source" = source || "unknown",
		"reason" = reason || "No reason",
		"time" = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss"),
		"paid" = paid,
	))

/datum/metacoins_controller/proc/get_round_mind(target_ckey)
	if(!target_ckey)
		return

	var/mob/player_mob = get_mob_by_ckey(target_ckey)
	if(player_mob?.mind)
		return player_mob.mind

	for(var/datum/mind/player_mind in SSticker.minds)
		if(ckey(player_mind?.key) == target_ckey)
			return player_mind

/datum/metacoins_controller/proc/is_evacuation_condition_met(target_ckey)
	var/datum/mind/player_mind = get_round_mind(target_ckey)
	if(!player_mind)
		return FALSE

	if(!considered_alive(player_mind, enforce_human = FALSE))
		return FALSE

	if(SSshuttle.emergency?.mode != SHUTTLE_ENDGAME)
		return FALSE

	var/mob/player_mob = player_mind.current
	var/area/player_area = get_area(player_mob)
	if(!player_area || is_imprisoned(player_mind))
		return FALSE

	var/turf/player_turf = get_turf(player_mob)
	if(!player_turf)
		return FALSE

	if(player_turf.onCentCom() || player_turf.onSyndieBase() || player_turf.on_escaped_shuttle())
		return TRUE

	return !!SSshuttle.emergency.shuttle_areas[player_area]

/datum/metacoins_controller/proc/is_important_role(target_ckey)
	var/datum/mind/player_mind = get_round_mind(target_ckey)
	var/job_title = player_mind?.assigned_role?.title
	if(!job_title)
		return FALSE

	return (job_title in METACOIN_IMPORTANT_JOBS)

/datum/metacoins_controller/proc/is_antag_greentext(target_ckey)
	var/datum/mind/player_mind = get_round_mind(target_ckey)
	if(!player_mind || !length(player_mind.antag_datums))
		return FALSE

	for(var/datum/antagonist/antag_datum as anything in player_mind.antag_datums)
		if(istype(antag_datum, /datum/antagonist/greentext))
			return TRUE
		if(antag_datum.antag_flags & ANTAG_FAKE)
			continue
		if(!is_greentext(antag_datum))
			continue
		return TRUE

	return FALSE

/datum/metacoins_controller/proc/is_greentext(datum/antagonist/antag_datum)
	if(!antag_datum)
		return FALSE

	if(!length(antag_datum.objectives))
		return TRUE

	if(istype(antag_datum, /datum/antagonist/traitor))
		var/datum/antagonist/traitor/traitor_datum = antag_datum
		var/datum/uplink_handler/handler = traitor_datum.uplink_handler
		if(handler?.final_objective)
			return TRUE

	for(var/datum/objective/objective as anything in antag_datum.objectives)
		if(!objective.check_completion())
			return FALSE

	return TRUE

/datum/metacoins_controller/proc/notify_reward(target_ckey, total_reward, list/reward_entries, sound = TRUE)
	if(total_reward <= 0)
		return

	var/mob/player_mob = get_mob_by_ckey(target_ckey)
	if(!player_mob?.client)
		return

	var/notice = player_mob.client.prefs.read_preference(/datum/preference/choiced/metacoin_notify)
	if(sound && (notice == "Both" || notice == "Only sound"))
		player_mob.playsound_local(player_mob, 'sound/effects/coin2.ogg', 40, TRUE, use_reverb = FALSE, pressure_affected = FALSE)
	if(notice != "Both" && notice != "Only chat notification")
		return

	var/list/reason_parts = list()
	for(var/list/reward_entry in reward_entries)
		var/entry_amount = reward_entry["amount"] || 0
		if(entry_amount <= 0)
			continue
		reason_parts += "+[entry_amount] [reward_entry["reason"] || "Reward"]"

	var/reasons_text = length(reason_parts) ? jointext(reason_parts, ", ") : "+[total_reward] Reward"
	to_chat(player_mob, span_boldnicegreen("You received [total_reward] metacoins ([reasons_text])."))

/datum/metacoins_controller/proc/fetch_balance(target_ckey)
	if(!target_ckey)
		return 0
	if(!SSdbcore.Connect())
		return null

	var/table_player = format_table_name("player")
	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT metacoins FROM [table_player] WHERE ckey = :ckey",
		list("ckey" = target_ckey),
	)
	if(!query.warn_execute(async = FALSE))
		qdel(query)
		return null

	var/balance = 0
	if(query.NextRow(async = FALSE))
		balance = query.item[1] || 0
	qdel(query)
	return balance

/// Returns the balances of the given ckeys keyed by ckey in one query, or null when the database is unavailable. Ckeys without a player row are left out.
/datum/metacoins_controller/proc/fetch_balances(list/target_ckeys)
	if(!length(target_ckeys))
		CRASH("fetch_balances needs at least one ckey")
	if(!SSdbcore.Connect())
		return null

	var/list/query_arguments = list()
	var/list/placeholders = list()
	for(var/index in 1 to length(target_ckeys))
		query_arguments["ckey[index]"] = target_ckeys[index]
		placeholders += ":ckey[index]"

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT ckey, metacoins FROM [format_table_name("player")] WHERE ckey IN ([placeholders.Join(",")])",
		query_arguments,
	)
	if(!query.warn_execute(async = FALSE))
		qdel(query)
		return null

	var/list/balances = list()
	while(query.NextRow(async = FALSE))
		balances[query.item[1]] = query.item[2] || 0
	qdel(query)
	return balances

/// Takes each amount from its ckey in one query, leaving out players who no longer have enough. Returns how many players were charged, or null when the database is unavailable.
/datum/metacoins_controller/proc/take_metacoins_from_each(list/amounts_by_ckey)
	if(!length(amounts_by_ckey))
		CRASH("take_metacoins_from_each needs at least one ckey")
	if(!SSdbcore.Connect())
		return null

	var/list/query_arguments = list()
	var/list/placeholders = list()
	var/list/amount_cases = list()
	var/index = 0
	for(var/target_ckey in amounts_by_ckey)
		index++
		query_arguments["ckey[index]"] = target_ckey
		query_arguments["amount[index]"] = amounts_by_ckey[target_ckey]
		placeholders += ":ckey[index]"
		amount_cases += "WHEN :ckey[index] THEN :amount[index]"

	var/amount_for_ckey = "CASE ckey [amount_cases.Join(" ")] END"
	var/datum/db_query/query = SSdbcore.NewQuery(
		"UPDATE [format_table_name("player")] SET metacoins = metacoins - [amount_for_ckey] WHERE ckey IN ([placeholders.Join(",")]) AND metacoins >= [amount_for_ckey]",
		query_arguments,
	)
	if(!query.warn_execute(async = FALSE))
		qdel(query)
		return null

	var/charged_count = query.affected
	qdel(query)
	return charged_count

/datum/metacoins_controller/proc/add_metacoins(target_ckey, amount)
	if(!target_ckey || amount <= 0)
		return FALSE
	if(!SSdbcore.Connect())
		return FALSE

	var/table_player = format_table_name("player")
	var/datum/db_query/update_query = SSdbcore.NewQuery(
		"UPDATE [table_player] SET metacoins = metacoins + :amount WHERE ckey = :ckey",
		list(
			"amount" = amount,
			"ckey" = target_ckey,
		),
	)

	var/success = update_query.warn_execute(async = FALSE)
	var/affected = update_query.affected
	qdel(update_query)
	return success && affected > 0

///Takes coins in one atomic query
/datum/metacoins_controller/proc/take_metacoins(target_ckey, amount)
	if(!target_ckey || !isnum(amount) || amount <= 0)
		return list("ok" = FALSE, "error" = "invalid_request")

	var/current_balance = fetch_balance(target_ckey)
	if(isnull(current_balance))
		return list("ok" = FALSE, "error" = "db_unavailable")
	if(current_balance < amount)
		return list("ok" = FALSE, "error" = "not_enough")

	var/table_player = format_table_name("player")
	var/datum/db_query/query = SSdbcore.NewQuery(
		"UPDATE [table_player] SET metacoins = metacoins - :amount WHERE ckey = :ckey AND metacoins >= :amount",
		list(
			"amount" = amount,
			"ckey" = target_ckey,
		),
	)
	if(!query.warn_execute(async = FALSE))
		qdel(query)
		return list("ok" = FALSE, "error" = "db_failed")
	qdel(query)

	var/balance = fetch_balance(target_ckey)
	if(isnull(balance))
		return list("ok" = FALSE, "error" = "db_failed")
	if(balance > current_balance - amount)
		return list("ok" = FALSE, "error" = "not_enough")

	return list("ok" = TRUE, "balance" = balance)

/datum/metacoinshop/panel/wallet
	interface_id = "MetaCoins"

/datum/metacoinshop/panel/wallet/ui_data(mob/user)
	var/list/data = list()
	var/datum/metacoins_controller/controller = get_metacoins_controller()
	var/client_ckey = owner?.ckey

	data["coinIcon"] = METACOIN_ICON_PATH
	data["coinIconState"] = METACOIN_ICON_STATE
	data["roundAwardsApplied"] = controller.round_awards_applied
	data["roundAwarded"] = controller.round_awards_applied && client_ckey ? controller.get_round_bonus(client_ckey) : 0
	data["roundAwardLog"] = controller.round_awards_applied && client_ckey ? controller.get_round_award_log(client_ckey) : list()
	data["canOpenShop"] = TRUE

	var/balance = controller.fetch_balance(client_ckey)
	data["dbConnected"] = !isnull(balance)
	data["balance"] = isnull(balance) ? 0 : balance

	return data

/datum/metacoinshop/panel/wallet/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "open_shop")
		new /datum/metacoinshop/panel/shop(owner, ui.user)
		return TRUE

	return FALSE

/client/verb/view_metacoins()
	set name = "View Metacoins"
	set category = "OOC"
	set desc = "View your metacoin balance and this round award log."

	new /datum/metacoinshop/panel/wallet(src, usr)

#undef METACOIN_REWARD_ROUNDSTART_READY
#undef METACOIN_REWARD_SURVIVE_EVAC
#undef METACOIN_REWARD_IMPORTANT_JOBS
#undef METACOIN_REWARD_ANTAG_GREENTEXT
#undef METACOIN_IMPORTANT_JOBS
#undef METACOIN_ICON_PATH
#undef METACOIN_ICON_STATE
