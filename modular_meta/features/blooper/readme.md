## Module ID: blooper

### Description:

Добавляет бипер.

### Как добавить голос:

1. Прогони звук через [blooper_sound.py](../../tools/blooper_sound.py), нужен ffmpeg. Скрипт кладёт в [sound/](sound/) чистый `squeak.ogg` и его копии `squeak_muffled.ogg` (противогаз), `squeak_radio.ogg` (рация) и `squeak_radio_muffled.ogg` (рация в противогазе), все на одной громкости. Тишину в начале срезает сам. Имя бери из названия голоса в меню: `Male Scream 1` становится `male_scream_1`, так же называй и датум.
	- Обычный звук: `python modular_meta/tools/blooper_sound.py sound/items/toy_squeak/toysqueak1.ogg squeak`
	- Длинный, вроде крика, режь флагом `--length`, останутся первые 0.3 секунды с затуханием: `python modular_meta/tools/blooper_sound.py --length 0.3 sound/mobs/humanoids/human/scream/malescream_1.ogg male_scream_1`
2. Добавь датум в [code/blooper_list.dm](code/blooper_list.dm):
	- Один звук: скопируй `/datum/blooper/squeak`.
	- Коллекция, где каждая фраза берёт один случайный голос из списка: скопируй `/datum/blooper_collection/cat_meow_random` и перечисли в `bloopers` датумы голосов, как `/datum/blooper/cat_meow_1`.
3. Допиши в [attributions.txt](attributions.txt), откуда звук и под какой лицензией.

### TG Proc/File Changes:

- code/game/machinery/telecomms/broadcasting.dm: `/datum/signal/subspace/vocal/broadcast()` bloops over the radio

### TGUI Files:

- tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/character_preferences/blooper.tsx
- tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/game_preferences/blooper_volume.tsx
