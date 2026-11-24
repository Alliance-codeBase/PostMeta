/obj/item/mod/control/pre_equipped/medical/secmed
	theme = /datum/mod_theme/medical
	applied_modules = list(
		/obj/item/mod/module/storage,
		/obj/item/mod/module/flashlight,
		/obj/item/mod/module/health_analyzer,
		/obj/item/mod/module/quick_carry,
	//	/obj/item/mod/module/rescue_hook,
	)


/datum/mod_theme/secmed
	name = "secmed"
	desc = "A lightweight suit by DeForest Medical Corporation, allows for easier movement."
	extended_desc = "A originally lightweight suit produced by the DeForest Medical Corporation, based off the work of \
		Nakamura Engineering. Previois version was suited for civillian usage only, \
		providing basic protection from pathogens, toxic-gasses, acid, and no ballistic protection whatsoever. \
		This version was heavily-modified, once-again, by DeForest Medical. During a design competition several engineering teams submitted prototypes, leaving this prototype in surplus. \
		The winning design entered production as the Rescue MOD-suit, nowadays used by Nanotrasen Emergency Response Teams. \
		This one features much more resillient front-plate. It provides great protection any types of damage user might encounter, especially bio-weaponry, laser and ballistic weaponry \
		Nanotrasen rarely issues a full combat medic suite to its Spinward outposts, however it found it's usage when APSD <i> also known as DAP </i> agents were tasked to transfer or watch high value prisoners on Nanotrasen space stations, \
		due to station policies DAP's beloved MK II SWAT-suits and <b> especially ballistic weaponry </b> were disallowed even for security personnel. \
		That's when the surplus MODsuits came in handy. As per the internal competition, although having excellent features and meeting most of the specification for an unknown reason it was rejected, even though \
		many users of this prototype especially <b> liked the rescue hook module that allowed seamless rescue operations of injured personell during combat operations, \
		allowing user to \"fish-out\" a person from a distant or a dangerous location </b>"
	default_skin = "medical"
	armor_type = /datum/armor/mod_theme_medical
	charge_drain = DEFAULT_CHARGE_DRAIN * 1.5
	slowdown_deployed = 0.5
	allowed_suit_storage = list(
		/obj/item/crowbar/power/paramedic,
		/obj/item/defibrillator/compact,
		/obj/item/healthanalyzer,
		/obj/item/reagent_containers/applicator,
		/obj/item/reagent_containers/cup/beaker,
		/obj/item/reagent_containers/cup/bottle,
		/obj/item/reagent_containers/cup/tube,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/hypospray,
		/obj/item/reagent_containers/syringe,
		/obj/item/sensor_device,
		/obj/item/stack/medical,
		/obj/item/storage/bag/bio,
		/obj/item/storage/bag/chemistry,
		/obj/item/storage/pill_bottle,
	)
