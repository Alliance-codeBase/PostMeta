/*
/datum/metacoinshop/listing/preround/donut_box/on_bought(datum/metacoin_shop_controller/shop, target_ckey, mob/player_mob, client/player_client, balance_after, role_id = null)
	to_chat(player_mob, span_green("success! die!")) // no idea why's there mob/player mob in params, but it's there, it exists! and it matters!

/datum/metacoinshop/listing/preround/donut_box/bought_on_spawn(datum/metacoin_shop_controller/shop, target_ckey, mob/living/carbon/human/human_spawned, obj/item/item, client/player_client)
	to_chat(human_spawned, span_green("success!"))
	sleep(20)
	to_chat(human_spawned, span_red("die!"))
	sleep(10)
	human_spawned.gib()// DIE!


example usage of variants for prerounds:

/datum/metacoinshop/listing/preround/backpack
	id = "backpack"
	name = "Backpack"
	desc = "A backpack of your chosen style!"
	category = /datum/metacoin_category/wardrobe // every item needs a shelf now
	price = 200
	item_type = /obj/item/storage/backpack
	variant_options = list("style" = list(
		/datum/metacoinshop/listing_variant/backpack/miner,
		/datum/metacoinshop/listing_variant/backpack/security,
	))

example usage of variants for persistent

/datum/metacoinshop/listing/persistent/_blessing/persistent_grant(datum/metacoin_shop_controller/shop, target_ckey, mob/living/spawned, client/player_client)
	var/saved_variant = shop.persistent.get_variant(target_ckey, src.id)
	var/selected_id = parse_choice(saved_variant, "blessing")
	var/datum/metacoinshop/listing_variant/variant_type = get_variant_datum("blessing", selected_id)
	switch(variant_type.id)
		if("health")
			spawned.heal_overall_damage(25)
		if("wealth")
			spawned.put_in_hands(new /obj/item/stack/spacecash/c1000(spawned))

*/

/datum/metacoinshop/listing/preround/donut_box
	id = "donut_box"
	category = /datum/metacoin_category/galley
	name = "Donut Box"
	desc = "A box of donuts... what else do you expect?"
	price = 20
	item_type = /obj/item/storage/fancy/donut_box

/datum/metacoinshop/listing/preround/kvass
	id = "kvass"
	category = /datum/metacoin_category/galley
	name = "Kvass"
	desc = "A can of kvass. Liquid bread, the breakfast of champions."
	price = 15
	item_type = /obj/item/reagent_containers/cup/soda_cans/kvass

/datum/metacoinshop/listing/preround/spray_libital
	id = "spray_libital"
	category = /datum/metacoin_category/infirmary
	name = "Libital Spray"
	desc = "An medigel full of libital, mainly used to treat bruises"
	price = 50
	item_type = /obj/item/reagent_containers/medigel/libital

/datum/metacoinshop/listing/preround/spray_auri
	id = "spray_auri"
	category = /datum/metacoin_category/infirmary
	name = "Aiuri Spray"
	desc = "An medigel full of aiuri, mainly used to treat burns"
	price = 50
	item_type = /obj/item/reagent_containers/medigel/aiuri

/datum/metacoinshop/listing/preround/eva_kit
	id = "extra_vehicular"
	category = /datum/metacoin_category/workshop
	name = "Premium EVA-ready kit"
	desc = "Full-kit containing a bluespace-compressed jetpack, an oxygen tank, a suit, a helmet and a medkit! Gun included!"
	price = 300
	item_type = /obj/item/storage/box/eva_kit

/obj/item/storage/box/eva_kit
	name = "EVA kit"
	desc = "A sturdy looking box, label says \"it has everything needed for space exploration\""

