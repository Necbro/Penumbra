/datum/preferences/proc/random_character(gender_override, antag_override = FALSE)
	if(!pref_species)
		random_species()
	real_name = pref_species.random_name(gender,1)
	if(gender_override)
		gender = gender_override
	else
		gender = pick(MALE,FEMALE)
	
	// Update pronouns and voice type to match gender
	switch(gender)
		if(MALE)
			pronouns = HE_HIM
			voice_type = VOICE_TYPE_MASC
		if(FEMALE)
			pronouns = SHE_HER
			voice_type = VOICE_TYPE_FEM
		else
			pronouns = THEY_THEM
			voice_type = VOICE_TYPE_ANDR
			
	age = AGE_ADULT
	var/list/skins = pref_species.get_skin_list()
	skin_tone = skins[pick(skins)]
	eye_color = random_eye_color()
	features = pref_species.get_random_features()
	body_markings = pref_species.get_random_body_markings(features)
	accessory = "Nothing"
	
	// Set up default genitals based on gender
	var/list/new_entries = list()
	var/datum/species/species = pref_species
	var/list/customizers = species.customizers
	
	for(var/customizer_type in customizers)
		var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
		if(!customizer.is_allowed(src))
			continue
		
		if(gender == MALE)
			if(istype(customizer, /datum/customizer/organ/penis))
				var/datum/customizer_entry/entry = customizer.make_default_customizer_entry(src, FALSE)  // Not disabled
				new_entries += entry
			else if(istype(customizer, /datum/customizer/organ/testicles))
				var/datum/customizer_entry/entry = customizer.make_default_customizer_entry(src, FALSE)  // Not disabled
				new_entries += entry
			else if(istype(customizer, /datum/customizer/organ/vagina))
				var/datum/customizer_entry/entry = customizer.make_default_customizer_entry(src, TRUE)   // Disabled
				new_entries += entry
		else
			if(istype(customizer, /datum/customizer/organ/vagina))
				var/datum/customizer_entry/entry = customizer.make_default_customizer_entry(src, FALSE)  // Not disabled
				new_entries += entry
			else if(istype(customizer, /datum/customizer/organ/penis))
				var/datum/customizer_entry/entry = customizer.make_default_customizer_entry(src, TRUE)   // Disabled
				new_entries += entry
	
	customizer_entries = new_entries
	validate_customizer_entries()
	
	reset_all_customizer_accessory_colors()
	randomize_all_customizer_accessories()

/datum/preferences/proc/random_species()
	var/random_species_type = GLOB.species_list[pick(get_selectable_species())]
	pref_species = new random_species_type
	if(randomise[RANDOM_NAME])
		real_name = pref_species.random_name(gender,1)
	set_new_race(new random_species_type)

/datum/preferences/proc/update_preview_icon()
	set waitfor = 0
	// Basic parent check first
	if(!parent)
		return

	// Determine what job is marked as 'High' priority, and dress them up as such.
	var/datum/job/previewJob
	var/highest_pref = 0
	for(var/job in job_preferences)
		if(job_preferences[job] > highest_pref)
			previewJob = SSjob.GetJob(job)
			highest_pref = job_preferences[job]

	// Set up the dummy for its photoshoot
	var/mob/living/carbon/human/dummy/mannequin = generate_or_wait_for_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)
	copy_to(mannequin, 1, TRUE, TRUE)

	if(previewJob)
		// Silicons only need a very basic preview since there is no customization for them.
		if(istype(previewJob,/datum/job/ai))
			parent.show_character_previews(image('icons/mob/ai.dmi', icon_state = resolve_ai_icon(preferred_ai_core_display), dir = SOUTH))
			unset_busy_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)
			return
		if(istype(previewJob,/datum/job/cyborg))
			parent.show_character_previews(image('icons/mob/robots.dmi', icon_state = "robot", dir = SOUTH))
			unset_busy_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)
			return

		testing("previewjob")
		mannequin.job = previewJob.title
		
		// First equip the base job outfit
		previewJob.equip(mannequin, TRUE, preference_source = parent)
		
		// Then check if this job has a selected class
		var/selected_class
		switch(previewJob.title)
			if("Occultist")
				selected_class = templar_class
			if("Town Guard")
				selected_class = town_guard_class
			if("Sergeant at Arms")
				selected_class = sergeant_class
			if("Knight Lieutenant")
				selected_class = knight_lieutenant_class
			if("Hand")
				selected_class = hand_class
			if("Squire")
				selected_class = squire_class
			if("Inquisitor")
				selected_class = inquisitor_class
			if("Mercenary")
				selected_class = mercenary_class
		
		// If a class is selected and the job has class options, layer the class outfit on top
		if(selected_class && previewJob.advclass_cat_rolls?.len)
			// Find the class datum
			for(var/type in subtypesof(/datum/advclass))
				var/datum/advclass/AC = new type()
				if(AC.name == selected_class)
					if(AC.outfit)
						// Clear any existing equipment first
						for(var/obj/item/I in mannequin)
							qdel(I)
						
						// Create outfit and equip items
						var/datum/outfit/O = new AC.outfit
						O.equip(mannequin, TRUE) // visualsOnly=TRUE to allow equipment but skip stat/skill changes
					qdel(AC)
					break

	mannequin.rebuild_obscured_flags()
	COMPILE_OVERLAYS(mannequin)
	if(parent)
		parent.show_character_previews(new /mutable_appearance(mannequin))
	unset_busy_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)

/datum/preferences/proc/spec_check(mob/user)
	if(!istype(pref_species))
		return FALSE
	if(!(pref_species.name in get_selectable_species()))
		return FALSE
	if(!pref_species.check_roundstart_eligible())
		return FALSE
	if(user && (pref_species.patreon_req > user.patreonlevel()))
		return FALSE
	return TRUE

/mob/proc/patreonlevel()
	if(client)
		return client.patreonlevel()
