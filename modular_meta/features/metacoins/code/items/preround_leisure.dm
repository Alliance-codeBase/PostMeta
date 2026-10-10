/datum/metacoinshop/listing/preround/six_pack
	id = "six_pack"
	category = /datum/metacoin_category/galley
	name = "Six-Pack"
	desc = "Six cans on a plastic ring."
	price = 15
	variant_options = list("drink" = list(
		/datum/metacoinshop/listing_variant/six_pack/beer,
		/datum/metacoinshop/listing_variant/six_pack/soda,
		/datum/metacoinshop/listing_variant/six_pack/gamer,
		/datum/metacoinshop/listing_variant/six_pack/energy,
	))

/datum/metacoinshop/listing_variant/six_pack/beer
	id = "beer"
	name = "Beer"
	item_type = /obj/item/storage/cans/sixbeer

/datum/metacoinshop/listing_variant/six_pack/soda
	id = "soda"
	name = "Soda"
	item_type = /obj/item/storage/cans/sixsoda

/datum/metacoinshop/listing_variant/six_pack/gamer
	id = "gamer"
	name = "Gamer Drink"
	item_type = /obj/item/storage/cans/sixgamerdrink

/datum/metacoinshop/listing_variant/six_pack/energy
	id = "energy"
	name = "Energy Drink"
	item_type = /obj/item/storage/cans/sixenergydrink

/datum/metacoinshop/listing/preround/lava_lamp
	id = "lava_lamp"
	category = /datum/metacoin_category/recreation_room
	name = "Lava Lamp"
	desc = "A groovy lava lamp in the color of your choice."
	price = 15
	variant_options = list("color" = list(
		/datum/metacoinshop/listing_variant/lava_lamp/red,
		/datum/metacoinshop/listing_variant/lava_lamp/blue,
		/datum/metacoinshop/listing_variant/lava_lamp/cyan,
		/datum/metacoinshop/listing_variant/lava_lamp/green,
		/datum/metacoinshop/listing_variant/lava_lamp/orange,
		/datum/metacoinshop/listing_variant/lava_lamp/purple,
		/datum/metacoinshop/listing_variant/lava_lamp/pink,
		/datum/metacoinshop/listing_variant/lava_lamp/yellow,
	))

/datum/metacoinshop/listing_variant/lava_lamp/red
	id = "red"
	name = "Red"
	item_type = /obj/item/flashlight/lamp/lava/red

/datum/metacoinshop/listing_variant/lava_lamp/blue
	id = "blue"
	name = "Blue"
	item_type = /obj/item/flashlight/lamp/lava/blue

/datum/metacoinshop/listing_variant/lava_lamp/cyan
	id = "cyan"
	name = "Cyan"
	item_type = /obj/item/flashlight/lamp/lava/cyan

/datum/metacoinshop/listing_variant/lava_lamp/green
	id = "green"
	name = "Green"
	item_type = /obj/item/flashlight/lamp/lava/green

/datum/metacoinshop/listing_variant/lava_lamp/orange
	id = "orange"
	name = "Orange"
	item_type = /obj/item/flashlight/lamp/lava/orange

/datum/metacoinshop/listing_variant/lava_lamp/purple
	id = "purple"
	name = "Purple"
	item_type = /obj/item/flashlight/lamp/lava/purple

/datum/metacoinshop/listing_variant/lava_lamp/pink
	id = "pink"
	name = "Pink"
	item_type = /obj/item/flashlight/lamp/lava/pink

/datum/metacoinshop/listing_variant/lava_lamp/yellow
	id = "yellow"
	name = "Yellow"
	item_type = /obj/item/flashlight/lamp/lava/yellow

