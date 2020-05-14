//Procedures in this file: Eye mending surgery
//////////////////////////////////////////////////////////////////
//						EYE SURGERY							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/eye
	clothless = 0
	priority = 2
	can_infect = 1

/datum/surgery_step/eye/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!ishuman(target))
		return 0
	var/obj/item/organ/external/BP = target.get_bodypart(target_zone)
	if (!BP)
		return 0
	return target_zone == O_EYES

/datum/surgery_step/eye/cut_open
	allowed_tools = list(
	/obj/item/weapon/scalpel = 100,		\
	/obj/item/weapon/kitchenknife = 75,	\
	/obj/item/weapon/shard = 50, 		\
	)

	min_duration = 90
	max_duration = 110

/datum/surgery_step/eye/cut_open/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))	return 0
	return ..()

/datum/surgery_step/eye/cut_open/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to separate the corneas on [target]'s eyes with \the [tool].", \
	"You start to separate the corneas on [target]'s eyes with \the [tool].")
	..()

/datum/surgery_step/eye/cut_open/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("\blue [user] has separated the corneas on [target]'s eyes with \the [tool]." , \
	"\blue You have separated the corneas on [target]'s eyes with \the [tool].",)
	target.op_stage.eyes = 1
	target.blinded += 1.5

/datum/surgery_step/eye/cut_open/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/internal/eyes/IO = target.organs_by_name[O_EYES]
	var/obj/item/organ/external/BP = target.get_bodypart(target_zone)
	user.visible_message("\red [user]'s hand slips, slicing [target]'s eyes wth \the [tool]!" , \
	"\red Your hand slips, slicing [target]'s eyes wth \the [tool]!" )
	BP.createwound(CUT, 10)
	IO.take_damage(5, 0)

/datum/surgery_step/eye/lift_eyes
	allowed_tools = list(
	/obj/item/weapon/retractor = 100,	        \
	/obj/item/weapon/kitchen/utensil/fork = 75,	\
	/obj/item/weapon/screwdriver = 50
	)

	min_duration = 30
	max_duration = 40

/datum/surgery_step/eye/lift_eyes/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))	return 0
	return ..() && target.op_stage.eyes == 1

/datum/surgery_step/eye/lift_eyes/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts lifting corneas from [target]'s eyes with \the [tool].", \
	"You start lifting corneas from [target]'s eyes with \the [tool].")
	..()

/datum/surgery_step/eye/lift_eyes/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("\blue [user] has lifted the corneas from [target]'s eyes from with \the [tool]." , \
	"\blue You has lifted the corneas from [target]'s eyes from with \the [tool]." )
	target.op_stage.eyes = 2

/datum/surgery_step/eye/lift_eyes/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/internal/eyes/IO = target.organs_by_name[O_EYES]
	var/obj/item/organ/external/BP = target.get_bodypart(target_zone)
	user.visible_message("\red [user]'s hand slips, damaging [target]'s eyes with \the [tool]!", \
	"\red Your hand slips, damaging [target]'s eyes with \the [tool]!")
	target.apply_damage(10, BRUTE, BP)
	IO.take_damage(5, 0)

/datum/surgery_step/eye/mend_eyes
	allowed_tools = list(
	/obj/item/weapon/hemostat = 100,             \
	/obj/item/stack/cable_coil = 75,            \
	/obj/item/weapon/wirecutters = 75,           \
	/obj/item/weapon/kitchen/utensil/fork = 50,  \
	/obj/item/device/assembly/mousetrap = 10	//I don't know. Don't ask me. But I'm leaving it because hilarity.
	)

	min_duration = 80
	max_duration = 100

/datum/surgery_step/eye/mend_eyes/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))	return 0
	return ..() && target.op_stage.eyes == 2

/datum/surgery_step/eye/mend_eyes/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts mending the nerves and lenses in [target]'s eyes with \the [tool].", \
	"You start mending the nerves and lenses in [target]'s eyes with the [tool].")
	..()

