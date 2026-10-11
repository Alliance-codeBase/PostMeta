/datum/component/judo_state
	// Переменные, которые хранятся на мобе
	var/judo_tier = 0
	var/judo_flow = 0
	var/judo_tier_timer = null
	var/grabbed_mob = null
	var/grabbed_timer = null

/datum/component/judo_state/Initialize()
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/judo_state/Destroy(force)
	if(judo_tier_timer)
		deltimer(judo_tier_timer)
		judo_tier_timer = null
	if(grabbed_timer)
		deltimer(grabbed_timer)
		grabbed_timer = null
	return ..()

// Проки для доступа к переменным
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
	has_twisted = FALSE
	if(judo_tier_timer)
		deltimer(judo_tier_timer)
		judo_tier_timer = null
	if(grabbed_timer)
		deltimer(grabbed_timer)
		grabbed_timer = null
	grabbed_mob = null

/datum/component/judo_state/proc/refresh_timer(mob/living/attacker, datum/martial_art/judo/art)
	if(judo_tier_timer)
		deltimer(judo_tier_timer)
	judo_tier_timer = addtimer(CALLBACK(src, PROC_REF(reset)), 10 SECONDS, TIMER_UNIQUE | TIMER_STOPPABLE)

/datum/component/judo_state
	var/has_twisted = FALSE
