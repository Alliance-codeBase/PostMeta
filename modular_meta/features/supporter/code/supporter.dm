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
