/datum/metacoinshop/listing/preround/assault_belt
	id = "assault_belt"
	category = /datum/metacoin_category/workshop
	name = "Assault Belt"
	desc = "A roomy military belt."
	price = 50
	item_type = /obj/item/storage/belt/military/assault

/datum/metacoinshop/listing/preround/medical_hud
	id = "medical_hud"
	category = /datum/metacoin_category/infirmary
	name = "Medical HUD"
	desc = "See everyone's health at a glance."
	price = 60
	item_type = /obj/item/clothing/glasses/hud/health

/datum/metacoinshop/listing/preround/multitool
	id = "multitool"
	category = /datum/metacoin_category/workshop
	name = "Multitool"
	desc = "The tool every maintenance crawler is looking for."
	price = 60
	item_type = /obj/item/multitool

/datum/metacoinshop/listing/preround/mod_paint
	id = "mod_paint"
	category = /datum/metacoin_category/research_surplus
	name = "MOD Paint Kit"
	desc = "Recolor and reskin a MODsuit."
	price = 15
	item_type = /obj/item/mod/paint

/datum/metacoinshop/listing/preround/mod_module
	id = "mod_module"
	category = /datum/metacoin_category/research_surplus
	name = "Cosmetic MOD Module"
	desc = "A fun MODsuit module of your choice."
	price = 20
	variant_options = list("module" = list(
		/datum/metacoinshop/listing_variant/mod_module/hat_stabilizer,
		/datum/metacoinshop/listing_variant/mod_module/rave_visor,
		/datum/metacoinshop/listing_variant/mod_module/tanner,
		/datum/metacoinshop/listing_variant/mod_module/balloon,
		/datum/metacoinshop/listing_variant/mod_module/perfumer,
		/datum/metacoinshop/listing_variant/mod_module/atrocinator,
	))

/datum/metacoinshop/listing_variant/mod_module/hat_stabilizer
	id = "hat_stabilizer"
	name = "Hat Stabilizer"
	item_type = /obj/item/mod/module/hat_stabilizer

/datum/metacoinshop/listing_variant/mod_module/rave_visor
	id = "rave_visor"
	name = "Rave Visor"
	item_type = /obj/item/mod/module/visor/rave

/datum/metacoinshop/listing_variant/mod_module/tanner
	id = "tanner"
	name = "Tanner"
	item_type = /obj/item/mod/module/tanner

/datum/metacoinshop/listing_variant/mod_module/balloon
	id = "balloon"
	name = "Balloon Blower"
	item_type = /obj/item/mod/module/balloon

/datum/metacoinshop/listing_variant/mod_module/perfumer
	id = "perfumer"
	name = "Perfumer"
	item_type = /obj/item/mod/module/selfcleaner

/datum/metacoinshop/listing_variant/mod_module/atrocinator
	id = "atrocinator"
	name = "Atrocinator"
	item_type = /obj/item/mod/module/atrocinator

/datum/metacoinshop/listing/preround/civilian_mod
	id = "civilian_mod"
	category = /datum/metacoin_category/research_surplus
	name = "Civilian MODsuit"
	desc = "A light civilian MODsuit with storage, welding protection and a flashlight. Not spaceproof."
	price = 120
	item_type = /obj/item/mod/control/pre_equipped/civilian

/datum/metacoinshop/listing/preround/portable_suit
	id = "portable_suit"
	category = /datum/metacoin_category/wardrobe
	name = "Portable Suit"
	desc = "A three-piece MOD suit worn on the neck, made for negotiations. Keeps you clean, prints paper and stamps it. No armor, not spaceproof."
	price = 60
	item_type = /obj/item/mod/control/pre_equipped/portable_suit

// /datum/metacoinshop/listing/preround/raw_anomaly_core
// 	id = "raw_anomaly_core"
// 	category = /datum/metacoin_category/research_surplus
// 	name = "Raw Anomaly Core"
// 	desc = "An unrefined anomaly core. Science still has to implode it to make it work."
// 	price = 150
// 	variant_options = list("core" = list(
// 		/datum/metacoinshop/listing_variant/raw_anomaly_core/gravitational,
// 		/datum/metacoinshop/listing_variant/raw_anomaly_core/flux,
// 		/datum/metacoinshop/listing_variant/raw_anomaly_core/bluespace,
// 		/datum/metacoinshop/listing_variant/raw_anomaly_core/vortex,
// 		/datum/metacoinshop/listing_variant/raw_anomaly_core/pyro,
// 		/datum/metacoinshop/listing_variant/raw_anomaly_core/hallucination,
// 		/datum/metacoinshop/listing_variant/raw_anomaly_core/bioscrambler,
// 		/datum/metacoinshop/listing_variant/raw_anomaly_core/dimensional,
// 		/datum/metacoinshop/listing_variant/raw_anomaly_core/ectoplasm,
// 		/datum/metacoinshop/listing_variant/raw_anomaly_core/weather,
// 	))

