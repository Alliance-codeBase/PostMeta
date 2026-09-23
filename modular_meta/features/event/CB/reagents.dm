// for the love of god add those to the blacklisted reagents for hydroponics

/datum/reagent/anomalous
	name = "unidentified liquid"
	description = "A liquid dispensed by SCP-294."
	color = "#3D3028"
	taste_description = "something unfamiliar"
	metabolization_rate = 1000
	chemical_flags = REAGENT_UNAFFECTED_BY_METABOLISM
	var/reaction = 'modular_meta/features/event/CB/sound/294/ew1.ogg'
	var/amount_spawned = 30

/datum/reagent/anomalous/get_taste_description(mob/living/taster)
	var/custom_taste = data?["taste"]
	if(custom_taste)
		return list("[custom_taste]" = 1)
	return ..()

/datum/reagent/anomalous/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	if(reaction)
		playsound(affected_mob, reaction, 40, FALSE)

/datum/reagent/anomalous/corrosion
	name = "Corrosion"
	taste_description = "rust, ash and old pennies"
	reaction = 'modular_meta/features/event/CB/sound/294/cough.ogg'
	amount_spawned = 5

/datum/reagent/anomalous/corrosion/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_tox_loss(35)
	affected_mob.adjust_brute_loss(5)
	affected_mob.adjust_organ_loss(ORGAN_SLOT_STOMACH, 10)

/datum/reagent/anomalous/explosion
	name = "Explosion"
	taste_description = "hot metal and ozone"
	reaction = 'modular_meta/features/event/CB/sound/294/cough.ogg'
	amount_spawned = 5

/datum/reagent/anomalous/explosion/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	explosion(affected_mob, heavy_impact_range = 1, light_impact_range = 3, flash_range = 4)

/datum/reagent/anomalous/heal
	name = "Healing"
	taste_description = "honey and warm milk"
	reaction = 'modular_meta/features/event/CB/sound/294/ahh.ogg'

/datum/reagent/anomalous/heal/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_brute_loss(-200)
	affected_mob.adjust_fire_loss(-200)
	affected_mob.adjust_tox_loss(-200)
	affected_mob.adjust_oxy_loss(-200)

/datum/reagent/anomalous/heal/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=0)
	. = ..()
	if(!(methods & (PATCH|TOUCH)))
		return
	var/healing = reac_volume * 5 * (1 - touch_protection)
	if(healing <= 0)
		return
	if(show_message && exposed_mob.stat == DEAD)
		exposed_mob.visible_message(span_notice("[exposed_mob]'s body convulses as the liquid takes hold!"))
		exposed_mob.do_jitter_animation(10)
	exposed_mob.do_strange_reagent_revival(healing)

/datum/reagent/anomalous/heal/god
	name = "Godmode"
	taste_description = "starlight and impossible sweetness"
	amount_spawned = 1

/datum/reagent/anomalous/heal/god/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.apply_status_effect(/datum/status_effect/scp294_god)

/datum/reagent/anomalous/heal/god/on_new(data)
	. = ..()
	if(volume > 2)
		surge()

/datum/reagent/anomalous/heal/god/on_merge(list/mix_data, amount)
	. = ..()
	if(volume <= 10 && volume + amount > 2)
		surge()

/datum/reagent/anomalous/heal/god/proc/surge()
	var/obj/item/reagent_containers/container = holder?.my_atom
	if(!istype(container))
		return
	container.visible_message(span_anomalous("[container] shivers and flashes with impossible colors!"))
	playsound(container, 'sound/effects/magic/cosmic_energy.ogg', 60, TRUE)
	var/base_y = container.pixel_y
	var/base_color = container.color
	var/matrix/base_transform = matrix(container.transform)
	animate(container, transform = matrix(base_transform).Scale(1.1), pixel_y = base_y + 6, color = "#FF5CB8", time = 0.3 SECONDS)
	animate(transform = matrix(base_transform).Scale(0.95), pixel_y = base_y - 3, color = "#FF9866", time = 0.3 SECONDS)
	animate(transform = matrix(base_transform).Scale(1.1), pixel_y = base_y + 6, color = "#FFE866", time = 0.3 SECONDS)
	animate(transform = matrix(base_transform).Scale(0.95), pixel_y = base_y - 3, color = "#65F7A4", time = 0.3 SECONDS)
	animate(transform = matrix(base_transform).Scale(1.1), pixel_y = base_y + 6, color = "#74A8FF", time = 0.3 SECONDS)
	animate(transform = matrix(base_transform).Scale(0.95), pixel_y = base_y - 3, color = "#C983FF", time = 0.3 SECONDS)
	animate(transform = base_transform, pixel_y = base_y, color = base_color, time = 0.3 SECONDS)

