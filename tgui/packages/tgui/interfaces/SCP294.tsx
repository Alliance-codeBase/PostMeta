import { type KeyboardEvent, useEffect, useRef } from 'react';
import type { BooleanLike } from 'tgui-core/react';
import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  input: string;
  message: string;
  coins: number;
  busy: BooleanLike;
  ready: BooleanLike;
};

const ROWS = [
  { keys: '1234567890', x: 229, y: 341 },
  { keys: 'QWERTYUIOP', x: 226, y: 379 },
  { keys: 'ASDFGHJKL', x: 223, y: 417 },
  { keys: 'ZXCVBNM-.', x: 221, y: 456 },
];
const rect = (x: number, y: number, w: number, h: number) => ({
  left: `${((x - 75) / 1048) * 100}%`,
  top: `${((y + 6) / 662) * 100}%`,
  width: `${(w / 1048) * 100}%`,
  height: `${(h / 662) * 100}%`,
});

export const SCP294 = () => {
  const { act, data } = useBackend<Data>();
  const { input = '', message, coins, busy, ready } = data;
  const screen = useRef<HTMLInputElement>(null);
  useEffect(() => screen.current?.focus(), []);

  const press = (key: string) => {
    if (ready && !busy) {
      act('key', { key });
    }
    screen.current?.focus();
  };
  const keyDown = (event: KeyboardEvent<HTMLDivElement>) => {
    if (event.ctrlKey || event.altKey || event.metaKey) {
      return;
    }
    const key = event.key;
    const action =
      key === 'Enter'
        ? 'enter'
        : key === 'Backspace'
          ? 'backspace'
          : key === ' '
            ? 'space'
            : /^[a-z0-9.-]$/i.test(key)
              ? key.toUpperCase()
              : null;
    if (action || key === 'Escape') {
      event.preventDefault();
      event.stopPropagation();
      if (!event.repeat) {
        if (key === 'Escape') {
          act('cancel');
        } else if (action) {
          press(action);
        }
      }
    }
  };
  const keyButton = (key: string, x: number, y: number, w = 31, h = 32) => (
    <button
      key={key}
      type="button"
      className="SCP294__key"
      aria-label={key}
      title={key}
      style={rect(x, y, w, h)}
      disabled={!ready || !!busy}
      onClick={() => press(key)}
    />
  );

  return (
    <Window width={1048} height={696} title="SCP-294">
      <Window.Content fitted className="SCP294">
        <div
          className="SCP294__panel"
          onKeyDown={keyDown}
          role="group"
          aria-label={`SCP-294. ${coins} coins inserted. Three coins per drink.`}
        >
          <img
            className="SCP294__art"
            src={resolveAsset('scp294_panel.png')}
            alt=""
            draggable={false}
          />
          <input
            ref={screen}
            className="SCP294__display"
            style={rect(845, 174, 144, 23)}
            aria-label="Requested drink or machine status"
            value={message || input || 'ENTER NAME HERE'}
            readOnly
            spellCheck={false}
          />
          {ROWS.flatMap((row) =>
            [...row.keys].map((key, index) =>
              keyButton(key, row.x + index * 36.3, row.y),
            ),
          )}
          {keyButton('backspace', 554, 417)}
          {keyButton('enter', 557, 456)}
          {keyButton('space', 221, 497, 367, 32)}
          <button
            type="button"
            className="SCP294__cancel"
            style={rect(893, 307, 109, 34)}
            onClick={() => act('cancel')}
          >
            CANCEL
          </button>
        </div>
      </Window.Content>
    </Window>
  );
};
