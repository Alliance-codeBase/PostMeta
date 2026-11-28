// THIS IS A MASSMETA UI FILE
import { type Feature, FeatureSliderInput } from '../base';

export const sound_blooper_volume: Feature<number> = {
  name: 'Blooper volume',
  category: 'SOUND',
  description: 'The volume of the bloops characters speak with.',
  component: FeatureSliderInput,
};
