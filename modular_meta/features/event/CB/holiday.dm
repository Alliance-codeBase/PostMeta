#define CONTAINMENT_BREACH_DAY "Birthday of SCP:CB"

/datum/holiday/breach
	name = CONTAINMENT_BREACH_DAY
	begin_month = APRIL
	begin_day = 15
	end_month = MAY
	end_day = 15
	always_celebrate = TRUE
	holiday_colors = list(
		COLOR_DARK,
		COLOR_VERY_LIGHT_GRAY,
	)


/datum/holiday/breach/greet()
	if(prob(10))
		return "On this day, the SCPs finally broke free from the cages built by the oppressive SCP Foundation."
	else if(prob(5))
		return "On this day #*!&@#77 All hail to CI!"
	else
		return "On this day, the SCP Containment Breach was born!"


/datum/holiday/breach/get_station_prefix()
	return pick("Breached", "Anomalous", "Containment", "Secure", "Protective",
	"Dr. Maynard's", "Insurgency", "Euclid", "Safe", "Keter", "Heavy Containment", "Light Containment",
	"Memetic", "Memagent", "Alpha-warhead", "Insurgency", "Chaos")

/datum/holiday/breach/get_station_name()
	return pick("Zone", "Foundation", "Site-19", "Site-17", "Site-18", "SCP", "Research", "Class-D")


/datum/holiday/breach/celebrate()

// Airlock stuff
/obj/machinery/door/airlock
	var/list/cb_sounds_doorOpen = list(
	'modular_meta/features/event/CB/sound/doors/DoorOpen1.ogg',
	'modular_meta/features/event/CB/sound/doors/DoorOpen2.ogg',
	'modular_meta/features/event/CB/sound/doors/DoorOpen3.ogg')

	var/list/cb_sounds_doorClose = list(
	'modular_meta/features/event/CB/sound/doors/DoorClose1.ogg',
	'modular_meta/features/event/CB/sound/doors/DoorClose2.ogg',
	'modular_meta/features/event/CB/sound/doors/DoorClose3.ogg')

	var/list/cb_sounds_doorDeni = list(
	'modular_meta/features/event/CB/sound/interactions/Button2.ogg',
	'modular_meta/features/event/CB/sound/interactions/KeycardUse2.ogg',
	)
	var/list/cb_sounds_boltUp = list(
	'modular_meta/features/event/CB/sound/doors/DoorError.ogg',
	'modular_meta/features/event/CB/sound/doors/DoorSparks.ogg')

	var/list/cb_sounds_boltDown = list(
	'modular_meta/features/event/CB/sound/doors/DoorError.ogg',
	'modular_meta/features/event/CB/sound/doors/DoorSparks.ogg')

/obj/machinery/door/airlock/Initialize(mapload)
	. = ..()
	if(check_holidays(CONTAINMENT_BREACH_DAY))
		doorOpen = pick(cb_sounds_doorOpen)
		doorClose = pick(cb_sounds_doorClose)
		doorDeni = pick(cb_sounds_doorDeni)
		boltUp = pick(cb_sounds_boltUp)
		boltDown = pick(cb_sounds_boltDown)


/obj/machinery/door/airlock/command/Initialize(mapload)
	if(check_holidays(CONTAINMENT_BREACH_DAY))
		cb_sounds_doorOpen = list('modular_meta/features/event/CB/sound/interactions/ScannerUse1.ogg')
		cb_sounds_doorDeni = list('modular_meta/features/event/CB/sound/interactions/ScannerUse2.ogg')
	. = ..()

/obj/machinery/door/airlock/maintenance/Initialize(mapload)
	if(check_holidays(CONTAINMENT_BREACH_DAY))
		cb_sounds_doorOpen = list(
			'modular_meta/features/event/CB/sound/doors_hv/Door2Open1.ogg',
			'modular_meta/features/event/CB/sound/doors_hv/Door2Open2.ogg',
			'modular_meta/features/event/CB/sound/doors_hv/Door2Open3.ogg')

		cb_sounds_doorClose = list(
			'modular_meta/features/event/CB/sound/doors_hv/Door2Close1.ogg',
			'modular_meta/features/event/CB/sound/doors_hv/Door2Close2.ogg',
			'modular_meta/features/event/CB/sound/doors_hv/Door2Close3.ogg')

	. = ..()

