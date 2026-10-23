/datum/metacoinshop/listing/preround/other/skillchip
	category = /datum/metacoin_category/neural_implants

// example of installing stuff into the body: the chip goes straight into the brain instead of the backpack
/datum/metacoinshop/listing/preround/other/skillchip/bought_on_spawn(datum/metacoin_shop_controller/shop, target_ckey, mob/living/carbon/human/human_spawned, obj/item/item, client/player_client)
	var/skillchip_path = get_chosen_typepath(shop, target_ckey)
	var/obj/item/skillchip/skillchip = new skillchip_path()
	var/implant_failure = human_spawned.implant_skillchip(skillchip)
	// it can refuse: no brain, no slots left, incompatible chip. then the player gets their coins back, never just eat them
	if(implant_failure)
		qdel(skillchip)
		shop.refund_and_notify(target_ckey, price, "[name] could not be implanted: [implant_failure]", human_spawned)
		return

	var/activation_failure = skillchip.try_activate_skillchip()
	if(activation_failure)
		human_spawned.remove_skillchip(skillchip, silent = TRUE)
		qdel(skillchip)
		shop.refund_and_notify(target_ckey, price, "[name] could not be activated: [activation_failure]", human_spawned)
		return

	playsound(human_spawned, 'sound/items/weapons/circsawhit.ogg', 100)
	to_chat(human_spawned, span_notice("You've been implanted with [skillchip.name]"))

/datum/metacoinshop/listing/preround/other/skillchip/novelty
	id = "novelty_skillchip"
	name = "Novelty Skillchip"
	desc = "A harmless hobby skillchip of your choice, implanted on arrival."
	price = 20
	variant_options = list("skill" = list(
		/datum/metacoinshop/listing_variant/novelty_skillchip/bonsai,
		/datum/metacoinshop/listing_variant/novelty_skillchip/wine_taster,
		/datum/metacoinshop/listing_variant/novelty_skillchip/sabrage,
		/datum/metacoinshop/listing_variant/novelty_skillchip/chefs_kiss,
		/datum/metacoinshop/listing_variant/novelty_skillchip/food_intuition,
		/datum/metacoinshop/listing_variant/novelty_skillchip/master_angler,
		/datum/metacoinshop/listing_variant/novelty_skillchip/big_pointer,
		/datum/metacoinshop/listing_variant/novelty_skillchip/musical,
		/datum/metacoinshop/listing_variant/novelty_skillchip/light_remover,
	))

/datum/metacoinshop/listing_variant/novelty_skillchip/bonsai
	id = "bonsai"
	name = "Hedge Trimming"
	item_type = /obj/item/skillchip/bonsai

/datum/metacoinshop/listing_variant/novelty_skillchip/wine_taster
	id = "wine_taster"
	name = "Wine Tasting"
	item_type = /obj/item/skillchip/wine_taster

/datum/metacoinshop/listing_variant/novelty_skillchip/sabrage
	id = "sabrage"
	name = "Champagne Sabrage"
	item_type = /obj/item/skillchip/sabrage

/datum/metacoinshop/listing_variant/novelty_skillchip/chefs_kiss
	id = "chefs_kiss"
	name = "Chef's Kiss"
	item_type = /obj/item/skillchip/chefs_kiss

/datum/metacoinshop/listing_variant/novelty_skillchip/food_intuition
	id = "food_intuition"
	name = "Food Intuition"
	item_type = /obj/item/skillchip/intj

/datum/metacoinshop/listing_variant/novelty_skillchip/master_angler
	id = "master_angler"
	name = "Master Angler"
	item_type = /obj/item/skillchip/master_angler

/datum/metacoinshop/listing_variant/novelty_skillchip/big_pointer
	id = "big_pointer"
	name = "Big Pointer"
	item_type = /obj/item/skillchip/big_pointer

/datum/metacoinshop/listing_variant/novelty_skillchip/musical
	id = "musical"
	name = "SS13: The Musical"
	item_type = /obj/item/skillchip/musical

/datum/metacoinshop/listing_variant/novelty_skillchip/light_remover
	id = "light_remover"
	name = "Hot Bulb Handling"
	item_type = /obj/item/skillchip/light_remover

/datum/metacoinshop/listing/preround/other/skillchip/drunken_brawler
	id = "drunken_brawler"
	name = "F0RC3 4DD1CT10N skillchip"
	desc = "While drunk your punches never miss, your grabs are stronger and your aim does not sway. Implanted on arrival."
	price = 120
	item_type = /obj/item/skillchip/drunken_brawler

/datum/metacoinshop/listing/preround/other/skillchip/matrix_taunt
	id = "matrix_taunt"
	name = "BULLET_DODGER skillchip"
	desc = "Taunting makes you dodge bullets for a moment. Implanted on arrival."
	price = 300
	item_type = /obj/item/skillchip/matrix_taunt

// /datum/metacoinshop/listing/preround/other/skillchip/kaza_ruk
// 	id = "kaza_ruk"
// 	name = "Kaza Ruk skillchip"
// 	desc = "Neck chops, low sweeps and lung punches. Implanted on arrival."
// 	price = 650
// 	item_type = /obj/item/skillchip/kaza_ruk

// /datum/metacoinshop/listing/preround/other/skillchip/wrestling
// 	id = "wrestling"
// 	name = "Wrestling skillchip"
// 	desc = "Slams, throws, kicks and drops. Implanted on arrival."
// 	price = 900
// 	item_type = /obj/item/skillchip/wrestling
