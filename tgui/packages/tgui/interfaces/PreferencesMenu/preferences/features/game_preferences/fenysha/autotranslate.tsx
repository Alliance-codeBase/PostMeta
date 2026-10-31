import type { FeatureChoiced } from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

/**
 * The exported name has to match the savefile_key on
 * /datum/preference/choiced/autotranslate_target, or GamePreferencesPage
 * renders "...is not filled out properly!!!" instead of a control.
 *
 * See fenysha_events/code/modules/autotranslate/preferences.dm
 */
export const autotranslate_target: FeatureChoiced = {
  name: 'Auto-translate speech',
  category: 'TRANSLATION',
  description:
    'Translates say and radio messages from other players into the chosen \
language. The original is shown first, underlined, and swaps over once the \
translation arrives - hover a translated line to see what was actually said. \
Machine translation, so expect rough edges.',
  component: FeatureDropdownInput,
};