/obj/item/storage/box/eva_kit/Initialize(mapload)
	. = ..()
	var/obj/item/stack/medical/suture/suture = new /obj/item/stack/medical/suture(src)
	suture.amount = 10
	var/obj/item/stack/medical/mesh/mesh = new /obj/item/stack/medical/mesh(src)
	mesh.amount = 10
	var/obj/item/stock_parts/power_store/cell/high/cell = new /obj/item/stock_parts/power_store/cell/high(src)
	cell.charge = 10000 // the fuck is a cell unit? ten thousand I guess? because after test a hundred is turned to be 0.1%
	var/obj/item/gun/energy/e_gun/mini/gun = new /obj/item/gun/energy/e_gun/mini(src)
	// the gun already made its own pin in Initialize, so swap the pin itself. a bare typepath in gun.pin jams the trigger
	qdel(gun.pin)
	var/obj/item/firing_pin/explorer/explorer_pin = new
	explorer_pin.gun_insert(new_gun = gun, starting = TRUE)
	var/obj/item/tank/jetpack/jpack = new /obj/item/tank/jetpack(src)
	//get current gas
	var/datum/gas_mixture/gas = jpack.return_air() // bitch it's literally oxygen
	gas.assert_gas(jpack.gas_type)
	// quadruple it and give it to the next jetpack
	gas.set_gas(/datum/gas/oxygen, ((24 * ONE_ATMOSPHERE) * jpack.volume / (R_IDEAL_GAS_EQUATION * T20C)))
	new /obj/item/clothing/suit/space(src)
	new /obj/item/clothing/head/helmet/space(src)
	new /obj/item/tank/internals/oxygen(src)
	new /obj/item/storage/medkit/advanced(src)
	new /obj/item/storage/belt/utility/full(src)
	new /obj/item/knife/combat/survival(src)
	new /obj/item/case_portable_recharger(src)
	new /obj/item/manual_cell_recharger(src)
	new /obj/item/stock_parts/servo/pico(src)
	new /obj/item/flashlight/seclite(src)

/*
same kit, the tg way. pick whichever reads better to you

/obj/item/storage/box/eva_kit/PopulateContents() // boxes fill themselves here, their Initialize calls it for you
	new /obj/item/stack/medical/suture(src) // ten is already the default, nothing to set
	new /obj/item/stack/medical/mesh(src, 10) // stacks take the amount right in new()
	var/obj/item/stock_parts/power_store/cell/high/cell = new /obj/item/stock_parts/power_store/cell/high(src)
	cell.charge = cell.maxcharge * 0.1 // a tenth of whatever this cell holds, no cell units to guess
	cell.update_appearance() // or the charge sprite keeps lying
	new /obj/item/gun/energy/e_gun/mini/explorer(src) // the pin rides in on a subtype, see below
	var/obj/item/tank/jetpack/jetpack = new /obj/item/tank/jetpack(src)
	var/datum/gas_mixture/jetpack_air = jetpack.return_air()
	jetpack_air.set_gas(jetpack.gas_type, jetpack_air.moles[jetpack.gas_type] * 4) // quadruple whatever it came with
	new /obj/item/clothing/suit/space(src)
	...the rest is the same new()

/obj/item/gun/energy/e_gun/mini/explorer
	pin = /obj/item/firing_pin/explorer // a typepath is fine here, the gun turns it into a real pin in its own Initialize
*/

/obj/item/storage/box/eva_kit/examine(mob/user)
	. = ..()
	. += span_notice("It has a small label taped to it that says, \"Bluespace compressed!\" ")

/obj/item/storage/box/eva_kit/examine_more(mob/user)
	. = ..()
	. += span_notice("Items seem to be rather small on the inside.. however, taking anything from the box makes it impossible to put it back in..")

/datum/metacoinshop/listing/preround/other/self_surgery
	id = "surgery"
	category = /datum/metacoin_category/neural_implants
	name = "4U70-P3R4710N skillchip"
	desc = "A skillchip containing old Nanotrasen medical training protocols, which one could use to perform surgical operations on themselves. \
	This one is new, I'd say, \"almost pristine condition.\" It will be already implanted in your brain upon purchause and your arrival."
	price = 250
	item_type = /obj/item/skillchip/self_surgery

