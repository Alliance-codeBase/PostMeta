/area/station/security/medical/brig_physician
	name = "Thanatorium"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/obj/effect/mapping_helpers/airlock/access/any/security/brig_physician
	name = "brig physician"

/obj/effect/mapping_helpers/airlock/access/any/security/brig_physician/get_access()
	return list(ACCESS_BRIG_PHYSICIAN, ACCESS_HOS)
