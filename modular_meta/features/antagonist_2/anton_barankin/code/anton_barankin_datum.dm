/datum/antagonist/anton_barankin
	name = "\improper Anton Barankin"

/datum/antagonist/anton_barankin/New()
	. = ..()
	todays_mood = pick(demonsins)

/datum/antagonist/anton_barankin/forge_objectives()
	var/datum/objective/anton_barankin/objct

/datum/antagonist/anton_barankin/on_gain()
	forge_objectives()
