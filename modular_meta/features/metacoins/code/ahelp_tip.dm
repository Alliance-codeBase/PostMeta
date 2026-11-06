/datum/admin_help/Close(key_name = key_name_admin(usr), silent = FALSE)
	var/was_active = state == AHELP_ACTIVE
	. = ..()
	if(was_active)
		offer_admin_tip()

/datum/admin_help/Resolve(key_name = key_name_admin(usr), silent = FALSE)
	var/was_active = state == AHELP_ACTIVE
	. = ..()
	if(was_active)
		offer_admin_tip()

/// Offers the player a tip link for the admin who ended the ticket, whatever button they pressed.
/datum/admin_help/proc/offer_admin_tip()
	if(isnull(initiator) || isnull(usr) || !GLOB.admin_datums[usr.ckey] || usr.ckey == initiator_ckey)
		return
	to_chat(initiator, span_notice("Happy with how your admin handled it? [GLOB.metacoin_tips.get_ahelp_link(usr.ckey)]"), confidential = TRUE)
