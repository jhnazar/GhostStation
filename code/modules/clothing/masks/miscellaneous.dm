/obj/item/clothing/mask/muzzle
	name = "muzzle"
	desc = "To stop that awful noise."
	icon_state = "muzzle"
	item_state = "muzzle"
	flags = MASKCOVERSMOUTH
	body_parts_covered = 0
	w_class = 2
	gas_transfer_coefficient = 0.90

//Monkeys can not take the muzzle off of themself! Call PETA!
/obj/item/clothing/mask/muzzle/attack_paw(mob/user)
	if (src == user.wear_mask)
		return
	else
		..()
	return


/obj/item/clothing/mask/surgical
	name = "sterile mask"
	desc = "A sterile mask designed to help prevent the spread of diseases."
	icon_state = "sterile"
	item_state = "sterile"
	w_class = 2
	flags = MASKCOVERSMOUTH
	body_parts_covered = 0
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 25, rad = 0, telepathy = 0)

/obj/item/clothing/mask/fakemoustache
	name = "fake moustache"
	desc = "Warning: moustache is fake."
	icon_state = "fake-moustache"
	flags_inv = HIDEFACE
	body_parts_covered = 0

/obj/item/clothing/mask/fake_face
	name = "fake face"
	desc = "Warning: this face not a fake."
	icon_state = "fake_face"
	flags_inv = HIDEFACE
	body_parts_covered = 0

/obj/item/clothing/mask/clownnose
	name = "clown nose"
	desc = "Take center ring at your carnival party with this red clown nose. These clown nose are made of lightweight foam and have a slit down the middle for a comfortable fit."
	icon_state = "clownnose"
	item_state = "clownnose"
	actions_types = /datum/action/item_action/attack_self
	var/cooldown = 0

/obj/item/clothing/mask/clownnose/attack_self()
	honk()

/obj/item/clothing/mask/clownnose/verb/honk()
	set category = "Object"
	set name = "HONK!"
	set src in usr

	if(!istype(usr, /mob/living)) return
	if(usr.stat) return
	if(cooldown < world.time - 10)
		playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
		cooldown = world.time
	return

/obj/item/clothing/mask/snorkel
	name = "snorkel"
	desc = "For the Swimming Savant."
	icon_state = "snorkel"
	flags_inv = HIDEFACE
	body_parts_covered = 0

//scarves (fit in in mask slot)

/obj/item/clothing/mask/scarf
	name = "scarf"
	desc = "A simple neck scarf."
	icon_state = "bluescarf"
	item_state = "bluescarf"
	flags = MASKCOVERSMOUTH
	w_class = 2
	gas_transfer_coefficient = 0.90
	actions_types = /datum/action/item_action/attack_self
	var/hanging = 0

/obj/item/clothing/mask/scarf/blue
	name = "blue neck scarf"
	desc = "A blue neck scarf."
	icon_state = "bluescarf"
	item_state = "bluescarf"

/obj/item/clothing/mask/scarf/red
	name = "red scarf"
	desc = "A red neck scarf."
	icon_state = "redscarf"
	item_state = "redscarf"

/obj/item/clothing/mask/scarf/green
	name = "green scarf"
	desc = "A green neck scarf."
	icon_state = "greenscarf"
	item_state = "greenscarf"

/obj/item/clothing/mask/scarf/yellow
	name = "yellow scarf"
	desc = "A yellow neck scarf."
	icon_state = "yellowscarf"
	item_state = "yellowscarf"

/obj/item/clothing/mask/scarf/violet
	name = "violet scarf"
	desc = "A violet neck scarf."
	icon_state = "violetscarf"
	item_state = "violetscarf"

/obj/item/clothing/mask/scarf/attack_self(mob/user)

	if(user.incapacitated())
		return


	if(!hanging)
		hanging = !hanging
		gas_transfer_coefficient = 1 //gas is now escaping to the turf and vice versa
		flags &= ~MASKCOVERSMOUTH
		icon_state = "[initial(icon_state)]down"
		to_chat(user, "Your scarf is now hanging on your neck.")
	else
		hanging = !hanging
		gas_transfer_coefficient = 0.90
		flags |= MASKCOVERSMOUTH
		icon_state = "[initial(icon_state)]"
		to_chat(user, "You pull the scarf up to cover your face.")
	user.update_inv_wear_mask()




/obj/item/clothing/mask/scarf/ninja
	name = "ninja scarf"
	desc = "A stealthy, dark scarf."
	icon_state = "ninja_scarf"
	item_state = "ninja_scarf"
	flags = MASKCOVERSMOUTH
	w_class = 2
	gas_transfer_coefficient = 0.90
	siemens_coefficient = 0

