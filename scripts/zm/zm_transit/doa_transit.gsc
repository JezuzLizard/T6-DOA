#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include scripts\zm\doa_utility;

main()
{
	level thread delete_lava_triggers();
	setup_transit_zones();
}

init()
{
}

delete_lava_triggers()
{
	triggers = getentarray( "lava_damage", "targetname" );
	foreach ( trig in triggers )
	{
		if ( isDefined( trig ) )
		{
			trig delete();
		}
	}
}

setup_transit_zones()
{
	level.doa_zones = [];

	level.doa_start_zone = "transit_town_middle";

	start_points = [];
	add_zone( "transit_first_room", "Bus Depot First Room", start_points );

	start_points = [];
	add_zone( "transit_bus_depot_outside", "Bus Depot Outside", start_points );

	start_points = [];
	add_zone( "transit_tunnel", "Tunnel", start_points );

	start_points = [];
	add_zone( "transit_diner_garage", "Diner Garage", start_points );

	start_points = [];
	add_zone( "transit_diner_building", "Diner", start_points );

	start_points = [];
	add_zone( "transit_diner_outside", "Diner Outside", start_points );

	start_points = [];
	add_zone( "transit_diner_roof", "Diner Roof", start_points );

	start_points = [];
	add_zone( "transit_farm_outside_gate", "Farm Outside Gate", start_points );

	start_points = [];
	add_zone( "transit_farm_inside_gate", "Farm Inside Gate", start_points );

	start_points = [];
	add_zone( "transit_cornfield_middle", "Cornfield Middle", start_points );

	start_points = [];
	add_zone( "transit_cornfield_nacht", "Cornfield Nacht", start_points );

	start_points = [];
	add_zone( "transit_power", "Power", start_points );

	start_points = [];
	add_zone( "transit_cabin", "Cabin", start_points );	

	start_points = [];
	add_zone( "transit_town_middle", "Town Middle", start_points );

	start_points = [];
	add_zone( "transit_town_bar", "Town Bar", start_points );

	start_points = [];
	add_zone( "transit_town_bank", "Town Bank", start_points );

	start_points = [];
	add_zone( "transit_town_mp5", "Town Mp5", start_points );
}

on_player_connect()
{
}