/datum/surgery_step/eye/mend_eyes/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("\blue [user] mends the nerves and lenses in [target]'s with \the [tool]." ,	\
	"\blue You mend the nerves and lenses in [target]'s with \the [tool].")
	target.op_stage.eyes = 3

/datum/surgery_step/eye/mend_eyes/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/internal/eyes/IO = target.organs_by_name[O_EYES]
	var/obj/item/organ/external/BP = target.get_bodypart(target_zone)
	user.visible_message("\red [user]'s hand slips, stabbing \the [tool] into [target]'s eye!", \
	"\red Your hand slips, stabbing \the [tool] into [target]'s eye!")
	target.apply_damage(10, BRUTE, BP, null, DAM_SHARP)
	IO.take_damage(5, 0)

/datum/surgery_step/eye/cauterize
	allowed_tools = list(
	/obj/item/weapon/cautery = 100,			\
	/obj/item/clothing/mask/cigarette = 75,	\
	/obj/item/weapon/lighter = 50,			\
	/obj/item/weapon/weldingtool = 50
	)

	min_duration = 70
	max_duration = 100

/datum/surgery_step/eye/cauterize/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))	return 0
	return ..()

/datum/surgery_step/eye/cauterize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] is beginning to cauterize the incision around [target]'s eyes with \the [tool]." , \
	"You are beginning to cauterize the incision around [target]'s eyes with \the [tool].")

/datum/surgery_step/eye/cauterize/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/internal/eyes/eyes = target.organs_by_name[O_EYES]
	user.visible_message("\blue [user] cauterizes the incision around [target]'s eyes with \the [tool].", \
	"\blue You cauterize the incision around [target]'s eyes with \the [tool].")
	if (target.op_stage.eyes == 3)
		target.disabilities &= ~NEARSIGHTED
		target.sdisabilities &= ~BLIND
		eyes.damage = 0
	target.op_stage.eyes = 0

/datum/surgery_step/eye/cauterize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/internal/eyes/IO = target.organs_by_name[O_EYES]
	var/obj/item/organ/external/BP = target.get_bodypart(target_zone)
	user.visible_message("\red [user]'s hand slips,  searing [target]'s eyes with \the [tool]!", \
	"\red Your hand slips, searing [target]'s eyes with \the [tool]!")
	target.apply_damage(5, BURN, BP)
	IO.take_damage(5, 0)

//////////////////////////////////////////////////////////////////
//						ROBO EYE SURGERY						//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/ipc_eye
	clothless = FALSE
	priority = 2
	can_infect = FALSE

/datum/surgery_step/ipc_eye/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return FALSE
	if(!(target.species && target.species.flags[IS_SYNTHETIC]))
		return FALSE
	var/obj/item/organ/external/BP = target.get_bodypart(target_zone)
	if(!BP)
		return FALSE
	return target_zone == O_EYES

/datum/surgery_step/ipc_eye/screw_open
	allowed_tools = list(
	/obj/item/weapon/screwdriver = 100,
	/obj/item/weapon/scalpel = 75,
	/obj/item/weapon/kitchenknife = 75,
	/obj/item/weapon/shard = 50
	)

	min_duration = 90
	max_duration = 110

/datum/surgery_step/ipc_eye/screw_open/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..()

/datum/surgery_step/ipc_eye/screw_open/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] begins to unscrew [target]'s camera panels with \the [tool].",
	"You unscrew [target]'s camera panels with \the [tool].")
	..()

/datum/surgery_step/ipc_eye/screw_open/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] unscrewed [target]'s camera panels with \the [tool].</span>" ,
	"<span class='notice'>You unscrewed [target]'s camera panels with \the [tool].</span>")
	target.op_stage.eyes = 1
	if(!target.is_bruised_organ(O_KIDNEYS))
		to_chat(target, "<span class='warning italics'>%VISUALS DENIED%. REQUESTING ADDITIONAL PERSPECTION REACTIONS.</span>")
	target.blinded += 1.5

