import { useState } from 'react';
import {
  Button,
  Input,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type Character = {
  name: string;
  ref: string;
};

type Data = {
  players: string[];
  characters: Character[];
};

export const MetaCoinTips = () => {
  const { act, data } = useBackend<Data>();
  const { players, characters } = data;
  const [search, setSearch] = useState('');
  const query = search.toLowerCase();
  const ckeyQuery = query.replace(/[^a-z0-9]/g, '');
  const shownPlayers = players.filter((player) => player.includes(ckeyQuery));
  const shownCharacters = characters.filter((character) =>
    character.name.toLowerCase().includes(query),
  );

  return (
    <Window title="Tip" width={420} height={520}>
      <Window.Content scrollable>
        <Section>
          <Stack>
            <Stack.Item grow>
              <Input
                fluid
                placeholder="Search by character name or ckey"
                value={search}
                onChange={setSearch}
              />
            </Stack.Item>
            <Stack.Item>
              <Button icon="crosshairs" onClick={() => act('pick_on_screen')}>
                Pick on screen
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
        <Section title="Characters">
          {shownCharacters.length === 0 ? (
            <NoticeBox>No characters found.</NoticeBox>
          ) : (
            <Table>
              {shownCharacters.map((character) => (
                <Table.Row key={character.ref}>
                  <Table.Cell>{character.name}</Table.Cell>
                  <Table.Cell collapsing>
                    <Button
                      icon="coins"
                      onClick={() =>
                        act('tip_character', { ref: character.ref })
                      }
                    >
                      Tip
                    </Button>
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          )}
        </Section>
        <Section title="Players">
          {shownPlayers.length === 0 ? (
            <NoticeBox>No players found.</NoticeBox>
          ) : (
            <Table>
              {shownPlayers.map((player) => (
                <Table.Row key={player}>
                  <Table.Cell>{player}</Table.Cell>
                  <Table.Cell collapsing>
                    <Button
                      icon="coins"
                      onClick={() => act('tip_player', { ckey: player })}
                    >
                      Tip
                    </Button>
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
