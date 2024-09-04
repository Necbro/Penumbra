/datum/job/roguetown
	display_order = JOB_DISPLAY_ORDER_CAPTAIN

/datum/job/roguetown/New()
	. = ..()
	if(give_bank_account)
		for(var/X in GLOB.peasant_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.yeoman_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.church_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.garrison_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.noble_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.courtier_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.youngfolk_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.mercenary_positions)
			peopleiknow += X
			peopleknowme += X

/datum/outfit/job/roguetown
	uniform = null
	id = null
	ears = null
	belt = null
	back = null
	shoes = null
	box = null
	backpack = null
	satchel  = null
	duffelbag = null
	/// List of patrons we are allowed to use
	var/list/allowed_patrons
	/// Default patron in case the patron is not allowed
	var/datum/patron/default_patron
	/// Can select equipment after you spawn in.
	var/has_loadout = FALSE

/datum/outfit/job/roguetown/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	var/datum/patron/old_patron = H.patron
	if(length(allowed_patrons) && (!old_patron || !(old_patron.type in allowed_patrons)))
		var/list/datum/patron/possiblegods = list()
		var/list/datum/patron/preferredgods = list()
		for(var/god in GLOB.patronlist)
			if(!(god in allowed_patrons))
				continue
			possiblegods |= god
			var/datum/patron/PA = GLOB.patronlist[god]
			if(PA.associated_faith == old_patron.associated_faith) // prefer to pick a patron within the same faith before apostatizing
				preferredgods |= god
		if(length(preferredgods))
			H.set_patron(default_patron || pick(preferredgods))
		else
			H.set_patron(default_patron || pick(possiblegods))
		var/change_message = span_warning("[old_patron] had not endorsed my practices in my younger years. I've since grown accustomed to [H.patron].")
		if(H.client)
			to_chat(H, change_message)
		else
			// Characters during round start are first equipped before clients are moved into them. This is a bandaid to give an important piece of information correctly to the client
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, change_message), 5 SECONDS)
	if(H.mind)
		var/datum/species/pref_species = H.dna?.species
		var/weak_gender = FEMALE
		if(pref_species?.gender_swapping)
			weak_gender = MALE
		if(H.gender == weak_gender)
			H.mind.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/weaving, 1, TRUE)
		if(H.dna)
			if(H.dna.species)
				if(H.dna.species.name in list("Elf", "Half-Elf"))
					H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.update_body()

/datum/outfit/job/roguetown/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(H.mind)
		if(H.ckey)
			if(check_crownlist(H.ckey))
				H.mind.special_items["Champion Circlet"] = /obj/item/clothing/head/roguetown/crown/sparrowcrown
			give_special_items(H)
	for(var/list_key in SStriumphs.post_equip_calls)
		var/datum/triumph_buy/thing = SStriumphs.post_equip_calls[list_key]
		thing.on_activate(H)
	if(has_loadout && H.mind)
		addtimer(CALLBACK(src, PROC_REF(choose_loadout), H), 50)
	return

/datum/outfit/job/roguetown/proc/choose_loadout(mob/living/carbon/human/H)
	if(!has_loadout)
		return
	if(!H.client)
		addtimer(CALLBACK(src, PROC_REF(choose_loadout), H), 50)
		return