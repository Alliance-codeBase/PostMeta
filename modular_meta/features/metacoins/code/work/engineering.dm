GLOBAL_LIST_EMPTY(metacoin_hull_breaches)

/turf/ChangeTurf(path, list/new_baseturfs, flags)
	var/was_open_to_space = isspaceturf(src) || isopenspaceturf(src)
	var/turf/new_turf = ..()
	if(!was_open_to_space && (isspaceturf(new_turf) || isopenspaceturf(new_turf)) && is_station_level(new_turf.z) && istype(new_turf.loc, /area/station))
		GLOB.metacoin_hull_breaches[new_turf] = TRUE
	return new_turf

/turf/open/build_with_floor_tiles(obj/item/stack/tile/iron/used_tiles, mob/living/user)
	. = ..()
	if(!GLOB.metacoin_hull_breaches[src] || !isfloorturf(src))
		return
	GLOB.metacoin_hull_breaches -= src
	var/datum/metacoins_controller/controller = get_metacoins_controller()
	controller.award_work(user.mind, amount = 1, category = /datum/metacoin_work_category/engineering, source = "hull_repair", reason = "Hull Repair")
