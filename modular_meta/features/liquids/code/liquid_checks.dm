/turf/proc/liquids_blocked_by_door()
	for(var/obj/machinery/door/door in src)
		if(door.density && !istype(door, /obj/machinery/door/window))
			return TRUE
	return FALSE

/turf/proc/refresh_liquid_neighbor_edges()
	for(var/dir in GLOB.cardinals)
		var/turf/open/neighbor = get_step(src, dir)
		if(!isopenturf(neighbor) || QDELETED(neighbor.liquids))
			continue
		var/datum/liquid_group/neighbor_group = neighbor.liquids.liquid_group
		if(QDELETED(neighbor_group))
			continue
		neighbor_group.check_edges(neighbor)

/obj/machinery/door/proc/liquids_on_open()
	for(var/turf/door_turf as anything in locs)
		door_turf.refresh_liquid_neighbor_edges()
