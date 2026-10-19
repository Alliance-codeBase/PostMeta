/mob/proc/is_explosives_banned()
	if(isnull(client) || isnull(client.ban_cache))
		return FALSE
	var/ban_role = is_antag() ? BAN_ANTAG_EXPLOSIVES : BAN_NON_ANTAG_EXPLOSIVES
	return ban_role in client.ban_cache

/mob/proc/refuse_explosives()
	if(!is_explosives_banned())
		return FALSE
	balloon_alert(src, "you don't want to do this")
	return TRUE

/atom/movable/proc/is_explosive()
	return FALSE

/proc/is_inside_explosive(atom/movable/thing)
	for(var/atom/movable/container = thing.loc, ismovable(container), container = container.loc)
		if(container.is_explosive())
			return TRUE
	return FALSE
