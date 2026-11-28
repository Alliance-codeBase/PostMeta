/// the picker's lowest pitch, a bare path::var after a minus trips the parser, hence the brackets
#define BLOOPER_PITCH_MINIMUM (/datum/preference/numeric/blooper_pitch::minimum)
/// the picker's highest pitch
#define BLOOPER_PITCH_MAXIMUM (/datum/preference/numeric/blooper_pitch::maximum)
/// the picker's pitch step
#define BLOOPER_PITCH_STEP (/datum/preference/numeric/blooper_pitch::step)
/// pitches the picker offers, 0.5 to 2 by 0.1 makes 16
#define BLOOPER_PITCH_STEPS (round((BLOOPER_PITCH_MAXIMUM - BLOOPER_PITCH_MINIMUM) / BLOOPER_PITCH_STEP, 1) + 1)
/// the pitch at a step, counted from 1 like dna blocks count
#define BLOOPER_PITCH_AT_STEP(step) (BLOOPER_PITCH_MINIMUM + ((step) - 1) * BLOOPER_PITCH_STEP)
