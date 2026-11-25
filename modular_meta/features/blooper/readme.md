## Module ID: blooper

### Description:

Добавляет бипер.

### Как добавить голос:

1. Прогони звук через [blooper_sound.py](../../tools/blooper_sound.py), нужен ffmpeg. Скрипт кладёт в [sound/](sound/) чистый `quack.ogg` и его копии `quack_muffled.ogg` (противогаз), `quack_radio.ogg` (рация) и `quack_radio_muffled.ogg` (рация в противогазе), все на одной громкости. Тишину в начале срезает сам.
	- Обычный звук: `python modular_meta/tools/blooper_sound.py sound/effects/quack.ogg quack`
	- Длинный, вроде крика, режь флагом `--length`, останутся первые 0.3 секунды с затуханием: `python modular_meta/tools/blooper_sound.py --length 0.3 sound/mobs/humanoids/human/scream/malescream_1.ogg malescream_1`
2. Добавь датум в [code/blooper_list.dm](code/blooper_list.dm):
	- Один звук: скопируй `/datum/blooper/quack`.
	- Коллекция, где каждая фраза берёт один случайный голос из списка: скопируй `/datum/blooper_collection/random_meow` и перечисли в `bloopers` датумы голосов, как `/datum/blooper/cat_meow1`.
3. Допиши в [attributions.txt](attributions.txt), откуда звук и под какой лицензией.

### TG Proc/File Changes:

- code/game/machinery/telecomms/broadcasting.dm: `/datum/signal/subspace/vocal/broadcast()` bloops over the radio

### TGUI Files:

- tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/character_preferences/blooper.tsx
- tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/game_preferences/blooper_volume.tsx