/datum/metacoinshop/listing/preround/other/self_surgery/bought_on_spawn(datum/metacoin_shop_controller/shop, target_ckey, mob/living/carbon/human/human_spawned, obj/item/item, client/player_client)
	var/obj/item/skillchip/skillchip = new item_type()
	human_spawned.implant_skillchip(skillchip)
	skillchip.try_activate_skillchip()
	playsound(human_spawned, 'sound/items/weapons/circsawhit.ogg', 100)
	to_chat(human_spawned, span_notice("You've been implanted with [skillchip.name]"))

/obj/item/storage/box/metacoin_kit
	abstract_type = /obj/item/storage/box/metacoin_kit
	var/list/kit_contents

/obj/item/storage/box/metacoin_kit/PopulateContents()
	generate_items_inside(kit_contents, src)

/datum/metacoinshop/listing/preround/donk_pockets
	id = "donk_pockets"
	category = /datum/metacoin_category/galley
	name = "Donk Pockets"
	desc = "A box of donk pockets in the flavor of your choice."
	price = 20
	// example of variants: one listing, many items. players pick one right in the shop window
	// "flavor" is the label shown above the buttons, the first variant in the list is the default
	// no item_type on the listing itself, it is taken from whatever variant got picked
	variant_options = list("flavor" = list(
		/datum/metacoinshop/listing_variant/donk_pockets/classic,
		/datum/metacoinshop/listing_variant/donk_pockets/spicy,
		/datum/metacoinshop/listing_variant/donk_pockets/teriyaki,
		/datum/metacoinshop/listing_variant/donk_pockets/pizza,
		/datum/metacoinshop/listing_variant/donk_pockets/berry,
//		/datum/metacoinshop/listing_variant/donk_pockets/honk,
	))

/datum/metacoinshop/listing_variant/donk_pockets/classic
	id = "classic" // auto-buy remembers this id in player prefs, rename it and everyone's saved pick is gone
	name = "Classic" // what the button says
	item_type = /obj/item/storage/box/donkpockets // what actually lands in your hands

/datum/metacoinshop/listing_variant/donk_pockets/spicy
	id = "spicy"
	name = "Spicy"
	item_type = /obj/item/storage/box/donkpockets/donkpocketspicy

/datum/metacoinshop/listing_variant/donk_pockets/teriyaki
	id = "teriyaki"
	name = "Teriyaki"
	item_type = /obj/item/storage/box/donkpockets/donkpocketteriyaki

/datum/metacoinshop/listing_variant/donk_pockets/pizza
	id = "pizza"
	name = "Pizza"
	item_type = /obj/item/storage/box/donkpockets/donkpocketpizza

/datum/metacoinshop/listing_variant/donk_pockets/berry
	id = "berry"
	name = "Berry"
	item_type = /obj/item/storage/box/donkpockets/donkpocketberry

/datum/metacoinshop/listing_variant/donk_pockets/honk
	id = "honk"
	name = "Honk"
	item_type = /obj/item/storage/box/donkpockets/donkpockethonk

/datum/metacoinshop/listing/preround/liquor
	id = "liquor"
	category = /datum/metacoin_category/galley
	name = "Bottle of Liquor"
	desc = "A full bottle of alcohol of your choice."
	price = 20
	variant_options = list("drink" = list(
		/datum/metacoinshop/listing_variant/liquor/whiskey,
		/datum/metacoinshop/listing_variant/liquor/wine,
		/datum/metacoinshop/listing_variant/liquor/vodka,
		/datum/metacoinshop/listing_variant/liquor/rum,
		/datum/metacoinshop/listing_variant/liquor/tequila,
		/datum/metacoinshop/listing_variant/liquor/champagne,
		/datum/metacoinshop/listing_variant/liquor/gin,
		/datum/metacoinshop/listing_variant/liquor/absinthe,
		/datum/metacoinshop/listing_variant/liquor/patron,
		/datum/metacoinshop/listing_variant/liquor/goldschlager,
		/datum/metacoinshop/listing_variant/liquor/ale,
		/datum/metacoinshop/listing_variant/liquor/kumiss,
	))

