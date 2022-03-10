/*

### This file contains a list of all the areas in any potential ship. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = 'ICON FILENAME' 			(defaults to 'icons/turf/areas.dmi')
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = FALSE 				(defaults to true)
	ambientsounds = list()				(defaults to GENERIC from sound.dm. override it as "ambientsounds = list('sound/ambience/signal.ogg')" or using another define.

NOTE: there are two lists of areas in the end of this file: centcom and station itself. Please maintain these lists valid. --rastaf0

*/


/*-----------------------------------------------------------------------------*/

/area/space
	icon_state = "space"
	requires_power = TRUE
	always_unpowered = TRUE
	static_lighting = FALSE
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	area_flags = UNIQUE_AREA | CAVES_ALLOWED | MOB_SPAWN_ALLOWED
	outdoors = TRUE
	ambientsounds = AMBIENCE_SPACE
	flags_1 = CAN_BE_DIRTY_1
	sound_environment = SOUND_AREA_SPACE

/area/space/nearstation
	icon_state = "space_near"
	area_flags = AREA_USES_STARLIGHT

/area/start
	name = "start area"
	icon_state = "start"
	requires_power = FALSE
	static_lighting = FALSE
	has_gravity = STANDARD_GRAVITY

/area/testroom
	requires_power = FALSE
	name = "Test Room"
	icon_state = "storage"

//EXTRA

/area/asteroid
	name = "Asteroid"
	icon_state = "asteroid"
	has_gravity = STANDARD_GRAVITY
	area_flags = UNIQUE_AREA | CAVES_ALLOWED | MOB_SPAWN_ALLOWED
	ambientsounds = AMBIENCE_MINING
	flags_1 = CAN_BE_DIRTY_1
	sound_environment = SOUND_AREA_ASTEROID

/area/aux_base
	name = "Auxiliary Base Construction"
	icon_state = "aux_base_construction"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

// SHIP AREAS //

/area/ship
	static_lighting = FALSE
	has_gravity = STANDARD_GRAVITY
	always_unpowered = FALSE
	area_flags = VALID_TERRITORY | BLOBS_ALLOWED // Loading the same shuttle map at a different time will produce distinct area instances.
	icon_state = "shuttle"
	flags_1 = CAN_BE_DIRTY_1 | CULT_PERMITTED
	area_limited_icon_smoothing = TRUE
	sound_environment = SOUND_ENVIRONMENT_ROOM
	/// The mobile port attached to this area
	var/obj/docking_port/mobile/mobile_port

/area/ship/Destroy()
	mobile_port = null
	. = ..()

/area/ship/PlaceOnTopReact(list/new_baseturfs, turf/fake_turf_type, flags)
	. = ..()
	if(length(new_baseturfs) > 1 || fake_turf_type)
		return // More complicated larger changes indicate this isn't a player
	if(ispath(new_baseturfs[1], /turf/open/floor/plating) && !new_baseturfs.Find(/turf/baseturf_skipover/shuttle))
		new_baseturfs.Insert(1, /turf/baseturf_skipover/shuttle)

/area/ship/proc/link_to_shuttle(obj/docking_port/mobile/M)
	mobile_port = M

/// Command ///
/area/ship/bridge
	name = "Bridge"
	icon_state = "bridge"
	ambientsounds = list('sound/ambience/signal.ogg')

/// Crew Quarters ///
/area/ship/crew
	name = "Crew Quarters"
	icon_state = "crew_quarters"

/area/ship/crew/cryo
	name = "Cryopod Room"
	icon_state = "cryopod"

/area/ship/crew/dorm
	name = "Dormitory"
	icon_state = "Sleep"

/area/ship/crew/toilet
	name = "Restrooms"
	icon_state = "toilet"

/area/ship/crew/canteen
	name = "Canteen"
	icon_state = "cafeteria"

/area/ship/crew/canteen/kitchen
	name = "Kitchen"
	icon_state = "kitchen"

/area/ship/crew/hydroponics
	name = "Hydroponics"
	icon_state = "hydro"

/area/ship/crew/chapel
	name = "Chapel"
	icon_state = "chapel"
	ambientsounds = AMBIENCE_HOLY
	flags_1 = NONE
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/ship/crew/chapel/office
	name = "Chapel Office"
	icon_state = "chapeloffice"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR
