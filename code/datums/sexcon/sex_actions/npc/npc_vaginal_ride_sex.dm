/datum/sex_action/npc_vaginal_ride_sex
	name = "Ride them"
	stamina_cost = 0
	check_same_tile = FALSE

/datum/sex_action/npc_vaginal_ride_sex/shows_on_menu(mob/living/user, mob/living/target)
	return FALSE

/datum/sex_action/npc_vaginal_ride_sex/can_perform(mob/living/user, mob/living/target)
	if(issimple(user))
		return TRUE
	return FALSE

/datum/sex_action/npc_vaginal_ride_sex/on_start(mob/living/user, mob/living/target)
	user.visible_message(span_warning("[user] gets on top of [target] and begins riding them with their cunt!"))
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), 20, TRUE, ignore_walls = FALSE)
	var/datum/sex_controller/sc = target.sexcon
	sc.beingfucked = TRUE

/datum/sex_action/npc_vaginal_ride_sex/on_perform(mob/living/user, mob/living/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] rides [target]."))
	playsound(target, 'sound/misc/mat/segso.ogg', 50, TRUE, -2, ignore_walls = FALSE)

	target.adjustBruteLoss(-0.2)
	target.adjustFireLoss(-0.2)
	target.adjustOxyLoss(-0.2)
	if(target.sexcon.considered_limp())
		user.sexcon.perform_sex_action(target, 1.2, 3, TRUE)
	else
		user.sexcon.perform_sex_action(target, 2.4, 7, TRUE)
	user.sexcon.handle_passive_ejaculation()

	user.sexcon.perform_sex_action(target, 2, 4, FALSE)
	if(target.sexcon.check_active_ejaculation())
		target.visible_message(span_love("[target] cums into [user]'s cunt!"))
		target.sexcon.cum_into(vaginal = TRUE)
//		target.try_impregnate(user)
		target.virginity = FALSE
		user.virginity = FALSE

/datum/sex_action/npc_vaginal_ride_sex/on_finish(mob/living/user, mob/living/target)
	user.visible_message(span_warning("[user] gets off [target]."))
	var/mob/living/simple_animal/hostile/retaliate/rogue/usermob = user
	usermob.stoppedfucking()
	var/datum/sex_controller/sc = target.sexcon
	sc.beingfucked = FALSE


/datum/sex_action/npc_vaginal_ride_sex/is_finished(mob/living/user, mob/living/target)
	if(user.sexcon.finished_check())
		var/mob/living/simple_animal/hostile/retaliate/rogue/usermob = user
		usermob.stoppedfucking()
		var/datum/sex_controller/sc = target.sexcon
		sc.beingfucked = FALSE
		return TRUE
	return FALSE