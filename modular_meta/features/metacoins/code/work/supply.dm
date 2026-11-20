GLOBAL_LIST_EMPTY(metacoin_ore_points_by_ckey)

/obj/machinery/mineral/ore_redemption/base_item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	var/points_before = points
	. = ..()
	pay_ore_delivery(user, points - points_before)

/obj/machinery/mineral/ore_redemption/pickup_item(datum/source, atom/movable/target, atom/old_loc)
	var/points_before = points
	var/mob/living/deliverer = find_ore_deliverer(target, old_loc)
	. = ..()
	if(isliving(deliverer))
		pay_ore_delivery(deliverer, points - points_before)

/// Whoever pulled, dropped or threw the ore onto the input, or dragged in the crate it spilled from. Conveyors and lone boxes have no deliverer
/obj/machinery/mineral/ore_redemption/proc/find_ore_deliverer(atom/movable/target, atom/old_loc)
	if(target.pulledby)
		return target.pulledby
	var/atom/movable/dropped_from = old_loc
	while(ismovable(dropped_from)) // hand, satchel in hand, satchel on belt. mapload init passes TRUE here
		if(ismob(dropped_from))
			return dropped_from
		if(dropped_from.pulledby) // cache opened or ore box emptied on the input
			return dropped_from.pulledby
		dropped_from = dropped_from.loc
	if(target.throwing)
		return target.throwing.get_thrower()
	return null

/obj/machinery/mineral/ore_redemption/proc/pay_ore_delivery(mob/living/deliverer, delivered_points)
	if(delivered_points <= 0 || isnull(deliverer.mind))
		return
	var/deliverer_ckey = ckey(deliverer.mind.key)
	var/points_before = GLOB.metacoin_ore_points_by_ckey[deliverer_ckey]
	var/points_after = points_before + delivered_points
	GLOB.metacoin_ore_points_by_ckey[deliverer_ckey] = points_after
	var/points_per_coin = 500
	var/coins = FLOOR(points_after / points_per_coin, 1) - FLOOR(points_before / points_per_coin, 1)
	if(coins > 0)
		var/datum/metacoins_controller/controller = get_metacoins_controller()
		controller.award_work(deliverer.mind, coins, category = /datum/metacoin_work_category/ore, source = "ore", reason = "Ore Delivery")

/obj/machinery/computer/piratepad_control/civilian/send(check_global = FALSE, mob/user)
	var/datum/bounty/personal_bounty = get_personal_bounty()
	var/list/datum/bounty/claimable_bounties = GLOB.shared_crew_bounties.Copy()
	if(personal_bounty)
		claimable_bounties += personal_bounty
	var/list/datum/bounty/unclaimed_bounties = list()
	for(var/datum/bounty/bounty as anything in claimable_bounties)
		if(!bounty.claimed)
			unclaimed_bounties += bounty
	. = ..()
	var/datum/metacoins_controller/controller = get_metacoins_controller()
	for(var/datum/bounty/bounty as anything in unclaimed_bounties)
		if(!bounty.claimed)
			continue
		if(bounty == personal_bounty)
			controller.award_work(user.mind, amount = 10, category = /datum/metacoin_work_category/bounty, source = "personal_bounty", reason = "Bounty")
		else
			controller.award_work(user.mind, amount = 15, category = /datum/metacoin_work_category/bounty, source = "shared_bounty", reason = "Station Bounty")

/obj/machinery/computer/piratepad_control/civilian/proc/get_personal_bounty()
	if(isnull(inserted_scan_id) || isnull(inserted_scan_id.registered_account))
		return null
	return inserted_scan_id.registered_account.civilian_bounty
