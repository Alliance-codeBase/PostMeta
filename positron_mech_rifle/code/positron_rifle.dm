// ============================================================================
// ПОЗИТРОННАЯ ВИНТОВКА ДЛЯ МЕХА (PR-1)
// Путь: modular_meta/features/positron_mech_rifle/code/positron_rifle.dm
//
// - Боезапас: ОДНА позитронная батарея = ОДИН выстрел
// - Ctrl+клик          -> накопление заряда (полоска над мехом; повторно - остановить)
// - обычный клик       -> выстрел (чем выше заряд, тем сильнее урон)
// - Луч пробивает всё (стены, мебель, машины...), кроме живых мобов и мехов
// - Голосовой помощник сообщает пилоту о состоянии оружия
// ============================================================================

#define POSITRON_MAX_CHARGE 3
#define POSITRON_CHARGE_TIME (1.5 SECONDS) // сколько копится один "уровень" заряда
#define POSITRON_CHARGE_TICK (0.25 SECONDS) // шаг обновления полоски
#define POSITRON_BASE_DAMAGE 40
#define POSITRON_DAMAGE_PER_CHARGE 25
// Эффекты полного заряда (на цели)
#define POSITRON_BLIND_TIME (6 SECONDS)
#define POSITRON_BLUR_TIME (12 SECONDS)
#define POSITRON_FIRE_STACKS 4
#define POSITRON_KNOCKBACK_RANGE 5
#define POSITRON_KNOCKBACK_SPEED 2
// Отдача меха: 1 клетка от обычного усиленного выстрела, 2 клетки от полного заряда
#define POSITRON_RECOIL_STEP_DELAY (0.15 SECONDS)
/// Полный заряд (с запасом на дробные значения)
#define POSITRON_IS_FULL_CHARGE(level) ((level) >= (POSITRON_MAX_CHARGE - 0.01))

// --- ЗВУКИ: поменяй пути на свои файлы -------------------------------------
#define POSITRON_SND_FIRE 'modular_meta/features/positron_mech_rifle/sound/positron_fire.ogg'
#define POSITRON_SND_FIRE_CHARGED 'modular_meta/features/positron_mech_rifle/sound/positron_fire_charged.ogg'
#define POSITRON_SND_BEAM 'modular_meta/features/positron_mech_rifle/sound/positron_beam.ogg'
#define POSITRON_SND_HIT_WALL 'modular_meta/features/positron_mech_rifle/sound/positron_hit_wall.ogg'
#define POSITRON_SND_HIT_MOB 'modular_meta/features/positron_mech_rifle/sound/positron_hit_mob.ogg'
#define POSITRON_SND_INSERT 'modular_meta/features/positron_mech_rifle/sound/positron_insert.ogg'
#define POSITRON_SND_EJECT 'modular_meta/features/positron_mech_rifle/sound/positron_eject.ogg' // выход батареи + падение на пол

// --- ГОЛОС ПОМОЩНИКА: твои реплики (.ogg) ---------------------------------
#define POSITRON_VOICE_BATTERY_LOADED 'modular_meta/features/positron_mech_rifle/voice/battery_loaded.ogg' // батарея установлена, орудие готово
#define POSITRON_VOICE_NO_BATTERY 'modular_meta/features/positron_mech_rifle/voice/no_battery.ogg' // боезапас отсутствует
#define POSITRON_VOICE_CHARGE_START 'modular_meta/features/positron_mech_rifle/voice/charge_start.ogg' // зарядка начата
#define POSITRON_VOICE_CHARGE_MAX 'modular_meta/features/positron_mech_rifle/voice/charge_max.ogg' // максимальный заряд
#define POSITRON_VOICE_CHARGE_STOP 'modular_meta/features/positron_mech_rifle/voice/charge_stop.ogg' // зарядка остановлена
#define POSITRON_VOICE_FIRED 'modular_meta/features/positron_mech_rifle/voice/fired.ogg' // выстрел
#define POSITRON_VOICE_FIRED_CHARGED 'modular_meta/features/positron_mech_rifle/voice/fired_charged.ogg' // усиленный выстрел
#define POSITRON_VOICE_BATTERY_SPENT 'modular_meta/features/positron_mech_rifle/voice/battery_spent.ogg' // отработанная батарея извлечена
#define POSITRON_VOICE_BATTERY_REMOVED 'modular_meta/features/positron_mech_rifle/voice/battery_removed.ogg' // батарея извлечена вручную / при снятии орудия
#define POSITRON_VOICE_VOLUME 80

