/// the voice, scramble the genes and the squeak goes with them
/datum/dna_block/identity/blooper

/datum/dna_block/identity/blooper/create_unique_block(mob/living/carbon/human/target)
	// nobody picked a voice yet, the genes roll one like a fresh body's hair
	if(isnull(target.blooper))
		return construct_block(rand(1, length(GLOB.blooper_voices)), length(GLOB.blooper_voices))
	return construct_block(GLOB.blooper_voices.Find(target.blooper), length(GLOB.blooper_voices))

/datum/dna_block/identity/blooper/apply_to_mob(mob/living/carbon/human/target, dna_hash)
	target.blooper = GLOB.blooper_voices[deconstruct_block(get_block(dna_hash), length(GLOB.blooper_voices))]

/// the pitch, in the picker's steps
/datum/dna_block/identity/blooper_pitch

/datum/dna_block/identity/blooper_pitch/create_unique_block(mob/living/carbon/human/target)
	var/pitch_step = round((target.blooper_pitch - BLOOPER_PITCH_MINIMUM) / BLOOPER_PITCH_STEP, 1) + 1
	// a vv'd pitch past the picker would spill out of the block and shift every block after it
	return construct_block(min(pitch_step, BLOOPER_PITCH_STEPS), BLOOPER_PITCH_STEPS)

/datum/dna_block/identity/blooper_pitch/apply_to_mob(mob/living/carbon/human/target, dna_hash)
	target.blooper_pitch = BLOOPER_PITCH_AT_STEP(deconstruct_block(get_block(dna_hash), BLOOPER_PITCH_STEPS))

/// a new voice for a human, the genes hear about it too or the next updateappearance takes it back
/mob/living/carbon/human/proc/set_blooper(new_blooper)
	blooper = new_blooper
	dna.update_ui_block(/datum/dna_block/identity/blooper)

/// a new pitch for a human, the genes hear about it too
/mob/living/carbon/human/proc/set_blooper_pitch(new_blooper_pitch)
	blooper_pitch = new_blooper_pitch
	dna.update_ui_block(/datum/dna_block/identity/blooper_pitch)

/mob/living/carbon/human/copy_blooper_from(mob/living/carbon/human/source)
	. = ..()
	// a clone got the squeak with the dna already, re-rolling the block would change its fingerprints
	if(source.dna.unique_identity == dna.unique_identity)
		return
	// the genes learn the borrowed squeak, or the next updateappearance takes it back
	dna.update_ui_block(/datum/dna_block/identity/blooper)
	dna.update_ui_block(/datum/dna_block/identity/blooper_pitch)
