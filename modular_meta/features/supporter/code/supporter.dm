GLOBAL_ALIST_INIT(supporters, alist())

/// checks whether this person is a supporter
/client/proc/issupporter(tier = 0)
	if(!SSdbcore.Connect())
		return FALSE
	var/datum/db_query/query
	if(!tier)
		query = SSdbcore.NewQuery({"
			SELECT ckey FROM [format_table_name("supporter")]
			WHERE ckey = :ckey AND permanent = TRUE
		"}, list("ckey" = ckey))
	else
		query = SSdbcore.NewQuery({"
			SELECT ckey FROM [format_table_name("supporter")]
			WHERE ckey = :ckey
				AND tier >= :tier
				AND starts_at <= UTC_TIMESTAMP()
				AND expires_at > UTC_TIMESTAMP()
		"}, list("ckey" = ckey, "tier" = tier))
	var/result = query.Execute() && query.NextRow()
	qdel(query)
	return result

/// returns a list of supportres as alist: ckey|tier
/proc/get_supporter_ckeys()
	var/list/supporters = list()
	if(!SSdbcore.Connect())
		return supporters
	var/datum/db_query/query = SSdbcore.NewQuery({"
		SELECT ckey, tier
		FROM [format_table_name("supporter")]
	"})
	if(query.Execute())
		while(query.NextRow())
			supporters[query.item[1]] = list(
			"tier" = text2num(query.item[2]),
			)
	qdel(query)
	message_admins("debug: [supporters]") // remove me
	message_admins("debug: [GLOB.supporters]") // remove me
	return supporters


/proc/supportify()
	var/list/supporters = get_supporter_ckeys()
	if(!supporters)
		return
	for(var/ckey in supporters)
		var/tier = supporters[ckey]["tier"]
		GLOB.supporters[ckey] = list(
			"tier" = tier,
		)
	message_admins("debug: [GLOB.supporters]") // remove me

// particularly no one uses sql events (may be wrong) out here, so i'm going to put it here
/// This makes a schedule runned check (every minute), checking if any boosty (or any other service) subscriptions came to an end

/*
CREATE EVENT expire_supporters
ON SCHEDULE EVERY 1 MINUTE
DO
    UPDATE supporter
    SET tier = 0,
        permanent = TRUE
    WHERE tier > 0
      AND expires_at <= UTC_TIMESTAMP();

*/

// btw, if you're someone who wanted add same tier-based supporter system for your server - main supporter table is handled
// separately from the game's code (you won't be able to find it in this repository)
