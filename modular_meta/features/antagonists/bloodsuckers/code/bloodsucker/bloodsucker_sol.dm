/**
 *	# Assigning Sol
 *
 *	Sol is the sunlight. After sol bloodsuckers gain ranks
 */

/// Start Sol, called when someone is assigned Bloodsucker
/datum/antagonist/bloodsucker/proc/check_start_sunlight()
	var/list/existing_suckers = get_antag_minds(/datum/antagonist/bloodsucker) - owner
	if(!length(existing_suckers))
		message_admins("New Sol has been created due to Bloodsucker assignment.")
		SSsunlight.can_fire = TRUE

/// End Sol, if you're the last Bloodsucker
/datum/antagonist/bloodsucker/proc/check_cancel_sunlight()
	var/list/existing_suckers = get_antag_minds(/datum/antagonist/bloodsucker) - owner
	if(!length(existing_suckers))
		message_admins("Sol has been deleted due to the lack of Bloodsuckers")
		SSsunlight.can_fire = FALSE

///Ranks the Bloodsucker up, called by Sol.
/datum/antagonist/bloodsucker/proc/sol_rank_up(atom/source)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, PROC_REF(RankUp))

///Called when Sol is near starting.
/datum/antagonist/bloodsucker/proc/sol_near_start(atom/source)
	SIGNAL_HANDLER
	if(bloodsucker_lair_area && !(locate(/datum/action/cooldown/bloodsucker/gohome) in powers))
		BuyPower(new /datum/action/cooldown/bloodsucker/gohome)

///Called when Sol first ends.
/datum/antagonist/bloodsucker/proc/on_sol_end(atom/source)
	SIGNAL_HANDLER
	check_end_torpor()
	for(var/datum/action/cooldown/bloodsucker/power in powers)
		if(istype(power, /datum/action/cooldown/bloodsucker/gohome))
			RemovePower(power)

/// Cycle through all vamp antags and check if they're inside a closet.
/datum/antagonist/bloodsucker/proc/handle_sol()
	SIGNAL_HANDLER
	if(!owner || !owner.current)
		return

	var/mob/living/bloodsucker_mob = owner.current

	if(istype(bloodsucker_mob.loc, /obj/structure/closet/crate/coffin))
		if(bloodsucker_mob.am_staked())
			to_chat(bloodsucker_mob, span_userdanger("You are staked! Remove the offending weapon from your heart before sleeping."))
		if(!HAS_TRAIT(bloodsucker_mob, TRAIT_NODEATH))
			check_begin_torpor(TRUE)
			bloodsucker_mob.add_mood_event("vampsleep", /datum/mood_event/coffinsleep)

		bloodsucker_mob.remove_status_effect(/datum/status_effect/bloodsucker_sol)
		dirty_area()
		return

	bloodsucker_mob.apply_status_effect(/datum/status_effect/bloodsucker_sol)

	if(!istype(bloodsucker_mob.loc, /obj/structure))
		bloodsucker_mob.add_mood_event("vampsleep", /datum/mood_event/daylight_2)
		return
	bloodsucker_mob.add_mood_event("vampsleep", /datum/mood_event/daylight_1)

///Makes the area the bloodsucker is currently in dirty with cobweb and dirt.
/datum/antagonist/bloodsucker/proc/dirty_area()
	var/list/turf/area_turfs = get_area_turfs(get_area(owner.current))
	var/turf/turf_to_be_dirtied = pick(area_turfs)
	if(turf_to_be_dirtied && !turf_to_be_dirtied.density)
		var/turf/north_turf = get_step(turf_to_be_dirtied, NORTH)
		if(istype(north_turf, /turf/closed/wall))
			var/turf/west_turf = get_step(turf_to_be_dirtied, WEST)
			if(istype(west_turf, /turf/closed/wall))
				new /obj/effect/decal/cleanable/cobweb(turf_to_be_dirtied)
			var/turf/east_turf = get_step(turf_to_be_dirtied, EAST)
			if(istype(east_turf, /turf/closed/wall))
				new /obj/effect/decal/cleanable/cobweb/cobweb2(turf_to_be_dirtied)
		new /obj/effect/decal/cleanable/dirt(turf_to_be_dirtied)

