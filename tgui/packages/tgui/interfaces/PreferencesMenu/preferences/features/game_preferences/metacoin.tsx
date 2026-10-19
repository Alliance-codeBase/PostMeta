import type { Feature } from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const metacoin_notify: Feature<string> = {
  name: 'Reward notifications',
  category: 'Metacoins',
  component: FeatureDropdownInput,
};