/datum/reagent/anomalous/narsie
	name = "Nar'Sie"
	taste_description = "blood and iron"
	reaction = 'sound/effects/magic/clockwork/narsie_attack.ogg'
	amount_spawned = 5

/datum/reagent/anomalous/narsie/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	var/turf/ground = get_turf(affected_mob)
	if(prob(1))
		var/obj/narsie/harbinger = new(ground)
		harbinger.start_ending_the_round()
		message_admins("[ADMIN_LOOKUPFLW(affected_mob)] summoned Nar'Sie through SCP-294 at [ADMIN_COORDJMP(affected_mob)].")
		log_game("[key_name(affected_mob)] summoned Nar'Sie through SCP-294 at [AREACOORD(affected_mob)].")
		return
	var/obj/item/toy/plush/narplush/plush = new(ground)
	plush.say("NAR'SIE HUNGERS FOR YOUR SOUL.")
	affected_mob.visible_message(span_narsie("[affected_mob] twists into a knot of bloody geometry!"))
	new /obj/effect/temp_visual/cult/sparks(ground)
	playsound(ground, 'sound/effects/magic/demon_attack1.ogg', 75, TRUE)
	shake_camera(affected_mob, 2 SECONDS, 4)
	affected_mob.inflate_gib(DROP_ALL_REMAINS)

/datum/reagent/anomalous/zombie
	name = "Zombie"
	taste_description = "rotting flesh and bitter medicine"
	reaction = 'modular_meta/features/event/CB/sound/294/cough.ogg'
	amount_spawned = 5

/datum/reagent/anomalous/zombie/on_mob_end_metabolize(mob/living/affected_mob, metabolization_ratio)
	. = ..()
	if(!ishuman(affected_mob))
		return
	var/mob/living/carbon/human/human = affected_mob
	if(!human.get_organ_slot(ORGAN_SLOT_ZOMBIE))
		var/obj/item/organ/zombie_infection/nodamage/tumor = new
		tumor.Insert(human)
	addtimer(CALLBACK(human, TYPE_PROC_REF(/mob/living/carbon, set_heartattack), TRUE), 10 SECONDS)

/datum/reagent/anomalous/death
	name = "Death"
	taste_description = "cold ash and grave dust"
	reaction = 'modular_meta/features/event/CB/sound/294/cough.ogg'
	amount_spawned = 1

/datum/reagent/anomalous/death/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.death()

/datum/reagent/anomalous/head
	name = "Headburst"
	taste_description = "copper and bitter almonds"
	reaction = 'modular_meta/features/event/CB/sound/294/cough.ogg'
	amount_spawned = 5

/datum/reagent/anomalous/head/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(!ishuman(affected_mob) || affected_mob.stat == DEAD)
		return
	var/datum/action/cooldown/spell/pointed/headburst/spell = new
	spell.cast(affected_mob)
	QDEL_IN(spell, 8 SECONDS)

/datum/reagent/anomalous/brain
	name = "Brain damage"
	taste_description = "ink and electric sparks"
	reaction = 'modular_meta/features/event/CB/sound/294/ew2.ogg'
	amount_spawned = 5

/datum/reagent/anomalous/brain/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_organ_loss(ORGAN_SLOT_BRAIN, 150)

