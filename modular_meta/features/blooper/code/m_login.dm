//ORIGINAL FILE: code/modules/mob/living/living_defines.dm
/mob/living
	/// bloops instead of a voice even when the server has one
	var/blooper_voice = FALSE

/// bloops or voice, bloops take the mic
/mob/living/proc/set_blooper_voice(new_blooper_voice)
	blooper_voice = new_blooper_voice
	if(blooper_voice)
		voice = null

//ORIGINAL FILE: code/modules/mob/living/carbon/human/login.dm
/mob/living/carbon/human/Login()
	. = ..()
	// strays without prefs still get a squeaky voice
	if(isnull(blooper))
		blooper = pick(GLOB.blooper_voices)
	// login just handed out a random voice, take it back
	set_blooper_voice(blooper_voice)

//ORIGINAL FILE: code/modules/mob/living/silicon/login.dm
/mob/living/silicon/Login()
	. = ..()
	// dropped mid-login, nobody to read prefs from
	if(!. || !client)
		return FALSE
	// the chassis squeaks like its char slot
	blooper = client.prefs.read_preference(/datum/preference/choiced/blooper)
	blooper_pitch = client.prefs.read_preference(/datum/preference/numeric/blooper_pitch)
	set_blooper_voice(client.prefs.read_preference(/datum/preference/toggle/blooper_voice))
