/datum/metacoin_category
	var/name
	var/icon
	var/tab_order

/datum/metacoin_category/command_picks
	name = "Command Picks"
	icon = FA_ICON_STAR
	tab_order = 1

/datum/metacoin_category/galley
	name = "Galley"
	icon = FA_ICON_UTENSILS
	tab_order = 2

/datum/metacoin_category/recreation_room
	name = "Rec Room"
	icon = FA_ICON_GAMEPAD
	tab_order = 3

/datum/metacoin_category/wardrobe
	name = "Wardrobe"
	icon = FA_ICON_USER_TIE
	tab_order = 4

/datum/metacoin_category/garage
	name = "Garage"
	icon = FA_ICON_PERSON_SKATING
	tab_order = 5

/datum/metacoin_category/workshop
	name = "Workshop"
	icon = FA_ICON_TOOLBOX
	tab_order = 6

/datum/metacoin_category/infirmary
	name = "Infirmary"
	icon = FA_ICON_KIT_MEDICAL
	tab_order = 7

/datum/metacoin_category/research_surplus
	name = "R&D Surplus"
	icon = FA_ICON_FLASK
	tab_order = 8

/datum/metacoin_category/armory
	name = "Armory"
	icon = FA_ICON_SHIELD_HALVED
	tab_order = 9

/datum/metacoin_category/gunsmiths_bench
	name = "Gunsmith's Bench"
	icon = FA_ICON_GUN
	tab_order = 10

/datum/metacoin_category/neural_implants
	name = "Neural Implants"
	icon = FA_ICON_MICROCHIP
	tab_order = 11

/proc/cmp_metacoin_categories(datum/metacoin_category/first, datum/metacoin_category/second)
	return cmp_numeric_asc(initial(first.tab_order), initial(second.tab_order))
