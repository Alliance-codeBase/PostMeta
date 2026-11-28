//ORIGINAL FILE: code/modules/mob/living/carbon/human/login.dm
/mob/living/carbon/human/Login()
	. = ..()
	// strays without prefs still get a squeaky voice
	if(isnull(blooper))
		set_blooper(pick(GLOB.blooper_voices))

//ORIGINAL FILE: code/modules/mob/living/silicon/login.dm
/mob/living/silicon/Login()
	. = ..()
	// dropped mid-login, nobody to read prefs from
	if(!. || !client)
		return FALSE
	// the chassis squeaks like its char slot
	blooper = client.prefs.read_preference(/datum/preference/choiced/blooper)
	blooper_pitch = client.prefs.read_preference(/datum/preference/numeric/blooper_pitch)