/datum/metacoinshop/listing/preround/pizza
	id = "pizza"
	category = /datum/metacoin_category/galley
	name = "Pizza Box"
	desc = "A whole pizza to share."
	price = 20
	variant_options = list("topping" = list(
		/datum/metacoinshop/listing_variant/pizza/margherita,
		/datum/metacoinshop/listing_variant/pizza/vegetable,
		/datum/metacoinshop/listing_variant/pizza/mushroom,
		/datum/metacoinshop/listing_variant/pizza/meat,
		/datum/metacoinshop/listing_variant/pizza/pineapple,
	))

/datum/metacoinshop/listing_variant/pizza/margherita
	id = "margherita"
	name = "Margherita"
	item_type = /obj/item/pizzabox/margherita

/datum/metacoinshop/listing_variant/pizza/vegetable
	id = "vegetable"
	name = "Vegetable"
	item_type = /obj/item/pizzabox/vegetable

/datum/metacoinshop/listing_variant/pizza/mushroom
	id = "mushroom"
	name = "Mushroom"
	item_type = /obj/item/pizzabox/mushroom

/datum/metacoinshop/listing_variant/pizza/meat
	id = "meat"
	name = "Meat"
	item_type = /obj/item/pizzabox/meat

/datum/metacoinshop/listing_variant/pizza/pineapple
	id = "pineapple"
	name = "Pineapple"
	item_type = /obj/item/pizzabox/pineapple

/datum/metacoinshop/listing/preround/instrument
	id = "instrument"
	category = /datum/metacoin_category/recreation_room
	name = "Musical Instrument"
	desc = "An instrument of your choice."
	price = 20
	variant_options = list("instrument" = list(
		/datum/metacoinshop/listing_variant/instrument/violin,
		/datum/metacoinshop/listing_variant/instrument/guitar,
		/datum/metacoinshop/listing_variant/instrument/electric_guitar,
		/datum/metacoinshop/listing_variant/instrument/banjo,
		/datum/metacoinshop/listing_variant/instrument/glockenspiel,
		/datum/metacoinshop/listing_variant/instrument/accordion,
		/datum/metacoinshop/listing_variant/instrument/trumpet,
		/datum/metacoinshop/listing_variant/instrument/saxophone,
		/datum/metacoinshop/listing_variant/instrument/trombone,
		/datum/metacoinshop/listing_variant/instrument/recorder,
		/datum/metacoinshop/listing_variant/instrument/harmonica,
		/datum/metacoinshop/listing_variant/instrument/piano_synth,
	))

/datum/metacoinshop/listing_variant/instrument/violin
	id = "violin"
	name = "Violin"
	item_type = /obj/item/instrument/violin

/datum/metacoinshop/listing_variant/instrument/guitar
	id = "guitar"
	name = "Guitar"
	item_type = /obj/item/instrument/guitar

/datum/metacoinshop/listing_variant/instrument/electric_guitar
	id = "electric_guitar"
	name = "Electric Guitar"
	item_type = /obj/item/instrument/eguitar

/datum/metacoinshop/listing_variant/instrument/banjo
	id = "banjo"
	name = "Banjo"
	item_type = /obj/item/instrument/banjo

/datum/metacoinshop/listing_variant/instrument/glockenspiel
	id = "glockenspiel"
	name = "Glockenspiel"
	item_type = /obj/item/instrument/glockenspiel

/datum/metacoinshop/listing_variant/instrument/accordion
	id = "accordion"
	name = "Accordion"
	item_type = /obj/item/instrument/accordion

/datum/metacoinshop/listing_variant/instrument/trumpet
	id = "trumpet"
	name = "Trumpet"
	item_type = /obj/item/instrument/trumpet

/datum/metacoinshop/listing_variant/instrument/saxophone
	id = "saxophone"
	name = "Saxophone"
	item_type = /obj/item/instrument/saxophone

/datum/metacoinshop/listing_variant/instrument/trombone
	id = "trombone"
	name = "Trombone"
	item_type = /obj/item/instrument/trombone

/datum/metacoinshop/listing_variant/instrument/recorder
	id = "recorder"
	name = "Recorder"
	item_type = /obj/item/instrument/recorder

