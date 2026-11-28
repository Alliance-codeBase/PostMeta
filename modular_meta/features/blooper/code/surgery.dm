#define OPERATION_NEW_BLOOPER "chosen_blooper"
#define OPERATION_NEW_BLOOPER_PITCH "chosen_blooper_pitch"

/// plastic surgery for the squeak, a new voice and pitch
/datum/surgery_operation/limb/blooper_reshape
	name = "vocal cord reshaping"
	desc = "Reshape a patient's vocal cords, changing the timbre and pitch of their voice."
	implements = list(
		TOOL_HEMOSTAT = 1,
	)
	time = 6.4 SECONDS
	operation_flags = OPERATION_AFFECTS_MOOD | OPERATION_NOTABLE
	success_sound = 'sound/items/handling/surgery/hemostat1.ogg'
	all_surgery_states_required = SURGERY_SKIN_OPEN
	// the hemostat clamps bleeders first, or every head clamp asks which one you meant
	any_surgery_states_blocked = SURGERY_VESSELS_UNCLAMPED

/datum/surgery_operation/limb/blooper_reshape/all_required_strings()
	return list("operate on head (target head)") + ..()

/datum/surgery_operation/limb/blooper_reshape/get_default_radial_image()
	return get_generic_limb_radial_image(BODY_ZONE_PRECISE_MOUTH)

/datum/surgery_operation/limb/blooper_reshape/state_check(obj/item/bodypart/limb)
	// the squeak lives in a human's dna, xenos and loose heads have none
	return limb.body_zone == BODY_ZONE_HEAD && ishuman(limb.owner)

/datum/surgery_operation/limb/blooper_reshape/pre_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	var/mob/living/carbon/human/patient = limb.owner
	var/datum/preference/choiced/blooper/blooper_preference = GLOB.preference_entries[/datum/preference/choiced/blooper]
	operation_args[OPERATION_NEW_BLOOPER] = tgui_input_list(surgeon, "New voice to tune the cords to", "Vocal Cord Reshaping", blooper_preference.get_choices(), patient.blooper)
	if(!operation_args[OPERATION_NEW_BLOOPER])
		return FALSE
	var/new_pitch = tgui_input_number(surgeon, "New pitch, [BLOOPER_PITCH_MINIMUM] to [BLOOPER_PITCH_MAXIMUM]", "Vocal Cord Reshaping", patient.blooper_pitch, BLOOPER_PITCH_MAXIMUM, BLOOPER_PITCH_MINIMUM, round_value = FALSE)
	if(isnull(new_pitch))
		return FALSE
	// the cords only take the picker's steps
	operation_args[OPERATION_NEW_BLOOPER_PITCH] = round(new_pitch, BLOOPER_PITCH_STEP)
	return TRUE

/datum/surgery_operation/limb/blooper_reshape/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("You begin to retune [limb.owner]'s vocal cords..."),
		span_notice("[surgeon] begins to retune [limb.owner]'s vocal cords."),
		span_notice("[surgeon] begins to work on [limb.owner]'s throat."),
	)
	display_pain(limb.owner, "You feel something tugging at your throat!")

/datum/surgery_operation/limb/blooper_reshape/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	var/mob/living/carbon/human/patient = limb.owner
	patient.set_blooper(operation_args[OPERATION_NEW_BLOOPER])
	patient.set_blooper_pitch(operation_args[OPERATION_NEW_BLOOPER_PITCH])
	display_results(
		surgeon,
		patient,
		span_notice("You retune [patient]'s vocal cords to [operation_args[OPERATION_NEW_BLOOPER]]."),
		span_notice("[surgeon] retunes [patient]'s vocal cords!"),
		span_notice("[surgeon] finishes the operation on [patient]'s throat."),
	)
	display_pain(patient, "The tugging stops, your throat feels new and unfamiliar.")

/datum/surgery_operation/limb/blooper_reshape/on_failure(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	var/mob/living/carbon/human/patient = limb.owner
	// botched cords squeak however they like
	patient.set_blooper(pick(GLOB.blooper_voices))
	patient.set_blooper_pitch(BLOOPER_PITCH_AT_STEP(rand(1, BLOOPER_PITCH_STEPS)))
	display_results(
		surgeon,
		patient,
		span_warning("You slip, leaving [patient]'s vocal cords in a tangle!"),
		span_warning("[surgeon] slips, tangling [patient]'s vocal cords!"),
		span_notice("[surgeon] finishes the operation on [patient]'s throat."),
	)
	display_pain(patient, "Your throat spasms, your voice feels all wrong!")

#undef OPERATION_NEW_BLOOPER
#undef OPERATION_NEW_BLOOPER_PITCH