/datum/reagent/anomalous/pain
	name = "Pain"
	taste_description = "raw salt and old wounds"
	reaction = 'modular_meta/features/event/CB/sound/294/cough.ogg'
	amount_spawned = 5

/datum/reagent/anomalous/pain/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_brute_loss(50)

/datum/reagent/anomalous/toxin
	name = "Severe poisoning"
	taste_description = "bitter chemicals and spoiled fruit"
	reaction = 'modular_meta/features/event/CB/sound/294/cough.ogg'
	amount_spawned = 5

/datum/reagent/anomalous/toxin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_tox_loss(100)

/datum/reagent/anomalous/fire
	name = "Burning"
	taste_description = "smoke and molten stone"
	reaction = 'modular_meta/features/event/CB/sound/294/cough.ogg'
	amount_spawned = 5

/datum/reagent/anomalous/fire/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_fire_loss(40)
	affected_mob.adjust_fire_stacks(8)
	affected_mob.ignite_mob()

/datum/reagent/anomalous/sleep
	name = "Sleep"
	taste_description = "warm milk and poppy seeds"
	reaction = 'modular_meta/features/event/CB/sound/294/ahh.ogg'

/datum/reagent/anomalous/sleep/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.Sleeping(20 SECONDS)

/datum/reagent/anomalous/fear
	name = "Hallucinations"
	taste_description = "cold sweat and burnt sugar"
	reaction = 'modular_meta/features/event/CB/sound/294/ew2.ogg'

/datum/reagent/anomalous/fear/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_hallucinations(60 SECONDS)

/datum/reagent/anomalous/stamina
	name = "Restore stamina"
	taste_description = "strong coffee and mint"
	reaction = 'modular_meta/features/event/CB/sound/294/ahh.ogg'

/datum/reagent/anomalous/stamina/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_stamina_loss(-100)

/datum/reagent/anomalous/organs
	name = "Organ failure"
	taste_description = "rotten fruit and iron"
	reaction = 'modular_meta/features/event/CB/sound/294/cough.ogg'
	amount_spawned = 5

/datum/reagent/anomalous/remember_everything
	name = "Overrated videogameDuh"
	taste_description = "a really overrated videogame"
	reaction = 'modular_meta/features/event/CB/sound/294/cough.ogg'
	amount_spawned = 5

/datum/reagent/anomalous/remember_everything/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	playsound(affected_mob,'sound/effects/magic/lightningshock.ogg', 50, 1)
	playsound(affected_mob,	'modular_meta/features/butt_farts/sound/farts/dagothgod.ogg', 80)
	spawn(15)
		affected_mob.gib()
		dyn_explosion(affected_mob.loc, 1, 0)

/datum/reagent/anomalous/organs/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	for(var/obj/item/organ/organ as anything in affected_mob.organs)
		organ.set_organ_damage(organ.maxHealth)

/datum/reagent/anomalous/organs/happiness
	name = "False happiness"
	taste_description = "cotton candy and bitter almonds"
	reaction = 'modular_meta/features/event/CB/sound/294/ahh.ogg'

/datum/reagent/anomalous/me
	name = "Me"
	taste_description = "something strangely familiar"

/datum/reagent/anomalous/nothing
	name = "Nothing"
	taste_description = "nothing at all"
	reaction = null

/datum/status_effect/scp294_god
	id = "scp294_god"
	duration = 30 SECONDS
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = /atom/movable/screen/alert/status_effect/scp294_god
	show_duration = TRUE

/datum/status_effect/scp294_god/on_apply()
	ADD_TRAIT(owner, TRAIT_GODMODE, TRAIT_STATUS_EFFECT(id))
	return TRUE

/datum/status_effect/scp294_god/on_remove()
	REMOVE_TRAIT(owner, TRAIT_GODMODE, TRAIT_STATUS_EFFECT(id))
	owner.death()

/atom/movable/screen/alert/status_effect/scp294_god
	name = "Borrowed Divinity"
	desc = "The drink has made you invulnerable. But something feel off...."
	icon_state = "wounded"
