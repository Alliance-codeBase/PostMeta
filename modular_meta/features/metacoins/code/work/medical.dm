/datum/component/treatment_journal
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/list/contributions = list()
	var/list/surgery_sessions_by_operation = list()
	var/last_revival_time

/datum/component/treatment_journal/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/treatment_journal/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_SURGERY_SUCCESS, PROC_REF(on_performed_surgery_step))
	RegisterSignal(parent, COMSIG_ATOM_SURGERY_FINISHED, PROC_REF(on_surgery_finished))
	RegisterSignal(parent, COMSIG_LIVING_REVIVE, PROC_REF(on_revived))

/datum/component/treatment_journal/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ATOM_SURGERY_SUCCESS, COMSIG_ATOM_SURGERY_FINISHED, COMSIG_LIVING_REVIVE))

/datum/component/treatment_journal/proc/is_paid_treatment(mob/living/medic)
	return medic != parent && !ismonkey(parent)

/datum/component/treatment_journal/proc/add_contribution(datum/mind/medic_mind, amount)
	var/contribution_window = 10 MINUTES
	while(length(contributions) && contributions[1]["time"] <= world.time - contribution_window)
		contributions.Cut(1, 2)
	UNTYPED_LIST_ADD(contributions, list("mind" = medic_mind, "amount" = amount, "time" = world.time))

/datum/component/treatment_journal/proc/treat(datum/mind/medic_mind, contribution, source, reason)
	add_contribution(medic_mind, contribution)
	var/datum/metacoins_controller/controller = get_metacoins_controller()
	controller.award_work(medic_mind, contribution, /datum/metacoin_work_category/medical, source, reason)

/datum/component/treatment_journal/proc/is_paid_operation(datum/surgery_operation/operation)
	var/static/list/paid_operation_types = typecacheof(list(
		/datum/surgery_operation/basic/tend_wounds,
		/datum/surgery_operation/organ/repair,
		/datum/surgery_operation/limb/prosthetic_replacement,
		/datum/surgery_operation/limb/secure_arbitrary_prosthetic,
		/datum/surgery_operation/limb/replace_limb,
		/datum/surgery_operation/limb/organ_manipulation,
		/datum/surgery_operation/basic/revival,
		/datum/surgery_operation/organ/fix_wings,
		/datum/surgery_operation/basic/implant_removal,
		/datum/surgery_operation/limb/repair_dislocation,
		/datum/surgery_operation/limb/repair_hairline,
		/datum/surgery_operation/limb/reset_compound,
		/datum/surgery_operation/limb/repair_compound,
		/datum/surgery_operation/limb/prepare_cranium_repair,
		/datum/surgery_operation/limb/repair_cranium,
		/datum/surgery_operation/limb/debride,
	))
	return is_type_in_typecache(operation, paid_operation_types)

/datum/component/treatment_journal/proc/take_patient_snapshot()
	var/mob/living/patient = parent
	var/organ_count = 0
	if(iscarbon(patient))
		var/mob/living/carbon/carbon_patient = patient
		organ_count = length(carbon_patient.organs)
	return list(
		"wound_damage" = patient.get_brute_loss() + patient.get_fire_loss(),
		"implant_count" = LAZYLEN(patient.implants),
		"organ_count" = organ_count,
		"dead" = patient.stat == DEAD,
	)

/datum/component/treatment_journal/proc/on_performed_surgery_step(mob/living/surgeon, datum/surgery_operation/operation, atom/movable/operating_on, tool)
	SIGNAL_HANDLER
	if(!is_paid_operation(operation))
		return
	var/mob/living/patient = operation.get_patient(operating_on)
	if(isnull(patient))
		return
	var/datum/component/treatment_journal/patient_journal = patient.GetComponent(/datum/component/treatment_journal)
	if(isnull(patient_journal) || !patient_journal.is_paid_treatment(surgeon))
		return
	patient_journal.start_surgery_session(surgeon, operation)

/datum/component/treatment_journal/proc/start_surgery_session(mob/living/surgeon, datum/surgery_operation/operation)
	if(surgery_sessions_by_operation[operation.type])
		return
	surgery_sessions_by_operation[operation.type] = list("surgeon" = surgeon.mind, "before" = take_patient_snapshot())

/datum/component/treatment_journal/proc/on_surgery_finished(mob/living/patient, datum/surgery_operation/operation, atom/movable/operating_on, tool)
	SIGNAL_HANDLER
	var/list/session = surgery_sessions_by_operation[operation.type]
	if(isnull(session))
		return
	surgery_sessions_by_operation -= operation.type

	var/datum/mind/surgeon_mind = session["surgeon"]
	var/list/before = session["before"]
	var/list/after = take_patient_snapshot()
	if(istype(operation, /datum/surgery_operation/basic/tend_wounds))
		var/healed_damage_per_coin = 25
		var/healed_coins = FLOOR((before["wound_damage"] - after["wound_damage"]) / healed_damage_per_coin, 1)
		if(healed_coins > 0)
			treat(surgeon_mind, contribution = healed_coins, source = "tend_wounds", reason = "Tend Wounds")
		return
	if(istype(operation, /datum/surgery_operation/basic/implant_removal) && after["implant_count"] >= before["implant_count"])
		return
	if(istype(operation, /datum/surgery_operation/limb/organ_manipulation) && after["organ_count"] <= before["organ_count"])
		return
	if(istype(operation, /datum/surgery_operation/basic/revival) && (!before["dead"] || after["dead"]))
		return
	treat(surgeon_mind, contribution = 5, source = "surgery", reason = "Surgery")

/datum/component/treatment_journal/proc/on_revived(mob/living/source, full_heal_flags)
	SIGNAL_HANDLER
	last_revival_time = world.time

/datum/component/treatment_journal/proc/on_defib_revival(mob/living/medic)
	if(!is_paid_treatment(medic))
		return
	add_contribution(medic.mind, amount = 2)
	var/list/contribution_by_mind = list()
	var/total_contribution = 0
	for(var/list/contribution as anything in contributions)
		contribution_by_mind[contribution["mind"]] += contribution["amount"]
		total_contribution += contribution["amount"]

	var/datum/metacoins_controller/controller = get_metacoins_controller()
	var/revival_fund = 10
	for(var/datum/mind/contributor as anything in contribution_by_mind)
		var/share = revival_fund * contribution_by_mind[contributor] / total_contribution
		controller.award_work(contributor, amount = share, category = /datum/metacoin_work_category/medical, source = "revival", reason = "Revival")

/obj/item/shockpaddles/do_help(mob/living/carbon/patient, mob/living/user)
	. = ..()
	var/datum/component/treatment_journal/journal = patient.GetComponent(/datum/component/treatment_journal)
	if(journal && journal.last_revival_time == world.time)
		journal.on_defib_revival(user)
