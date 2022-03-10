#define sound_to(target, sound)                             target << (sound)
/obj/item/device/walkman
	name = "walkman"
	desc = "A cassette player that first hit the market over 200 years ago. Crazy how these never went out of style. Alt-click removes the Cassette. Ctrl-click changes to the next song"
	icon = 'voidcrew/icons/obj/walkman.dmi'
	icon_state = "walkman"
	w_class = WEIGHT_CLASS_SMALL
	actions_types = list(/datum/action/item_action/walkman/play_pause,/datum/action/item_action/walkman/next_song,/datum/action/item_action/walkman/restart_song)
	///the cassette tape object
	var/obj/item/device/cassette_tape/tape
	///if the walkman is paused or not
	var/paused = TRUE
	///songs inside the current playlist
	var/list/current_playlist = list()
	///names of the songs inside the current playlist
	var/list/current_songnames = list()
	///Current song being played
	var/sound/current_song
	///Who's using the walkman
	var/mob/current_listener
	///where in the playlist you are
	var/pl_index = 1
	///volume the walkman starts at
	var/volume = 25
	/// What kind of walkman design style to use
	var/design = 1

/obj/item/device/walkman/Initialize()
	. = ..()
	design = rand(1, 5)
	update_icon()

/obj/item/device/walkman/Destroy()
	QDEL_NULL(tape)
	break_sound()
	current_song = null
	current_listener = null
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/device/walkman/attackby(obj/item/cassette, mob/user)
	if(istype(cassette, /obj/item/device/cassette_tape))
		if(!tape)
			insert_tape(cassette)
			playsound(src,'sound/weapons/handcuffs.ogg',20,1)
			to_chat(user,("You insert \the [cassette] into \the [src]"))
		else
			to_chat(user,("Remove the other tape first!"))

/obj/item/device/walkman/attack_self(mob/user)
	..()

	if(!current_listener)
		current_listener = user
		START_PROCESSING(SSobj, src)
	if(istype(tape))
		if(paused)
			play()
			to_chat(user,("You press [src]'s 'play' button"))
		else
			pause()
			to_chat(user,("You pause [src]"))
		update_icon()
	else
		to_chat(user,("There's no tape to play"))
	playsound(src,'sound/machines/click.ogg',20,1)

/obj/item/device/walkman/AltClick(mob/user)
	if(tape)
		eject_tape(user)
		return
	else
		..()

/obj/item/device/walkman/CtrlClick(mob/user)
	if(tape)
		next_song(user)
		return

///This is called when sound needs to be broken ie you die or lose access to it
/obj/item/device/walkman/proc/break_sound()
	var/sound/break_sound = sound(null, 0, 0, SOUND_CHANNEL_WALKMAN)
	break_sound.priority = 255
	update_song(break_sound, current_listener, 0)

/*Called when songs are updated ie volume change
 *Arguments: mob/user -> the current user of the walkman
 * sound/noise -> the sound that is being directed to the user
 */
/obj/item/device/walkman/proc/update_song(sound/noise, mob/user, flags = SOUND_UPDATE)
	if(!istype(user) || !istype(noise)) return
	if(HAS_TRAIT(user, TRAIT_DEAF))
		flags |= SOUND_MUTE
	noise.status = flags
	noise.volume = src.volume
	noise.channel = SOUND_CHANNEL_WALKMAN
	sound_to(user,noise)

/*Called when music is paused by the user
 *Arguments: mob/user -> the current user of the walkman
 */
/obj/item/device/walkman/proc/pause(mob/user)
	if(!current_song) return
	paused = TRUE
	update_song(current_song,current_listener, SOUND_PAUSED | SOUND_UPDATE)

///Handles the actual playing of the sound to the current_listener
/obj/item/device/walkman/proc/play()
	if(!current_song)
		if(current_playlist.len > 0)
			current_song = sound(current_playlist[pl_index], 0, 0, SOUND_CHANNEL_WALKMAN, volume)
			current_song.status = SOUND_STREAM
		else
			return
	paused = FALSE
	if(current_song.status & SOUND_PAUSED)
		update_song(current_song,current_listener)
	else
		update_song(current_song,current_listener,0)

	update_song(current_song,current_listener)

/*Called when
 *Arguments: obj/item/device/cassette_tape/CT -> the cassette in question that you are inserting into the walkman
 */
