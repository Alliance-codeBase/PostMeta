// THIS IS A MASSMETA UI FILE
import { useBackend } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';

import {
  type FeatureChoiced,
  type FeatureChoicedServerData,
  type FeatureNumeric,
  FeatureSliderInput,
  type FeatureValueProps,
} from '../base';
import { FeatureDropdownInput } from '../dropdowns';

function FeatureBlooperDropdownInput(
  props: FeatureValueProps<string, string, FeatureChoicedServerData>,
) {
  const { act } = useBackend();

  return (
    <Stack>
      <Stack.Item grow>
        <FeatureDropdownInput {...props} />
      </Stack.Item>
      {/* hear yourself before the crew does */}
      <Stack.Item>
        <Button
          onClick={() => {
            act('play_blooper');
          }}
          icon="play"
          width="100%"
          height="100%"
        />
      </Stack.Item>
    </Stack>
  );
}

export const blooper: FeatureChoiced = {
  name: 'Blooper',
  component: FeatureBlooperDropdownInput,
};

export const blooper_pitch: FeatureNumeric = {
  name: 'Blooper Pitch',
  component: FeatureSliderInput,
};
