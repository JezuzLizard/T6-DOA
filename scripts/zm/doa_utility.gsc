#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

add_zone( name, display_name, start_points )
{
	zone = spawnStruct();
	zone.name = name;
	zone.display_name = display_name;
	zone.start_points = start_points;

	level.doa_zones[ level.doa_zones.size ] = zone;
}