// /datum/metacoinshop/listing_variant/raw_anomaly_core/gravitational
// 	id = "gravitational"
// 	name = "Gravitational"
// 	item_type = /obj/item/raw_anomaly_core/grav

// /datum/metacoinshop/listing_variant/raw_anomaly_core/flux
// 	id = "flux"
// 	name = "Flux"
// 	item_type = /obj/item/raw_anomaly_core/flux

// /datum/metacoinshop/listing_variant/raw_anomaly_core/bluespace
// 	id = "bluespace"
// 	name = "Bluespace"
// 	item_type = /obj/item/raw_anomaly_core/bluespace

// /datum/metacoinshop/listing_variant/raw_anomaly_core/vortex
// 	id = "vortex"
// 	name = "Vortex"
// 	item_type = /obj/item/raw_anomaly_core/vortex

// /datum/metacoinshop/listing_variant/raw_anomaly_core/pyro
// 	id = "pyro"
// 	name = "Pyro"
// 	item_type = /obj/item/raw_anomaly_core/pyro

// /datum/metacoinshop/listing_variant/raw_anomaly_core/hallucination
// 	id = "hallucination"
// 	name = "Hallucination"
// 	item_type = /obj/item/raw_anomaly_core/hallucination

// /datum/metacoinshop/listing_variant/raw_anomaly_core/bioscrambler
// 	id = "bioscrambler"
// 	name = "Bioscrambler"
// 	item_type = /obj/item/raw_anomaly_core/bioscrambler

// /datum/metacoinshop/listing_variant/raw_anomaly_core/dimensional
// 	id = "dimensional"
// 	name = "Dimensional"
// 	item_type = /obj/item/raw_anomaly_core/dimensional

// /datum/metacoinshop/listing_variant/raw_anomaly_core/ectoplasm
// 	id = "ectoplasm"
// 	name = "Ectoplasm"
// 	item_type = /obj/item/raw_anomaly_core/ectoplasm

// /datum/metacoinshop/listing_variant/raw_anomaly_core/weather
// 	id = "weather"
// 	name = "Weather"
// 	item_type = /obj/item/raw_anomaly_core/weather

// /datum/metacoinshop/listing/preround/anomaly_core
// 	id = "anomaly_core"
// 	category = /datum/metacoin_category/research_surplus
// 	name = "Anomaly Core"
// 	desc = "A refined anomaly core, ready for reactive armor. It counts towards the station's core limit and is refunded if the limit is already reached."
// 	price = 300
// 	variant_options = list("core" = list(
// 		/datum/metacoinshop/listing_variant/anomaly_core/gravitational,
// 		/datum/metacoinshop/listing_variant/anomaly_core/hallucination,
// 		/datum/metacoinshop/listing_variant/anomaly_core/ectoplasm,
// 	))

// /datum/metacoinshop/listing/preround/anomaly_core/deliver(datum/metacoin_shop_controller/shop, target_ckey, mob/living/carbon/human/human_spawned, client/player_client)
// 	var/core_type = get_chosen_typepath(shop, target_ckey)
// 	if(!SSresearch.is_core_available(core_type))
// 		shop.refund_and_notify(target_ckey, price, "[name] could not be delivered, the station has reached its limit of these cores.", human_spawned)
// 		return
// 	SSresearch.increment_existing_anomaly_cores(core_type)
// 	return ..()

// /datum/metacoinshop/listing_variant/anomaly_core/gravitational
// 	id = "gravitational"
// 	name = "Gravitational"
// 	item_type = /obj/item/assembly/signaler/anomaly/grav

// /datum/metacoinshop/listing_variant/anomaly_core/hallucination
// 	id = "hallucination"
// 	name = "Hallucination"
// 	item_type = /obj/item/assembly/signaler/anomaly/hallucination

// /datum/metacoinshop/listing_variant/anomaly_core/ectoplasm
// 	id = "ectoplasm"
// 	name = "Ectoplasm"
// 	item_type = /obj/item/assembly/signaler/anomaly/ectoplasm

/datum/metacoinshop/listing/preround/lead_pipe
	id = "lead_pipe"
	category = /datum/metacoin_category/armory
	name = "Lead Pipe"
	desc = "A heavy lead pipe. Classic."
	price = 60
	item_type = /obj/item/lead_pipe

/datum/metacoinshop/listing/preround/pumpup
	id = "pumpup"
	category = /datum/metacoin_category/infirmary
	name = "Pump-Up Medipen"
	desc = "Shake off stuns and get back in the fight."
	price = 60
	item_type = /obj/item/reagent_containers/hypospray/medipen/pumpup

/datum/metacoinshop/listing/preround/spear
	id = "spear"
	category = /datum/metacoin_category/armory
	name = "Spear"
	desc = "A two-handed spear with reach."
	price = 80
	item_type = /obj/item/spear