/datum/surgery_step/ipc_eye/screw_open/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/internal/eyes/IO = target.organs_by_name[O_EYES]
	var/obj/item/organ/external/BP = target.get_bodypart(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, scratching [target]'s cameras wth \the [tool]!</span>" ,
	"<span class='warning'>Your hand slips, scratching [target]'s cameras wth \the [tool]!</span>")
	BP.createwound(CUT, 10)
	IO.take_damage(5, 0)

/datum/surgery_step/ipc_eye/mend_cameras
	allowed_tools = list(
	/obj/item/stack/nanopaste = 100,
	/obj/item/weapon/bonegel = 30,
	/obj/item/weapon/wrench = 70
	)

	min_duration = 80
	max_duration = 100

/datum/surgery_step/ipc_eye/mend_cameras/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.eyes == 1

/datum/surgery_step/ipc_eye/mend_cameras/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts mending lenses and wires in [target]'s cameras with \the [tool].",
	"You start mending lenses and wires in [target]'s cameras with the [tool].")
	..()

/datum/surgery_step/ipc_eye/mend_cameras/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] mends the lenses and wires in [target]'s cameras with \the [tool].</span>",
	"<span class='notice'>You mend the lenses abd wires in [target]'s cameras with \the [tool].</span>")
	target.op_stage.eyes = 2

/datum/surgery_step/ipc_eye/mend_cameras/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/internal/eyes/IO = target.organs_by_name[O_EYES]
	var/obj/item/organ/external/BP = target.get_bodypart(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, denting [target]'s cameras with \the [tool]!</span>",
	"<span class='warning'>Your hand slips, denting [target]'s cameras with \the [tool]!</span>")
	var/dam_amt = 2

	if(istype(tool, /obj/item/stack/nanopaste) || istype(tool, /obj/item/weapon/bonegel))
		target.apply_damage(6, BURN, BP, null)

	else if(istype(tool, /obj/item/weapon/wrench))
		target.apply_damage(12, BRUTE, BP, null)
		BP.createwound(CUT, 5)

	IO.take_damage(dam_amt,0)
	if(!target.is_bruised_organ(O_KIDNEYS))
		to_chat(target, "<span class='warning italics'>SEVERE VISUAL SENSOR DAMAGE DETECTED. %REACTION_OVERLOAD%.</span>")
	target.blinded += 3.0

/datum/surgery_step/ipc_eye/close_shut
	allowed_tools = list(
	/obj/item/weapon/screwdriver = 100,
	/obj/item/weapon/scalpel = 75,
	/obj/item/weapon/kitchenknife = 75,
	/obj/item/weapon/shard = 50,
	)

	min_duration = 70
	max_duration = 100

/datum/surgery_step/ipc_eye/close_shut/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..()

/datum/surgery_step/ipc_eye/close_shut/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] is beginning to lock [target]'s camera panels with \the [tool]." ,
	"You are beginning to lock [target]'s camera panels with \the [tool].")

/datum/surgery_step/ipc_eye/closet_shut/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/internal/eyes/eyes = target.organs_by_name[O_EYES]
	user.visible_message("<span class='notice'>[user] locks [target]'s camera panels with \the [tool].</span>",
	"<span class='notice'>You lock [target]'s camera panels with \the [tool].</span>")
	if (target.op_stage.eyes == 2)
		target.disabilities &= ~NEARSIGHTED
		target.sdisabilities &= ~BLIND
		eyes.damage = 0
	target.op_stage.eyes = 0

/datum/surgery_step/ipc_eye/close_shut/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/internal/eyes/IO = target.organs_by_name[O_EYES]
	var/obj/item/organ/external/BP = target.get_bodypart(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips,  denting [target]'s cameras with \the [tool]!</span>",
	"<span class='warning'>Your hand slips, denting [target]'s cameras with \the [tool]!</span>")
	target.apply_damage(5, BRUTE, BP)
	IO.take_damage(5, 0)