// ============================================================================
// БАТАРЕЯ
// ============================================================================
/obj/item/positron_battery
	name = "позитронная батарея"
	desc = "Одноразовая батарея с нестабильной позитронной материей. Рассчитана ровно на один выстрел."
	icon = 'modular_meta/features/positron_mech_rifle/icons/positron_rifle.dmi' // TODO: свой дмик
	icon_state = "positron_battery"
	w_class = WEIGHT_CLASS_NORMAL
	/// Использована ли батарея
	var/spent = FALSE

/obj/item/positron_battery/proc/mark_spent()
	spent = TRUE
	name = "разряженная позитронная батарея"
	desc = "Выгоревшая позитронная батарея. Больше ни на что не годится."
	icon_state = "positron_battery_spent"
	update_appearance()

/obj/item/positron_battery/examine(mob/user)
	. = ..()
	. += span_notice("Её можно вставить в меха, на котором установлена позитронная винтовка.")

/// Использование батареи на меха = попытка зарядить винтовку
/obj/item/positron_battery/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!ismecha(interacting_with))
		return NONE
	var/obj/vehicle/sealed/mecha/mech = interacting_with
	for(var/obj/item/mecha_parts/mecha_equipment/weapon/positron_rifle/rifle in mech.flat_equipment)
		if(rifle.load_battery(src, user))
			return ITEM_INTERACT_SUCCESS
		return ITEM_INTERACT_BLOCKING
	return NONE

// ============================================================================
// ВИНТОВКА
// Выстрел делает базовый /weapon/action() (снаряд, прицел, лог, кулдаун, kickback).
// Мы только: проверяем батарею, выставляем звук, считаем заряд, выбрасываем батарею.
// ============================================================================
/obj/item/mecha_parts/mecha_equipment/weapon/positron_rifle
	name = "PR-1 \"Позитронная винтовка\""
	desc = "Тяжёлое энергетическое орудие для мехов. Выстреливает позитронным лучом, \
		пробивающим любые препятствия, но задерживаемым живыми целями. \
		Использует одну позитронную батарею на выстрел. Ctrl+клик - зарядить, клик - выстрелить. \
		Усиленный выстрел отбрасывает мех назад. Полный заряд ослепляет, поджигает и отбрасывает цель, \
		а боргов и мехов выводит из строя электромагнитным импульсом."
	icon_state = "mecha_laser" // TODO: свой спрайт
	equip_cooldown = 2 SECONDS
	energy_drain = 0
	projectile = /obj/projectile/beam/positron
	fire_sound = POSITRON_SND_FIRE
	firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect/blue
	harmful = TRUE
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5)
	/// Установленная батарея
	var/obj/item/positron_battery/battery
	/// Накопленный заряд в децисекундах (0 .. POSITRON_MAX_CHARGE * POSITRON_CHARGE_TIME)
	var/charge_progress = 0
	/// Идёт ли сейчас накопление заряда
	var/charging = FALSE
	var/charge_timer
	/// Выстрел сделан, ждём выброса батареи
	var/shot_fired = FALSE
	/// Заряд последнего выстрела в "уровнях" (дробное число; читается снарядом в fire())
	var/last_shot_level = 0
	/// Стандартная полоска прогресса (/datum/progressbar): видна только пилоту, рисуется над мехом
	var/datum/progressbar/charge_bar
	/// Пилот, который запустил зарядку (ему показываем полоску)
	var/mob/charge_user

/obj/item/mecha_parts/mecha_equipment/weapon/positron_rifle/Destroy()
	if(charge_timer)
		deltimer(charge_timer)
	hide_bar()
	charge_user = null
	QDEL_NULL(battery)
	return ..()