/datum/metacoinshop/listing_variant/instrument/harmonica
	id = "harmonica"
	name = "Harmonica"
	item_type = /obj/item/instrument/harmonica

/datum/metacoinshop/listing_variant/instrument/piano_synth
	id = "piano_synth"
	name = "Piano Synthesizer"
	item_type = /obj/item/instrument/piano_synth

/datum/metacoinshop/listing/preround/golden_violin
	id = "golden_violin"
	category = /datum/metacoin_category/recreation_room
	name = "Golden Violin"
	desc = "A golden violin. Show-off."
	price = 40
	item_type = /obj/item/instrument/violin/golden

/datum/metacoinshop/listing/preround/camera_kit
	id = "camera_kit"
	category = /datum/metacoin_category/wardrobe
	name = "Camera Kit"
	desc = "A camera, spare film and a photo album."
	price = 20
	item_type = /obj/item/storage/box/metacoin_kit/camera

/obj/item/storage/box/metacoin_kit/camera
	name = "camera kit"
	kit_contents = list(
		/obj/item/camera = 1,
		/obj/item/camera_film = 1,
		/obj/item/storage/photo_album = 1,
	)

/datum/metacoinshop/listing/preround/tattoo_kit
	id = "tattoo_kit"
	category = /datum/metacoin_category/wardrobe
	name = "Tattoo Kit"
	desc = "Ink something on someone. Permanently."
	price = 20
	item_type = /obj/item/tattoo_kit

/datum/metacoinshop/listing/preround/costume_set
	id = "costume_set"
	category = /datum/metacoin_category/wardrobe
	name = "Costume Set"
	desc = "A full outfit for your gimmick."
	price = 25
	variant_options = list("costume" = list(
		/datum/metacoinshop/listing_variant/costume_set/wedding,
		/datum/metacoinshop/listing_variant/costume_set/tuxedo,
		/datum/metacoinshop/listing_variant/costume_set/pirate_captain,
		/datum/metacoinshop/listing_variant/costume_set/brawler,
		/datum/metacoinshop/listing_variant/costume_set/mad_dog,
	))

/datum/metacoinshop/listing_variant/costume_set/wedding
	id = "wedding"
	name = "Wedding Dress"
	item_type = /obj/item/storage/box/metacoin_kit/costume/wedding

/datum/metacoinshop/listing_variant/costume_set/tuxedo
	id = "tuxedo"
	name = "Tuxedo"
	item_type = /obj/item/storage/box/metacoin_kit/costume/tuxedo

/datum/metacoinshop/listing_variant/costume_set/pirate_captain
	id = "pirate_captain"
	name = "Pirate Captain"
	item_type = /obj/item/storage/box/metacoin_kit/costume/pirate_captain

/datum/metacoinshop/listing_variant/costume_set/brawler
	id = "brawler"
	name = "Dragon of Dojima"
	item_type = /obj/item/storage/box/metacoin_kit/costume/brawler

/datum/metacoinshop/listing_variant/costume_set/mad_dog
	id = "mad_dog"
	name = "Mad Dog"
	item_type = /obj/item/storage/box/metacoin_kit/costume/mad_dog

/obj/item/storage/box/metacoin_kit/costume
	abstract_type = /obj/item/storage/box/metacoin_kit/costume
	name = "costume box"

/obj/item/storage/box/metacoin_kit/costume/wedding
	kit_contents = list(
		/obj/item/clothing/under/dress/wedding_dress = 1,
		/obj/item/clothing/head/costume/weddingveil = 1,
	)

/obj/item/storage/box/metacoin_kit/costume/tuxedo
	kit_contents = list(
		/obj/item/clothing/under/suit/tuxedo = 1,
		/obj/item/storage/belt/fannypack/cummerbund = 1,
	)

/obj/item/storage/box/metacoin_kit/costume/pirate_captain
	kit_contents = list(
		/obj/item/clothing/suit/costume/pirate/captain = 1,
		/obj/item/clothing/head/costume/pirate/captain = 1,
	)

