//todo for pickles
obj/item/seeds/cucumber
	name = "pack of cucumber seeds"
	desc = "Boil 'em! Mash 'em! Stick 'em in a stew!"
	icon_state = "seed-potato"
	species = "potato"
	plantname = "Cucumber Plants"
	product = /obj/item/reagent_containers/food/snacks/grown/potato
	lifespan = 30
	maturation = 10
	production = 1
	yield = 4
	growthstages = 4
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "potato-grow"
	icon_dead = "potato-dead"
	genes = list(/datum/plant_gene/trait/battery)
	mutatelist = list(/obj/item/seeds/potato/sweet)
	reagents_add = list("vitamin" = 0.04, "nutriment" = 0.1)


/obj/item/reagent_containers/food/snacks/grown/pickle
	seed = /obj/item/seeds/cucumber
	name = "pickle"
	desc = "Wubba lubba dub dub!"
	icon_state = "pickle"
	filling_color = "#446038"
	bitesize_mod = 2
	foodtype = VEGETABLES


/obj/item/reagent_containers/food/snacks/grown/pickle/attackby(obj/item/W, mob/user, params)

	if(istype(W, /obj/item/device/mmi))
		var/obj/item/device/mmi/M = W
			if(!isturf(loc))
				to_chat(user, "<span class='warning'>You can't put [M] in, the pickle has to be inert!</span>")
				return
			if(!M.brainmob)
				to_chat(user, "<span class='warning'>Sticking an empty [M.name] into the pickle would sort of defeat the purpose!</span>")
				return

		var/mob/living/brain/BM = M.brainmob
			if(!BM.key || !BM.mind)
				to_chat(user, "<span class='warning'>The MMI indicates that their mind is completely unresponsive; there's no point!</span>")
				return

			if(!BM.client) //braindead
				to_chat(user, "<span class='warning'>The MMI indicates that their mind is currently inactive; it might change!</span>")
				return

			if(BM.stat == DEAD || (M.brain && M.brain.damaged_brain))
				to_chat(user, "<span class='warning'>Sticking a dead brain into the frame would sort of defeat the purpose!</span>")
				return

			if(!user.temporarilyRemoveItemFromInventory(W))
				return

	else(