/datum/metacoinshop/listing_variant/liquor/whiskey
	id = "whiskey"
	name = "Whiskey"
	item_type = /obj/item/reagent_containers/cup/glass/bottle/whiskey

/datum/metacoinshop/listing_variant/liquor/wine
	id = "wine"
	name = "Wine"
	item_type = /obj/item/reagent_containers/cup/glass/bottle/wine

/datum/metacoinshop/listing_variant/liquor/vodka
	id = "vodka"
	name = "Vodka"
	item_type = /obj/item/reagent_containers/cup/glass/bottle/vodka

/datum/metacoinshop/listing_variant/liquor/rum
	id = "rum"
	name = "Rum"
	item_type = /obj/item/reagent_containers/cup/glass/bottle/rum

/datum/metacoinshop/listing_variant/liquor/tequila
	id = "tequila"
	name = "Tequila"
	item_type = /obj/item/reagent_containers/cup/glass/bottle/tequila

/datum/metacoinshop/listing_variant/liquor/champagne
	id = "champagne"
	name = "Champagne"
	item_type = /obj/item/reagent_containers/cup/glass/bottle/champagne

/datum/metacoinshop/listing_variant/liquor/gin
	id = "gin"
	name = "Gin"
	item_type = /obj/item/reagent_containers/cup/glass/bottle/gin

/datum/metacoinshop/listing_variant/liquor/absinthe
	id = "absinthe"
	name = "Absinthe"
	item_type = /obj/item/reagent_containers/cup/glass/bottle/absinthe

/datum/metacoinshop/listing_variant/liquor/patron
	id = "patron"
	name = "Patron"
	item_type = /obj/item/reagent_containers/cup/glass/bottle/patron

/datum/metacoinshop/listing_variant/liquor/goldschlager
	id = "goldschlager"
	name = "Goldschlager"
	item_type = /obj/item/reagent_containers/cup/glass/bottle/goldschlager

/datum/metacoinshop/listing_variant/liquor/ale
	id = "ale"
	name = "Ale"
	item_type = /obj/item/reagent_containers/cup/glass/bottle/ale

/datum/metacoinshop/listing_variant/liquor/kumiss
	id = "kumiss"
	name = "Kumiss"
	item_type = /obj/item/reagent_containers/cup/glass/bottle/kumiss

/datum/metacoinshop/listing/preround/balloons
	id = "balloons"
	category = /datum/metacoin_category/recreation_room
	name = "Box of Balloons"
	desc = "A box of balloons."
	price = 20
	item_type = /obj/item/storage/box/balloons

/datum/metacoinshop/listing/preround/cream_pie
	id = "cream_pie"
	category = /datum/metacoin_category/recreation_room
	name = "Cream Pie"
	desc = "A cream pie, best served to the face."
	price = 200
	item_type = /obj/item/food/pie/cream

/datum/metacoinshop/listing/preround/soap
	id = "soap"
	category = /datum/metacoin_category/wardrobe
	name = "Soap"
	desc = "A bar of soap."
	price = 10
	variant_options = list("brand" = list(
		/datum/metacoinshop/listing_variant/soap/plain,
		/datum/metacoinshop/listing_variant/soap/homemade,
		/datum/metacoinshop/listing_variant/soap/nanotrasen,
		/datum/metacoinshop/listing_variant/soap/deluxe,
	))

/datum/metacoinshop/listing_variant/soap/plain
	id = "plain"
	name = "Plain"
	item_type = /obj/item/soap

/datum/metacoinshop/listing_variant/soap/homemade
	id = "homemade"
	name = "Homemade"
	item_type = /obj/item/soap/homemade

/datum/metacoinshop/listing_variant/soap/nanotrasen
	id = "nanotrasen"
	name = "Nanotrasen"
	item_type = /obj/item/soap/nanotrasen

/datum/metacoinshop/listing_variant/soap/deluxe
	id = "deluxe"
	name = "Deluxe"
	item_type = /obj/item/soap/deluxe

