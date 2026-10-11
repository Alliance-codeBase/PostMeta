#define SEMYA_KRASNOVY "krasnovy"
#define FAMILY_GIOVANI "giovani"
#define FAMILY_KONICHIWA "konichiwa"
#define FAMILY_GOLDSHTEIN "goldshtein"

/datum/antagonist/mafia
	name = "\improper Mafia"
	show_in_antagpanel = TRUE
	roundend_category = "mafia"
	antagpanel_category = "Mafia"
	pref_flag = ROLE_MAFIA
	antag_hud_name = "mafia"
	show_name_in_check_antagonists = TRUE
	hijack_speed = 0.5
	hud_icon = 'modular_meta/features/antagonists/icons/bloodsuckers/bloodsucker_icons.dmi'
	ui_name = "AntagInfoBloodsucker"
	can_assign_self_objectives = FALSE
	preview_outfit = /datum/outfit/bloodsucker_outfit

	// БЛЯ ПРОСТО СКОПИРОВАНО С ГЛАМУРА ДЕМОНА ГРЕХА И СОСАТЕЛЯ КРОВИ БРУХА
	// ЭТО ПЕРЕМЕННАЯ ГДЕ КОРОЧЕ КУДА НАЗНАЧЕН МАФИОЗНИК КАКАЯ СЕМЬЯ
	var/gang

	// ЭТО СПИСОК СЕМЕЙ, ВЫДАЁТСЯ ПРИ ЕСТЕСТВЕННОМ ЯВЛЕНИЕ В МИР ОПГШНИКА
	var/static/list/gang = list(SEMYA_KRASNOVY, FAMILY_GIOVANI, FAMILY_KONICHIWA, FAMILY_GOLDSHTEIN)

/datum/antagonist/mafia/New()
	. = ..()
	gang = pick(gang)

/datum/antagonist/mafia/forge_objectives()
	var/datum/objective/mafia/objct

/datum/antagonist/mafia/greet()
	to_chat(owner.current, span_warning("<b>You are member of organised criminal group. You are a part of [gang], who find their way to this deep-space station.</b>"))

/datum/antagonist/mafia/on_gain()
	forge_objectives()
	owner.current.add_faction("mafia")

/datum/antagonist/mafia/on_removal()
	owner.current.add_faction("mafia")

#undef SEMYA_KRASNOVY
#undef FAMILY_GIOVANI
#undef FAMILY_KONICHIWA
#undef FAMILY_GOLDSHTEIN

/datum/antagonist/mafia/get_preview_icon()
	var/datum/universal_icon/mafia_icon = uni_icon('modular_meta/features/antagonists/icons/sinful_demon/passport_photo.dmi', "sinfuldemon")

	mafia_icon.scale(ANTAGONIST_PREVIEW_ICON_SIZE, ANTAGONIST_PREVIEW_ICON_SIZE)

	return mafia_icon
