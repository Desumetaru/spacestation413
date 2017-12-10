/obj/machinery/computer/timemachine
	name = "spatiotemporal control station"
	desc = "Used to control a linked tachyon accelerator and temporal gateway"
	icon_screen = "teleport"
	icon_keyboard = "teleport_key"
	light_color = LIGHT_COLOR_BLUE
	circuit = /obj/item/circuitboard/computer/timemachine
	var/obj/machinery/timemachine/tachyon_accelerator/tachyon_accel


/obj/machinery/computer/timemachine/Initialize()
	. = ..()
	id = "[rand(1000, 9999)]"
	link_tachyon_accel()


/obj/machinery/computer/timemachine/proc/link_tachyon_accel()
	if(tachyon_accel)
		return
	for(var/direction in GLOB.cardinals)
		tachyon_accel = locate(/obj/machinery/timemachine/tachyon_accelerator, get_step(src, direction))
		if(tachyon_accel)
			break
	return power_station
