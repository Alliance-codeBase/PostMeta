#define TRAITOR_POPULATION_EXTREME_LOWPOP 10

// population restricts
// to restrict his grace and allow for deswords, as well as martial arts to be bought from the uplink on lowpop shifts.

// kits
/datum/uplink_item/bundles_tc/contract_kit
	population_minimum = TRAITOR_POPULATION_EXTREME_LOWPOP

// dangerous
/datum/uplink_item/dangerous/doublesword
	population_minimum = TRAITOR_POPULATION_EXTREME_LOWPOP

// stealthy
/datum/uplink_item/stealthy_weapons/martialarts
	population_minimum = TRAITOR_POPULATION_EXTREME_LOWPOP

/datum/uplink_item/stealthy_weapons/romerol_kit
	population_minimum = TRAITOR_POPULATION_EXTREME_LOWPOP

// role_restricted
/datum/uplink_item/role_restricted/spider_injector
	population_minimum = TRAITOR_POPULATION_EXTREME_LOWPOP

#undef TRAITOR_POPULATION_EXTREME_LOWPOP
