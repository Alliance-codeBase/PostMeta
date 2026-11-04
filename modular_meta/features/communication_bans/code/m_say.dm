/mob/proc/refuse_say()
	if(isnull(client) || !is_banned_from(client.ckey, BAN_SAY))
		return FALSE
	to_chat(src, span_danger("You cannot speak IC (banned)."))
	return TRUE

//ORIGINAL FILE: code/modules/mob/mob_say.dm
/mob/try_speak(message, ignore_spam = FALSE, forced = null, filterproof = FALSE)
	if(!(ignore_spam || forced) && refuse_say())
		return FALSE
	return ..()

//ORIGINAL FILE: code/modules/antagonists/blob/overmind.dm
/mob/eye/blob/say(
	message,
	bubble_type,
	list/spans = list(),
	sanitize = TRUE,
	datum/language/language,
	ignore_spam = FALSE,
	forced,
	filterproof = FALSE,
	message_range = 7,
	datum/saymode/saymode,
	list/message_mods = list(),
)
	if(refuse_say())
		return
	return ..()

//ORIGINAL FILE: code/modules/mob/living/basic/space_fauna/revenant/_revenant.dm
/mob/living/basic/revenant/say(
	message,
	bubble_type,
	list/spans = list(),
	sanitize = TRUE,
	datum/language/language,
	ignore_spam = FALSE,
	forced,
	filterproof = FALSE,
	message_range = 7,
	datum/saymode/saymode,
	list/message_mods = list(),
)
	if(refuse_say())
		return
	return ..()
