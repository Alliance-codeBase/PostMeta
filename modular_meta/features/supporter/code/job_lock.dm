// You can add any jobs or roles in the list below to lock them for supporter only, but that's only the UI part,
// example below this proc code shows how to lock it for supporters-only
/datum/preference_middleware/jobs/get_ui_static_data(mob/user)
	. = ..()
	if(!(user.ckey in GLOB.supporters))
		.["supporter_locked"] = list(JOB_BRIG_PHYSICIAN)


/datum/controller/subsystem/job/check_job_eligibility(mob/dead/new_player/player, datum/job/possible_job, debug_prefix = "", add_job_to_log = FALSE)
	. = ..()
	if(possible_job.title == JOB_BRIG_PHYSICIAN && !(player.ckey in GLOB.supporters))
		return JOB_UNAVAILABLE_GENERIC

