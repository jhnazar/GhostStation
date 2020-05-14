/obj/item/weapon/airlock_painter
	name = "universal painter"
	desc = "An advanced autopainter preprogrammed with several paintjobs for airlocks, windows and pipes. Use it on an airlock during or after construction to change the paintjob, or on window or pipe."
	icon_state = "paint sprayer"
	item_state = "paint sprayer"

	w_class = 2.0

	m_amt = 50
	g_amt = 50
	origin_tech = "engineering=1"

	flags = CONDUCT
	slot_flags = SLOT_BELT

	var/static/list/modes // used to dye pipes, contains pipe colors.
	var/obj/item/device/toner/ink

	var/saved_turf_icon_state = "floor"
	var/saved_turf_dir = NORTH
	var/can_paint = TRUE

/obj/item/weapon/airlock_painter/atom_init()
	. = ..()

	if(!modes)
		modes = new()
		for(var/C in pipe_colors)
			modes += "[C]"

	ink = new /obj/item/device/toner(src)

	//This proc doesn't just check if the painter can be used, but also uses it.
	//Only call this if you are certain that the painter will be used right after this check!
/obj/item/weapon/airlock_painter/proc/use(mob/user, cost)
	if(can_use(user, cost))
		ink.charges -= cost
		playsound(src.loc, 'sound/effects/spray2.ogg', 50, 1)
		return 1
	else
		return 0

	//This proc only checks if the painter can be used.
	//Call this if you don't want the painter to be used right after this check, for example
	//because you're expecting user input.
/obj/item/weapon/airlock_painter/proc/can_use(mob/user, cost = 10)
	if(!ink)
		to_chat(user, "<span class='notice'>There is no toner cardridge installed installed in \the [name]!</span>")
		return 0
	else if(ink.charges < cost)
		to_chat(user, "<span class='notice'>Not enough ink!</span>")
		if(ink.charges < 1)
			to_chat(user, "<span class='notice'>\The [name] is out of ink!</span>")
		return 0
	else
		return 1

/obj/item/weapon/airlock_painter/examine(mob/user)
	..()
	if(!ink)
		to_chat(user, "<span class='notice'>It doesn't have a toner cardridge installed.</span>")
		return
	var/ink_level = "high"
	if(ink.charges < 1)
		ink_level = "empty"
	else if((ink.charges/ink.max_charges) <= 0.25) //25%
		ink_level = "low"
	else if((ink.charges/ink.max_charges) > 1) //Over 100% (admin var edit)
		ink_level = "dangerously high"
	to_chat(user, "<span class='notice'>Its ink levels look [ink_level].</span>")

/obj/item/weapon/airlock_painter/attackby(obj/item/weapon/W, mob/user)
	..()
	if(istype(W, /obj/item/device/toner))
		if(ink)
			to_chat(user, "<span class='notice'>\the [name] already contains \a [ink].</span>")
			return
		user.drop_item()
		W.loc = src
		to_chat(user, "<span class='notice'>You install \the [W] into \the [name].</span>")
		ink = W
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)

/obj/item/weapon/airlock_painter/attack_self(mob/user)
	var/action = input(user, "What action you wish to perform?", "Action selection") as null|anything in list("Choose floor paintjob", "Take cartridge out")
	switch(action)
		if("Choose floor paintjob")
			if(can_paint)
				can_paint = FALSE
				var/new_icon_state = input(user, "Choose a new paintjob for the floor.", "Paintjob selection") as null|anything in PAINTER_FLOOR_NAME2ICONSTATE
				if(new_icon_state && !user.is_busy() && do_after(user, 10, target=src))
					saved_turf_icon_state = PAINTER_FLOOR_NAME2ICONSTATE[new_icon_state]
				var/new_dir = input(user, "Choose a direction for paintjob.", "Direction selection") as null|anything in list("North", "South", "West", "East")
				switch(new_dir)
					if("North")
						saved_turf_dir = NORTH
					if("South")
						saved_turf_dir = SOUTH
					if("West")
						saved_turf_dir = WEST
					if("East")
						saved_turf_dir = EAST
				can_paint = TRUE
		if("Take cartridge out")
			if(ink)
				playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
				ink.loc = user.loc
				user.put_in_hands(ink)
				to_chat(user, "<span class='notice'>You remove \the [ink] from \the [name].</span>")
				ink = null

/obj/item/weapon/airlock_painter/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return

	if(istype(A, /turf/simulated/floor) && A.name == "floor" && A.icon == 'icons/turf/floors.dmi' && A.icon_state in PAINTER_FLOOR_ICON_STATES) // The floor check helps in rare cases where custom turfs have custom names. Completely redundant and should be reworked. ~Luduk
		var/turf/simulated/floor/F = A
		if(can_paint && use(user))
			F.icon_state = saved_turf_icon_state
			F.dir = saved_turf_dir
		return

	if(!istype(A, /obj/machinery/atmospherics/pipe) || \
		istype(A, /obj/machinery/atmospherics/components/unary/tank) || \
		istype(A, /obj/machinery/atmospherics/pipe/simple/heat_exchanging) || \
		!in_range(user, A))
	{
		return
	}

	var/obj/machinery/atmospherics/pipe/P = A

	var/selected_color = input("Which colour do you want to use?", "Universal painter") in modes
	if(!selected_color)
		return

	user.visible_message("<span class='notice'>[user] paints \the [P] [selected_color].</span>", "<span class='notice'>You paint \the [P] [selected_color].</span>")
	P.change_color(pipe_colors[selected_color])