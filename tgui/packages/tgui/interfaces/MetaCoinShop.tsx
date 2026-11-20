import {
  Box,
  Button,
  DmIcon,
  Icon,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

type VariantOption = {
  id: string;
  name: string;
};

type VariantOptions = Record<string, VariantOption[]>;

type ShopItem = {
  id: string;
  kind: 'item' | 'other' | 'antag_token' | 'persistent';
  category?: string | null;
  name: string;
  desc: string;
  price: number;
  icon?: string;
  iconState?: string;
  fallbackIcon: string;
  owned: BooleanLike;
  canAfford: BooleanLike;
  variantOptions?: VariantOptions | null;
  autoBuySupported: BooleanLike;
  tokensLeft?: number;
  selectedRoleName?: string | null;
};

type ShopCategory = {
  id: string;
  name: string;
  icon: string;
};

type Data = {
  isPregame: BooleanLike;
  balance: number;
  preroundCategories: ShopCategory[];
  preroundItems: ShopItem[];
  persistentItems: ShopItem[];
  autoBuy: Record<string, string | null>;
};

const renderListingIcon = (item: ShopItem) => {
  const fallbackNode = <Icon name={item.fallbackIcon} size={2} />;

  if (item.icon && item.iconState) {
    return (
      <DmIcon
        icon={item.icon}
        icon_state={item.iconState}
        width="42px"
        height="42px"
        fallback={fallbackNode}
      />
    );
  }

  return fallbackNode;
};

const parseVariant = (variant: string | null | undefined) => {
  if (!variant) {
    return {};
  }

  try {
    return JSON.parse(variant) as Record<string, string>;
  } catch {
    return {};
  }
};

const sortByPrice = (items: ShopItem[]) =>
  [...items].sort((first, second) => first.price - second.price);

type PreroundListingProps = {
  item: ShopItem;
  isPregame: boolean;
  autoBuyEnabled: boolean;
  selectedVariant: string | null | undefined;
  onSelectVariant: (variant: string) => void;
};

const PreroundListing = (props: PreroundListingProps) => {
  const { act } = useBackend<Data>();
  const { item, isPregame, autoBuyEnabled, selectedVariant, onSelectVariant } =
    props;
  const isAntagToken = item.kind === 'antag_token';
  const owned = Boolean(item.owned);
  const canAfford = Boolean(item.canAfford);
  const tokensLeft = item.tokensLeft ?? 0;
  const tokenSoldOut = isAntagToken && tokensLeft <= 0;
  const currentVariant = parseVariant(selectedVariant);

  const buttonDisabled =
    !isPregame || owned || !canAfford || tokenSoldOut || autoBuyEnabled;

  const buttonText = isAntagToken
    ? `Choose Role (${item.price})`
    : `Buy (${item.price})`;

  const buttonAction = () => {
    if (isAntagToken) {
      act('open_antag_token');
      return;
    }

    act('buy_preround', {
      itemId: item.id,
      variant: selectedVariant || null,
    });
  };

  return (
    <Section
      title={item.name}
      buttons={
        <>
          {Boolean(item.autoBuySupported) && (
            <Button.Checkbox
              checked={autoBuyEnabled}
              tooltip="Buy automatically at every roundstart while you can afford it."
              onClick={() =>
                autoBuyEnabled
                  ? act('disable_autobuy', { itemId: item.id })
                  : act('enable_autobuy', {
                      itemId: item.id,
                      variant: selectedVariant || null,
                    })
              }
            >
              Auto-buy
            </Button.Checkbox>
          )}
          <Button
            icon={isAntagToken ? 'user-secret' : 'shopping-cart'}
            disabled={buttonDisabled}
            onClick={buttonAction}
          >
            {buttonText}
          </Button>
        </>
      }
    >
      <Stack>
        <Stack.Item>{renderListingIcon(item)}</Stack.Item>
        <Stack.Item grow>
          <Box>{item.desc}</Box>
          <Box mt={1} color="label">
            Price: {item.price}
          </Box>

          {item.variantOptions &&
            Object.entries(item.variantOptions).map(([groupName, options]) => (
              <Box key={groupName} mt={1}>
                <Box color="label">{groupName}</Box>
                <Box mt={1}>
                  {options.map((option) => (
                    <Button
                      key={option.id}
                      mb={0.5}
                      selected={
                        // linked with default_variant() in _listing.dm: DM buys
                        // the first variant when nothing is picked. change both
                        (currentVariant[groupName] ?? options[0].id) ===
                        option.id
                      }
                      onClick={() =>
                        onSelectVariant(
                          JSON.stringify({
                            ...currentVariant,
                            [groupName]: option.id,
                          }),
                        )
                      }
                    >
                      {option.name}
                    </Button>
                  ))}
                </Box>
              </Box>
            ))}

          {isAntagToken && (
            <Box mt={1} color={tokensLeft > 0 ? 'average' : 'bad'}>
              Tokens left this round: {tokensLeft}
            </Box>
          )}

          {isAntagToken && item.selectedRoleName && owned && (
            <Box mt={1} color="good">
              Reserved role: {item.selectedRoleName}
            </Box>
          )}

          {autoBuyEnabled && !owned && (
            <Box mt={1} color="average">
              Bought automatically at roundstart.
            </Box>
          )}

          {owned && !isAntagToken && (
            <Box mt={1} color="good">
              Already purchased for this round.
            </Box>
          )}

          {owned && isAntagToken && (
            <Box mt={1} color="good">
              Antag token already purchased for this round.
            </Box>
          )}

          {!canAfford && !owned && (
            <Box mt={1} color="bad">
              Not enough metacoins.
            </Box>
          )}

          {tokenSoldOut && !owned && (
            <Box mt={1} color="bad">
              No antag tokens left this round.
            </Box>
          )}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const MetaCoinShop = () => {
  const { act, data } = useBackend<Data>();
  const {
    isPregame,
    balance,
    preroundCategories,
    preroundItems,
    persistentItems,
    autoBuy,
  } = data;

  const [activeTab, setActiveTab] = useLocalState<'preround' | 'persistent'>(
    'metacoinShopTab',
    'preround',
  );

  const [selectedVariants, setSelectedVariants] = useLocalState<
    Record<string, string>
  >('metacoinShopVariants', {});

  const [selectedCategory, setSelectedCategory] = useLocalState<string>(
    'metacoinShopCategory',
    '',
  );

  const itemsByCategory = new Map<ShopItem['category'], ShopItem[]>();
  for (const item of sortByPrice(preroundItems)) {
    const categoryItems = itemsByCategory.get(item.category);
    if (categoryItems) {
      categoryItems.push(item);
    } else {
      itemsByCategory.set(item.category, [item]);
    }
  }
  const filledCategories = preroundCategories
    .map((category) => ({
      category,
      items: itemsByCategory.get(category.id) || [],
    }))
    .filter(({ items }) => items.length > 0);
  const activeEntry =
    filledCategories.find(
      ({ category }) => category.id === selectedCategory,
    ) || filledCategories[0];

  return (
    <Window title="Metacoin Shop" width={780} height={560}>
      <Window.Content scrollable>
        <Section
          title="Balance"
          buttons={
            <Button icon="dice" onClick={() => act('open_slots')}>
              Open Slot Machine
            </Button>
          }
        >
          <Box fontSize="20px" bold color="good">
            {balance}
          </Box>
        </Section>

        <Section fitted>
          <Tabs>
            <Tabs.Tab
              selected={activeTab === 'preround'}
              onClick={() => setActiveTab('preround')}
            >
              Preround shop
            </Tabs.Tab>
            <Tabs.Tab
              selected={activeTab === 'persistent'}
              onClick={() => setActiveTab('persistent')}
            >
              Persistent rewards
            </Tabs.Tab>
          </Tabs>
        </Section>

        {activeTab === 'preround' && (
          <Section
            title="Preround shop"
            buttons={
              <Box color={isPregame ? 'good' : 'bad'}>
                {isPregame
                  ? 'Purchases are open (pregame)'
                  : 'Purchases are closed'}
              </Box>
            }
          >
            {!activeEntry ? (
              <NoticeBox>No items available.</NoticeBox>
            ) : (
              <Stack>
                <Stack.Item>
                  <Tabs vertical>
                    {filledCategories.map(({ category, items }) => (
                      <Tabs.Tab
                        key={category.id}
                        icon={category.icon}
                        selected={category.id === activeEntry.category.id}
                        onClick={() => setSelectedCategory(category.id)}
                      >
                        {`${category.name} (${items.length})`}
                      </Tabs.Tab>
                    ))}
                  </Tabs>
                </Stack.Item>
                <Stack.Divider />
                <Stack.Item grow>
                  <Stack vertical>
                    {activeEntry.items.map((item) => {
                      const autoBuyEnabled = item.id in autoBuy;
                      return (
                        <Stack.Item key={item.id}>
                          <PreroundListing
                            item={item}
                            isPregame={Boolean(isPregame)}
                            autoBuyEnabled={autoBuyEnabled}
                            selectedVariant={
                              autoBuyEnabled
                                ? autoBuy[item.id]
                                : selectedVariants[item.id]
                            }
                            onSelectVariant={(variant) =>
                              autoBuyEnabled
                                ? act('enable_autobuy', {
                                    itemId: item.id,
                                    variant,
                                  })
                                : setSelectedVariants({
                                    ...selectedVariants,
                                    [item.id]: variant,
                                  })
                            }
                          />
                        </Stack.Item>
                      );
                    })}
                  </Stack>
                </Stack.Item>
              </Stack>
            )}
          </Section>
        )}

        {activeTab === 'persistent' && (
          <Section
            title="Persistent rewards"
            buttons={
              <Button
                icon="cog"
                tooltip="Configure"
                onClick={() => act('open_settings')}
              >
                Settings
              </Button>
            }
          >
            {!persistentItems.length ? (
              <NoticeBox>No persistent rewards available.</NoticeBox>
            ) : (
              <Stack vertical>
                {sortByPrice(persistentItems).map((item) => {
                  const owned = Boolean(item.owned);
                  const canAfford = Boolean(item.canAfford);
                  const buttonDisabled = owned || !canAfford;

                  return (
                    <Stack.Item key={item.id}>
                      <Section
                        title={item.name}
                        buttons={
                          <Button
                            icon={owned ? 'check' : 'shopping-cart'}
                            disabled={buttonDisabled}
                            onClick={() =>
                              act('buy_persistent', {
                                itemId: item.id,
                              })
                            }
                          >
                            Buy ({item.price})
                          </Button>
                        }
                      >
                        <Stack>
                          <Stack.Item>{renderListingIcon(item)}</Stack.Item>
                          <Stack.Item grow>
                            <Box>{item.desc}</Box>
                            <Box mt={1} color="label">
                              Price: {item.price}
                            </Box>

                            {owned && (
                              <Box mt={1} color="good">
                                Already owned.
                              </Box>
                            )}

                            {!canAfford && !owned && (
                              <Box mt={1} color="bad">
                                Not enough metacoins.
                              </Box>
                            )}
                          </Stack.Item>
                        </Stack>
                      </Section>
                    </Stack.Item>
                  );
                })}
              </Stack>
            )}
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