/obj/item/storage/box/metacoin_kit/costume/brawler
	kit_contents = list(
		/obj/item/clothing/under/costume/mm/lad/brawler = 1,
		/obj/item/clothing/suit/costume/mm/brawler_blazer = 1,
		/obj/item/clothing/shoes/laceup/mm_lgray = 1,
	)

/obj/item/storage/box/metacoin_kit/costume/mad_dog
	kit_contents = list(
		/obj/item/clothing/under/costume/mm/lad/maddog = 1,
		/obj/item/clothing/shoes/mm_metalcomb = 1,
	)

/datum/metacoinshop/listing/preround/rollerskates
	id = "rollerskates"
	category = /datum/metacoin_category/garage
	name = "Rollerskates"
	desc = "Roll around the station in style."
	price = 25
	item_type = /obj/item/clothing/shoes/wheelys/rollerskates

/datum/metacoinshop/listing/preround/collectable_hat
	id = "collectable_hat"
	category = /datum/metacoin_category/wardrobe
	name = "Collectable Hat"
	desc = "A rare collectable hat. Purely cosmetic."
	price = 30
	variant_options = list("hat" = list(
		/datum/metacoinshop/listing_variant/collectable_hat/tophat,
		/datum/metacoinshop/listing_variant/collectable_hat/captain,
		/datum/metacoinshop/listing_variant/collectable_hat/head_of_security,
		/datum/metacoinshop/listing_variant/collectable_hat/head_of_personnel,
		/datum/metacoinshop/listing_variant/collectable_hat/chef,
		/datum/metacoinshop/listing_variant/collectable_hat/police,
		/datum/metacoinshop/listing_variant/collectable_hat/swat,
		/datum/metacoinshop/listing_variant/collectable_hat/thunderdome,
		/datum/metacoinshop/listing_variant/collectable_hat/beret,
		/datum/metacoinshop/listing_variant/collectable_hat/flatcap,
		/datum/metacoinshop/listing_variant/collectable_hat/pirate,
		/datum/metacoinshop/listing_variant/collectable_hat/wizard,
		/datum/metacoinshop/listing_variant/collectable_hat/kitty,
		/datum/metacoinshop/listing_variant/collectable_hat/rabbitears,
		/datum/metacoinshop/listing_variant/collectable_hat/hardhat,
		/datum/metacoinshop/listing_variant/collectable_hat/welding,
		/datum/metacoinshop/listing_variant/collectable_hat/paper,
		/datum/metacoinshop/listing_variant/collectable_hat/slime,
		/datum/metacoinshop/listing_variant/collectable_hat/xenomorph,
		/datum/metacoinshop/listing_variant/collectable_hat/petehat,
	))

/datum/metacoinshop/listing_variant/collectable_hat/tophat
	id = "tophat"
	name = "Top Hat"
	item_type = /obj/item/clothing/head/collectable/tophat

/datum/metacoinshop/listing_variant/collectable_hat/captain
	id = "captain"
	name = "Captain"
	item_type = /obj/item/clothing/head/collectable/captain

/datum/metacoinshop/listing_variant/collectable_hat/head_of_security
	id = "head_of_security"
	name = "Head of Security"
	item_type = /obj/item/clothing/head/collectable/hos

/datum/metacoinshop/listing_variant/collectable_hat/head_of_personnel
	id = "head_of_personnel"
	name = "Head of Personnel"
	item_type = /obj/item/clothing/head/collectable/hop

/datum/metacoinshop/listing_variant/collectable_hat/chef
	id = "chef"
	name = "Chef"
	item_type = /obj/item/clothing/head/collectable/chef

/datum/metacoinshop/listing_variant/collectable_hat/police
	id = "police"
	name = "Police"
	item_type = /obj/item/clothing/head/collectable/police

/datum/metacoinshop/listing_variant/collectable_hat/swat
	id = "swat"
	name = "SWAT"
	item_type = /obj/item/clothing/head/collectable/swat

