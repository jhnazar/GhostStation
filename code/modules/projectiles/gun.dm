/obj/item/weapon/gun
	name = "gun"
	desc = "It's a gun. It's pretty terrible, though."
	icon = 'icons/obj/gun.dmi'
	icon_state = "detective"
	item_state = "gun"
	flags =  CONDUCT
	slot_flags = SLOT_BELT
	m_amt = 2000
	w_class = 3.0
	throwforce = 5
	throw_speed = 4
	throw_range = 5
	force = 5.0
	origin_tech = "combat=1"
	attack_verb = list("struck", "hit", "bashed")
	actions_types = /datum/action/item_action/attack_self
	var/obj/item/ammo_casing/chambered = null
	var/fire_sound = 'sound/weapons/Gunshot.ogg'
	var/load_sound = null
	var/unload_sound = null
	var/silenced = 0
	var/recoil = 0
	var/clumsy_check = 1
	var/can_suicide_with = TRUE
	var/tmp/list/mob/living/target //List of who yer targeting.
	var/tmp/lock_time = -100
	var/automatic = 0 //Used to determine if you can target multiple people.
	var/tmp/mob/living/last_moved_mob //Used to fire faster at more than one person.
	var/tmp/told_cant_shoot = 0 //So that it doesn't spam them with the fact they cannot hit them.
	var/firerate = 0 	//0 for keep shooting until aim is lowered
						// 1 for one bullet after tarrget moves and aim is lowered
	var/fire_delay = 6
	var/last_fired = 0

	var/burst_mode = FALSE
	var/burst_amount = 1
	var/burst_delay = 3 //in world ticks

	lefthand_file = 'icons/mob/inhands/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/guns_righthand.dmi'

	var/wielded = FALSE
	var/twohands_required = FALSE

/obj/item/weapon/gun/update_twohanding()
	if(twohands_required)
		var/mob/living/M = loc
		if(istype(M) && is_held_twohanded(M))
			wielded = TRUE
		else
			wielded = FALSE
		update_icon()
		..()

/obj/item/weapon/gun/proc/ready_to_fire()
	if(world.time >= last_fired + fire_delay)
		last_fired = world.time
		return 1
	else
		return 0

/obj/item/weapon/gun/proc/process_chamber()
	return 0

/obj/item/weapon/gun/proc/special_check(mob/M, atom/target) //Placeholder for any special checks, like detective's revolver. or wizards
	if(M.mind && M.mind.special_role == "Wizard")
		return FALSE
	if(!wielded && twohands_required && ishuman(M))
		to_chat(M, "<span class='red'>You must hold [src.name] in both hands in order to fire!</span>")
		return FALSE
	return TRUE

/obj/item/weapon/gun/proc/shoot_with_empty_chamber(mob/living/user)
	to_chat(user, "<span class='warning'>*click*</span>")
	playsound(user, 'sound/weapons/empty.ogg', 100, 1)
	return

/obj/item/weapon/gun/proc/shoot_live_shot(mob/living/user)
	if(recoil)
		shake_camera(user, recoil + 1, recoil)

	if(silenced)
		playsound(user, fire_sound, 10, 1)
	else
		playsound(user, fire_sound, 50, 0)
		user.visible_message("<span class='danger'>[user] fires [src]!</span>", "<span class='danger'>You fire [src]!</span>", "You hear a [istype(src, /obj/item/weapon/gun/energy) ? "laser blast" : "gunshot"]!")

/obj/item/weapon/gun/emp_act(severity)
	for(var/obj/O in contents)
		O.emp_act(severity)

/obj/item/weapon/gun/Destroy()
	qdel(chambered)
	chambered = null
	return ..()

/obj/item/weapon/gun/afterattack(atom/A, mob/living/user, flag, params)
	if(flag)	return //It's adjacent, is the user, or is on the user's person
	if(istype(target, /obj/machinery/recharger) && istype(src, /obj/item/weapon/gun/energy))	return//Shouldnt flag take care of this?
	if(user && user.client && user.client.gun_mode && !(A in target))
		PreFire(A,user,params) //They're using the new gun system, locate what they're aiming at.
	else
		Fire(A,user,params) //Otherwise, fire normally.

/mob/living/carbon/AltClickOn(atom/A)
	if(isliving(A))
		var/mob/living/M = A
		var/obj/item/I = get_active_hand()
		if(istype(I, /obj/item/weapon/gun))
			var/obj/item/weapon/gun/G = I
			if(M in G.target)
				M.NotTargeted(G)
			else
				G.PreFire(M, src)
			return
	..()

