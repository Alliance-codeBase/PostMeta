GLOBAL_LIST_EMPTY(metacoin_work_coins_by_category_and_ckey)

/datum/metacoin_work_category
	abstract_type = /datum/metacoin_work_category
	var/round_cap
	var/doubled_departments = NONE

/datum/metacoin_work_category/ore
	round_cap = 30

/datum/metacoin_work_category/bounty
	round_cap = 30

/datum/metacoin_work_category/medical
	round_cap = 100
	doubled_departments = DEPARTMENT_BITFLAG_MEDICAL

/datum/metacoin_work_category/engineering
	round_cap = 100
	doubled_departments = DEPARTMENT_BITFLAG_ENGINEERING

/// Accrues a payout for station work, up to the round cap of its category. Antagonists get nothing. Silicons and members of the category's doubled departments get double.
/datum/metacoins_controller/proc/award_work(datum/mind/worker_mind, amount, datum/metacoin_work_category/category, source, reason)
	if(isnull(worker_mind) || is_antagonist(worker_mind))
		return
	var/doubled_departments = initial(category.doubled_departments)
	if(doubled_departments && (issilicon(worker_mind.current) || (worker_mind.assigned_role.departments_bitflags & doubled_departments)))
		amount *= 2
	var/worker_ckey = ckey(worker_mind.key)
	var/category_and_ckey = "[category]:[worker_ckey]"
	var/awarded_coins = GLOB.metacoin_work_coins_by_category_and_ckey[category_and_ckey]
	var/granted_coins = min(round(amount, 1), initial(category.round_cap) - awarded_coins)
	if(granted_coins <= 0)
		return
	if(!award_metacoins(worker_ckey, granted_coins, source, reason, allow_repeat = TRUE, sound = FALSE))
		return
	GLOB.metacoin_work_coins_by_category_and_ckey[category_and_ckey] = awarded_coins + granted_coins

/datum/metacoins_controller/proc/is_antagonist(datum/mind/player_mind)
	for(var/datum/antagonist/antagonist as anything in player_mind.antag_datums)
		if(!(antagonist.antag_flags & ANTAG_FAKE))
			return TRUE
	return FALSE
