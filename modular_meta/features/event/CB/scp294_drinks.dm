/datum/anomalous_coffeemachine/drinks
	var/id
	var/list/aliases = list()
	var/reagent = /datum/reagent/anomalous
	var/anomaly = TRUE
	var/label
	var/taste

/datum/anomalous_coffeemachine/drinks/regular
	anomaly = FALSE

/datum/anomalous_coffeemachine/drinks/regular/water
	id = "water"
	reagent = /datum/reagent/water

/datum/anomalous_coffeemachine/drinks/regular/coffee
	id = "coffee"
	aliases = list("black coffee", "espresso")
	reagent = /datum/reagent/consumable/coffee

/datum/anomalous_coffeemachine/drinks/regular/tea
	id = "tea"
	aliases = list("green tea", "black tea", "hot tea")
	reagent = /datum/reagent/consumable/tea

/datum/anomalous_coffeemachine/drinks/regular/cola
	id = "cola"
	aliases = list("coke", "coca-cola", "pepsi", "soda")
	reagent = /datum/reagent/consumable/space_cola

/datum/anomalous_coffeemachine/drinks/regular/hot_chocolate
	id = "hot chocolate"
	aliases = list("chocolate", "cocoa")
	reagent = /datum/reagent/consumable/hot_coco

/datum/anomalous_coffeemachine/drinks/regular/orange_juice
	id = "orange juice"
	aliases = list("orange")
	reagent = /datum/reagent/consumable/orangejuice

/datum/anomalous_coffeemachine/drinks/regular/apple_juice
	id = "apple juice"
	aliases = list("apple")
	reagent = /datum/reagent/consumable/applejuice

/datum/anomalous_coffeemachine/drinks/regular/lemon_juice
	id = "lemon juice"
	reagent = /datum/reagent/consumable/lemonjuice

/datum/anomalous_coffeemachine/drinks/regular/milk
	id = "milk"
	reagent = /datum/reagent/consumable/milk

/datum/anomalous_coffeemachine/drinks/regular/honey
	id = "honey"
	reagent = /datum/reagent/consumable/honey

/datum/anomalous_coffeemachine/drinks/regular/beer
	id = "beer"
	aliases = list("lager")
	reagent = /datum/reagent/consumable/ethanol/beer

/datum/anomalous_coffeemachine/drinks/regular/wine
	id = "wine"
	aliases = list("red wine")
	reagent = /datum/reagent/consumable/ethanol/wine

/datum/anomalous_coffeemachine/drinks/regular/vodka
	id = "vodka"
	reagent = /datum/reagent/consumable/ethanol/vodka

/datum/anomalous_coffeemachine/drinks/regular/whiskey
	id = "whiskey"
	reagent = /datum/reagent/consumable/ethanol/whiskey

/datum/anomalous_coffeemachine/drinks/scp106
	id = "scp-106"
	aliases = list("106", "scp 106", "old man", "larry", "black corrosive liquid")
	reagent = /datum/reagent/anomalous/corrosion

/datum/anomalous_coffeemachine/drinks/nuke
	id = "nuke"
	aliases = list("atomic", "nuclear", "antimatter")
	reagent = /datum/reagent/anomalous/explosion

/datum/anomalous_coffeemachine/drinks/god
	id = "god"
	aliases = list("divinity")
	reagent = /datum/reagent/anomalous/heal/god

/datum/anomalous_coffeemachine/drinks/narsie
	id = "narsie"
	aliases = list("nar sie", "nar-sie", "blood geometer", "the blood geometer", "geometer", "blood god", "blood goddess", "elder goddess")
	reagent = /datum/reagent/anomalous/narsie

/datum/anomalous_coffeemachine/drinks/zombie
	id = "zombie"
	aliases = list("romerol", "scp-008", "scp 008", "008", "plague")
	reagent = /datum/reagent/anomalous/zombie

/datum/anomalous_coffeemachine/drinks/life
	id = "life"
	aliases = list("estus", "scp-500", "panacea")
	reagent = /datum/reagent/anomalous/heal

/datum/anomalous_coffeemachine/drinks/death
	id = "death"
	reagent = /datum/reagent/anomalous/death

/datum/anomalous_coffeemachine/drinks/rage
	id = "rage"
	aliases = list("anger", "hate")
	reagent = /datum/reagent/anomalous/head

/datum/anomalous_coffeemachine/drinks/knowledge
	id = "knowledge"
	reagent = /datum/reagent/anomalous/brain

/datum/anomalous_coffeemachine/drinks/pain
	id = "pain"
	aliases = list("liquid pain")
	reagent = /datum/reagent/anomalous/pain

/datum/anomalous_coffeemachine/drinks/poison
	id = "poison"
	reagent = /datum/reagent/anomalous/toxin

/datum/anomalous_coffeemachine/drinks/lava
	id = "lava"
	aliases = list("magma")
	reagent = /datum/reagent/anomalous/fire

/datum/anomalous_coffeemachine/drinks/generals_end
	id = "general"
	aliases = list("sanabi", "wasabi", "san4bi")
	reagent = /datum/reagent/anomalous/remember_everything

/datum/anomalous_coffeemachine/drinks/sleep
	id = "sleep"
	aliases = list("dreams")
	reagent = /datum/reagent/anomalous/sleep

/datum/anomalous_coffeemachine/drinks/fear
	id = "fear"
	aliases = list("horror", "terror")
	reagent = /datum/reagent/anomalous/fear

/datum/anomalous_coffeemachine/drinks/courage
	id = "courage"
	aliases = list("bravery")
	reagent = /datum/reagent/anomalous/stamina

/datum/anomalous_coffeemachine/drinks/happiness
	id = "happiness"
	reagent = /datum/reagent/anomalous/organs/happiness

/datum/anomalous_coffeemachine/drinks/me
	id = "me"
	reagent = /datum/reagent/anomalous/me

/datum/anomalous_coffeemachine/drinks/nothing
	id = "nothing"
	reagent = /datum/reagent/anomalous/nothing

/obj/machinery/anomalous_coffeemachine/proc/find_drink(query)
	for(var/datum/anomalous_coffeemachine/drinks/drink_type as anything in subtypesof(/datum/anomalous_coffeemachine/drinks))
		var/datum/anomalous_coffeemachine/drinks/drink = new drink_type
		if(query == drink.id || (query in drink.aliases))
			return drink
		qdel(drink)