/datum/metacoinshop/listing_variant/collectable_hat/thunderdome
	id = "thunderdome"
	name = "Thunderdome"
	item_type = /obj/item/clothing/head/collectable/thunderdome

/datum/metacoinshop/listing_variant/collectable_hat/beret
	id = "beret"
	name = "Beret"
	item_type = /obj/item/clothing/head/collectable/beret

/datum/metacoinshop/listing_variant/collectable_hat/flatcap
	id = "flatcap"
	name = "Flat Cap"
	item_type = /obj/item/clothing/head/collectable/flatcap

/datum/metacoinshop/listing_variant/collectable_hat/pirate
	id = "pirate"
	name = "Pirate"
	item_type = /obj/item/clothing/head/collectable/pirate

/datum/metacoinshop/listing_variant/collectable_hat/wizard
	id = "wizard"
	name = "Wizard"
	item_type = /obj/item/clothing/head/collectable/wizard

/datum/metacoinshop/listing_variant/collectable_hat/kitty
	id = "kitty"
	name = "Kitty Ears"
	item_type = /obj/item/clothing/head/collectable/kitty

/datum/metacoinshop/listing_variant/collectable_hat/rabbitears
	id = "rabbitears"
	name = "Rabbit Ears"
	item_type = /obj/item/clothing/head/collectable/rabbitears

/datum/metacoinshop/listing_variant/collectable_hat/hardhat
	id = "hardhat"
	name = "Hard Hat"
	item_type = /obj/item/clothing/head/collectable/hardhat

/datum/metacoinshop/listing_variant/collectable_hat/welding
	id = "welding"
	name = "Welding"
	item_type = /obj/item/clothing/head/collectable/welding

/datum/metacoinshop/listing_variant/collectable_hat/paper
	id = "paper"
	name = "Paper"
	item_type = /obj/item/clothing/head/collectable/paper

/datum/metacoinshop/listing_variant/collectable_hat/slime
	id = "slime"
	name = "Slime"
	item_type = /obj/item/clothing/head/collectable/slime

/datum/metacoinshop/listing_variant/collectable_hat/xenomorph
	id = "xenomorph"
	name = "Xenomorph"
	item_type = /obj/item/clothing/head/collectable/xenom

/datum/metacoinshop/listing_variant/collectable_hat/petehat
	id = "petehat"
	name = "Pete"
	item_type = /obj/item/clothing/head/collectable/petehat

/datum/metacoinshop/listing/preround/boombox
	id = "boombox"
	category = /datum/metacoin_category/recreation_room
	name = "Boombox"
	desc = "Never quit making all that racket. Comes with a tape of your choice inside."
	price = 30
	item_type = /obj/item/boombox
	variant_options = list("tape" = list(
		/datum/metacoinshop/listing_variant/boombox_tape/industrial,
		/datum/metacoinshop/listing_variant/boombox_tape/rock,
		/datum/metacoinshop/listing_variant/boombox_tape/hiphop,
		/datum/metacoinshop/listing_variant/boombox_tape/jazz,
		/datum/metacoinshop/listing_variant/boombox_tape/pop,
		/datum/metacoinshop/listing_variant/boombox_tape/robocop,
	))

/datum/metacoinshop/listing/preround/boombox/deliver(datum/metacoin_shop_controller/shop, target_ckey, mob/living/carbon/human/human_spawned, client/player_client)
	var/obj/item/boombox/boombox = new item_type(human_spawned)
	var/datum/metacoinshop/listing_variant/chosen_tape = get_chosen_variant(shop, target_ckey)
	var/tape_path = initial(chosen_tape.item_type)
	boombox.tapedeck = new tape_path(boombox)
	boombox.update_available_icons()
	hand_over(human_spawned, boombox)

/datum/metacoinshop/listing_variant/boombox_tape/industrial
	id = "industrial"
	name = "Industrial Crush"
	item_type = /obj/item/music_tape

