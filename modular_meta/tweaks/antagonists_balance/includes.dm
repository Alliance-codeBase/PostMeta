#include "code\heretic_armor.dm"
#include "code\mod.dm"
#include "code\uplink_items.dm"
#include "code\malf_ai_modules.dm"

/datum/modpack/antagonists_balance
	id = "antagonists_balance"
	name = "Баланс антагонистов"
	group = "Tweaks"
	desc = "Теперь игроков для объявления войны нужно хотя бы 25, ТК нюкам выдается в зависимости от онлайна (кол-во игроков)*6, т.е. 25 pop = 150 TC и тд. Убирает у Предателя на онлайне ниже 10 - цельки на убийства. Malfunction AI появлется с 20 онлайна, Doomsday device с 25."
	author = "RosSample, Huz2e, Pikita"
