/datum/preferences/load_preferences()
	. = ..()
	if(!.)
		return FALSE
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	READ_FILE(S["ships_owned"], ships_owned)