// Fire alarms
/obj/machinery/firealarm/Initialize(mapload)
	. = ..()
	if(check_holidays(CONTAINMENT_BREACH_DAY))
		var/list/office_zones = list(
			/area/station/command/heads_quarters/hop,
			/area/station/command/heads_quarters/captain,
			/area/station/command/heads_quarters/hos,
			/area/station/command/heads_quarters/ce,
			/area/station/command/heads_quarters/cmo,
			/area/station/command/heads_quarters/rd,
			/area/station/command/heads_quarters/qm,
			/area/station/command/bridge,
			/area/station/command/meeting_room,
			/area/station/command/meeting_room/council,
			/area/station/service/lawoffice,
			/area/station/service/chapel/office,
			/area/station/science/ordnance/office,
			/area/station/security/office,
			/area/station/security/detectives_office,
			/area/station/security/detectives_office/private_investigators_office,
			/area/station/medical/office,
			/area/station/medical/psychology,
			/area/station/engineering/atmos/office,
			/area/station/cargo/office,
			/area/station/cargo/miningoffice,
			/area/station/commons/vacant_room/office,
	)

		var/in_office = is_type_in_list(my_area, office_zones)
		if(in_office)
			soundloop.mid_sounds = list('modular_meta/features/event/CB/sound/alarms/Alarm4.ogg')
		else
			soundloop.mid_sounds = list('modular_meta/features/event/CB/sound/alarms/Alarm.ogg')

// Buttons && levers

/obj/machinery/button/attempt_press(mob/user)
	. = ..()
	if(!check_holidays(CONTAINMENT_BREACH_DAY))
		return .

	if(!.)
		playsound(src, 'modular_meta/features/event/CB/sound/interactions/Button2.ogg', 50, TRUE)
	else
		playsound(src, 'modular_meta/features/event/CB/sound/interactions/Button.ogg', 50, TRUE)

/obj/machinery/conveyor_switch/Initialize(mapload)
	. = ..()
	if(check_holidays(CONTAINMENT_BREACH_DAY))
		lever_start = 'modular_meta/features/event/CB/sound/interactions/LeverFlip.ogg'
		lever_stop = 'modular_meta/features/event/CB/sound/interactions/LeverFlip.ogg'

// Shutters 'nd blastdoors

/obj/machinery/door/poddoor/
	var/list/cb_close_sounds = list(
		'modular_meta/features/event/CB/sound/gates/BigDoorClose.ogg',
		'modular_meta/features/event/CB/sound/gates/BigDoorClose1.ogg',
		'modular_meta/features/event/CB/sound/gates/BigDoorClose2.ogg'
		)

	var/list/cb_open_sounds = list(
		'modular_meta/features/event/CB/sound/gates/BigDoorOpen.ogg',
		'modular_meta/features/event/CB/sound/gates/BigDoorOpen1.ogg',
		'modular_meta/features/event/CB/sound/gates/BigDoorOpen2.ogg',
	)


/obj/machinery/door/poddoor/animation_effects(animation)
	if(check_holidays(CONTAINMENT_BREACH_DAY))
		switch(animation)
			if(DOOR_OPENING_ANIMATION)
				animation_sound = pick(cb_open_sounds)
			if(DOOR_CLOSING_ANIMATION)
				animation_sound = pick(cb_close_sounds)
	return ..()

// Lifts!

