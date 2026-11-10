/datum/job/brig_physician
	parent_type = /datum/job/doctor
	title = JOB_BRIG_PHYSICIAN
	description = "Provide medical care to security personnel and prisoners."
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_HOS
	config_tag = "BRIG_PHYSICIAN"
	outfit = /datum/outfit/job/brig_physician
	paycheck_department = ACCOUNT_SEC
	display_order = JOB_DISPLAY_ORDER_BRIG_PHYSICIAN
	departments_list = list(/datum/job_department/security)

/datum/outfit/job/brig_physician
	parent_type = /datum/outfit/job/doctor
	name = JOB_BRIG_PHYSICIAN
	jobtype = /datum/job/brig_physician
	id_trim = /datum/id_trim/job/brig_physician
	uniform = /obj/item/clothing/under/rank/security/brig_physician
	suit = /obj/item/clothing/suit/toggle/labcoat/brig_physician
	head = /obj/item/clothing/head/soft/brig_physician
	ears = /obj/item/radio/headset/headset_med/brig_physician
	glasses = /obj/item/clothing/glasses/hud/medsechud
	belt = /obj/item/storage/belt/medical/brig_physician
	l_pocket = /obj/item/modular_computer/pda/crew/medical
	pda_slot = ITEM_SLOT_LPOCKET
	implants = list(/obj/item/implant/mindshield)
	backpack = /obj/item/storage/backpack/brig_physician
	satchel = /obj/item/storage/backpack/satchel/brig_physician
	duffelbag = /obj/item/storage/backpack/duffelbag/brig_physician

/datum/id_trim/job/brig_physician
	parent_type = /datum/id_trim/job/medical_doctor
	assignment = JOB_BRIG_PHYSICIAN
	department_color = COLOR_SECURITY_RED
	sechud_icon = 'modular_meta/features/not_enough_jobs/icons/hud.dmi'
	sechud_icon_state = "hudbrigphysician"
	minimal_access = list(ACCESS_BRIG_ENTRANCE, ACCESS_BRIG, ACCESS_BRIG_PHYSICIAN, ACCESS_SECURITY, ACCESS_MEDICAL, ACCESS_MECH_MEDICAL, ACCESS_MORGUE, ACCESS_PHARMACY, ACCESS_SURGERY, ACCESS_MINERAL_STOREROOM)
	template_access = list(ACCESS_CAPTAIN, ACCESS_CHANGE_IDS, ACCESS_HOS, ACCESS_CMO)
	job = /datum/job/brig_physician

/obj/effect/landmark/start/brig_physician
	name = JOB_BRIG_PHYSICIAN
	icon = 'modular_meta/features/not_enough_jobs/icons/landmarks.dmi'
	icon_state = "Brig Physician"

/obj/item/radio/headset/headset_med/brig_physician
	name = "brig physician's headset"
	keyslot2 = /obj/item/encryptionkey/headset_sec

/obj/item/clothing/under/rank/security/brig_physician
	name = "brig physician's uniform"
	desc = "A uniform for the brig's medical staff."
	icon = 'modular_meta/features/not_enough_jobs/icons/items/under.dmi'
	worn_icon = 'modular_meta/features/not_enough_jobs/icons/on_mob/under.dmi'
	icon_state = "secmed_alt"
	inhand_icon_state = "gy_suit"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/toggle/labcoat/brig_physician
	name = "brig physician's labcoat"
	desc = "A labcoat with security markings."
	icon = 'modular_meta/features/not_enough_jobs/icons/items/suits.dmi'
	worn_icon = 'modular_meta/features/not_enough_jobs/icons/on_mob/suits.dmi'
	icon_state = "labcoat_secmed_alt"
	inhand_icon_state = null

/obj/item/clothing/under/rank/security/brig_physician/skirt
	name = "brig physician's grey jumpskirt"
	icon_state = "secmed_alt_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	bodyshapes_with_variations = NONE

/obj/item/clothing/under/rank/security/brig_physician/white
	name = "brig physician's white uniform"
	icon_state = "secmed"
	inhand_icon_state = "w_suit"
	armor_type = /datum/armor/clothing_under/rank_medical

