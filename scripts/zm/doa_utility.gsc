#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

add_zone( name, display_name, start_points, barriers, bounds, start_zone )
{
	zone = spawnStruct();
	zone.name = name;
	zone.display_name = display_name;
	zone.start_points = start_points;
	zone.barriers = barriers;
	zone.bounds = bounds;
	level.doa_zones[ level.doa_zones.size ] = zone;
	if ( is_true( start_zone ) )
	{
		level.doa_start_zone = zone;
	}
}

store_barrier_info( model, origin, angles )
{
	//ent = spawn( "script_model", origin );
	ent.origin = origin;
	ent.angles = angles;
	ent.model = model;
	return ent;
}

spawn_barrier( barrier_info )
{
	ent = spawn( "script_model", barrier_info.origin );
	ent.angles = barrier_info.angles;
	ent setModel( barrier_info.model );
	if ( !isDefined( level.doa_barrier_ents ) )
	{
		level.doa_barrier_ents = [];
	}
	level.doa_barrier_ents[ level.doa_barrier_ents.size ] = ent;
}

get_next_point( vector, angles, num )
{
	angles_to_forward = anglestoforward( angles );

	x = vector[ 0 ] + num * angles_to_forward[ 0 ];
	y = vector[ 1 ] + num * angles_to_forward[ 1 ];
	final_vector = ( x, y, vector[ 2 ] );
	//logprint( "final_vector: " + final_vector + " vector: " + vector + " angles: " + angles + " angles_to_forward: " + angles_to_forward + " num: " + num + "\n" );
	return final_vector;
}

on_line( line, point )
{
	// Check whether p is on the line or not
	if ( point[ 0 ] <= max( line[ 0 ][ 0 ], line[ 1 ][ 0 ] )
		&& point[ 0 ] <= min( line[ 0 ][ 0 ], line[ 1 ][ 0 ] )
		&& ( point[ 1 ] <= max( line[ 0 ][ 1 ], line[ 1 ][ 1 ] )
		&& point[ 1 ] <= min( line[ 0 ][ 1 ], line[ 1 ][ 1 ] ) ) )
	{
		return true;
	}
	return false;
}

direction( point_a, point_b, point_c )
{
	val1 = point_b[ 1 ] - point_a[ 1 ];
	val2 = point_c[ 0 ] - point_b[ 0 ];
	val3 = point_b[ 0 ] - point_a[ 0 ];
	val4 = point_c[ 1 ] - point_b[ 1 ];
	val = ( val1 * val2 ) - ( val3 * val4 );

	if ( val == 0 )
	{
		// Colinear
		return 0;
	}
	else if ( val < 0 )
	{
		// Anti-clockwise direction
		return 2;
	}
	// Clockwise direction
	return 1;
}

isIntersect( line1, line2 )
{
	// Four direction for two lines and points of other line
	dir1 = direction( line1[ 0 ], line1[ 1 ], line2[ 0 ] );
	dir2 = direction( line1[ 0 ], line1[ 1 ], line2[ 1 ] );
	dir3 = direction( line2[ 0 ], line2[ 1 ], line1[ 0 ] );
	dir4 = direction( line2[ 0 ], line2[ 1 ], line1[ 1 ] );

	// When intersecting
	if ( dir1 != dir2 && dir3 != dir4 )
	{
		return true;
	}
	// When p2 of line2 are on the line1
	if ( dir1 == 0 && on_line( line1, line2[ 0 ] ) )
	{
		return true;
	}
	// When p1 of line2 are on the line1
	if ( dir2 == 0 && on_line( line1, line2[ 1 ] ) )
	{
		return true;
	}
	// When p2 of line1 are on the line2
	if ( dir3 == 0 && on_line( line2, line1[ 0 ] ) )
	{
		return true;
	}
	// When p1 of line1 are on the line2
	if ( dir4 == 0 && on_line( line2, line1[ 1 ] ) )
	{
		return true;
	}
	return false;
}

checkInside( polygon, sides, point )
{

	// When polygon has less than 3 edge, it is not polygon
	if ( sides < 3 )
		return false;

	// Create a point at infinity, y is same as point p
	exline = [];
	exline[ 0 ] = point;
	exline[ 1 ] = ( 99999, point[ 1 ], 0 );
	count = 0;
	i = 0;
	do {

		// Forming a line from two consecutive points of
		// poly
		side = [];
		side[ 0 ] = polygon[ i ];
		side[ 1 ] = polygon[ ( i + 1 ) % sides ];
		if ( isIntersect( side, exline ) ) 
		{

			// If side is intersects exline
			if ( direction( side[ 0 ], point, side[ 1 ] ) == 0)
				return on_line( side, point );
			count++;
		}
		i = ( i + 1 ) % sides;
	} while ( i != 0 );

	// When count is odd
	return count & 1;
}

// Driver code
check_point_is_in_polygon( polygon, point )
{
	// Function call
	if ( checkInside( polygon, polygon.size, point ) )
	{
		//print( "Point is inside." );
		return true;
	}
	else
	{
		//print( "Point is outside." );
		return false;
	}
}