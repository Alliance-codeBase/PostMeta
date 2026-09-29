//ORIGINAL FILE: code/modules/tgui_input/say_modal/speech.dm
/// Marks the window closed right after an immediate force, so the same text is not said twice.
/datum/tgui_say/force_say(list/alter_phrases = null, immediate = FALSE)
	. = ..()
	if(immediate)
		window_open = FALSE