/datum/metacoinshop/listing_variant/boombox_tape/rock
	id = "rock"
	name = "Bainmack"
	item_type = /obj/item/music_tape/rock

/datum/metacoinshop/listing_variant/boombox_tape/hiphop
	id = "hiphop"
	name = "Groovepad"
	item_type = /obj/item/music_tape/hiphop

/datum/metacoinshop/listing_variant/boombox_tape/jazz
	id = "jazz"
	name = "Franky's Gonna Boom"
	item_type = /obj/item/music_tape/jazz

/datum/metacoinshop/listing_variant/boombox_tape/pop
	id = "pop"
	name = "Bubblegum"
	item_type = /obj/item/music_tape/pop

/datum/metacoinshop/listing_variant/boombox_tape/robocop
	id = "robocop"
	name = "Nanotrasen Company Approved Ambiance"
	item_type = /obj/item/music_tape/robocop

/datum/metacoinshop/listing/preround/hookah
	id = "hookah"
	category = /datum/metacoin_category/recreation_room
	name = "Hookah"
	desc = "A glass hookah with coals and tobacco to get started."
	price = 30
	item_type = /obj/item/hookah

/datum/metacoinshop/listing/preround/hookah/bought_on_spawn(datum/metacoin_shop_controller/shop, target_ckey, mob/living/carbon/human/human_spawned, obj/item/item, client/player_client)
	hand_over(human_spawned, new /obj/item/storage/box/metacoin_kit/hookah_supplies(human_spawned))

/obj/item/storage/box/metacoin_kit/hookah_supplies
	name = "hookah supplies"
	kit_contents = list(
		/obj/item/hookah_coals = 3,
		/obj/item/food/grown/tobacco = 5,
	)

/datum/metacoinshop/listing/preround/skateboard_pro
	id = "skateboard_pro"
	category = /datum/metacoin_category/garage
	name = "Pro Skateboard"
	desc = "A faster, sturdier skateboard."
	price = 40
	item_type = /obj/item/melee/skateboard/pro

/datum/metacoinshop/listing/preround/hoverboard
	id = "hoverboard"
	category = /datum/metacoin_category/garage
	name = "Hoverboard"
	desc = "Skateboards are for the past."
	price = 60
	item_type = /obj/item/melee/skateboard/hoverboard

/datum/metacoinshop/listing/preround/fishing_toolbox
	id = "fishing_toolbox"
	category = /datum/metacoin_category/recreation_room
	name = "Angler's Toolbox"
	desc = "A fishing toolbox with a rod, a hook, a line and bait."
	price = 30
	item_type = /obj/item/storage/toolbox/fishing

// /datum/metacoinshop/listing/preround/master_fishing_rod
// 	id = "master_fishing_rod"
// 	category = /datum/metacoin_category/recreation_room
// 	name = "Master Fishing Rod"
// 	desc = "A telescopic rod for those who never miss a catch."
// 	price = 50
// 	item_type = /obj/item/fishing_rod/telescopic/master

/datum/metacoinshop/listing/preround/laser_tag
	id = "laser_tag"
	category = /datum/metacoin_category/recreation_room
	name = "Laser Tag Set"
	desc = "A laser tag gun with its matching vest and helmet."
	price = 30
	variant_options = list("team" = list(
		/datum/metacoinshop/listing_variant/laser_tag/red,
		/datum/metacoinshop/listing_variant/laser_tag/blue,
	))

/datum/metacoinshop/listing_variant/laser_tag/red
	id = "red"
	name = "Red Team"
	item_type = /obj/item/storage/box/metacoin_kit/laser_tag/red

/datum/metacoinshop/listing_variant/laser_tag/blue
	id = "blue"
	name = "Blue Team"
	item_type = /obj/item/storage/box/metacoin_kit/laser_tag/blue

/obj/item/storage/box/metacoin_kit/laser_tag
	abstract_type = /obj/item/storage/box/metacoin_kit/laser_tag
	name = "laser tag set"

