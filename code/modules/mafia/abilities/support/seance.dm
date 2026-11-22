/**
 * Seance
 *
 * An ability that doesn't give you any actions, instead grants the ability to speak with the dead during the Night.
 */
/datum/mafia_ability/seance
	name = "Speak with the Dead"
	action_priority = null
	use_flags = NONE

/**
 * handle_message
 *
 * During the night, Seancers speaking will instead be talking to deadchat.
 */
/datum/mafia_ability/seance/handle_speech(datum/source, list/speech_args)
	. = ..()
	if(host_role.mafia_game_controller.phase != MAFIA_PHASE_NIGHT)
		return FALSE

	//MASSMETA EDIT CHANGE BEGIN (xss_hotfix)
	/* ORIGINAL
	var/message = span_changeling("<b>\[DEAD CHAT - CHAPLAIN\] [source]</b>: [html_decode(speech_args[SPEECH_MESSAGE])]")
	*/
	var/message = span_changeling("<b>\[DEAD CHAT - CHAPLAIN\] [source]</b>: [speech_args[SPEECH_MESSAGE]]") // say() already encoded it, decoding hands raw html to to_chat
	//MASSMETA EDIT CHANGE END
	host_role.mafia_game_controller.send_message(message, team = MAFIA_TEAM_DEAD)
	speech_args[SPEECH_MESSAGE] = ""
	return TRUE
