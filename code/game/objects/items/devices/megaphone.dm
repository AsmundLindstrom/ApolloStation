/obj/item/device/megaphone
	name = "megaphone"
	desc = "A device used to project your voice. Loudly."
	icon_state = "megaphone"
	item_state = "radio"
	w_class = 2.0
	flags = CONDUCT

	var/spamcheck = 0
	var/emagged = 0
	var/insults = 0
	var/list/insultmsg = list("FUCK EVERYONE!", "I'M A TATER!", "ALL SECURITY TO SHOOT ME ON SIGHT!", "I HAVE A BOMB!", "CAPTAIN IS A COMDOM!", "FOR THE SYNDICATE!")

/obj/item/device/megaphone/attack_self(mob/living/user as mob)
	if (user.client)
		if(user.client.prefs.muted & MUTE_IC)
			src << "<span class='alert'>You cannot speak in IC (muted).</span>"
			return
	if(!ishuman(user))
		user << "<span class='alert'>You don't know how to use this!</span>"
		return
	if(user.silent)
		return
	if(spamcheck)
		user << "<span class='alert'>\The [src] needs to recharge!</span>"
		return

	var/message = sanitize(input(user, "Shout a message?", "Megaphone", null)  as text)
	if(!message)
		return
	message = capitalize(message)
	if ((src.loc == user && usr.stat == 0))
		if(emagged)
			if(insults)
				for(var/mob/O in (viewers(user)))
					O.show_message("<B>[user]</B> broadcasts, <FONT size=3>\"[pick(insultmsg)]\"</FONT>",2) // 2 stands for hearable message
				insults--
			else
				user << "<span class='alert'>*BZZZZzzzzzt*</span>"
		else
			for(var/mob/O in (viewers(user)))
				O.show_message("<B>[user]</B> broadcasts, <FONT size=3>\"[message]\"</FONT>",2) // 2 stands for hearable message

		spamcheck = 1
		spawn(20)
			spamcheck = 0
		return

/obj/item/device/megaphone/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/card/emag) && !emagged)
		user << "<span class='alert'>You overload \the [src]'s voice synthesizer.</span>"
		emagged = 1
		insults = rand(1, 3)//to prevent dickflooding
		return
	return