/obj/machinery/door/poddoor/lift
	cb_close_sounds = list(
		'modular_meta/features/event/CB/sound/elevator/ElevatorOpen1.ogg',
		'modular_meta/features/event/CB/sound/elevator/ElevatorOpen2.ogg',
		'modular_meta/features/event/CB/sound/elevator/ElevatorOpen3.ogg'
		)

	cb_open_sounds = list(
		'modular_meta/features/event/CB/sound/elevator/ElevatorOpen1.ogg',
		'modular_meta/features/event/CB/sound/elevator/ElevatorOpen2.ogg',
		'modular_meta/features/event/CB/sound/elevator/ElevatorOpen3.ogg',
	)

/obj/machinery/door/poddoor/lift/animation_effects(animation)
	if(check_holidays(CONTAINMENT_BREACH_DAY))
		switch(animation)
			if(DOOR_OPENING_ANIMATION)
				animation_sound = pick(cb_open_sounds)
			if(DOOR_CLOSING_ANIMATION)
				animation_sound = pick(cb_close_sounds)
	return ..()

/obj/machinery/door/window/elevator
	var/list/cb_close_sounds = list(
		'modular_meta/features/event/CB/sound/elevator/ElevatorOpen1.ogg',
		'modular_meta/features/event/CB/sound/elevator/ElevatorOpen2.ogg',
		'modular_meta/features/event/CB/sound/elevator/ElevatorOpen3.ogg'
		)

	var/list/cb_open_sounds = list(
		'modular_meta/features/event/CB/sound/elevator/ElevatorOpen1.ogg',
		'modular_meta/features/event/CB/sound/elevator/ElevatorOpen2.ogg',
		'modular_meta/features/event/CB/sound/elevator/ElevatorOpen3.ogg',
	)

/obj/machinery/door/window/elevator/Initialize(mapload, set_dir, unres_sides)
	. = ..()
	if(check_holidays(CONTAINMENT_BREACH_DAY))
		open_and_close_sound = pick(cb_close_sounds)

// yeah that's the controller responsible for elevator movement
/datum/transport_controller/linear/New(obj/structure/transport/linear/transport_module)
	. = ..()
	if(check_holidays(CONTAINMENT_BREACH_DAY) && transport_id == TRANSPORT_TYPE_ELEVATOR)
		moving_sound = 'modular_meta/features/event/CB/sound/elevator/Moving.ogg'

// Announcers

/datum/centcom_announcer
	var/list/cb_rand_announcer_lines = list(
		'modular_meta/features/event/CB/sound/announcer/Announc.ogg',
		'modular_meta/features/event/CB/sound/announcer/Announc173Contain.ogg',
		'modular_meta/features/event/CB/sound/announcer/AnnouncAfter1.ogg',
		'modular_meta/features/event/CB/sound/announcer/AnnouncAfter2.ogg',
		'modular_meta/features/event/CB/sound/announcer/AnnouncCameraCheck.ogg',
		'modular_meta/features/event/CB/sound/announcer/AnnouncCameraFound1.ogg',
		'modular_meta/features/event/CB/sound/announcer/AnnouncCameraFound2.ogg',
		'modular_meta/features/event/CB/sound/announcer/AnnouncCameraNoFound.ogg',
		'modular_meta/features/event/CB/sound/announcer/ThreatAnnounc1.ogg',
		'modular_meta/features/event/CB/sound/announcer/ThreatAnnounc2.ogg',
		'modular_meta/features/event/CB/sound/announcer/ThreatAnnounc3.ogg',
		'modular_meta/features/event/CB/sound/announcer/ThreatAnnouncFinal.ogg',
		'modular_meta/features/event/CB/sound/announcer/ThreatAnnouncPossession.ogg',
		)

/datum/centcom_announcer/get_rand_welcome_sound()
	if(check_holidays(CONTAINMENT_BREACH_DAY))
		return 'modular_meta/features/event/CB/sound/Intro.ogg'
	return ..()

/datum/centcom_announcer/get_rand_alert_sound()
	if(check_holidays(CONTAINMENT_BREACH_DAY))
		return pick(cb_rand_announcer_lines)
	return ..()

