#define LONG_TEXT_LENGTH 50
#define LONG_TEXT_MINIMUM_KEPT 40

/datum/tgui_say
	/// Hurt suffixes for Russian speech.
	var/static/list/russian_hurt_phrases = list("ой!", "ох!", "ах!", "ай!", "ух!", "уф!", "оу!")

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
			INVOKE_ASYNC(speaker, TYPE_PROC_REF(/atom/movable, say), cry)
		return
	var/message_modifiers = copytext_char(entry, 1, length_char(entry) - length_char(body) + 1)
	var/cut_body = cut_off(body)
	var/radio_key = channel == RADIO_CHANNEL ? RADIO_KEY_COMMON : ""
	var/suffix = LOWER_TEXT(pick(alter_phrases || hurt_phrases_for(cut_body)))
	var/interruption = suffix ? "... [suffix]" : "..."
	INVOKE_ASYNC(speaker, TYPE_PROC_REF(/atom/movable, say), "[radio_key][message_modifiers][cut_body][interruption]")

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

#undef LONG_TEXT_LENGTH
#undef LONG_TEXT_MINIMUM_KEPT
