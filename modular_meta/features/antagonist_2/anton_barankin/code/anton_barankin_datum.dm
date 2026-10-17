#define CHASTLIV "=)"
#define VZRYVNOY "babah!!"

/datum/antagonist/anton_barankin
	name = "\improper Anton Barankin"

	var/todays_mood

	var/static/list/all_moods = list(CHASTLIV, VZRYVNOY)

/datum/antagonist/anton_barankin/New()
	. = ..()
	todays_mood = pick(all_moods)

/datum/antagonist/anton_barankin/forge_objectives()
	var/datum/objective/anton_barankin/objct

/datum/antagonist/anton_barankin/on_gain()
	forge_objectives()

#undef CHASTLIV
#undef VZRYVNOY
