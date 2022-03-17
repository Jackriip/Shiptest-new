#define SHUTTLE_INACTIVE_CREW 0
#define SHUTTLE_SSD_CREW 1
#define SHUTTLE_ACTIVE_CREW 2

///zlevel location of the overmap (1 is for centcom)
#define OVERMAP_Z_LEVEL 1

#define OVERMAP_MIN_X 1
#define OVERMAP_MAX_X 18
#define OVERMAP_MIN_Y (world.maxy - 18)
#define OVERMAP_MAX_Y world.maxy


#define OVERMAP_GENERATOR_SOLAR "solar_system"
#define OVERMAP_GENERATOR_RANDOM "random"

//Add new star types here
#define SMALLSTAR 1
#define TWOSTAR 2
#define MEDSTAR 3
#define BIGSTAR 4

//Star classes
/// Extremely bright blue main sequence star or (super)giant
#define STARO 1
/// Bright blue main sequence star or (super)giant
#define STARB 2
/// Light blue main sequence star
#define STARA 3
/// White main sequence star
#define STARF 4
/// Yellow main sequence star or supergiant
#define STARG 5
/// Orange dwarf, main sequence star, or hypergiant
#define STARK 6
/// Red dwarf or red (super)giant
#define STARM 7
/// Cool red dwarf
#define STARL 8
/// Methane dwarf
#define START 9
/// Sad lame brown dwarf
#define STARY 10
/// White dwarf
#define STARD 11

//Amount of times the overmap generator will attempt to place something before giving up
#define MAX_OVERMAP_PLACEMENT_ATTEMPTS 5

//Possible ship states
#define OVERMAP_SHIP_IDLE "idle"
#define OVERMAP_SHIP_FLYING "flying"
#define OVERMAP_SHIP_ACTING "acting"
#define OVERMAP_SHIP_DOCKING "docking"
#define OVERMAP_SHIP_UNDOCKING "undocking"