/obj/item/clothing/mask/pig
	name = "pig mask"
	desc = "A rubber pig mask."
	icon_state = "pig"
	item_state = "pig"
	flags = BLOCKHAIR
	flags_inv = HIDEFACE
	w_class = 2
	siemens_coefficient = 0.9
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/pig/speechModification(message)
	if(!canremove)
		message = pick("Oink!", "Squeeeeeeee!", "Oink Oink!")
	return message

/obj/item/clothing/mask/horsehead
	name = "horse head mask"
	desc = "A mask made of soft vinyl and latex, representing the head of a horse."
	icon_state = "horsehead"
	item_state = "horsehead"
	flags = BLOCKHAIR
	flags_inv = HIDEFACE
	body_parts_covered = HEAD|FACE|EYES
	w_class = 2
	siemens_coefficient = 0.9

/obj/item/clothing/mask/horsehead/speechModification(message)
	if(!canremove)
		message = pick("NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!")
	return message

/obj/item/clothing/mask/cowmask
	name = "cowface"
	desc = "It looks like a mask, but closer inspection reveals it's melded onto this persons face!"
	icon_state = "cowmask"
	item_state = "cowmask"
	flags = BLOCKHAIR
	flags_inv = HIDEFACE
	body_parts_covered = HEAD|FACE|EYES
	w_class = 2

/obj/item/clothing/mask/cowmask/speechModification(message)
	if(!canremove)
		message = pick("Moooooooo!", "Moo!", "Moooo!")
	return message

/obj/item/clothing/mask/bandana
	name = "botany bandana"
	desc = "A fine bandana with nanotech lining and a hydroponics pattern."
	w_class = 1
	flags = MASKCOVERSMOUTH
	actions_types = /datum/action/item_action/attack_self
	icon_state = "bandbotany"
	body_parts_covered = 0

/obj/item/clothing/mask/dealwithit
	name = "ultracool sunglasses"
	desc = "This station is too easy for you, deal with it."
	icon_state = "dealwithit"
	flags_inv = HIDEFACE
	body_parts_covered = FACE|EYES

/obj/item/clothing/mask/chicken
	name = "chicken suit head"
	desc = "Bkaw!"
	icon_state = "chickenmask"
	flags = BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/chicken/speechModification(message)
	if(!canremove)
		message = pick("BKAW!", "BUK BUK!", "Ba-Gawk!")
	return message

/obj/item/clothing/mask/bandana/verb/adjustmask()
	set category = "Object"
	set name = "Adjust bandana"
	set src in usr
	if(usr.canmove && !usr.stat && !usr.restrained())
		flags ^= MASKCOVERSMOUTH
		if(flags & MASKCOVERSMOUTH)
			src.icon_state = initial(icon_state)
			to_chat(usr, "Your bandana is now covering your face.")
		else
			src.icon_state += "_up"
			to_chat(usr, "You tie the bandana around your head.")
		usr.update_inv_wear_mask()

/obj/item/clothing/mask/bandana/attack_self(mob/user)
	adjustmask(user)

/obj/item/clothing/mask/bandana/red
	name = "red bandana"
	desc = "A fine red bandana with nanotech lining."
	icon_state = "bandred"

/obj/item/clothing/mask/bandana/blue
	name = "blue bandana"
	desc = "A fine blue bandana with nanotech lining."
	icon_state = "bandblue"

/obj/item/clothing/mask/bandana/green
	name = "green bandana"
	desc = "A fine green bandana with nanotech lining."
	icon_state = "bandgreen"

/obj/item/clothing/mask/bandana/gold
	name = "gold bandana"
	desc = "A fine gold bandana with nanotech lining."
	icon_state = "bandgold"

/obj/item/clothing/mask/bandana/black
	name = "black bandana"
	desc = "A fine black bandana with nanotech lining."
	icon_state = "bandblack"

/obj/item/clothing/mask/bandana/skull
	name = "skull bandana"
	desc = "A fine black bandana with nanotech lining and a skull emblem."
	icon_state = "bandskull"

/obj/item/clothing/mask/tie/collar
	name = "silver collar"
	desc = "A common collar with silver covering"
	icon_state = "collar"
	body_parts_covered = 0

/obj/item/clothing/mask/tie/collar2
	name = "gold collar"
	desc = "A common collar with gold covering"
	icon_state = "collar2"
	body_parts_covered = 0