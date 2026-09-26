/*
 * Это основной файл куда будут складываться все наши НОВЫЕ модульные добавления.
 *
 * Добавлять только: модули (.dm файлами)
 *
 * Сам этот файл добавлен в tgstation.dme
 *
 * Все Defines файлы лежат в папке "~meta_defines\"
 *
 * Все файлы должны быть в алфавитном порядке
 */


//master files (unsorted, TODO: need modularization)

// AutoTranslate Module
#include "code/modules/autotranslate/_autotranslate.dm"
#include "code/modules/autotranslate/config.dm"
#include "code/modules/autotranslate/debug.dm"
#include "code/modules/autotranslate/hear.dm"
#include "code/modules/autotranslate/libretranslate.dm"
#include "code/modules/autotranslate/preferences.dm"
#include "code/modules/autotranslate/provider.dm"
#include "code/modules/autotranslate/runechat.dm"
#include "code/modules/autotranslate/SSautotranslate.dm"
#include "code/modules/autotranslate/text_morph.dm"
#include "code/modules/autotranslate/translated_speech.dm"

#include "code\obj\items\clothing\belt.dm"
#include "code\datums\components\crafting\weapon_ammo.dm"
#include "code\modules\ammunition\ballistic\shotgun.dm"
#include "code\modules\projectiles\projectile\bullets\shotgun.dm"
#include "code\modules\map_vote.dm"