/obj/item/device/walkman/proc/insert_tape(obj/item/device/cassette_tape/CTape)
	if(tape || !istype(CTape))
		return

	tape = CTape
	CTape.forceMove(src)

	update_icon()
	paused = TRUE
	pl_index = 1
	if(tape.songs["side1"] && tape.songs["side2"])
		var/list/list = tape.songs["[tape.flipped ? "side2" : "side1"]"]
		for(var/song in list)
			current_playlist += song
			current_songnames += list[song]

/*Called when you eject a tape
 *Arguments: mob/user -> the current user of the walkman
 */
/obj/item/device/walkman/proc/eject_tape(mob/user)
	if(!tape) return

	break_sound()

	current_song = null
	current_playlist.Cut()
	current_songnames.Cut()
	user.put_in_hands(tape)
	paused = TRUE
	tape = null
	update_icon()
	playsound(src,'sound/weapons/handcuffs.ogg',20,1)

/*Called when you need to go to next song either when it naturally ends or when user changes song manually
 *Arguments: mob/user -> the current user of the walkman
 */
/obj/item/device/walkman/proc/next_song(mob/user)

	if(current_playlist.len == 0)
		return

	break_sound()

	pl_index = (pl_index + 1 <= current_playlist.len) ? pl_index++ : 1

	current_song = sound(current_playlist[pl_index], 0, 0, SOUND_CHANNEL_WALKMAN, volume)
	current_song.status = SOUND_STREAM
	play()



/obj/item/device/walkman/update_icon()
	..()
	overlays.Cut()
	if(design)
		overlays += "+[design]"
	if(tape)
		if(!paused)
			overlays += "+playing"
	else
		overlays += "+empty"

	if(ishuman(loc))
		///current human used to get location
		var/mob/living/carbon/human/player = loc
		player.regenerate_icons()

/obj/item/device/walkman/process()
	if(!(src in current_listener.GetAllContents()) || current_listener.stat & DEAD)
		if(current_song)
			current_song = null
		break_sound()
		paused = TRUE
		current_listener = null
		update_icon()
		STOP_PROCESSING(SSobj, src)
		return

	if(HAS_TRAIT(current_listener, TRAIT_DEAF) && current_song && !(current_song.status & SOUND_MUTE))
		update_song(current_song, current_listener)
	if(!HAS_TRAIT(current_listener, TRAIT_DEAF) && current_song && current_song.status & SOUND_MUTE)
		update_song(current_song, current_listener)

/obj/item/device/walkman/verb/change_volume()
	set name = "Change Walkman volume"
	set category = "Object"
	set src in usr

	if(!current_song) return

	var/tmp = input(usr,"Change the volume (0 - 100)","Volume") as num|null
	if(tmp == null) return
	if(tmp > 100) tmp = 100
	if(tmp < 0) tmp = 0
	volume = tmp
	update_song(current_song, current_listener)

/* Called when you need to restart a song
 * Arguments: mob/user -> the user that has triggered the reset
 */
/obj/item/device/walkman/proc/restart_song(mob/user)
	if(!current_song) return

	update_song(current_song, current_listener, 0)

/*

	ACTION BUTTONS

*/

/datum/action/item_action/walkman
	icon_icon = 'voidcrew/icons/obj/walkman.dmi'
	background_icon_state = "bg_tech_blue"
/datum/action/item_action/walkman/New()
	..()

/datum/action/item_action/walkman/play_pause
	button_icon_state = "walkman_playpause"

/datum/action/item_action/walkman/play_pause/New()
	..()
	name = "Play/Pause"
	button.name = name

/datum/action/item_action/walkman/play_pause/Trigger()
	if(target)
		var/obj/item/device/walkman/WM = target
		WM.attack_self(owner)

/datum/action/item_action/walkman/next_song
	button_icon_state = "walkman_next"

/datum/action/item_action/walkman/next_song/New()
	..()
	name = "Next song"
	button.name = name

/datum/action/item_action/walkman/next_song/Trigger()
	if(target)
		var/obj/item/device/walkman/walkM = target
		walkM.next_song(owner)

/datum/action/item_action/walkman/restart_song
	button_icon_state = "walkman_restart"

/datum/action/item_action/walkman/restart_song/New()
	..()
	name = "Restart song"
	button.name = name

/datum/action/item_action/walkman/restart_song/Trigger()
	if(target)
		var/obj/item/device/walkman/walkM = target
		walkM.restart_song(owner)
