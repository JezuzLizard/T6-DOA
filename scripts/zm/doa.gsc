#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

main()
{
	replaceFunc( common_scripts\utility::struct_class_init, ::struct_class_init_override );
}

init()
{
	level thread on_player_connect();
	level.round_start_custom_func = ::doa_start_of_round;
	level.round_end_custom_logic = ::doa_end_of_round;
	level waittill( "connected", player );
	level thread delete_door_triggers();
	level thread disable_wallbuy_triggers();
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
}

bottomless_clip()
{
	level endon( "end_game" );

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
	self.health = 60;
	self takeAllWeapons();

}

handle_revive()
{

}

delete_door_triggers()
{
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

disable_wallbuy_triggers()
{
	weapon_spawns = GetEntArray( "weapon_upgrade", "targetname" );
	for ( i = 0; i < weapon_spawns.size; i++ )
	{
		weapon_spawns[ i ] trigger_off();
	}
}

doa_start_of_round()
{
	flag_clear( "spawn_zombies" );
}

doa_end_of_round()
{
	delay = 5;
	level thread display_starting_next_round_hud( delay );
	wait delay;
	level thread setup_next_zone();
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
}

setup_next_zone()
{
	
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