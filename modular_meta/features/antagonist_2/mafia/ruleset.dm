//////////////////////////////////////////////
//                                          //
//        ROUNDSTART MAFIA                  //
//                                          //
//////////////////////////////////////////////


/datum/dynamic_ruleset/roundstart/mafia
	name = "Mafia Member"
	config_tag = "Member of Mafia"
	pref_flag = ROLE_MAFIA
	jobban_flag = ROLE_TRAITOR

	preview_antag_datum = /datum/antagonist/mafia
	min_pop = 10
	weight = alist(
		DYNAMIC_TIER_LOW = 0,
		DYNAMIC_TIER_LOWMEDIUM = 2,
		DYNAMIC_TIER_MEDIUMHIGH = 3,
		DYNAMIC_TIER_HIGH = 3,
	)
	// чё блять это вообще значит, ебать нахуй это какая математика ахуеть
	max_antag_cap = list("denominator" = 24)
	blacklisted_roles = list(
		JOB_MEDICAL_DOCTOR,
		JOB_PARAMEDIC,
	)

/datum/dynamic_ruleset/roundstart/mafia/assign_role(datum/mind/candidate)
	candidate.add_antag_datum(/datum/antagonist/mafia)

//////////////////////////////////////////////
//                                          //
//          LATEJOIN MAFIA                  //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/latejoin/mafia
	name = "Demon Infiltration"
	config_tag = "Latejoin Demon of Sin"
	preview_antag_datum = /datum/antagonist/mafia
	pref_flag = ROLE_DEMONINFILTRATION
	jobban_flag = ROLE_TRAITOR
	min_pop = 15
	weight = 2
	blacklisted_roles = list(
		JOB_CHAPLAIN,
	)

/datum/dynamic_ruleset/latejoin/mafia/assign_role(datum/mind/candidate)
	candidate.add_antag_datum(/datum/antagonist/mafia)
