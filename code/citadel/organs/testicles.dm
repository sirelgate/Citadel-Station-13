/obj/item/organ/genital/testicles
	name = "Testicles"
	desc = "A male reproductive organ."
	icon_state = "testicles"
	icon = 'code/citadel/icons/penis.dmi'
	zone = "groin"
	slot = "testicles"
	w_class = 3
	var/internal 		= FALSE
	size 				= BALLS_SIZE_DEF
	var/sack_size		= BALLS_SACK_SIZE_DEF
	fluid_id 			= "semen"
	producing			= TRUE
	var/sent_full_message = 1 //defaults to 1 since they're full to start
	var/obj/item/organ/genital/penis/linked_penis

/obj/item/organ/genital/testicles/Initialize()
	. = ..()
	reagents.add_reagent(fluid_id, fluid_max_volume)

/obj/item/organ/genital/testicles/on_life()
	if(QDELETED(src))
		return
	if(reagents && producing)
		generate_cum()

/obj/item/organ/genital/testicles/proc/generate_cum()
	reagents.maximum_volume = fluid_max_volume
	if(reagents.total_volume >= reagents.maximum_volume)
		if(!sent_full_message)
			send_full_message()
			sent_full_message = 1
		return FALSE
	sent_full_message = 0
	update_link()
	if(!linked_penis)
		return FALSE
	reagents.isolate_reagent(fluid_id)//remove old reagents if it changed and just clean up generally
	reagents.add_reagent(fluid_id, (fluid_mult * fluid_rate))//generate the cum

/obj/item/organ/genital/testicles/update_link()
	if(owner && !QDELETED(src))
		linked_penis = (owner.getorganslot("penis"))
		if(linked_penis)
			linked_penis.linked_balls = src
	else
		if(linked_penis)
			linked_penis.linked_balls = null
		linked_penis = null

/obj/item/organ/genital/testicles/proc/send_full_message(msg = "Your balls finally feel full, again.")
	if(owner && istext(msg))
		owner << msg
		return TRUE

