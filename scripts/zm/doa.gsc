#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

main()
{
	replaceFunc( common_scripts\utility::struct_class_init, ::struct_class_init_override );
	replaceFunc( maps\mp\zombies\_zm_zonemgr::manage_zones, ::manage_zones_override );
	replaceFunc( maps\mp\zombies\_zm_pers_upgrades::is_pers_system_disabled, ::is_pers_system_disabled_override );
	replaceFunc( maps\mp\zombies\_zm_utility::init_zombie_run_cycle, ::init_zombie_run_cycle_override );
	replaceFunc( maps\mp\zombies\_zm_score::get_points_multiplier, ::get_points_multiplier_override );
	replaceFunc( maps\mp\zombies\_zm_perks::perk_set_max_health_if_jugg, ::perk_set_max_health_if_jugg_override );
	replaceFunc( maps\mp\zombies\_zm::ai_calculate_health, ::ai_calculate_health_override );
	level.no_board_repair = true;
}

init()
{
	level thread on_player_connect();
	level thread start_zone();
	level.round_start_custom_func = ::doa_start_of_round;
	level.round_end_custom_logic = ::doa_end_of_round;
	level._game_module_game_end_check = ::doa_end_game_check;
	level waittill( "connected", player );
	level thread drop_all_barriers();
	level thread delete_door_triggers();
	level thread disable_wallbuy_triggers();
	level thread kill_start_chest();
}

start_zone()
{
	flag_wait( "initial_players_connected" );
	zone = level.doa_start_zone;
	level.doa_current_zone_name = zone.name;
	start_points = array_randomize( zone.start_points );
	foreach ( index, player in level.players )
	{
		if ( player.sessionstate == "playing" )
		{
			player setOrigin( start_points[ index ] );
		}
	}
	level thread spawn_barriers( zone );
}

on_player_connect()
{
	level endon( "end_game" );

	while ( true )
	{
		level waittill( "connected", player );
		player doa_setup_player();
		player thread starting_loadout();
		player thread handle_revive();
		player thread bottomless_clip();
		player thread print_origin();
		player thread on_player_spawn();
	}
}

print_origin()
{
	self endon( "disconnect" );
	while ( true )
	{
		wait 0.05;
		if ( getDvarInt( "doa_debug" ) == 0 )
		{
			continue;
		}
		if ( self meleeButtonPressed() )
		{
			logprint( "origin: " + self.origin + "\n" );
			logprint( "angles: " + self.angles + "\n" );
			//logprint( "anglestoforward: " + anglesToForward( self.angles ) + "\n" );
			while ( self meleeButtonPressed() )
				wait 0.05;
		}
	}
}

on_player_spawn()
{
	level endon( "end_game" );
	self endon( "disconnect" );
	while ( true )
	{
		self waittill( "spawned_player" );
		if ( getDvarInt( "doa_debug" ) == 0 )
		{
			self allowlean( false );
			self allowads( true );
			self allowsprint( false );
			self allowprone( false );
			self allowcrouch( true );
			self allowmelee( false );
			self allowjump( false );
		}
		else 
		{
			self.score = 1000000;
		}
	}
}

doa_setup_player()
{
	if ( !isDefined( self.doa_vars ) )
	{
		self.doa_vars = [];
	}
	self.doa_vars[ "pause_infinite_ammo" ] = false;
	self.doa_vars[ "fate" ] = undefined;
	self.doa_vars[ "weapon" ] = "galil_zm";
	self.doa_vars[ "old_weapon" ] = "galil_zm";
	self.doa_vars[ "multiplier" ] = 1;
}

bottomless_clip()
{
	level endon( "end_game" );
	self endon( "disconnect" );
	while ( true )
	{
		if ( is_true( self.doa_vars[ "pause_infinite_ammo" ] ) )
		{
			wait 0.05;
			continue;
		}
		weapon = self getCurrentWeapon();
		if ( weapon != "none" )
		{
			self setWeaponAmmoClip( weapon, weaponClipSize( weapon ) );
			self giveMaxAmmo( weapon );
		}
		wait 0.05;
	}
}

starting_loadout()
{
	self waittill( "spawned_player" );
	wait 1;
	self takeAllWeapons();
	self giveWeapon( self.doa_vars[ "weapon" ] );
}

