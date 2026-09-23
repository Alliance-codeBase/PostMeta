#define CONTAINMENT_BREACH_DAY "Birthday of SCP:CB"

/datum/holiday/breach
	name = CONTAINMENT_BREACH_DAY
	begin_month = APRIL
	begin_day = 15
	end_month = MAY
	end_day = 15
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
