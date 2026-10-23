/mob/living/silicon/robot/shell/cell
	var/cell_to_insert = /obj/item/stock_parts/power_store/cell/high

/mob/living/silicon/robot/shell/cell/Initialize(mapload)
	. = ..()

	if(!cell && cell_to_insert)
		cell = new cell_to_insert(src)

	return .

/mob/living/silicon/robot/shell/cell/infinity
	cell_to_insert = /obj/item/stock_parts/power_store/cell/infinite/abductor