handle_revive()
{

}

delete_door_triggers()
{
	if ( getDvarInt( "doa_debug" ) == 1 )
	{
		return;
	}
	debris_trigs = getentarray( "zombie_debris", "targetname" );
	if ( isDefined( debris_trigs ) )
	{
		foreach ( trig in debris_trigs )
		{
			trig delete();
			wait 0.05;
		}
	}
   	zombie_doors = getentarray( "zombie_door", "targetname" );
	if ( isDefined( zombie_doors ) )
	{
		foreach ( door in zombie_doors )
		{
			door delete();
			wait 0.05;
		}
	}
}

kill_start_chest()
{
	if ( getDvarInt( "doa_debug" ) == 1 )
	{
		return;
	}
	flag_wait( "initial_blackscreen_passed" );
	wait 2;
	foreach ( chest in level.chests )
	{
		chest maps\mp\zombies\_zm_magicbox::hide_chest( 0 );
		chest notify( "kill_chest_think" );
		wait 0.05;
	}
}

disable_wallbuy_triggers()
{
	if ( getDvarInt( "doa_debug" ) == 1 )
	{
		return;
	}
	weapon_spawns = GetEntArray( "weapon_upgrade", "targetname" );
	for ( i = 0; i < weapon_spawns.size; i++ )
	{
		weapon_spawns[ i ] trigger_off();
	}
}

drop_all_barriers()
{
	zkeys = getarraykeys( level.zones );

	for ( z = 0; z < level.zones.size; z++ )
	{
		zbarriers = get_all_zone_zbarriers( zkeys[z] );

		if ( !isdefined( zbarriers ) )
			continue;

		foreach ( zbarrier in zbarriers )
		{
			zbarrier_pieces = zbarrier getnumzbarrierpieces();

			for ( i = 0; i < zbarrier_pieces; i++ )
			{
				zbarrier hidezbarrierpiece( i );
				zbarrier setzbarrierpiecestate( i, "open" );
			}

			wait 0.05;
		}
	}
}

get_all_zone_zbarriers( zone_name )
{
	if ( !isdefined( zone_name ) )
		return undefined;

	zone = level.zones[zone_name];
	return zone.zbarriers;
}

doa_start_of_round()
{
	//flag_clear( "spawn_zombies" );
}

doa_end_of_round()
{
	foreach ( player in level.players )
	{
		if ( player player_is_in_laststand() )
		{
			player maps\mp\zombies\_zm_laststand::auto_revive( player );
		}
	}
	delay = 5;
	level thread display_starting_next_round_hud( delay );
	wait delay;
	level thread send_players_to_next_zone();
}

doa_end_game_check()
{
	return false;
}

display_starting_next_round_hud( delay )
{
	zone_change_hud = newHudElem();
	zone_change_hud.alignx = "center";
	zone_change_hud.aligny = "middle";
	zone_change_hud.horzalign = "center";
	zone_change_hud.vertalign = "middle";
	zone_change_hud.fontscale = 2.5;
	zone_change_hud.alpha = 1;
	zone_change_hud.hidewheninmenu = 1;
	zone_change_hud.label = &"Changing to new zone in: "; 

	change_delay = int( delay );
	
	while ( 1 )
	{
		zone_change_hud SetValue( change_delay );
		wait 1;
		change_delay--;
	}
	zone_change_hud destroy();
}

send_players_to_next_zone()
{
	delete_barriers( level.doa_current_zone_name );
	if ( !isDefined( level.doa_possible_zones ) || level.doa_possible_zones.size <= 0 )
	{
		level.doa_possible_zones = level.doa_zones;
		level.doa_possible_zones = array_randomize( level.doa_possible_zones );
		while ( level.doa_possible_zones.size > 1 && level.doa_possible_zones[ 0 ].name == level.doa_current_zone_name )
		{
			level.doa_possible_zones = array_randomize( level.doa_possible_zones );
		}
	}
	else 
	{
		foreach ( index, zone in level.doa_possible_zones )
		{
			zone_bak = zone;
			if ( zone.name == level.doa_current_zone_name )
			{
				arrayRemoveIndex( level.doa_possible_zones, index );
				break;
			}
		}
	}
	zone = level.doa_possible_zones[ 0 ];
	level.doa_current_zone_name = zone.name;
	start_points = array_randomize( zone.start_points );
	foreach ( index, player in level.players )
	{
		if ( player.sessionstate == "playing" )
		{
			player setOrigin( start_points[ index ] );
		}
	}
	level thread spawn_barriers( zone );
}

