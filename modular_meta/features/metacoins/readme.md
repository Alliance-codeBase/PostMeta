## Module ID: metacoins

### Description:

Meta currency for useful work in the round. Spent in the preround shop and on tips.

Want to sell something? Copy, paste, profit:
- code\items\_listing.dm - every hook a listing can override, with notes
- code\items\preround.dm, the commented block on top - on_bought, bought_on_spawn and variants for preround and persistent listings
- code\items\preround.dm, eva_kit - filling a box with set up items, the old way and the tg way
- code\items\preround.dm, donk_pockets - variants
- code\items\preround_leisure.dm, butt - an "other" listing that installs an organ instead of handing out an item, and refusing a purchase
- code\items\preround_skillchips.dm, skillchip - implanting into the body and refunding when it fails
- code\items\persistent.dm, the commented block on top - checking whether a persistent reward is bought

### TG Proc/File Changes:

code\datums\achievements_awards.dm - 94 - 99 - every achievement gives you some coins!
tgui\packages\tgui\interfaces\DeathmatchPanel.tsx
tgui\packages\tgui\interfaces\DeathmatchLobby.tsx - those two are for paid matches :D
code\modules\deathmatch\deathmatch_controller.dm -
code\modules\escape_menu\escape_menu.dm - tip button
tgui\packages\tgui-escape-menu\pages\HomePage.tsx - tip button
modular_meta\features\mentors\code\mentorpm.dm - tip link on mentor answers

### Modular Overrides:

- /obj/item/shockpaddles/do_help
- /turf/ChangeTurf
- /turf/open/build_with_floor_tiles
- /obj/machinery/mineral/ore_redemption/base_item_interaction, pickup_item
- /obj/machinery/computer/piratepad_control/civilian/send
- /datum/admin_help/Close, Resolve

### Defines:

-

### TGUI Files:

- tgui\packages\tgui\interfaces\MetaCoinAntagToken.tsx
- tgui\packages\tgui\interfaces\MetaCoins.tsx
- tgui\packages\tgui\interfaces\MetaCoinShop.tsx
- tgui\packages\tgui\interfaces\MetaCoinTips.tsx
- tgui\packages\tgui\interfaces\MetaCoinSlot.tsx
- tgui\packages\tgui\styles\interfaces\MetaCoinSlot.scss

### Credits:

-