// /datum/metacoinshop/listing/preround/fireworks
// 	id = "fireworks"
// 	category = /datum/metacoin_category/recreation_room
// 	name = "Box of Fireworks"
// 	desc = "Three sparklers, three firecrackers and a snap pop."
// 	price = 30
// 	item_type = /obj/item/storage/box/fireworks

/datum/metacoinshop/listing/preround/cannabis
	id = "cannabis"
	category = /datum/metacoin_category/galley
	name = "Cannabis Cigarettes"
	desc = "A pack of cannabis cigarettes."
	price = 25
	item_type = /obj/item/storage/fancy/cigarettes/cigpack_cannabis

/datum/metacoinshop/listing/preround/toolbelt
	id = "toolbelt"
	category = /datum/metacoin_category/workshop
	name = "Toolbelt"
	desc = "An empty toolbelt."
	price = 40
	item_type = /obj/item/storage/belt/utility

/datum/metacoinshop/listing/preround/megaphone
	id = "megaphone"
	category = /datum/metacoin_category/wardrobe
	name = "Megaphone"
	desc = "A megaphone."
	price = 30
	item_type = /obj/item/megaphone

/datum/metacoinshop/listing/preround/cash
	id = "cash"
	category = /datum/metacoin_category/command_picks
	name = "1000 Credits"
	desc = "A stack of cash worth 1000 credits."
	price = 100
	item_type = /obj/item/stack/spacecash/c1000

/datum/metacoinshop/listing/preround/pai_card
	id = "pai_card"
	category = /datum/metacoin_category/wardrobe
	name = "pAI Card"
	desc = "A personal AI device."
	price = 30
	item_type = /obj/item/pai_card

/datum/metacoinshop/listing/preround/baseball_bat
	id = "baseball_bat"
	category = /datum/metacoin_category/armory
	name = "Baseball Bat"
	desc = "A wooden baseball bat."
	price = 100
	item_type = /obj/item/melee/baseball_bat

/datum/metacoinshop/listing/preround/toolbelt_full
	id = "toolbelt_full"
	category = /datum/metacoin_category/workshop
	name = "Full Toolbelt"
	desc = "A toolbelt with a full set of tools."
	price = 80
	item_type = /obj/item/storage/belt/utility/full

/datum/metacoinshop/listing/preround/skateboard
	id = "skateboard"
	category = /datum/metacoin_category/garage
	name = "Skateboard"
	desc = "A skateboard."
	price = 30
	item_type = /obj/item/melee/skateboard

// /datum/metacoinshop/listing/preround/sunglasses
// 	id = "sunglasses"
// 	category = /datum/metacoin_category/workshop
// 	name = "Sunglasses"
// 	desc = "Sunglasses that protect the eyes from flashes."
// 	price = 150
// 	variant_options = list("style" = list(
// 		/datum/metacoinshop/listing_variant/sunglasses/classic,
// 		/datum/metacoinshop/listing_variant/sunglasses/big,
// 		/datum/metacoinshop/listing_variant/sunglasses/gar,
// 	))

// /datum/metacoinshop/listing_variant/sunglasses/classic
// 	id = "classic"
// 	name = "Classic"
// 	item_type = /obj/item/clothing/glasses/sunglasses

// /datum/metacoinshop/listing_variant/sunglasses/big
// 	id = "big"
// 	name = "Big"
// 	item_type = /obj/item/clothing/glasses/sunglasses/big

// /datum/metacoinshop/listing_variant/sunglasses/gar
// 	id = "gar"
// 	name = "Gar"
// 	item_type = /obj/item/clothing/glasses/sunglasses/gar

/datum/metacoinshop/listing/preround/insulated_gloves
	id = "insulated_gloves"
	category = /datum/metacoin_category/workshop
	name = "Insulated Gloves"
	desc = "A pair of insulated gloves."
	price = 250
	item_type = /obj/item/clothing/gloves/color/yellow
