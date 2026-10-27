/mob/living/basic/bacteria
	name = "B̷̢͓̿͞a҉̛̯͍̝̋͜c̶̨͓̄͑̂͡ṫ̸̨̟̊͠ȩ̶̝̩̀̕r̸̡̬̬̆́͡i҉̢̜̯́̍͒͠ͅą̶̠́͡"
	desc = "Ẃ̶̪̲̯͙̯̦͖̞̗͕͎͕͇͍͂̔̀̽̍̅̓̅̋̎͋̋ͅḧ̴͕̳̪͖͔̱̮͈̙͔͔̟̞̞͈͎̩̲̖̳̠̿̽̀͛́̆͐̊̽̊͐͐͌a̶̫̯̮̖̪̦̝͎̦̗̯̲̲̘̫̰̲̣̗̿̽͌͛͒͑͆̿̂͆̔͑̉̅̓̾̊̋̏͋ṱ̵̗̣̮̩͇̪̖̬̙̞̭̘̏̃͛̀̄̔́̒̅̿̅̃̿̇ͅ y҉͖͇͚̩̮̖̪͚̙̭̠̦͈͕̅͑̊̈̒́͒̓̈́̌̍̿͛͒̓̈͌͊̽̏́̂͐̚o҈̜͎͎̞̜͍̖͖̥̟͖̙̗̋̄̀̍̅̀͂͑̑́̌̐͐̇̍ȕ̴̱̩͔̮̥̖̭̗͍͔̗̩̬͙͔͚̬̈͐̌͂̽̒͛̔͂͒̊͆̓̀̑̑̈́͛͑͛͋ͅ l̸̫̲͈͔͍͙͉̭̙͇̤͍̪̖̮͙̇́͑̔͐̎̑̎͛̔̆̇́͗͒̈̔͛̈̏͑̃ͅo҉͙̲̖̗̟̬̳̜̘̜͇̝͈͇͎̤̟̥̇̓̏͌͐͑̀̐̓̏̅̉̒̋̑̍́̉̚ͅo̶̬̮̬̤̥̯̫͓̭͔͔͎̦͙͇̭͖̦̤͎̩̗̤̓̌̿̌̒̍̍̑̅͑̃̐̾̓͐̀̓̏k҉͈̦͉̱̰͖͖̝̙̬͕͖͚̩̮̤̅̎͊͛͆͗͆͛̊͂̒̔̀͑͌̇͗̋̅̍̈́̄i̷͍͎̙̫̣̗̜̤̠̮͓̣̩͓̱̥͉̾̔͌̏͊̿̋́̀̽͊̽̉̈́̓̀̿̂̈́̋͛͐̚̚n҉͓̲͖͚͎̠̞̯̟̘͍̤̝̥͈̜͑̓͑̓̐̀͋̉̀̓̓͛̉̏̉̚g̴̭͍̲̩̘͈̱͖͉̙̖̙͕̬̜̉̾̒̈́̅̀̆͂͋̓̏̀ à̴͕͍͕͍̱͓̝̞̫̱̭͕̱͚͚̜̲͖̟̭͗̀̇͆̔͐̐͋̌̀̆̄̇t҈͕̩̮̪͎͈͔̗̤̠̥͈̟͓̥͖̠̫͈̲͂̈̃̏̌̀́̓͆̓̌͂̀͆̅̐̇̊̆̀̚?҉͚̦͚̝͍̙̗͕̣̜̞̬̟̔͗͂̎͛͊̄͐̾͐̋̑̏̾̓͆͋͌̅̎"
	icon_state = "bacteria"
	icon_living = "bacteria"
	base_icon_state = "bacteria"
	icon = 'modular_meta/features/content/icons/mob.dmi'
	melee_damage_lower = 40
	melee_damage_upper = 50
	armour_penetration = 100
	mob_biotypes = MOB_ORGANIC | MOB_SPECIAL
	sight = SEE_SELF|SEE_MOBS|SEE_OBJS|SEE_TURFS
	health = INFINITY
	maxHealth = INFINITY
	speed = 0
	faction = list(FACTION_HOSTILE)

	lighting_cutoff_red = 255
	lighting_cutoff_green = 255
	lighting_cutoff_blue = 255

	ai_controller = /datum/ai_controller/basic_controller/simple/simple_hostile_obstacles

/mob/living/basic/bacteria/captain
	name = "Captain Clark"
	desc = "He very long and his face looks deformed"
	icon_state = "clark"
	icon_living = "clark"
	base_icon_state = "clark"
	icon = 'modular_meta/features/content/icons/mob.dmi'
	melee_damage_lower = 30
	melee_damage_upper = 35
	armour_penetration = 60
	var/music_trigger_range = 20
	var/list/tracked_music_victims

/mob/living/basic/bacteria/captain/New(loc)
	..()
	tracked_music_victims = list()
	if(SSfastprocess)
		START_PROCESSING(SSfastprocess, src)

/mob/living/basic/bacteria/captain/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	for(var/mob/living/carbon/human/human_victim in tracked_music_victims)
		if(human_victim)
			human_victim.stop_chase_music()
	tracked_music_victims = null
	return ..()

/mob/living/basic/bacteria/captain/process(delta_time)
	var/list/humans_nearby = list()

	for(var/mob/living/carbon/human/human_target in orange(music_trigger_range, src))
		if(human_target.stat == 0 && human_target.client)
			humans_nearby += human_target

	for(var/mob/living/carbon/human/near_human in humans_nearby)
		if(!(near_human in tracked_music_victims))
			tracked_music_victims += near_human
			near_human.start_chase_music(src)

	for(var/mob/living/carbon/human/tracked_human in tracked_music_victims)
		if(!(tracked_human in humans_nearby) || tracked_human.stat != 0)
			tracked_human.stop_chase_music()
			tracked_music_victims -= tracked_human

/mob/living/basic/statue/cookie
	name = "\improper Sculpture"
	desc = "SCP-173, also known as the Sculpture, is a fictional character originating from 4chan and spawning the SCP Foundation collaborative writing project. \
	Within the fictional universe of the SCP Foundation, it is a large statue, made primarily of concrete and rebar, that has the ability to move so long as it is not being directly observed by a living being. \
	SCP-173 is described as a roughly human-sized sculpture made from concrete and rebar that has been coated in Krylon branded spray paint. \
	It is listed under the 'Euclid' object class, which means it is considered unpredictable and may potentially escape containment if containment procedures are not followed. \
	When SCP-173 is unobserved and left alone in its containment chamber, it moves around aimlessly, creating a scraping sound due to its concrete body. \
	The entity also secretes a reddish-brown substance, which is a combination of blood and feces. From where and how the entity produces or excretes the material is unknown. \
	If it is not directly observed, it will attack and kill humans by breaking their necks."
	icon = 'modular_meta/features/content/icons/mob32x64.dmi'
	icon_state = "cookie"
	icon_living = "cookie"
	icon_dead = "cookie"
	attack_verb_continuous = "snaps"
	attack_verb_simple = "snap"
	attack_sound = list('modular_meta/features/content/sound/neck_snap_1.ogg', 'modular_meta/features/content/sound/neck_snap_2.ogg')
	armour_penetration = 100
	melee_damage_lower = 90
	melee_damage_upper = 110

	move_resist = MOVE_RESIST_DEFAULT
	move_force = MOVE_FORCE_DEFAULT
	pull_force = PULL_FORCE_DEFAULT
