// All new mod's includes here
// Some modules can be easy excludes from code compile sequence by commenting #define you need to remove in code\__DEFINES\__meta_modpaks_includes.dm
// Keep in mind, that module may not be only in modular folder but also embedded directly in TG code and covered with #ifdef - #endif structure

#include "__modpack\assets_modpacks.dm"
#include "__modpack\modpack.dm" //modpack obj
#include "__modpack\modpacks_subsystem.dm" //actually mods subsystem + tgui in "tgui/packages/tgui/interfaces/Modpacks.tsx"

/* --FEATURES-- */

#include "features\additional_circuit\includes.dm"
#include "features\antagonists\includes.dm"
#if CHEBUREK_CAR
	#include "features\cheburek_car\includes.dm"
#endif
#include "features\uplink_items\includes.dm"
#include "features\venom_knife\includes.dm"
#include "features\clown_traitor_sound\includes.dm"
#include "features\woodgen\includes.dm"
#include "features\not_enough_medical\includes.dm"
#include "features\more_cell_interactions\includes.dm"
#include "features\new_emotes\includes.dm"
#include "features\makeshift_grenade_trap\includes.dm"
#include "features\tier5\includes.dm"
#include "features\copytech\includes.dm"
#include "features\cargo_teleporter\includes.dm"
/* -- REVERTS -- */

#include "reverts\revert_glasses_protect_welding\includes.dm"

/* --TRANSLATIONS-- */

#include "ru_translate\ru_ai_laws\includes.dm"

#if RU_CRAYONS
	#include "ru_translate\ru_crayons\includes.dm"
#endif
#include "ru_translate\ru_tweak_say_fonts\includes.dm"
#if RU_VENDORS
	#include "ru_translate\ru_vendors\includes.dm"
#endif