/area/ship/crew/library
	name = "Library"
	icon_state = "library"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/ship/crew/law_office
	name = "Law Office"
	icon_state = "law"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/ship/crew/solgov
	name = "SolGov Consulate"
	icon_state = "solgov"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/ship/crew/office
	name = "Office"
	icon_state = "vacant_office"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/ship/crew/janitor
	name = "Custodial Closet"
	icon_state = "janitor"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/// Medical Bay ///
/area/ship/medical
	name = "Infirmary"
	icon_state = "medbay3"
	ambientsounds = AMBIENCE_MEDICAL

/area/ship/medical/surgery
	name = "Surgical Bay"
	icon_state = "surgery"

/area/ship/medical/morgue
	name = "Morgue"
	icon_state = "morgue"
	ambientsounds = AMBIENCE_SPOOKY

/// Science Lab ///
/area/ship/science
	name = "Science Lab"
	icon_state = "toxlab"

/area/ship/science/robotics
	name = "Robotics"
	icon_state = "medresearch"

/area/ship/science/ai_chamber
	name = "AI Chamber"
	icon_state = "ai_chamber"
	ambientsounds = list('sound/ambience/ambimalf.ogg', 'sound/ambience/ambitech.ogg', 'sound/ambience/ambitech2.ogg', 'sound/ambience/ambiatmos.ogg', 'sound/ambience/ambiatmos2.ogg')

/// Engineering ///
/area/ship/engineering
	name = "Engineering"
	icon_state = "engine"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/ship/engineering/atmospherics
	name = "Atmospherics"
	icon_state = "atmos"

/area/ship/engineering/electrical
	name = "Electrical"
	icon_state = "engine_smes"

/area/ship/engineering/communications
	name = "Communications"
	icon_state = "tcomsatcham"

/area/ship/engineering/engine
	name = "Engine Room"
	icon_state = "engine_sm"

/// Security ///
/area/ship/security
	name = "Brig"
	icon_state = "brig"

/area/ship/security/prison
	name = "Brig Cells"
	icon_state = "sec_prison"

/area/ship/security/range
	name = "Firing Range"
	icon_state = "firingrange"

/area/ship/security
	name = "Security Office"
	icon_state = "security"

/area/ship/security/armory
	name = "Armory"
	icon_state = "armory"

/// Cargo Bay ///
/area/ship/cargo
	name = "Cargo Bay"
	icon_state = "cargo_bay"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/ship/cargo/office
	name = "Cargo Office"
	icon_state = "quartoffice"
	sound_environment = SOUND_AREA_STANDARD_STATION

/// Hallways ///
/area/ship/hallway
	name = "Hallway"
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED

/area/ship/hallway/aft
	name = "Aft Hallway"
	icon_state = "hallA"

/area/ship/hallway/fore
	name = "Fore Hallway"
	icon_state = "hallF"

/area/ship/hallway/starboard
	name = "Starboard Hallway"
	icon_state = "hallS"

/area/ship/hallway/port
	name = "Port Hallway"
	icon_state = "hallP"

/area/ship/hallway/central
	name = "Central Hallway"
	icon_state = "hallC"

/// Maintenance Areas ///
/area/ship/maintenance
	name = "Maintenance"
	ambientsounds = AMBIENCE_MAINT
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED

/area/ship/maintenance/aft
	name = "Aft Maintenance"
	icon_state = "amaint"

/area/ship/maintenance/fore
	name = "Fore Maintenance"
	icon_state = "fmaint"

/area/ship/maintenance/starboard
	name = "Starboard Maintenance"
	icon_state = "smaint"

/area/ship/maintenance/port
	name = "Port Maintenance"
	icon_state = "pmaint"

/area/ship/maintenance/central
	name = "Central Maintenance"
	icon_state = "maintcentral"

/area/ship/construction
	name = "Construction Area"
	icon_state = "construction"

/area/ship/storage
	name = "Storage Bay"
	icon_state = "storage"

/// External Areas ///
/area/ship/external
	name = "External"
	area_flags = AREA_USES_STARLIGHT
	icon_state = "space_near"