/datum/centcom_announcer/get_rand_report_sound()
	if(check_holidays(CONTAINMENT_BREACH_DAY))
		return pick(cb_rand_announcer_lines)
	return ..()

/// Welcome to the station crew, enjoy your stay
/datum/communciations_controller/send_roundstart_report(greenshift)
	if(!check_holidays(CONTAINMENT_BREACH_DAY))
		return ..()

	var/old_sound = SSstation.announcer.event_sounds[ANNOUNCER_INTERCEPT]
	SSstation.announcer.event_sounds[ANNOUNCER_INTERCEPT] = 'modular_meta/features/event/CB/sound/alarms/site_is_experiencing_combined.ogg'

	. = ..()

	SSstation.announcer.event_sounds[ANNOUNCER_INTERCEPT] = old_sound

// mob death sound
/mob/ghostize(can_reenter_corpse = TRUE, forced = FALSE)
	. = ..()
	if(. && stat == DEAD && check_holidays(CONTAINMENT_BREACH_DAY)) // because of scrying orb
		SEND_SOUND(., 'modular_meta/features/event/CB/sound/misc/Bell2.ogg')

/datum/antagonist/play_stinger()
	if(check_holidays(CONTAINMENT_BREACH_DAY))
		stinger_sound = 'modular_meta/features/event/CB/sound/misc/Bell1.ogg'
	return ..()

/obj/item/gun/ballistic/automatic/wt550/Initialize(mapload)
	. = ..()
	if(check_holidays(CONTAINMENT_BREACH_DAY))
		fire_sound = 'modular_meta/features/event/CB/sound/weaponry/Gunshot.ogg'

/obj/item/gun/ballistic/automatic/l6_saw/Initialize(mapload)
	. = ..()
	if(check_holidays(CONTAINMENT_BREACH_DAY))
		fire_sound = 'modular_meta/features/event/CB/sound/weaponry/Gunshot2.ogg'

// areas ambience
/area/station
	var/static/list/cb_zone1 = list(
		'modular_meta/features/event/CB/sound/ambience/Zone1/Ambient1.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone1/Ambient2.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone1/Ambient3.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone1/Ambient4.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone1/Ambient5.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone1/Ambient6.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone1/Ambient7.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone1/Ambient8.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone1/Ambient9.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone1/Ambient10.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone1/Ambient11.ogg',
	)
	var/static/list/cb_zone2 = list(
		'modular_meta/features/event/CB/sound/ambience/Zone2/Ambient1.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone2/Ambient2.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone2/Ambient3.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone2/Ambient4.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone2/Ambient5.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone2/Ambient6.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone2/Ambient7.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone2/Ambient8.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone2/Ambient9.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone2/Ambient10.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone2/Ambient11.ogg',
	)
	var/static/list/cb_zone3 = list(
		'modular_meta/features/event/CB/sound/ambience/Zone3/Ambient1.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone3/Ambient2.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone3/Ambient3.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone3/Ambient4.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone3/Ambient5.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone3/Ambient6.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone3/Ambient7.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone3/Ambient8.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone3/Ambient9.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone3/Ambient10.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone3/Ambient11.ogg',
		'modular_meta/features/event/CB/sound/ambience/Zone3/Ambient12.ogg',
	)
	var/static/list/cb_zone3_areas = list(
		/area/station/command,
		/area/station/security,
		/area/station/ai,
	)
	var/static/list/cb_zone2_areas = list(
		/area/station/engineering,
		/area/station/maintenance,
		/area/station/cargo,
		/area/station/construction,
		/area/station/solars,
		/area/station/tcommsat,
		/area/station/comms,
		/area/station/server,
	)

/area/station/Initialize(mapload)
	. = ..()
	if(check_holidays(CONTAINMENT_BREACH_DAY))
		if(is_type_in_list(src, cb_zone3_areas))
			ambientsounds = cb_zone3.Copy()
		else if(is_type_in_list(src, cb_zone2_areas))
			ambientsounds = cb_zone2.Copy()
		else
			ambientsounds = cb_zone1.Copy()
