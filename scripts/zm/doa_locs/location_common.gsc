#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_zonemgr;

main()
{
	replaceFunc( maps\mp\zombies\_zm_zonemgr::manage_zones, ::manage_zones_override );
}

manage_zones_override( initial_zone )
{
	assert( isdefined( initial_zone ), "You must specify an initial zone to manage" );
	deactivate_initial_barrier_goals();
	zone_choke = 0;
	spawn_points = maps\mp\gametypes_zm\_zm_gametype::get_player_spawns_for_gametype();

	for ( i = 0; i < spawn_points.size; i++ )
	{
		assert( isdefined( spawn_points[i].script_noteworthy ), "player_respawn_point: You must specify a script noteworthy with the zone name" );
		spawn_points[i].locked = 1;
	}

	if ( isdefined( level.zone_manager_init_func ) )
		[[ level.zone_manager_init_func ]]();

	location = getDvar( "ui_zm_mapstartlocation" );
	if ( isDefined( level.location_zones ) && isDefined( level.location_zones[ location ] ) )
	{
		location_zones = level.location_zones[ location ];
		for ( i = 0; i < location_zones.size; i++ )
		{
			zone_init( location_zones[ i ] );
			enable_zone( location_zones[ i ] );
		}
		initial_zone = level.location_zones[ location ];
	}
	else if ( isarray( initial_zone ) )
	{
		for ( i = 0; i < initial_zone.size; i++ )
		{
			zone_init( initial_zone[i] );
			enable_zone( initial_zone[i] );
		}
	}
	else
	{
/#
		println( "ZM >> zone_init (_zm_zonemgr.gsc) = " + initial_zone );
#/
		zone_init( initial_zone );
		enable_zone( initial_zone );
	}

	if ( isDefined( level.location_zones_func ) )
	{
		level [[ level.location_zones_func ]]();
	}

	setup_zone_flag_waits();
	zkeys = getarraykeys( level.zones );
	level.zone_keys = zkeys;
	level.newzones = [];

	for ( z = 0; z < zkeys.size; z++ )
		level.newzones[zkeys[z]] = spawnstruct();

	oldzone = undefined;
	flag_set( "zones_initialized" );
	flag_wait( "begin_spawning" );
/#
	level thread _debug_zones();
#/
	while ( getdvarint( "noclip" ) == 0 || getdvarint( "notarget" ) != 0 )
	{
		for ( z = 0; z < zkeys.size; z++ )
		{
			level.newzones[zkeys[z]].is_active = 0;
			level.newzones[zkeys[z]].is_occupied = 0;
		}

		a_zone_is_active = 0;
		a_zone_is_spawning_allowed = 0;
		level.zone_scanning_active = 1;

		for ( z = 0; z < zkeys.size; z++ )
		{
			zone = level.zones[zkeys[z]];
			newzone = level.newzones[zkeys[z]];

			if ( !zone.is_enabled )
				continue;

			if ( isdefined( level.zone_occupied_func ) )
				newzone.is_occupied = [[ level.zone_occupied_func ]]( zkeys[z] );
			else
				newzone.is_occupied = player_in_zone( zkeys[z] );

			if ( newzone.is_occupied )
			{
				newzone.is_active = 1;
				a_zone_is_active = 1;

				if ( zone.is_spawning_allowed )
					a_zone_is_spawning_allowed = 1;

				if ( !isdefined( oldzone ) || oldzone != newzone )
				{
					level notify( "newzoneActive", zkeys[z] );
					oldzone = newzone;
				}

				azkeys = getarraykeys( zone.adjacent_zones );

				for ( az = 0; az < zone.adjacent_zones.size; az++ )
				{
					if ( zone.adjacent_zones[azkeys[az]].is_connected && level.zones[azkeys[az]].is_enabled )
					{
						level.newzones[azkeys[az]].is_active = 1;

						if ( level.zones[azkeys[az]].is_spawning_allowed )
							a_zone_is_spawning_allowed = 1;
					}
				}
			}

			zone_choke++;

			if ( zone_choke >= 3 )
			{
				zone_choke = 0;
				wait 0.05;
			}
		}

		level.zone_scanning_active = 0;

		for ( z = 0; z < zkeys.size; z++ )
		{
			level.zones[zkeys[z]].is_active = level.newzones[zkeys[z]].is_active;
			level.zones[zkeys[z]].is_occupied = level.newzones[zkeys[z]].is_occupied;
		}

		if ( !a_zone_is_active || !a_zone_is_spawning_allowed )
		{
			if ( isarray( initial_zone ) )
			{
				level.zones[initial_zone[0]].is_active = 1;
				level.zones[initial_zone[0]].is_occupied = 1;
				level.zones[initial_zone[0]].is_spawning_allowed = 1;
			}
			else
			{
				level.zones[initial_zone].is_active = 1;
				level.zones[initial_zone].is_occupied = 1;
				level.zones[initial_zone].is_spawning_allowed = 1;
			}
		}

		[[ level.create_spawner_list_func ]]( zkeys );
/#
		debug_show_spawn_locations();
#/
		level.active_zone_names = maps\mp\zombies\_zm_zonemgr::get_active_zone_names();
		wait 1;
	}
}