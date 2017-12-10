/mob/living/carbon/human/movement_delay()
	. = 0
	var/static/config_human_delay
	if(isnull(config_human_delay))
		config_human_delay = CONFIG_GET(number/human_delay)
	. += ..() + config_human_delay + dna.species.movement_delay(src)

/mob/living/carbon/human/slip(knockdown_amount, obj/O, lube)
	if(isobj(shoes) && (shoes.flags_1&NOSLIP_1) && !(lube&GALOSHES_DONT_HELP))
		return 0
	return ..()

/mob/living/carbon/human/experience_pressure_difference()
	playsound(src, 'sound/effects/space_wind.ogg', 50, 1)
	if(shoes && shoes.flags_1&NOSLIP_1)
		return 0
	return ..()

/mob/living/carbon/human/mob_has_gravity()
	. = ..()
	if(!.)
		if(mob_negates_gravity())
			. = 1

/mob/living/carbon/human/mob_negates_gravity()
	return ((shoes && shoes.negates_gravity()) || dna.species.negates_gravity(src))

/mob/living/carbon/human/Move(NewLoc, direct)
	. = ..()
	stepcounter += 1
	for(var/datum/mutation/human/HM in dna.mutations)
		HM.on_move(src, NewLoc)

	//Bone fracture effects placeholder until we get organ damage
	if (stepcounter == 10)
		var/obj/item/bodypart/HD = get_bodypart("head")
		if(HD.damagestatus == BP_BROKEN)
			if(prob(1))
				adjustBrainLoss(2)
				blur_eyes(1)
				to_chat(src, "<span class='notice'>You feel a sharp pain in the center of your skull.</span>")
				emote("scream")
			if(prob(1))
				adjustEarDamage(5, 10)
				to_chat(src, "<span class='notice'>You feel a sharp pain in your inner ear.</span>")
			if(prob(1))
				adjust_eye_damage(5)
				blur_eyes(1)
				to_chat(src, "<span class='notice'>You feel a stinging pressure behind your eyeballs.</span>")

		var/obj/item/bodypart/CH = get_bodypart("chest")
		if(CH.damagestatus == BP_BROKEN)
			if(prob(1))
				if(losebreath <= 10)
					losebreath = Clamp(losebreath + 5, 0, 10)
				adjustOxyLoss(10)
				to_chat(src, "<span class='notice'>You feel a sting in your lungs and lose your breath.</span>")

			if(prob(1))
				Stun(rand(40,60))
				adjustToxLoss(1)
				vomit(50)
				to_chat(src, "<span class='notice'>You feel a sharp pain in your abdomen as a wave of nausea washes over you.</span>")
		stepcounter = 0

	if(shoes)
		if(!lying && !buckled)
			if(loc == NewLoc)
				if(!has_gravity(loc))
					return
				var/obj/item/clothing/shoes/S = shoes

				//Bloody footprints
				var/turf/T = get_turf(src)
				if(S.bloody_shoes && S.bloody_shoes[S.blood_state])
					var/obj/effect/decal/cleanable/blood/footprints/oldFP = locate(/obj/effect/decal/cleanable/blood/footprints) in T
					if(oldFP && oldFP.blood_state == S.blood_state)
						return
					else
						//No oldFP or it's a different kind of blood
						S.bloody_shoes[S.blood_state] = max(0, S.bloody_shoes[S.blood_state]-BLOOD_LOSS_PER_STEP)

						var/obj/effect/decal/cleanable/blood/footprints/FP
						if(S.blood_DNA && S.blood_DNA.len)
							switch(S.blood_DNA["color"])
								if("r")
									FP = new /obj/effect/decal/cleanable/blood/footprints/troll_r(T)
								if("b")
									FP = new /obj/effect/decal/cleanable/blood/footprints/troll_b(T)
								if("y")
									FP = new /obj/effect/decal/cleanable/blood/footprints/troll_y(T)
								if("l")
									FP = new /obj/effect/decal/cleanable/blood/footprints/troll_l(T)
								if("o")
									FP = new /obj/effect/decal/cleanable/blood/footprints/troll_o(T)
								if("j")
									FP = new /obj/effect/decal/cleanable/blood/footprints/troll_j(T)
								if("t")
									FP = new /obj/effect/decal/cleanable/blood/footprints/troll_t(T)
								if("c")
									FP = new /obj/effect/decal/cleanable/blood/footprints/troll_c(T)
								if("i")
									FP = new /obj/effect/decal/cleanable/blood/footprints/troll_i(T)
								if("p")
									FP = new /obj/effect/decal/cleanable/blood/footprints/troll_p(T)
								if("v")
									FP = new /obj/effect/decal/cleanable/blood/footprints/troll_v(T)
								if("f")
									FP = new /obj/effect/decal/cleanable/blood/footprints/troll_f(T)
								else
									FP = new /obj/effect/decal/cleanable/blood/footprints(T)
							FP.transfer_blood_dna(S.blood_DNA)
						else
							FP = new /obj/effect/decal/cleanable/blood/footprints(T)
						FP.blood_state = S.blood_state
						FP.entered_dirs |= dir
						FP.bloodiness = S.bloody_shoes[S.blood_state]
						FP.update_icon()
						update_inv_shoes()
				//End bloody footprints
				S.step_action()

/mob/living/carbon/human/Moved()
	. = ..()
	if(buckled_mobs && buckled_mobs.len && riding_datum)
		riding_datum.on_vehicle_move()

/mob/living/carbon/human/Process_Spacemove(movement_dir = 0) //Temporary laziness thing. Will change to handles by species reee.
	if(..())
		return 1
	return dna.species.space_move(src)
