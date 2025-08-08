/datum/supply_pack/imports/viruscrateillegal
		name = "Illegal virus crate"
		desc = "Sometimes, normal weapons isn't enough..."
		hidden = TRUE
		cost = CARGO_CRATE_VALUE * 150
		contains = list(
	/obj/item/reagent_containers/cup/bottle/cordafungi = 1,
	/obj/item/reagent_containers/cup/bottle/annorwa = 1
	)

/obj/item/reagent_containers/cup/bottle/annorwa
		name = "Annoying virus sample culture bottle"
		desc = "A small bottle. Contains a sample of Annorwa."
		spawned_disease = /datum/disease/annorwa

/obj/item/reagent_containers/cup/bottle/cordafungi
		name = "Fungal Rabies culture bottle"
		desc = "A small bottle. Contains a sample of Cordius Fungi."
		spawned_disease = /datum/disease/cordafungi
