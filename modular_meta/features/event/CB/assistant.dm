
/obj/item/paper/fluff/class_d
	name = "Strange paper"

/obj/item/paper/fluff/class_d/Initialize(mapload)
	. = ..()
	var/datum/asset/simple/class_d/leaflet = get_asset_datum(/datum/asset/simple/class_d)
	var/list/urls = leaflet.get_url_mappings()
	var/url = urls["class_d_leaflet.jpg"]
	add_raw_text("<img src='[url]' style='width:100%;height:auto'>", advanced_html = TRUE)
	update_appearance()

/datum/asset/simple/class_d
	assets = list("class_d_leaflet.jpg" = 'modular_meta/features/event/CB/icons/Class-D_Orientation_Leaflet.png')

/obj/item/paper/fluff/class_d/ui_assets(mob/user)
	. = ..()
	. += get_asset_datum(/datum/asset/simple/class_d)

/datum/outfit/job/assistant/New()
	. = ..()
	if(check_holidays(CONTAINMENT_BREACH_DAY))
		uniform = /obj/item/clothing/under/rank/prisoner
		r_pocket = /obj/item/paper/fluff/class_d

/datum/outfit/job/assistant/consistent/New()
	. = ..()
	if(check_holidays(CONTAINMENT_BREACH_DAY))
		uniform = /obj/item/clothing/under/rank/prisoner
		r_pocket = /obj/item/paper/fluff/class_d

/datum/outfit/job/assistant/pre_equip(mob/living/carbon/human/target)
	if(check_holidays(CONTAINMENT_BREACH_DAY))
		uniform = /obj/item/clothing/under/rank/prisoner