/obj/item/weapon/gun/proc/Fire(atom/target, mob/living/user, params, reflex = 0)//TODO: go over this
	//Exclude lasertag guns from the CLUMSY check.
	if(!user.IsAdvancedToolUser())
		to_chat(user, "<span class='red'>You don't have the dexterity to do this!</span>")
		return
	if(isliving(user))
		var/mob/living/M = user
		if (HULK in M.mutations)
			to_chat(M, "<span class='red'>Your meaty finger is much too large for the trigger guard!</span>")
			return
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.species.name == SHADOWLING)
				to_chat(H, "<span class='notice'>Your fingers don't fit in the trigger guard!</span>")
				return

			if(user.dna && user.dna.mutantrace == "adamantine")
				to_chat(user, "<span class='red'>Your metal fingers don't fit in the trigger guard!</span>")
				return
			if(H.wear_suit && istype(H.wear_suit, /obj/item/clothing/suit))
				var/obj/item/clothing/suit/V = H.wear_suit
				V.attack_reaction(H, REACTION_GUN_FIRE)

			if(clumsy_check) //it should be AFTER hulk or monkey check.
				var/going_to_explode = 0
				if ((CLUMSY in H.mutations) && prob(50))
					going_to_explode = 1
				if(chambered && chambered.crit_fail && prob(10))
					going_to_explode = 1
				if(going_to_explode)
					explosion(user.loc, 0, 0, 1, 1)
					to_chat(H, "<span class='danger'>[src] blows up in your face.</span>")
					H.take_bodypart_damage(0, 20)
					H.drop_item()
					qdel(src)
					return

	add_fingerprint(user)

	if(!special_check(user, target))
		return

	if (!ready_to_fire())
		if (world.time % 3) //to prevent spam
			to_chat(user, "<span class='warning'>[src] is not ready to fire again!</span>")
		return

	if(chambered)
		if(burst_mode)
			var/Burst_iter = burst_amount
			while(Burst_iter--)
				if(!single_shot(target, user, params))
					shoot_with_empty_chamber(user)
					break
				shoot_live_shot(user)
				if(burst_delay)
					sleep(burst_delay * world.tick_lag)
		else
			single_shot(target, user, params) ? shoot_live_shot(user) : shoot_with_empty_chamber(user)
	else
		shoot_with_empty_chamber(user)
	update_icon()

	if(user.hand)
		user.update_inv_l_hand()
	else
		user.update_inv_r_hand()

/obj/item/weapon/gun/proc/single_shot(atom/target, mob/living/user, params)
	if(chambered.fire(target, user, params, , silenced))
		user.newtonian_move(get_dir(target, user))
		process_chamber()
		return TRUE
	else
		process_chamber()
		return FALSE

/obj/item/weapon/gun/proc/can_fire()
	return

/obj/item/weapon/gun/proc/can_hit(mob/living/target, mob/living/user)
	return chambered.BB.check_fire(target,user)

/obj/item/weapon/gun/proc/click_empty(mob/user = null)
	if (user)
		user.visible_message("*click click*", "<span class='red'><b>*click*</b></span>")
		playsound(user, 'sound/weapons/empty.ogg', 100, 1)
	else
		src.visible_message("*click click*")
		playsound(src.loc, 'sound/weapons/empty.ogg', 100, 1)

/obj/item/weapon/gun/proc/isHandgun()
	return 1

/obj/item/weapon/gun/attack(mob/living/M, mob/living/user, def_zone)
	//Suicide handling.
	if (M == user && def_zone == O_MOUTH)
		if(user.is_busy())
			return
		if(!can_suicide_with)
			to_chat(user, "<span class='notice'>You have tried to commit suicide, but couldn't do it with [src].</span>")
			return
		if(isrobot(user))
			to_chat(user, "<span class='notice'>You have tried to commit suicide, but couldn't do it.</span>")
			return
		M.visible_message("<span class='warning'>[user] sticks their gun in their mouth, ready to pull the trigger...</span>")
		if(!do_after(user, 40, target = user))
			M.visible_message("<span class='notice'>[user] decided life was worth living.</span>")
			return
		if (can_fire())
			user.visible_message("<span class = 'warning'>[user] pulls the trigger.</span>")
			if(silenced)
				playsound(user, fire_sound, 10, 1)
			else
				playsound(user, fire_sound, 50, 1)
			if(istype(chambered.BB, /obj/item/projectile/beam/lastertag) || istype(chambered.BB, /obj/item/projectile/beam/practice))
				user.visible_message("<span class = 'notice'>Nothing happens.</span>",\
									"<span class = 'notice'>You feel rather silly, trying to commit suicide with a toy.</span>")
				return
			if(istype(chambered.BB, /obj/item/projectile/bullet/chameleon))
				user.visible_message("<span class = 'notice'>Nothing happens.</span>",\
									"<span class = 'notice'>You feel weakness and the taste of gunpowder, but no more.</span>")
				user.apply_effect(5,WEAKEN,0)
				return

			chambered.BB.on_hit(M)
			if (chambered.BB.damage_type != HALLOSS)
				user.apply_damage(chambered.BB.damage * 2.5, chambered.BB.damage_type, BP_HEAD, null, chambered.BB.damage_flags(), "Point blank shot in the mouth with \a [chambered.BB]")
				user.death()
			else
				to_chat(user, "<span class = 'notice'>Ow...</span>")
				user.apply_effect(110,AGONY,0)
			chambered.BB = null
			chambered.update_icon()
			update_icon()
			process_chamber()
			return
		else
			click_empty(user)
			return

	if (can_fire())
		//Point blank shooting if on harm intent or target we were targeting.
		if(!special_check(user, target))
			return
		if(user.a_intent == "hurt")
			user.visible_message("<span class='red'><b> \The [user] fires \the [src] point blank at [M]!</b></span>")
			chambered.BB.damage *= 1.3
			chambered.BB.point_blank = TRUE
			Fire(M,user)
			return
		else if(target && M in target)
			Fire(M,user) ///Otherwise, shoot!
			return
	else
		return ..()