/datum/metacoinshop/listing/preround/bola_kit
	id = "bola_kit"
	category = /datum/metacoin_category/armory
	name = "Bola and Cable Cuffs"
	desc = "Trip them, then tie them up."
	price = 80
	item_type = /obj/item/storage/box/metacoin_kit/bola

/obj/item/storage/box/metacoin_kit/bola
	name = "restraint kit"
	kit_contents = list(
		/obj/item/restraints/legcuffs/bola = 1,
		/obj/item/restraints/handcuffs/cable = 1,
	)

/datum/metacoinshop/listing/preround/spess_knife
	id = "spess_knife"
	category = /datum/metacoin_category/workshop
	name = "Spess Knife"
	desc = "A knife, a screwdriver and wirecutters in one. Usually picks the right one."
	price = 80
	item_type = /obj/item/spess_knife

/datum/metacoinshop/listing/preround/buckler
	id = "buckler"
	category = /datum/metacoin_category/armory
	name = "Buckler"
	desc = "A small wooden shield that blocks attacks."
	price = 100
	item_type = /obj/item/shield/buckler

/datum/metacoinshop/listing/preround/old_armor
	id = "old_armor"
	category = /datum/metacoin_category/armory
	name = "Worn Security Armor"
	desc = "An old security helmet and vest. Seen better days."
	price = 120
	item_type = /obj/item/storage/box/metacoin_kit/old_armor

/obj/item/storage/box/metacoin_kit/old_armor
	name = "armor box"
	kit_contents = list(
		/obj/item/clothing/head/helmet/old = 1,
		/obj/item/clothing/suit/armor/vest/old = 1,
	)

// /datum/metacoinshop/listing/preround/telescopic_baton
// 	id = "telescopic_baton"
// 	category = /datum/metacoin_category/armory
// 	name = "Telescopic Baton"
// 	desc = "A collapsible baton that knocks people down."
// 	price = 200
// 	item_type = /obj/item/melee/baton/telescopic

// /datum/metacoinshop/listing/preround/sword
// 	id = "sword"
// 	category = /datum/metacoin_category/armory
// 	name = "Sword"
// 	desc = "A real blade of your choice."
// 	price = 1000
// 	variant_options = list("blade" = list(
// 		/datum/metacoinshop/listing_variant/sword/katana,
// 		/datum/metacoinshop/listing_variant/sword/claymore,
// 	))

// /datum/metacoinshop/listing_variant/sword/katana
// 	id = "katana"
// 	name = "Katana"
// 	item_type = /obj/item/katana

// /datum/metacoinshop/listing_variant/sword/claymore
// 	id = "claymore"
// 	name = "Claymore"
// 	item_type = /obj/item/claymore

// /datum/metacoinshop/listing/preround/speed_jackboots
// 	id = "speed_jackboots"
// 	category = /datum/metacoin_category/garage
// 	name = "Speed Jackboots"
// 	desc = "Run three times faster than anyone else."
// 	price = 1200
// 	item_type = /obj/item/clothing/shoes/jackboots/fast

/datum/metacoinshop/listing/preround/neptune_drone
	id = "neptune_drone"
	category = /datum/metacoin_category/garage
	name = "CULD Neptune-B Drone"
	desc = "A foldable remote-controlled scout drone with its controller. Opens public airlocks on its own."
	price = 650
	item_type = /obj/item/storage/box/metacoin_kit/neptune_drone

/obj/item/storage/box/metacoin_kit/neptune_drone
	name = "Neptune-B drone kit"
	kit_contents = list(
		/obj/item/deployable_vehicle = 1,
		/obj/item/unmanned_vehicle_remote = 1,
	)

/datum/metacoinshop/listing/preround/pluto_drone
	id = "pluto_drone"
	category = /datum/metacoin_category/garage
	name = "CULD-T Pluto Drone"
	desc = "A tiny remote-controlled drone with its controller. Fast, quiet and easy to step over. Removed from public sale for a reason."
	price = 400
	item_type = /obj/item/storage/box/metacoin_kit/pluto_drone

/obj/item/storage/box/metacoin_kit/pluto_drone
	name = "Pluto drone kit"
	kit_contents = list(
		/obj/item/deployable_vehicle/tiny = 1,
		/obj/item/unmanned_vehicle_remote = 1,
	)

// /datum/metacoinshop/listing/preround/mythril
// 	id = "mythril"
// 	category = /datum/metacoin_category/workshop
// 	name = "Mythril Sheets"
// 	desc = "Five sheets of a material that should not exist."
// 	price = 600
// 	item_type = /obj/item/stack/sheet/mineral/mythril/five

// /datum/metacoinshop/listing/preround/backstab_switchblade
// 	id = "backstab_switchblade"
// 	category = /datum/metacoin_category/armory
// 	name = "Backstab Switchblade"
// 	desc = "A switchblade that hits much harder when you stab someone from behind."
// 	price = 400
// 	item_type = /obj/item/switchblade/backstab/nt
