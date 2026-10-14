#define METACOIN_REWARD_FAILED_GOAL 50

/datum/station_goal
	/// awarded to each non-antagonist for completing this goal
	var/reward = 250

/datum/station_goal/station_shield
	reward = 50 // extremely easy

/datum/station_goal/bluespace_cannon
	reward = 300

/datum/metacoins_controller/proc/goal_rewards()
	var/list/crew_rewards = list()
	var/list/antag_rewards = list()

	for(var/datum/station_goal/goal as anything in SSstation.get_station_goals())
		if(goal.check_completion())
			crew_rewards += list(list(
				"amount" = goal.reward,
				"source" = "station_goal_[goal.type]",
				"reason" = "Station Goal: [goal.name]",
			))
		else
			antag_rewards += list(list(
				"amount" = METACOIN_REWARD_FAILED_GOAL,
				"source" = "station_goal_[goal.type]",
				"reason" = "Station Goal Failed: [goal.name]",
			))

	return list("crew" = crew_rewards, "antag" = antag_rewards)

/datum/metacoins_controller/proc/goal_payout(target_ckey, list/rewards)
	var/datum/mind/player_mind = get_round_mind(target_ckey)
	if(!player_mind)
		return list()

	for(var/datum/antagonist/antag as anything in player_mind.antag_datums)
		if(!(antag.antag_flags & ANTAG_FAKE))
			return rewards["antag"]

	return rewards["crew"]

#undef METACOIN_REWARD_FAILED_GOAL