/obj/item/storage/box/metacoin_kit/laser_tag/red
	kit_contents = list(
		/obj/item/gun/energy/laser/redtag = 1,
		/obj/item/clothing/suit/redtag = 1,
		/obj/item/clothing/head/helmet/taghelm/red = 1,
	)

/obj/item/storage/box/metacoin_kit/laser_tag/blue
	kit_contents = list(
		/obj/item/gun/energy/laser/bluetag = 1,
		/obj/item/clothing/suit/bluetag = 1,
		/obj/item/clothing/head/helmet/taghelm/blue = 1,
	)

/datum/metacoinshop/listing/preround/broadcast_camera
	id = "broadcast_camera"
	category = /datum/metacoin_category/wardrobe
	name = "Broadcast Camera"
	desc = "Stream live to the station entertainment monitors."
	price = 50
	item_type = /obj/item/broadcast_camera/cargo

// example of an "other" listing: nothing is handed over, deliver() skips straight to bought_on_spawn() with item = null
// so the item_type here is just a blueprint, build it and put it wherever you like. in this case, where the sun don't shine
/datum/metacoinshop/listing/preround/other/butt
	category = /datum/metacoin_category/wardrobe

// one rear per customer. return an error code to refuse the purchase, the text players see lives in error_text()
/datum/metacoinshop/listing/preround/other/butt/purchase_error(datum/metacoin_shop_controller/shop, target_ckey, variant)
	for(var/pending_id in shop.get_pending_items(target_ckey))
		if(istype(shop.preround_catalog[pending_id], /datum/metacoinshop/listing/preround/other/butt))
			return "butt_already_bought"
	return ..()

// the timer is load-bearing: /datum/job/clown/after_spawn swaps in a clown butt right after this signal, so we wait for the honk to settle
/datum/metacoinshop/listing/preround/other/butt/bought_on_spawn(datum/metacoin_shop_controller/shop, target_ckey, mob/living/carbon/human/human_spawned, obj/item/item, client/player_client)
	addtimer(CALLBACK(src, PROC_REF(replace_butt), shop, target_ckey, human_spawned, get_chosen_typepath(shop, target_ckey)), 1 DECISECONDS)

/datum/metacoinshop/listing/preround/other/butt/proc/replace_butt(datum/metacoin_shop_controller/shop, target_ckey, mob/living/carbon/human/receiver, butt_path)
	if(QDELETED(receiver))
		shop.refund_and_notify(target_ckey, price, "[name] could not be delivered.", null)
		return
	var/obj/item/organ/internal/butt/butt = new butt_path()
	butt.Insert(receiver, special = TRUE, movement_flags = DELETE_IF_REPLACED) // the old one is deleted, no spare butts lying around
	to_chat(receiver, span_notice("You feel a draft. Your rear is now \a [butt]."))

/datum/metacoinshop/listing/preround/other/butt/novelty
	id = "novelty_butt"
	name = "Novelty Butt"
	desc = "Your own rear is swapped for a novelty one on arrival."
	price = 15
	variant_options = list("butt" = list(
		/datum/metacoinshop/listing_variant/novelty_butt/iron,
		/datum/metacoinshop/listing_variant/novelty_butt/xenomorph,
	))

/datum/metacoinshop/listing_variant/novelty_butt/iron
	id = "iron"
	name = "The Iron Butt"
	item_type = /obj/item/organ/internal/butt/iron

/datum/metacoinshop/listing_variant/novelty_butt/xenomorph
	id = "xenomorph"
	name = "Xenomorph Butt"
	item_type = /obj/item/organ/internal/butt/xeno

/datum/metacoinshop/listing/preround/other/butt/bluespace
	id = "bluespace_butt"
	name = "Bluespace Posterior"
	desc = "Your own rear is swapped for a bluespace one on arrival. Its farts leave the floor wet, and it falls off more often."
	price = 30
	item_type = /obj/item/organ/internal/butt/bluespace