/datum/antagonist/bloodsucker/proc/give_warning(atom/source, danger_level, vampire_warning_message, vassal_warning_message)
	SIGNAL_HANDLER
	if(!owner)
		return
	to_chat(owner, vampire_warning_message)

	switch(danger_level)
		if(DANGER_LEVEL_FIRST_WARNING)
			owner.current.playsound_local(null, 'modular_meta/features/antagonists/bloodsuckers/sounds/griffin_3.ogg', vol = 50, vary = TRUE)
		if(DANGER_LEVEL_SECOND_WARNING)
			owner.current.playsound_local(null, 'modular_meta/features/antagonists/bloodsuckers/sounds/griffin_5.ogg', vol = 50, vary = TRUE)
		if(DANGER_LEVEL_THIRD_WARNING)
			owner.current.playsound_local(null, 'sound/effects/alert.ogg', vol = 75, vary = TRUE)
		if(DANGER_LEVEL_SOL_ROSE)
			owner.current.playsound_local(null, 'sound/ambience/misc/ambimystery.ogg', vol = 75, vary = TRUE)
		if(DANGER_LEVEL_SOL_ENDED)
			owner.current.playsound_local(null, 'sound/ambience/misc/source_holehit3.ogg', vol = 90, vary = TRUE)

/datum/status_effect/bloodsucker_sol
	id = "bloodsucker_sol"
	tick_interval = -1
	alert_type = /atom/movable/screen/alert/status_effect/bloodsucker_sol
	var/list/datum/action/cooldown/bloodsucker/burdened_actions
	var/static/list/sol_traits = list(
		TRAIT_EASILY_WOUNDED,
	)

/datum/status_effect/bloodsucker_sol/on_apply()
	if(!SSsunlight.sunlight_active || istype(owner.loc, /obj/structure/closet/crate/coffin))
		return FALSE
	RegisterSignal(SSsunlight, COMSIG_SOL_END, PROC_REF(on_sol_end))
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(on_owner_moved))
	owner.add_traits(sol_traits, id)
	owner.remove_filter(id)
	owner.add_filter(id, 2, drop_shadow_filter(x = 0, y = 0, size = 3, offset = 1.5, color = "#ee7440"))
	owner.add_movespeed_modifier(/datum/movespeed_modifier/bloodsucker_sol)
	owner.add_actionspeed_modifier(/datum/actionspeed_modifier/bloodsucker_sol)
	to_chat(owner, span_userdanger("Sol has risen! Your body is burdened, and you will not heal outside of a coffin!"), type = MESSAGE_TYPE_INFO)
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		human_owner.damage_resistance -= 50
	return TRUE

/datum/status_effect/bloodsucker_sol/on_remove()
	UnregisterSignal(SSsunlight, COMSIG_SOL_END)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	owner.remove_traits(sol_traits, id)
	owner.remove_filter(id)
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/bloodsucker_sol)
	owner.remove_actionspeed_modifier(/datum/actionspeed_modifier/bloodsucker_sol)
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		human_owner.damage_resistance += 50
	for(var/datum/action/cooldown/bloodsucker/power in owner.actions)
		power.build_all_button_icons(UPDATE_BUTTON_NAME | UPDATE_BUTTON_STATUS)
	LAZYNULL(burdened_actions)

/datum/status_effect/bloodsucker_sol/get_examine_text()
	return span_warning("[owner.p_They()] seem[owner.p_s()] sickly and painfully overburned!")

/datum/status_effect/bloodsucker_sol/proc/on_sol_end()
	SIGNAL_HANDLER
	if(!QDELING(src))
		to_chat(owner, span_big(span_boldnotice("Sol has ended!")), type = MESSAGE_TYPE_INFO)
		qdel(src)

/datum/status_effect/bloodsucker_sol/proc/on_owner_moved()
	SIGNAL_HANDLER
	if(istype(owner.loc, /obj/structure/closet/crate/coffin))
		qdel(src)

/atom/movable/screen/alert/status_effect/bloodsucker_sol
	name = "Solar Flares"
	desc = "Solar flares bombard the station, preventing you from healing and burdening your body!\nSleep in a coffin to avoid the effects of the solar flare!"
	icon = 'modular_meta/features/antagonists/icons/bloodsuckers/actions_bloodsucker.dmi'
	icon_state = "sol_alert"

/datum/actionspeed_modifier/bloodsucker_sol
	multiplicative_slowdown = 1

/datum/movespeed_modifier/bloodsucker_sol
	multiplicative_slowdown = 0.45