/obj/item/clothing/under/rank/security/brig_physician/white/skirt
	name = "brig physician's white jumpskirt"
	icon_state = "secmed_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	bodyshapes_with_variations = NONE

/obj/item/clothing/under/rank/security/brig_physician/scrubs
	name = "brig physician's scrubs"
	icon_state = "scrubssec"
	inhand_icon_state = "w_suit"
	armor_type = /datum/armor/clothing_under/rank_medical

/obj/item/clothing/suit/toggle/labcoat/brig_physician/white
	name = "brig physician's white labcoat"
	icon_state = "labcoat_secmed"

/obj/item/clothing/suit/toggle/labcoat/brig_physician/old
	name = "brig physician's old labcoat"
	icon_state = "labcoat_secmed_old"

/obj/item/clothing/head/utility/surgerycap/brig_physician
	name = "brig physician's surgical cap"
	desc = "A red surgical cap for the brig's medical staff."
	icon = 'modular_meta/features/not_enough_jobs/icons/items/surgerycap.dmi'
	worn_icon = 'modular_meta/features/not_enough_jobs/icons/on_mob/surgerycap.dmi'
	icon_state = "surgicalcapsec"

/obj/item/clothing/head/soft/brig_physician
	name = "brig physician's cap"
	desc = "A cap for the brig's medical staff."
	icon = 'modular_meta/features/not_enough_jobs/icons/items/head.dmi'
	worn_icon = 'modular_meta/features/not_enough_jobs/icons/on_mob/head.dmi'
	icon_state = "secmedsoft"
	soft_type = "secmed"
	dog_fashion = null

/obj/item/storage/backpack/brig_physician
	name = "brig physician's backpack"
	desc = "A backpack for the brig's medical staff."
	icon = 'modular_meta/features/not_enough_jobs/icons/items/back.dmi'
	worn_icon = 'modular_meta/features/not_enough_jobs/icons/on_mob/back.dmi'
	lefthand_file = 'modular_meta/features/not_enough_jobs/icons/inhands/back_lefthand.dmi'
	righthand_file = 'modular_meta/features/not_enough_jobs/icons/inhands/back_righthand.dmi'
	icon_state = "backpack-secmed"
	inhand_icon_state = "backpack-secmed"

/obj/item/storage/backpack/satchel/brig_physician
	name = "brig physician's satchel"
	desc = "A satchel for the brig's medical staff."
	icon = 'modular_meta/features/not_enough_jobs/icons/items/back.dmi'
	worn_icon = 'modular_meta/features/not_enough_jobs/icons/on_mob/back.dmi'
	lefthand_file = 'modular_meta/features/not_enough_jobs/icons/inhands/back_lefthand.dmi'
	righthand_file = 'modular_meta/features/not_enough_jobs/icons/inhands/back_righthand.dmi'
	icon_state = "satchel-secmed"
	inhand_icon_state = "satchel-secmed"

/obj/item/storage/backpack/duffelbag/brig_physician
	name = "brig physician's duffel bag"
	desc = "A duffel bag for the brig's medical staff."
	icon = 'modular_meta/features/not_enough_jobs/icons/items/back.dmi'
	worn_icon = 'modular_meta/features/not_enough_jobs/icons/on_mob/back.dmi'
	lefthand_file = 'modular_meta/features/not_enough_jobs/icons/inhands/back_lefthand.dmi'
	righthand_file = 'modular_meta/features/not_enough_jobs/icons/inhands/back_righthand.dmi'
	icon_state = "duffel-secmed"
	inhand_icon_state = "duffel-secmed"

/obj/item/storage/belt/medical/brig_physician
	name = "brig physician's medical belt"
	icon = 'modular_meta/features/not_enough_jobs/icons/items/belt.dmi'
	worn_icon = 'modular_meta/features/not_enough_jobs/icons/on_mob/belt.dmi'
	icon_state = "secmed"
	worn_icon_state = "secmed"
	inhand_icon_state = "security"