delete_barriers()
{
	if ( !isDefined( level.doa_barrier_ents ) || level.doa_barrier_ents.size <= 0 )
	{
		return;
	}
	foreach ( index, ent in level.doa_barrier_ents )
	{	
		if ( isDefined( ent ) )
		{
			ent delete();
		}
	}
}

spawn_barriers( zone )
{
	foreach ( info in zone.barriers )
	{
		spawn_barrier( info );
	}
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

struct_class_init_override()
{
	level.struct_class_names = [];
	level.struct_class_names[ "target" ] = [];
	level.struct_class_names[ "targetname" ] = [];
	level.struct_class_names[ "script_noteworthy" ] = [];
	level.struct_class_names[ "script_linkname" ] = [];
	level.struct_class_names[ "script_unitrigger_type" ] = [];
	if ( !isDefined( level.blocked_structs_keys ) )
	{
		level.blocked_structs_keys = [];
	}
	foreach ( s_struct in level.struct )
	{
		if ( isDefined( s_struct.targetname ) && s_struct.targetname == "zm_perk_machine" )
		{
			continue;
		}
		add_struct( s_struct );
	}
}

add_struct( s_struct )
{
	if ( isDefined( s_struct.targetname ) )
	{
		if ( !isDefined( level.struct_class_names[ "targetname" ][ s_struct.targetname ] ) )
		{
			level.struct_class_names[ "targetname" ][ s_struct.targetname ] = [];
		}
		if ( !is_true( level.blocked_structs_keys[ s_struct.targetname ] ) )
		{
			size = level.struct_class_names[ "targetname" ][ s_struct.targetname ].size;
			level.struct_class_names[ "targetname" ][ s_struct.targetname ][ size ] = s_struct;
		}
	}
	if ( isDefined( s_struct.script_noteworthy ) )
	{
		if ( !isDefined( level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ] ) )
		{
			level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ] = [];
		}
		if ( !is_true( level.blocked_structs_keys[ s_struct.script_noteworthy ] ) )
		{
			size = level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ].size;
			level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ][ size ] = s_struct;
		}
	}
	if ( isDefined( s_struct.target ) )
	{
		if ( !isDefined( level.struct_class_names[ "target" ][ s_struct.target ] ) )
		{
			level.struct_class_names[ "target" ][ s_struct.target ] = [];
		}
		if ( !is_true( level.blocked_structs_keys[ s_struct.target ] ) )
		{
			size = level.struct_class_names[ "target" ][ s_struct.target ].size;
			level.struct_class_names[ "target" ][ s_struct.target ][ size ] = s_struct;
		}
	}
	if ( isDefined( s_struct.script_linkname ) )
	{
		if ( !is_true( level.blocked_structs_keys[ s_struct.script_linkname ] ) )
		{
			level.struct_class_names[ "script_linkname" ][ s_struct.script_linkname ][ 0 ] = s_struct;
		}
	}
	if ( isDefined( s_struct.script_unitrigger_type ) )
	{
		if ( !isDefined( level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ] ) )
		{
			level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ] = [];
		}
		if ( !is_true( level.blocked_structs_keys[ s_struct.script_unitrigger_type ] ) )
		{
			size = level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ].size;
			level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ][ size ] = s_struct;
		}
	}
}

is_pers_system_disabled_override()
{
	return true;
}

init_zombie_run_cycle_override()
{
	self set_zombie_run_cycle();
}

get_points_multiplier_override( player )
{
	return player.doa_vars[ "multiplier" ];
}

perk_set_max_health_if_jugg_override( perk, set_premaxhealth, clamp_health_to_max_health )
{
	max_total_health = 60;
	self setmaxhealth( max_total_health );
	self.health = max_total_health;
}

ai_calculate_health_override( round_number )
{
	level.zombie_health = 150 * round_number;
}