#define MODE_FORCE_SAY_SUFFIX "force_say_suffix"
#define MODE_FORCE_SAY_SUFFIX_ONLY "force_say_suffix_only"
#define LONG_TEXT_LENGTH 50
#define LONG_TEXT_MINIMUM_KEPT 40

/datum/tgui_say
	/// Hurt suffixes for Russian speech.
	var/static/list/russian_hurt_phrases = list("ОЙ!", "ОХ!", "АХ!", "АЙ!", "УХ!", "УФ!", "ОУ!")

/// Says the interrupted entry with its say prefixes kept. An empty entry gives a lone cry or nothing.
/datum/tgui_say/proc/delegate_forced_speech(payload, channel)
	if(GLOB.say_disabled || !is_in_character(channel))
		return
	var/entry = ""
	if(is_in_character(payload["channel"]) && trimtext(payload["entry"]))
		entry = payload["entry"]
	var/mob/speaker = client.mob
	var/body = ""
	if(entry)
		body = speaker.get_message_mods(entry, list())
	if(!body)
		var/cry = pick(alter_phrases || russian_hurt_phrases)
		if(cry)
			INVOKE_ASYNC(speaker, TYPE_PROC_REF(/atom/movable, say), cry, message_mods = list(MODE_FORCE_SAY_SUFFIX_ONLY = TRUE))
		return
	var/message_modifiers = copytext_char(entry, 1, length_char(entry) - length_char(body) + 1)
	var/cut_body = cut_off(body)
	var/radio_key = channel == RADIO_CHANNEL ? RADIO_KEY_COMMON : ""
	var/suffix = pick(alter_phrases || hurt_phrases_for(cut_body))
	INVOKE_ASYNC(speaker, TYPE_PROC_REF(/atom/movable, say), "[radio_key][message_modifiers][cut_body]", message_mods = list(MODE_FORCE_SAY_SUFFIX = suffix))

/// TRUE for channels spoken in character.
/datum/tgui_say/proc/is_in_character(channel)
	return channel == SAY_CHANNEL || channel == RADIO_CHANNEL

/// Cuts the text off where the speaker was interrupted.
/datum/tgui_say/proc/cut_off(text)
	var/text_length = length_char(text)
	if(text_length > LONG_TEXT_LENGTH)
		return trim(text, rand(LONG_TEXT_MINIMUM_KEPT, LONG_TEXT_LENGTH))
	if(text_length > 1)
		return trim(text, text_length)
	return text

/// English hurt phrases if the text has more Latin than Cyrillic letters, Russian otherwise.
/datum/tgui_say/proc/hurt_phrases_for(text)
	var/static/regex/not_cyrillic = regex(@"[^а-яА-ЯёЁ]", "g")
	var/static/regex/not_latin = regex(@"[^a-zA-Z]", "g")
	var/cyrillic_count = length_char(not_cyrillic.Replace(text, ""))
	var/latin_count = length_char(not_latin.Replace(text, ""))
	return latin_count > cyrillic_count ? hurt_phrases : russian_hurt_phrases

/// Adds the interruption to a forced message. Chat gets "-SUFFIX", TTS gets "... suffix" in lowercase, blackout gets "..." in both. A lone cry only gets lowercase TTS.
/proc/interrupt_speech(list/message_data, list/message_mods)
	if(!message_data["message"])
		return
	if(message_mods[MODE_FORCE_SAY_SUFFIX_ONLY])
		message_data["tts_message"] = LOWER_TEXT(message_data["tts_message"])
		return
	if(!(MODE_FORCE_SAY_SUFFIX in message_mods))
		return
	var/suffix = message_mods[MODE_FORCE_SAY_SUFFIX]
	if(!suffix)
		message_data["message"] = "[message_data["message"]]..."
		message_data["tts_message"] = "[message_data["tts_message"]]..."
		return
	message_data["message"] = "[message_data["message"]]-[suffix]"
	message_data["tts_message"] = "[message_data["tts_message"]]... [LOWER_TEXT(suffix)]"

#undef MODE_FORCE_SAY_SUFFIX
#undef MODE_FORCE_SAY_SUFFIX_ONLY
#undef LONG_TEXT_LENGTH
#undef LONG_TEXT_MINIMUM_KEPT
