/obj/item/reagent_containers/cup/bottle/annorwa
	name = "Annoying virus sample culture bottle"
	desc = "A small bottle. Contains a sample of Annorwa."
	spawned_disease = /datum/disease/annorwa

/obj/item/reagent_containers/cup/bottle/cordafungi
	name = "Fungal Rabies culture bottle"
	desc = "A small bottle. Contains a sample of Cordius Fungi."
	spawned_disease = /datum/disease/cordafungi

/datum/uplink_item/role_restricted/annorwauplink
    name = "Annorwa sample"
	desc = "Annoying virus culture bottle, why i need to explain?."
	item = /obj/item/reagent_containers/cup/bottle/annorwa
	cost = 20
	restricted_roles = list(JOB_MEDICAL_DOCTOR)
	surplus = 0

/datum/uplink_item/role_restricted/cordafungiuplink
    name = "Cordafungi sample"
	desc = "Fungal rabies culture bottle, why i need to explain?."
	item = /obj/item/reagent_containers/cup/bottle/cordafungi
	cost = 20
	restricted_roles = list(JOB_MEDICAL_DOCTOR)
	surplus = 0
