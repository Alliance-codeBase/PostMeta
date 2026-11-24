## Module ID: blooper

### Description:

Добавляет бипер.

### Как добавить голос:

1. `python modular_meta/tools/blooper_sound.py путь/к/звуку.ogg quack` кладёт в `sound/` чистый `quack.ogg` и его копии `quack_muffled.ogg` (противогаз), `quack_radio.ogg` (рация) и `quack_radio_muffled.ogg` (рация в противогазе), все на одной громкости. Нужен ffmpeg.
2. Датум `/datum/blooper/quack` в `code/blooper_list.dm` со всеми четырьмя файлами.
3. Строчка в `attributions.txt`: откуда звук и под какой лицензией.

### TG Proc/File Changes:

- code/game/machinery/telecomms/broadcasting.dm: `/datum/signal/subspace/vocal/broadcast()` bloops over the radio

### TGUI Files:

- tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/character_preferences/blooper.tsx
- tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/game_preferences/blooper_volume.tsx