/obj/item/mecha_parts/mecha_equipment/weapon/positron_rifle/examine(mob/user)
	. = ..()
	. += span_notice("Батарея: [battery ? "установлена" : "отсутствует"].")

/// Винтовку снимают с меха - батарея вылетает (родительский detach из weapons.dm сохраняем)
/obj/item/mecha_parts/mecha_equipment/weapon/positron_rifle/detach(atom/moveto)
	stop_charging(silent = TRUE)
	// Полоску убираем ДО parent: он обнуляет chassis
	hide_bar()
	eject_battery(voice = FALSE)
	shot_fired = FALSE
	return ..()

// --- Голос помощника (реплики .ogg, слышит только пилот) --------------------
/obj/item/mecha_parts/mecha_equipment/weapon/positron_rifle/proc/announce(voice_line)
	if(!chassis || !voice_line)
		return
	for(var/mob/occupant as anything in chassis.occupants)
		occupant.playsound_local(get_turf(chassis), voice_line, POSITRON_VOICE_VOLUME, FALSE)

// --- Полоска заряда ---------------------------------------------------------
/obj/item/mecha_parts/mecha_equipment/weapon/positron_rifle/proc/update_bar()
	// Полоска нужна, пока идёт зарядка или заряд заморожен (>0), и только пока пилот в мехе
	if(!chassis || !charge_user || !(charge_user in chassis.occupants) || (!charging && charge_progress <= 0))
		hide_bar()
		return
	if(charge_bar && charge_bar.user != charge_user)
		hide_bar()
	if(!charge_bar)
		charge_bar = new /datum/progressbar(charge_user, POSITRON_MAX_CHARGE * POSITRON_CHARGE_TIME, chassis)
	charge_bar.update(charge_progress)

/obj/item/mecha_parts/mecha_equipment/weapon/positron_rifle/proc/hide_bar()
	QDEL_NULL(charge_bar)

// --- Установка / извлечение батареи ----------------------------------------
/obj/item/mecha_parts/mecha_equipment/weapon/positron_rifle/proc/load_battery(obj/item/positron_battery/new_battery, mob/user)
	if(battery || shot_fired)
		to_chat(user, span_warning("В винтовке уже стоит батарея!"))
		return FALSE
	if(new_battery.spent)
		to_chat(user, span_warning("Эта батарея разряжена."))
		return FALSE
	if(!user.transferItemToLoc(new_battery, src))
		return FALSE
	battery = new_battery
	charge_progress = 0
	playsound(chassis || src, POSITRON_SND_INSERT, 60, TRUE)
	to_chat(user, span_notice("Вы вставляете [new_battery] в [src]."))
	announce(POSITRON_VOICE_BATTERY_LOADED)
	return TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/positron_rifle/proc/eject_battery(voice = TRUE)
	if(!battery)
		return
	var/obj/item/positron_battery/old_battery = battery
	battery = null
	charge_progress = 0
	update_bar()
	old_battery.forceMove(get_turf(chassis || src))
	old_battery.pixel_x = old_battery.base_pixel_x + rand(-8, 8)
	old_battery.pixel_y = old_battery.base_pixel_y + rand(-8, 8)
	playsound(old_battery, POSITRON_SND_EJECT, 60, TRUE)
	if(voice)
		announce(POSITRON_VOICE_BATTERY_REMOVED)

// --- Накопление заряда (Ctrl+клик) -----------------------------------------
/obj/item/mecha_parts/mecha_equipment/weapon/positron_rifle/proc/toggle_charge(mob/user)
	if(!battery || shot_fired)
		announce(POSITRON_VOICE_NO_BATTERY)
		return
	if(charging)
		stop_charging()
		return
	if(charge_progress >= POSITRON_MAX_CHARGE * POSITRON_CHARGE_TIME)
		announce(POSITRON_VOICE_CHARGE_MAX)
		return
	charging = TRUE
	charge_user = user
	announce(POSITRON_VOICE_CHARGE_START)
	update_bar()
	charge_timer = addtimer(CALLBACK(src, PROC_REF(charge_tick)), POSITRON_CHARGE_TICK, TIMER_STOPPABLE)

