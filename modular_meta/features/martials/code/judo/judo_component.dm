/datum/component/judo_state
	var/judo_tier = 0
	var/judo_flow = 0
	var/judo_tier_timer = null
	var/grabbed_mob = null // кого мы держим
	var/grabbed_timer = null // таймер удержания

/datum/component/judo_state/Initialize()
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/judo_state/Destroy(force)
	if(judo_tier_timer)
		deltimer(judo_tier_timer)
		judo_tier_timer = null
	return ..()

/datum/component/judo_state/proc/get_tier()
	return judo_tier

/datum/component/judo_state/proc/set_tier(value)
	judo_tier = value

/datum/component/judo_state/proc/get_flow()
	return judo_flow

/datum/component/judo_state/proc/increment_flow()
	judo_flow++

/datum/component/judo_state/proc/reset()
	judo_tier = 0
	judo_flow = 0
	if(judo_tier_timer)
		deltimer(judo_tier_timer)
		judo_tier_timer = null

/datum/component/judo_state/proc/refresh_timer(mob/living/attacker, datum/martial_art/judo/art)
	if(judo_tier_timer)
		deltimer(judo_tier_timer)
	judo_tier_timer = addtimer(CALLBACK(src, PROC_REF(reset)), 10 SECONDS, TIMER_UNIQUE | TIMER_STOPPABLE)

