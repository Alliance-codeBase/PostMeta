GLOBAL_VAR_INIT(global_evaporation_rate, 2)

/datum/reagent
	///Whether it will evaporate if left untouched on a liquids simulated puddle
	var/evaporates = TRUE
	/// How flammable is this material? For liquid spills and molotov cocktails
	var/accelerant_quality = 0
	///Whether a fire from this requires oxygen in the atmosphere
	var/fire_needs_oxygen = TRUE
	///The opacity of the chems used to determine the alpha of liquid turfs
	var/opacity = 180
	///The rate of evaporation in units per call
	var/evaporation_rate = 2
	///The rate of evaporation for the entire GROUP per call, for special things like drying agent
	var/group_evaporation_rate = 0
	/// do we have a turf exposure (used to prevent liquids doing un-needed processes)
	var/turf_exposure = FALSE
	/// are we slippery?
	var/slippery = TRUE
	/// slips every time you step into it? aka water and etc
	var/really_slippery = FALSE

/datum/reagent/proc/evaporate(turf/exposed_turf, reac_volume)
	return

/datum/reagent/water
	color = "#88cff0"
	slippery = FALSE
	really_slippery = TRUE
	evaporation_rate = 5
	opacity = 150

/datum/reagent/lube
	slippery = FALSE
	really_slippery = TRUE
	evaporation_rate = 3

/datum/reagent/blood
	slippery = FALSE
	evaporation_rate = 1
	opacity = 255

/datum/reagent/consumable/sugar
	slippery = FALSE
	opacity = 255

/datum/reagent/consumable/salt
	slippery = FALSE
	opacity = 255

/datum/reagent/consumable/coffee
	opacity = 230

/datum/reagent/consumable/ethanol
	accelerant_quality = 5
	opacity = 200

/datum/reagent/fuel
	accelerant_quality = 15
	opacity = 200

/datum/reagent/oil
	accelerant_quality = 8
	opacity = 200

/datum/reagent/hellwater
	accelerant_quality = 20

/datum/reagent/drying_agent
	group_evaporation_rate = 16
	evaporation_rate = 0 //will never evaporate on it's own

/datum/reagent/clf3
	evaporation_rate = 100

/datum/reagent/phlogiston
	accelerant_quality = 20

/datum/reagent/napalm
	accelerant_quality = 20

/datum/reagent/toxin
	evaporation_rate = 4 //2x faster than normal chems

/datum/reagent/toxin/plasma
	accelerant_quality = 50 //OWWW

/datum/reagent/toxin/spore_burning
	accelerant_quality = 10