/obj/item/mecha_parts/mecha_equipment/weapon/positron_rifle/proc/charge_tick()
	charge_timer = null
	if(!charging || !battery || shot_fired || !chassis)
		stop_charging(silent = TRUE)
		return
	charge_progress = min(charge_progress + POSITRON_CHARGE_TICK, POSITRON_MAX_CHARGE * POSITRON_CHARGE_TIME)
	update_bar()
	if(charge_progress >= POSITRON_MAX_CHARGE * POSITRON_CHARGE_TIME)
		charging = FALSE
		announce(POSITRON_VOICE_CHARGE_MAX)
		return
	charge_timer = addtimer(CALLBACK(src, PROC_REF(charge_tick)), POSITRON_CHARGE_TICK, TIMER_STOPPABLE)

/obj/item/mecha_parts/mecha_equipment/weapon/positron_rifle/proc/stop_charging(silent = FALSE)
	if(charge_timer)
		deltimer(charge_timer)
		charge_timer = null
	if(charging && !silent)
		announce(POSITRON_VOICE_CHARGE_STOP)
	charging = FALSE

// --- Выстрел ----------------------------------------------------------------
/obj/item/mecha_parts/mecha_equipment/weapon/positron_rifle/action_checks(atom/target)
	if(!..())
		return FALSE
	if(!battery || shot_fired)
		// Не спамим голосом при каждом клике
		if(!TIMER_COOLDOWN_RUNNING(src, "positron_empty_warn"))
			TIMER_COOLDOWN_START(src, "positron_empty_warn", 2 SECONDS)
			announce(POSITRON_VOICE_NO_BATTERY)
		return FALSE
	return TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/positron_rifle/action(mob/source, atom/target, list/modifiers)
	// Ctrl+клик - зарядка (клики до нас доходят в обеих руках)
	if(LAZYACCESS(modifiers, CTRL_CLICK))
		toggle_charge(source)
		return FALSE

	if(!action_checks(target))
		return FALSE

	// Заряд в "уровнях" (дробный): от 0 до POSITRON_MAX_CHARGE
	var/level = charge_progress / POSITRON_CHARGE_TIME
	stop_charging(silent = TRUE)
	// ВАЖНО: shot_fired ставим только ПОСЛЕ базового action(), иначе его внутренний
	// вызов action_checks() увидит флаг и сам заблокирует выстрел.
	// Базовый action() читает fire_sound уже после создания снаряда, поэтому звук выставляем заранее.
	// Снаряд сам заберёт уровень заряда в fire() (см. ниже).
	var/charged = level >= 1
	fire_sound = charged ? POSITRON_SND_FIRE_CHARGED : POSITRON_SND_FIRE
	last_shot_level = level

	. = ..()
	if(!.)
		// Что-то помешало выстрелу - батарея и заряд остаются на месте
		return FALSE

	shot_fired = TRUE
	charge_progress = 0
	update_bar() // прячет полоску (заряд = 0)
	charge_user = null

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), chassis, POSITRON_SND_BEAM, 70, TRUE), 0.2 SECONDS)
	announce(charged ? POSITRON_VOICE_FIRED_CHARGED : POSITRON_VOICE_FIRED)
	if(charged)
		apply_recoil(target, level)
	battery?.mark_spent()
	// Через секунду отработанная батарея выскакивает и падает на пол
	addtimer(CALLBACK(src, PROC_REF(eject_spent_battery)), 1 SECONDS)

/// Отдача: усиленный выстрел отбрасывает мех от цели, полный заряд - на две клетки
/obj/item/mecha_parts/mecha_equipment/weapon/positron_rifle/proc/apply_recoil(atom/target, level)
	if(!chassis)
		return
	var/full = POSITRON_IS_FULL_CHARGE(level)
	var/push_dir = get_dir(target, chassis) // направление ОТ цели
	if(!push_dir)
		push_dir = REVERSE_DIR(chassis.dir)
	// Тряска экрана у пилотов
	for(var/mob/occupant as anything in chassis.occupants)
		shake_camera(occupant, full ? 4 : 2, full ? 3 : 2)
	if(chassis.has_gravity())
		step(chassis, push_dir)
		if(full)
			addtimer(CALLBACK(src, PROC_REF(recoil_step), push_dir), POSITRON_RECOIL_STEP_DELAY)
	else
		// В невесомости базовый kickback уже толкает меха, добавляем импульс сверху
		chassis.newtonian_move(dir2angle(push_dir))
		if(full)
			chassis.newtonian_move(dir2angle(push_dir))

