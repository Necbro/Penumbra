/datum/job/roguetown/niteman
	title = "Bathmaster"
	flag = NITEMASTER
	department_flag = YEOMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	f_title = "Bathmatron"
	allowed_races = RACES_ALL_KINDS
	tutorial = "You run the town’s bathhouse as a front for illicit dealings. Behind the guise of a humble overseer, you peddle drugs and control a network of workers, blending charm with calculated manipulation to play for power."
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/niteman
	display_order = JDO_NITEMASTER
	give_bank_account = 20
	min_pq = 0 //No drugs until you finish the tutorial, Jimmy!
	max_pq = null
	bypass_lastclass = TRUE
	round_contrib_points = 3

/datum/outfit/job/roguetown/niteman/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/rope
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	beltr = /obj/item/storage/keyring/nightman
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	pants = /obj/item/clothing/under/roguetown/trou/leather
	ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DRUGENHANCER, TRAIT_GENERIC)
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE) // Need the strongarm to wrestle people out of the baths
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/stealing, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.change_stat("strength", 1)
		H.change_stat("intelligence", -1)
		H.change_stat("constitution", 1)
		H.change_stat("perception", -1)

	if(H.pronouns == HE_HIM || H.pronouns == THEY_THEM || H.pronouns == IT_ITS)
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor/nightman
		H.dna.species.soundpack_m = new /datum/voicepack/male/zeth()
	else
		armor = /obj/item/clothing/suit/roguetown/armor/armordress/alt
