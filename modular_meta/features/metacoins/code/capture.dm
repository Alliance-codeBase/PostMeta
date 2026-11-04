#define METACOIN_CAPTURE_LIMIT 5
#define METACOIN_CAPTURE_CAP 10

GLOBAL_LIST_INIT(metacoin_brig_areas, zebra_typecacheof(list(
	/area/station/security/brig = TRUE,
	/area/station/security/holding_cell = TRUE,
	/area/station/security/processing = TRUE,
	/area/station/security/interrogation = TRUE,
	/area/station/security/prison = TRUE,
	/area/station/security/execution/transfer = TRUE,
	/area/station/security/execution/education = TRUE,
	/area/station/security/courtroom/holding = TRUE,
	/area/shuttle/escape/brig = TRUE,
	/area/shuttle/labor = TRUE,
	/area/mine/laborcamp = TRUE,
	/area/mine/laborcamp/security = FALSE,
)))

/datum/antagonist
	/// base metacoin reward for capturing this antagonist alive
	var/capture_reward = 100
	/// Security payout for killing or jailing this antagonist.
	var/defeat_reward = 10

/datum/antagonist/hypnotized
	capture_reward = 0
	defeat_reward = 0

/datum/antagonist/rev
	capture_reward = 0
	defeat_reward = 0

/datum/antagonist/enemy_of_the_state
	// the math is simple, stop the mutiny, revive the headrevs and get your reward
	capture_reward = 100

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
		var/amount = get_security_reward(player_mind)
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

/datum/metacoins_controller/proc/get_security_reward(datum/mind/player_mind)
	if(!is_antagonist(player_mind))
		return 0

	var/alive = is_antagonist_alive(player_mind)
	var/mob/captive = player_mind.current
	var/delivered = alive && is_restrained(captive) && reached_centcom(captive)
	var/imprisoned = alive && is_imprisoned(player_mind)
	var/amount = 0
	// count only the highest capture or defeat reward
	for(var/datum/antagonist/antagonist as anything in player_mind.antag_datums)
		if(antagonist.antag_flags & ANTAG_FAKE)
			continue
		if(delivered)
			amount = max(amount, antagonist.capture_reward, antagonist.defeat_reward)
		else if(!alive || (imprisoned && antagonist.capture_reward > 0))
			amount = max(amount, antagonist.defeat_reward)
	return amount

/datum/metacoins_controller/proc/is_antagonist_alive(datum/mind/player_mind)
	var/mob/body = player_mind.current
	if(QDELETED(body) || isbrain(body))
		return FALSE
	if(!isliving(body))
		return TRUE
	var/mob/living/living_body = body
	return living_body.stat != DEAD

/datum/metacoins_controller/proc/is_restrained(mob/captive)
	return HAS_TRAIT(captive, TRAIT_RESTRAINED) || istype(captive.loc, /obj/item/aicard)

/datum/metacoins_controller/proc/reached_centcom(atom/movable/target)
	return target.onCentCom() || target.on_escaped_shuttle()

/datum/metacoins_controller/proc/is_imprisoned(datum/mind/player_mind)
	var/mob/captive = player_mind.current
	return is_held_in_brig(captive) && is_restrained(captive)

/datum/metacoins_controller/proc/is_held_in_brig(mob/captive)
	if(!isliving(captive))
		return FALSE
	var/area/captive_area = get_area(captive)
	return is_type_in_typecache(captive_area, GLOB.metacoin_brig_areas)

/datum/metacoins_controller/proc/capture_reward(target_ckey, amount)
	var/static/list/roles = list(
		/datum/job/captain,
		/datum/job/head_of_security,
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
		"reason" = "Antagonists Defeated",
	))

#undef METACOIN_CAPTURE_LIMIT
#undef METACOIN_CAPTURE_CAP