/obj/item/mecha_parts/mecha_equipment/weapon/positron_rifle/proc/recoil_step(push_dir)
	if(chassis)
		step(chassis, push_dir)

/obj/item/mecha_parts/mecha_equipment/weapon/positron_rifle/proc/eject_spent_battery()
	if(!shot_fired)
		return
	shot_fired = FALSE
	eject_battery(voice = FALSE)
	announce(POSITRON_VOICE_BATTERY_SPENT)

// ============================================================================
// СНАРЯД
// ============================================================================
/obj/projectile/beam/positron
	name = "позитронный луч"
	icon_state = "omnilaser"
	damage = POSITRON_BASE_DAMAGE
	damage_type = BURN
	armor_flag = LASER
	hitscan = TRUE
	range = 60
	// Свои звуки попаданий ставим вручную в on_hit()
	hitsound = null
	hitsound_wall = null
	muzzle_type = /obj/effect/projectile/muzzle/laser/blue
	tracer_type = /obj/effect/projectile/tracer/laser/blue
	impact_type = /obj/effect/projectile/impact/laser/blue
	/// Уровень заряда, с которым выпущен луч
	var/charge_level = 0

/// К моменту fire() базовый weapon/action() уже выставил firer и fired_from
/obj/projectile/beam/positron/fire(angle, atom/direct_target)
	var/obj/item/mecha_parts/mecha_equipment/weapon/positron_rifle/rifle = fired_from
	if(istype(rifle))
		charge_level = rifle.last_shot_level
		damage = round(POSITRON_BASE_DAMAGE + (charge_level * POSITRON_DAMAGE_PER_CHARGE), 1)
	return ..()

/// Пробиваем всё, кроме живых существ и мехов
/obj/projectile/beam/positron/prehit_pierce(atom/target)
	if(target == firer)
		return PROJECTILE_PIERCE_PHASE
	if(isliving(target) || ismecha(target))
		return PROJECTILE_PIERCE_NONE
	return PROJECTILE_PIERCE_HIT

/obj/projectile/beam/positron/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	if(isliving(target) || ismecha(target))
		playsound(target, POSITRON_SND_HIT_MOB, 70, TRUE)
	else
		playsound(target, POSITRON_SND_HIT_WALL, 60, TRUE)
	if(blocked < 100 && POSITRON_IS_FULL_CHARGE(charge_level))
		apply_overcharge_effects(target)

/// Эффекты полного заряда: ослепление, поджог, отбрасывание; электроника (борги, мехи) - ЭМИ
/obj/projectile/beam/positron/proc/apply_overcharge_effects(atom/target)
	if(iscyborg(target) || ismecha(target))
		target.emp_act(EMP_LIGHT)
		return
	if(!isliving(target))
		return
	var/mob/living/victim = target
	victim.adjust_temp_blindness(POSITRON_BLIND_TIME)
	victim.adjust_eye_blur(POSITRON_BLUR_TIME)
	victim.adjust_fire_stacks(POSITRON_FIRE_STACKS)
	victim.ignite_mob()
	var/atom/throw_target = get_edge_target_turf(victim, angle2dir(angle))
	victim.throw_at(throw_target, POSITRON_KNOCKBACK_RANGE, POSITRON_KNOCKBACK_SPEED, firer)

#undef POSITRON_MAX_CHARGE
#undef POSITRON_CHARGE_TIME
#undef POSITRON_BASE_DAMAGE
#undef POSITRON_DAMAGE_PER_CHARGE
#undef POSITRON_BLIND_TIME
#undef POSITRON_BLUR_TIME
#undef POSITRON_FIRE_STACKS
#undef POSITRON_KNOCKBACK_RANGE
#undef POSITRON_KNOCKBACK_SPEED
#undef POSITRON_RECOIL_STEP_DELAY
#undef POSITRON_IS_FULL_CHARGE
