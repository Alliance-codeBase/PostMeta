//ORIGINAL FILE: code/modules/mob/living/carbon/human/human_defines.dm
/mob/living/carbon/human
	/// bloops instead of a voice even when the server has one
	var/blooper_voice = FALSE

/// hands the mic over to the bloops
/mob/living/carbon/human/proc/update_blooper_voice()
	if(blooper_voice)
		voice = null

//ORIGINAL FILE: code/modules/mob/living/carbon/human/login.dm
/mob/living/carbon/human/Login()
	. = ..()
	// strays without prefs still get a squeaky voice
	if(isnull(blooper))
		blooper = pick(GLOB.bloopers)
	// login just handed out a random voice, take it back
	update_blooper_voice()
