/datum/metacoinshop/listing/preround/rifle_stock
	id = "rifle_stock"
	category = /datum/metacoin_category/gunsmiths_bench
	name = "Rifle Stock"
	desc = "A wooden stock for improvised guns."
	price = 100
	item_type = /obj/item/weaponcrafting/stock

/datum/metacoinshop/listing/preround/modular_receiver
	id = "modular_receiver"
	category = /datum/metacoin_category/gunsmiths_bench
	name = "Modular Receiver"
	desc = "A receiver and trigger assembly for improvised guns."
	price = 150
	item_type = /obj/item/weaponcrafting/receiver

// /datum/metacoinshop/listing/preround/hellfire_kit
// 	id = "hellfire_kit"
// 	category = /datum/metacoin_category/gunsmiths_bench
// 	name = "Hellfire Conversion Kit"
// 	desc = "Turns a laser gun into a hellfire laser."
// 	price = 150
// 	item_type = /obj/item/weaponcrafting/gunkit/hellgun

/datum/metacoinshop/listing/preround/inducer
	id = "inducer"
	category = /datum/metacoin_category/gunsmiths_bench
	name = "Inducer"
	desc = "Charges cells on the go. Also the heart of a heated rebar crossbow."
	price = 150
	item_type = /obj/item/inducer/orderable

/datum/metacoinshop/listing/preround/weapon_journal
	id = "weapon_journal"
	category = /datum/metacoin_category/gunsmiths_bench
	name = "Gunsmith Journal"
	desc = "A worn journal that teaches an improved improvised gun recipe."
	price = 200
	variant_options = list("recipe" = list(
		/datum/metacoinshop/listing_variant/weapon_journal/pipegun_prime,
		/datum/metacoinshop/listing_variant/weapon_journal/laser_musket_prime,
	))

/datum/metacoinshop/listing_variant/weapon_journal/pipegun_prime
	id = "pipegun_prime"
	name = "Regal Pipegun"
	item_type = /obj/item/book/granter/crafting_recipe/dusting/pipegun_prime

/datum/metacoinshop/listing_variant/weapon_journal/laser_musket_prime
	id = "laser_musket_prime"
	name = "Heroic Laser Musket"
	item_type = /obj/item/book/granter/crafting_recipe/dusting/laser_musket_prime

/datum/metacoinshop/listing/preround/pipegun_kit
	id = "pipegun_kit"
	category = /datum/metacoin_category/gunsmiths_bench
	name = "Pipegun Kit"
	desc = "A receiver, a stock and duct tape. Bring your own pipe."
	price = 250
	item_type = /obj/item/storage/box/metacoin_kit/pipegun

/obj/item/storage/box/metacoin_kit/pipegun
	name = "pipegun kit"
	kit_contents = list(
		/obj/item/weaponcrafting/receiver = 1,
		/obj/item/weaponcrafting/stock = 1,
		/obj/item/stack/medical/wrap/sticky_tape/duct = 1,
	)

/datum/metacoinshop/listing/preround/sks_kit
	id = "sks_kit"
	category = /datum/metacoin_category/gunsmiths_bench
	name = "SKS Parts Kit"
	desc = "Parts for a Sakhno SKS. Needs a receiver and a stock."
	price = 400
	item_type = /obj/item/weaponcrafting/gunkit/sks

/datum/metacoinshop/listing/preround/big_slappy_kit
	id = "big_slappy_kit"
	category = /datum/metacoin_category/gunsmiths_bench
	name = "Big Slappy Parts Kit"
	desc = "Everything special you need to build Big Slappy."
	price = 400
	item_type = /obj/item/weaponcrafting/giant_wrench
