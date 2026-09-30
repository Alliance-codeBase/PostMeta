#define METACOIN_CAPTURE_LIMIT 5
#define METACOIN_CAPTURE_CAP 10

/datum/antagonist
	/// base metacoin reward for capturing this antagonist alive
	var/capture_reward = 100

/datum/antagonist/changeling
	capture_reward = 200

/datum/antagonist/heretic
	capture_reward = 300

/datum/antagonist/nukeop
	capture_reward = 600 // we both know that's kinda impossible

/datum/antagonist/wizard
	capture_reward = 600

/datum/metacoins_controller/proc/capture_total()
	if(SSshuttle.emergency?.mode != SHUTTLE_ENDGAME)
		return 0

	var/list/rewards = list()
	for(var/datum/mind/player_mind as anything in SSticker.minds)
		if(!iscarbon(player_mind.current))
			continue
		var/mob/living/carbon/captive = player_mind.current
		if(captive.stat == DEAD || !captive.handcuffed)
			continue
		var/area/location = get_area(captive)
		if(!istype(location, /area/shuttle/escape/brig) || !SSshuttle.emergency.shuttle_areas[location])
			continue

		// count only the highest capture reward
		var/amount = 0
		for(var/datum/antagonist/antag as anything in player_mind.antag_datums)
			if(!(antag.antag_flags & ANTAG_FAKE))
				amount = max(amount, antag.capture_reward)
		if(amount > 0)
			rewards += amount

	sortTim(rewards, GLOBAL_PROC_REF(cmp_numeric_dsc))
	var/total = 0
	for(var/index in 1 to length(rewards))
		var/amount = rewards[index]
		if(index > METACOIN_CAPTURE_LIMIT)
			amount = min(amount, METACOIN_CAPTURE_CAP)
		else if(index > 2)
			amount /= 2 ** (index - 2)
		total += round(amount)
	return total

/datum/metacoins_controller/proc/capture_reward(target_ckey, amount)
	var/static/list/roles = list(
		/datum/job/captain,
		/datum/job/head_of_personnel,
		/datum/job/head_of_security,
		/datum/job/chief_engineer,
		/datum/job/chief_medical_officer,
		/datum/job/research_director,
		/datum/job/quartermaster,
		/datum/job/warden,
		/datum/job/detective,
		/datum/job/security_officer,
		/datum/job/veteran_advisor,
	) // debatable, you may want to remove heads of staff except hos and captain
	var/datum/mind/player_mind = get_round_mind(target_ckey)
	var/datum/job/role = player_mind?.assigned_role
	if(!role)
		return list()
	if(!is_type_in_list(role, roles))
		return list()
	for(var/datum/antagonist/antag as anything in player_mind.antag_datums)
		if(!(antag.antag_flags & ANTAG_FAKE))
			return list()

	return list(list(
		"amount" = amount,
		"source" = "antag_capture",
		"reason" = "Antagonist Captured Alive",
	))

#undef METACOIN_CAPTURE_LIMIT
#undef METACOIN_CAPTURE_CAP