/obj/item/storage/belt/medical/brig_physician/PopulateContents()
	new /obj/item/reagent_containers/hypospray/brig_physician(src)
	new /obj/item/stack/medical/suture/medicated(src)
	new /obj/item/stack/medical/mesh/advanced(src)
	new /obj/item/stack/medical/wrap/gauze/twelve(src)
	new /obj/item/healthanalyzer/advanced(src)
	new /obj/item/reagent_containers/hypospray/medipen/atropine(src)

/obj/item/reagent_containers/hypospray/brig_physician
	name = "brig physician's hypospray"
	desc = "A medical autoinjector designed by DeForest with cooperation of Aussec Armory; Allegedly first prototype was stolen from a deceased Cybersun operative during an <b> REDACTED </b>  operation abroad NTSS-<b>REDACTED</b>\
	this version features an advanced piercing tip to administer medicine through protective clothing."
	icon_state = "sec_hypo"
	inhand_icon_state = "combat_hypo"
	ignore_flags = TRUE
	list_reagents = list(/datum/reagent/medicine/omnizine = 30)

/obj/item/storage/bag/garment/brig_physician
	name = "brig physician's garment bag"

/obj/item/storage/bag/garment/brig_physician/PopulateContents()
	new /obj/item/clothing/under/rank/security/brig_physician(src)
	new /obj/item/clothing/under/rank/security/brig_physician/skirt(src)
	new /obj/item/clothing/under/rank/security/brig_physician/white(src)
	new /obj/item/clothing/under/rank/security/brig_physician/white/skirt(src)
	new /obj/item/clothing/under/rank/security/brig_physician/scrubs(src)
	new /obj/item/clothing/suit/toggle/labcoat/brig_physician(src)
	new /obj/item/clothing/suit/toggle/labcoat/brig_physician/white(src)
	new /obj/item/clothing/suit/toggle/labcoat/brig_physician/old(src)
	new /obj/item/clothing/head/soft/brig_physician(src)
	new /obj/item/clothing/head/utility/surgerycap/brig_physician(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/storage/backpack/brig_physician(src)
	new /obj/item/storage/backpack/satchel/brig_physician(src)
	new /obj/item/storage/backpack/duffelbag/brig_physician(src)

/obj/structure/closet/secure_closet/secmed
	name = "security medical locker"
	icon = 'modular_meta/features/not_enough_jobs/icons/closet.dmi'
	icon_state = "secmed"
	req_access = list(ACCESS_SECURITY)
	paint_jobs = FALSE

/obj/structure/closet/secure_closet/secmed/blue
	icon_state = "secmed_blue"

/obj/structure/closet/secure_closet/secmed/PopulateContents()
	..()
	new /obj/item/storage/bag/garment/brig_physician(src)
	new /obj/item/storage/belt/medical/brig_physician(src)
	new /obj/item/flashlight/seclite(src)
	new /obj/item/clothing/suit/jacket/straight_jacket(src)
	new /obj/item/clothing/mask/muzzle(src)
	new /obj/item/clothing/glasses/blindfold(src)
	new /obj/item/healthanalyzer(src)
	new /obj/item/storage/backpack/duffelbag/sec/surgery(src)
	new /obj/item/defibrillator/loaded(src)
	new /obj/item/reagent_containers/blood/o_minus(src)
	new /obj/item/reagent_containers/blood/o_minus(src)
	new /obj/item/clothing/glasses/hud/medsechud(src)
	new /obj/item/emergency_bed(src)
	new /obj/item/storage/box/bodybags(src)
	new /obj/item/sensor_device(src)
	new /obj/item/storage/medkit/regular(src)
	new /obj/item/storage/medkit/brute(src)
	new /obj/item/storage/medkit/fire(src)
	new /obj/item/storage/medkit/toxin(src)
	new /obj/item/storage/medkit/o2(src)


/datum/station_trait/cybernetic_revolution/New()
	. = ..()
	job_to_cybernetic += list(/datum/job/brig_physician = /obj/item/organ/cyberimp/arm/toolkit/surgery,)
