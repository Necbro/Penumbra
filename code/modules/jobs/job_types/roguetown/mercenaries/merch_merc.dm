/datum/job/roguetown/grabber
	title = "Henchman"
	flag = GRABBER
	department_flag = MERCENARIES
	faction = "Station"
	total_positions = 3
	spawn_positions = 3

	allowed_races = RACES_VERY_SHUNNED_UP
	allowed_sexes = list(MALE, FEMALE)

	tutorial = "You're hired muscle for the local brothel. \
				You work directly under the Brothel's ownership, whether that be a Nightmaster or Nightmatron. \
				Assure nobody causes trouble or harms the prostitutes, \
				alongside the added help of keeping the long arm of the law away from the shady business happening inside."

	outfit = /datum/outfit/job/roguetown/grabber
	display_order = JDO_GRABBER
	give_bank_account = TRUE
	min_pq = 0
	max_pq = null
	advjob_examine = TRUE
	advclass_cat_rolls = list(CTAG_HENCH = 20)
	cmode_music = 'sound/music/combat_giza.ogg'

/datum/outfit/job/roguetown/grabber/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == MALE)
		shoes = /obj/item/clothing/shoes/roguetown/boots/armor/leather
		pants = /obj/item/clothing/under/roguetown/tights/sailor
		neck = /obj/item/storage/belt/rogue/pouch/coins/poor
		beltl = /obj/item/storage/keyring/nightman
		belt = /obj/item/storage/belt/rogue/leather
		backl = /obj/item/storage/backpack/rogue/satchel
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor
		if(prob(30))
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/red
		if(prob(23))
			armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
	else
		head = /obj/item/clothing/head/roguetown/helmet/bandana
		shoes = /obj/item/clothing/shoes/roguetown/gladiator
		pants = /obj/item/clothing/under/roguetown/tights/sailor
		neck = /obj/item/storage/belt/rogue/pouch/coins/poor
		beltl = /obj/item/storage/keyring/nightman
		belt = /obj/item/storage/belt/rogue/leather
		backl = /obj/item/storage/backpack/rogue/satchel
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor
		if(prob(23))
			armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
		if(prob(77))
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/red

	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger)


/datum/job/roguetown/grabber/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")

//General purpose muscle. Decent stat spread and a mace.
/datum/advclass/grabber_muscle
	name = "Muscle"
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/grabber/muscle
	tutorial = "Picked up off the street, or otherwise brought into the life of the Brothel, it matters little to you. \
	You've a mace and the skill to beat someone's head in. Do your job in keeping the order of this wonderful establishment. By force, if needed."
	category_tags = list(CTAG_HENCH)
	traits_applied = list(TRAIT_STRONG_GRABBER, TRAIT_CHARGER, TRAIT_MEDIUMARMOR)

/datum/outfit/job/roguetown/grabber/muscle/pre_equip(mob/living/carbon/human/H)
	. = ..()
	beltr = /obj/item/rogueweapon/mace
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/hunting, 1, TRUE)
		H.change_stat("endurance", 4)
		H.change_stat("strength", 3)
		H.change_stat("constitution", 2)

//Female leaning grunt. Based around the sword entirely. Nutcracker too, I guess, since that's funny.

/datum/advclass/grabber_adherent
	name = "Adherent"
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/grabber/adherent
	tutorial = "At one point, you were a prostitute of the Brothel. Now? You defend them. \
	Seeing potential in you, the Wightvein's owner saw to your training. \
	No expense was spared, assuring you're easily the best sword hand this side of the harbour. Or so they say."
	category_tags = list(CTAG_HENCH)
	traits_applied = list(TRAIT_NUTCRACKER, TRAIT_DODGEEXPERT) //What else could they get? No idea.

/datum/outfit/job/roguetown/grabber/adherent/pre_equip(mob/living/carbon/human/H)
	. = ..()
	beltr = /obj/item/rogueweapon/sword/cutlass
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/alchemy, 2, TRUE) //They're more likely to fuck with poison to deal with troublemakers.
		//weaker Nightmaiden skills, they were a old prostitute, so might as well
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3 , TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/music, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)

		H.change_stat("speed", 4)
		H.change_stat("endurance", 2)
		H.change_stat("strength", 1)

//Male leaning grunt. Entire thing is based around unarmed combat, akin to a monk. Doesn't get dodge expert, for obvious reasons.
//No, I don't.
/datum/advclass/grabber_bouncer
	name = "Bouncer"
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/grabber/bouncer
	tutorial = "The hired muscle? Those brought up with sword training? Neither are relevant to you. \
	What is? Those guns you possess. The last man, or woman for that matter, to say otherwise? They went into the harbour. \
	Only a fool needs weapons."
	category_tags = list(CTAG_HENCH)
	traits_applied = list(TRAIT_STRONG_GRABBER, TRAIT_PUGILIST, TRAIT_CRITICAL_RESISTANCE, TRAIT_NOPAINSTUN) //They don't get a duster, but they get traits to atleast accomodate punching.

/datum/outfit/job/roguetown/grabber/bouncer/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/hunting, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3 , TRUE)
		H.change_stat("strength", 3)//On par with monk.
		H.change_stat("endurance", 2)
		H.change_stat("speed", 1)
		H.change_stat("constitution", 1)