/obj/item/circuitboard/machine/nanite_chamber
	name = "Nanite Chamber (Machine Board)"
	icon_state = "science"
	build_path = /obj/machinery/nanite_chamber
	req_components = list(
		/obj/item/stock_parts/scanning_module = 2,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/manipulator = 1)

/obj/item/circuitboard/machine/nanite_program_hub
	name = "Nanite Program Hub (Machine Board)"
	icon_state = "science"
	build_path = /obj/machinery/nanite_program_hub
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1)

/obj/item/circuitboard/machine/nanite_programmer
	name = "Nanite Programmer (Machine Board)"
	icon_state = "science"
	build_path = /obj/machinery/nanite_programmer
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/scanning_module = 1)

/obj/item/circuitboard/machine/public_nanite_chamber
	name = "Public Nanite Chamber (Machine Board)"
	icon_state = "science"
	build_path = /obj/machinery/public_nanite_chamber
	var/cloud_id = 1
	req_components = list(
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/manipulator = 1)

/obj/item/circuitboard/machine/public_nanite_chamber/multitool_act(mob/living/user)
	. = ..()
	var/new_cloud = input("Set the public nanite chamber's Cloud ID (1-100).", "Cloud ID", cloud_id) as num|null
	if(!new_cloud || (loc != user))
		to_chat(user, "<span class='warning'>You must hold the circuitboard to change its Cloud ID!</span>")
		return
	cloud_id = clamp(round(new_cloud, 1), 1, 100)

/obj/item/circuitboard/machine/public_nanite_chamber/examine(mob/user)
	. = ..()
	. += "Cloud ID is currently set to [cloud_id]."

/obj/item/circuitboard/machine/clonepod
	name = "Clone Pod (Machine Board)"
	icon_state = "medical"
	build_path = /obj/machinery/clonepod
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/scanning_module = 2,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/sheet/glass = 1)
