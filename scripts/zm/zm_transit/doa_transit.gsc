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
	setDvar( "scr_screecher_ignore_player", 1 );
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

	level.doa_start_zone_name = "transit_town_middle";
	level.doa_current_zone_name = "transit_town_middle";
	level.doa_next_zone = undefined;

	start_points = [];
	start_points[ start_points.size ] = (-7082.91, 5228.06, -55.875);
	start_points[ start_points.size ] = (-7086.71, 5378.83, -55.875);
	start_points[ start_points.size ] = (-6905.94, 5415.32, -58.2372);
	start_points[ start_points.size ] = (-6898.94, 5173.35, -55.875);
	start_points[ start_points.size ] = (-6646.22, 5327.87, -55.875);
	start_points[ start_points.size ] = (-6414.07, 5378.84, -55.054);
	start_points[ start_points.size ] = (-6402.78, 5580.76, -53.4705);
	start_points[ start_points.size ] = (-6678.26, 5594.12, -55.875);
	bounds = [];
	barriers = [];
	add_zone( "transit_first_room", "Bus Depot First Room", start_points, barriers, bounds );

	start_points = [];
	start_points[ start_points.size ] = (-6115.46, 4626.48, -58.7688);
	start_points[ start_points.size ] = (-6227.5, 4616.49, -63.875);
	start_points[ start_points.size ] = (-6344.35, 4624.44, -63.875);
	start_points[ start_points.size ] = (-6475.78, 4622.14, -55.875);
	start_points[ start_points.size ] = (-6478.56, 4848.4, -63.875);
	start_points[ start_points.size ] = (-6336.16, 4856.22, -61.8885);
	start_points[ start_points.size ] = (-6205.54, 4847.27, -63.875);
	start_points[ start_points.size ] = (-6075.84, 4845.24, -62.0749);
	bounds = [];
	barriers = [];
	barrier_start_point = (-5859.44, 4786.1, -60.5761);
	next_point = get_next_point( barrier_start_point, (0, -133.273 + 90, 0), 128 );
	barriers[ barriers.size ] = store_barrier_info( "collision_player_256x256x10", next_point, (0, -133.273 + 90, 0) );
	barrier_start_point = (-7653.66, 5000.36, -55.875);
	next_point = get_next_point( barrier_start_point, (0, -94.3651 + 90, 0), 256 );
	barriers[ barriers.size ] = store_barrier_info( "collision_player_512x512x10", next_point, (0, -94.3651 + 90, 0) );
	add_zone( "transit_bus_depot_outside", "Bus Depot Outside", start_points, barriers, bounds );

	start_points = [];
	start_points[ start_points.size ] = (-11556.7, -2493.88, 192.125);
	start_points[ start_points.size ] = (-11568.3, -2380.13, 192.125);
	start_points[ start_points.size ] = (-11593.9, -2276.25, 192.125);
	start_points[ start_points.size ] = (-11580, -2182.96, 192.125);
	start_points[ start_points.size ] = (-11068.7, -2462.49, 192.125);
	start_points[ start_points.size ] = (-11082.2, -2347.03, 192.125);
	start_points[ start_points.size ] = (-11070.2, -2228.77, 192.125);
	start_points[ start_points.size ] = (-11087, -2098.56, 191.443);
	bounds = [];
	barriers = [];
	barrier_start_point = (-10946.8, -3270.99, 193.918);
	next_point = get_next_point( barrier_start_point, (0, 3.19355 + 90, 0), 128 );
	barriers[ barriers.size ] = store_barrier_info( "collision_player_256x256x10", next_point, (0, 3.19355 + 90, 0) );
	barrier_start_point = (-11464.7, -570.791, 192.125);
	next_point = get_next_point( barrier_start_point, (0, -0.871396 + 90, 0), 256 );
	barriers[ barriers.size ] = store_barrier_info( "collision_player_512x512x10", next_point, (0, -0.871396 + 90, 0) );
	add_zone( "transit_tunnel", "Tunnel", start_points, barriers, bounds );

	start_points = [];
	start_points[ start_points.size ] = (-4250.54, -7594.09, -62.5864);
	start_points[ start_points.size ] = (-4246.48, -7712.42, -62.003);
	start_points[ start_points.size ] = (-4252.37, -7826.3, -62.875);
	start_points[ start_points.size ] = (-4258.23, -7922.54, -62.875);
	start_points[ start_points.size ] = (-4674.03, -7894.23, -62.875);
	start_points[ start_points.size ] = (-4672.65, -7781.54, -48.7388);
	start_points[ start_points.size ] = (-4668.69, -7680.72, -53.5036);
	start_points[ start_points.size ] = (-4661.71, -7570.15, -57.875);
	bounds = [];
	barriers = [];
	add_zone( "transit_diner_garage", "Diner Garage", start_points, barriers, bounds );

	/*
	start_points = [];
	start_points[ start_points.size ] = (-5583.14, -7820.18, 0.125);
	start_points[ start_points.size ] = (-5577.67, -7736.41, 0.125);
	start_points[ start_points.size ] = (-5574.2, -7664.02, 0.125);
	start_points[ start_points.size ] = (-5570.5, -7601.76, 0.125)
	start_points[ start_points.size ] = (-6339.82, -7645.37, 0.125)
	start_points[ start_points.size ] = (-6339.92, -7718.79, 0.125)
	start_points[ start_points.size ] = (-6340.09, -7798.43, 2.04648)
	start_points[ start_points.size ] = (-6340.31, -7883.75, 23.4461)
	bounds = [];
	barriers = [];
	add_zone( "transit_diner_building", "Diner", start_points, barriers, bounds );
	*/

	start_points = [];
	start_points[ start_points.size ] = (-5220.72, -7363.36, -65.1351);
	start_points[ start_points.size ] = (-5134.19, -7363.18, -67.8671);
	start_points[ start_points.size ] = (-5041.14, -7363.33, -60.9987);
	start_points[ start_points.size ] = (-4959.7, -7363.37, -61.7515);
	start_points[ start_points.size ] = (-4966.29, -7191.38, -58.6556);
	start_points[ start_points.size ] = (-5064.2, -7194.52, -57.8192);
	start_points[ start_points.size ] = (-5154.98, -7194.83, -58.6078);
	start_points[ start_points.size ] = (-5258.89, -7183.1, -60.933);
	bounds = [];
	barriers = [];
	barrier_start_point = (-3929.98, -6395.96, -38.8073);
	next_point = get_next_point( barrier_start_point, (0, -92.6458 + 90, 0), 128 );
	barriers[ barriers.size ] = store_barrier_info( "collision_player_256x256x10", next_point, (0, -92.6458 + 90, 0) );
	barrier_start_point = (-3954.37, -6843.64, -56.0435);
	next_point = get_next_point( barrier_start_point, (0, -92.9753 + 90, 0), 256 );
	barriers[ barriers.size ] = store_barrier_info( "collision_player_512x512x10", next_point, (0, -92.9753 + 90, 0) );
	barrier_start_point = (-6386.95, -6799.38, -55.7099);
	next_point = get_next_point( barrier_start_point, (0, -76.9353 + 90, 0), 128 );
	barriers[ barriers.size ] = store_barrier_info( "collision_player_256x256x10", next_point, (0, -76.9353 + 90, 0) );
	add_zone( "transit_diner_outside", "Diner Outside", start_points, barriers, bounds );

	start_points = [];
	start_points[ start_points.size ] = (-6350.25, -7678.92, 225.982);
	start_points[ start_points.size ] = (-6267.44, -7678.63, 225.563);
	start_points[ start_points.size ] = (-6181.3, -7679.28, 225.624);
	start_points[ start_points.size ] = (-6097.54, -7679.96, 224.503);
	start_points[ start_points.size ] = (-6011.69, -7682.82, 227.071);
	start_points[ start_points.size ] = (-5921.45, -7683.95, 228.044);
	start_points[ start_points.size ] = (-5841.25, -7686.14, 224.753);
	start_points[ start_points.size ] = (-5742.19, -7685.51, 224.125);
	bounds = [];
	barriers = [];
	add_zone( "transit_diner_roof", "Diner Roof", start_points, barriers, bounds );

	/*
	start_points = [];
	start_points[ start_points.size ] = (6655.25, -5898.87, -64.6025);
	start_points[ start_points.size ] = (6511, -5840.11, -64.8609);
	start_points[ start_points.size ] = (6373.94, -5782.94, -66.6616);
	start_points[ start_points.size ] = (6242.63, -5719.63, -72.8781);
	start_points[ start_points.size ] = (6393.4, -5599.26, -64.7332);
	start_points[ start_points.size ] = (6527.99, -5626.55, -59.1234);
	start_points[ start_points.size ] = (6722.7, -5655.33, -63.8684);
	start_points[ start_points.size ] = (6831.02, -5675.78, -62.8213);
	add_zone( "transit_farm_outside_gate", "Farm Outside Gate", start_points, barriers, bounds );
	*/
	start_points = [];
	start_points[ start_points.size ] = (7884.48, -5501.41, 41.4032);
	start_points[ start_points.size ] = (8015.8, -5522.37, 36.6635);
	start_points[ start_points.size ] = (8139.41, -5510.51, 39.8785);
	start_points[ start_points.size ] = (8257.5, -5528.83, 40.9774);
	start_points[ start_points.size ] = (8205.16, -5879.66, 37.0199);
	start_points[ start_points.size ] = (8102.92, -5880.25, 21.6595);
	start_points[ start_points.size ] = (7996.47, -5880.01, 14.7042);
	start_points[ start_points.size ] = (7898.42, -5879.42, 10.3457);
	bounds = [];
	barriers = [];
	add_zone( "transit_farm_inside_gate", "Farm Inside Gate", start_points, barriers, bounds );

	start_points = [];
	start_points[ start_points.size ] = (10472.7, -22.8956, -215.745);
	start_points[ start_points.size ] = (10464.8, -116.181, -215.494);
	start_points[ start_points.size ] = (10475.2, -226.049, -215.736);
	start_points[ start_points.size ] = (10482.5, -329.654, -215.77);
	start_points[ start_points.size ] = (10047.3, -318.776, -215.621);
	start_points[ start_points.size ] = (10051.1, -203.63, -216.308);
	start_points[ start_points.size ] = (10069.6, -84.7591, -218.693);
	start_points[ start_points.size ] = (10087.3, 30.0929, -219.865);
	bounds = [];
	barriers = [];
	barrier_start_point = (10343.6, -461.571, -218.865);
	next_point = get_next_point( barrier_start_point, (0, 163.495 + 90, 0), 128 );
	barriers[ barriers.size ] = store_barrier_info( "collision_player_256x256x10", next_point, (0, 163.495 + 90, 0) );
	barrier_start_point = (10176.9, -1749.34, -217.767);
	next_point = get_next_point( barrier_start_point, (0, 119.341 + 90, 0), 256 );
	barriers[ barriers.size ] = store_barrier_info( "collision_player_512x512x10", next_point, (0, 119.341 + 90, 0) );
	next_point = get_next_point( next_point, (0, 119.341 + 90, 0), 128 );
	barriers[ barriers.size ] = store_barrier_info( "collision_player_256x256x10", next_point, (0, 119.341 + 90, 0) );
	add_zone( "transit_cornfield_middle", "Cornfield Middle", start_points, barriers, bounds );

	start_points = [];
	start_points[ start_points.size ] = (13260.8, 8.20651, -199.565);
	start_points[ start_points.size ] = (13260.6, -77.9321, -202.709);
	start_points[ start_points.size ] = (13255.7, -169.446, -201.371);
	start_points[ start_points.size ] = (13250.9, -274.479, -200.564);
	start_points[ start_points.size ] = (13443.9, -281.353, -193.333);
	start_points[ start_points.size ] = (13440.7, -179.095, -193.505);
	start_points[ start_points.size ] = (13437, -90.7293, -189.097);
	start_points[ start_points.size ] = (13445.3, 7.8597, -182.715);
	bounds = [];
	barriers = [];
	barrier_start_point = (12949.1, -622.748, -194.141);
	next_point = get_next_point( barrier_start_point, (0, -93.9531 + 90, 0), 128 );
	barriers[ barriers.size ] = store_barrier_info( "collision_player_256x256x10", next_point, (0, -93.9531 + 90, 0) );
	add_zone( "transit_cornfield_nacht", "Cornfield Nacht", start_points, barriers, bounds );

	start_points = [];
	start_points[ start_points.size ] = (11330.9, 7721.07, -540.262);
	start_points[ start_points.size ] = (11238.1, 7721.2, -557.123);
	start_points[ start_points.size ] = (11153.5, 7703.06, -570.479);
	start_points[ start_points.size ] = (11057.1, 7710.51, -580.849);
	start_points[ start_points.size ] = (10992.9, 7866.36, -585.199);
	start_points[ start_points.size ] = (11080.9, 7860.72, -576.083);
	start_points[ start_points.size ] = (11187.5, 7850.54, -567.272);
	start_points[ start_points.size ] = (11296.6, 7842.85, -548.303);
	bounds = [];
	barriers = [];
	barrier_start_point = (10033.3, 7225.31, -569.225);
	next_point = get_next_point( barrier_start_point, (0, 9.41726 + 90, 0), 256 );
	barriers[ barriers.size ] = store_barrier_info( "collision_player_512x512x10", next_point, (0, 9.41726 + 90, 0) );
	barrier_start_point = (10391.2, 8353.94, -576.267);
	next_point = get_next_point( barrier_start_point, (0, -171.583 + 90, 0), 256 );
	barriers[ barriers.size ] = store_barrier_info( "collision_player_512x512x10", next_point, (0, -171.583 + 90, 0) );
	barrier_start_point = (9908.17, 8265.4, -555.56);
	next_point = get_next_point( barrier_start_point, (0, 11.2959 + 90, 0), 128 );
	barriers[ barriers.size ] = store_barrier_info( "collision_player_256x256x10", next_point, (0, 11.2959 + 90, 0) );
	add_zone( "transit_power", "Power", start_points, barriers, bounds );

	/*
	start_points = [];
	start_points[ start_points.size ] = (5380.64, 6403.86, -63.875);
	start_points[ start_points.size ] = (5376.76, 6274.92, -63.875);
	start_points[ start_points.size ] = (5375.62, 6140.33, -63.875);
	start_points[ start_points.size ] = (5380.64, 5971.53, -63.619);
	start_points[ start_points.size ] = (5050.92, 6429.41, -63.875);
	start_points[ start_points.size ] = (5056.64, 6323.89, -63.875);
	start_points[ start_points.size ] = (5049.06, 6208.86, -63.875);
	start_points[ start_points.size ] = (5043.1, 6092.92, -63.875);
	add_zone( "transit_cabin", "Cabin", start_points, barriers, bounds );
	*/

	start_points = [];
	start_points[ start_points.size ] = (828.324, -354.589, -61.875);
	start_points[ start_points.size ] = (742.521, -354.601, -61.875);
	start_points[ start_points.size ] = (654.491, -354.578, -61.875);
	start_points[ start_points.size ] = (571.732, -665.533, -55.875);
	start_points[ start_points.size ] = (654.794, -670.054, -55.875);
	start_points[ start_points.size ] = (714.122, -665.693, -55.875);
	start_points[ start_points.size ] = (842.699, -667.068, -55.875);
	start_points[ start_points.size ] = (966.006, -647.31, -55.875);
	bounds = [];
	barriers = [];
	barrier_start_point = (1239.19, 954.614, -58.4676);
	next_point = get_next_point( barrier_start_point, (0, -2.81604 + 90, 0), 256 );
	barriers[ barriers.size ] = store_barrier_info( "collision_player_512x512x10", next_point, (0, -2.81604 + 90, 0) );
	barrier_start_point = get_next_point( next_point, (0, -2.81604 + 90, 0), 256 );
	next_point = get_next_point( barrier_start_point, (0, -2.81604 + 90, 0), 256 );
	barriers[ barriers.size ] = store_barrier_info( "collision_player_512x512x10", next_point, (0, -2.81604 + 90, 0) );	
	barrier_start_point = (393.748, -589.056, -61.9006);
	next_point = get_next_point( barrier_start_point, (0, 83.108 + 90, 0), 128 );
	barriers[ barriers.size ] = store_barrier_info( "collision_player_256x256x10", next_point, (0, 83.108 + 90, 0) );
	add_zone( "transit_town_middle", "Town Middle", start_points, barriers, bounds, true );

	start_points = [];
	start_points[ start_points.size ] = (1872.35, 603.116, -55.875);
	start_points[ start_points.size ] = (1973.45, 610.331, -55.875);
	start_points[ start_points.size ] = (2075.62, 612.75, -55.875);
	start_points[ start_points.size ] = (2164.94, 627.466, -55.875);
	start_points[ start_points.size ] = (2169.25, 331.44, -55.875);
	start_points[ start_points.size ] = (2079.1, 333.598, -55.875);
	start_points[ start_points.size ] = (1990.21, 322.459, -55.875);
	start_points[ start_points.size ] = (1887.78, 321.589, -55.875);
	bounds = [];
	barriers = [];
	barrier_start_point = (1832.74, -110.874, 88.125);
	next_point = get_next_point( barrier_start_point, (0, 128.608 + 90, 0), 128 );
	barriers[ barriers.size ] = store_barrier_info( "collision_player_256x256x10", next_point, (0, 128.608 + 90, 0) );
	add_zone( "transit_town_bar", "Town Bar", start_points, barriers, bounds );

	start_points = [];
	start_points[ start_points.size ] = (1040.81, 423.271, -39.875);
	start_points[ start_points.size ] = (1056, 320.627, -39.875);
	start_points[ start_points.size ] = (1060.98, 220.298, -39.875);
	start_points[ start_points.size ] = (1066.02, 118.533, -39.875);
	start_points[ start_points.size ] = (697.707, 95.2497, -39.875);
	start_points[ start_points.size ] = (696.932, 199.22, -39.875);
	start_points[ start_points.size ] = (701.504, 317.95, -39.7262);
	start_points[ start_points.size ] = (699.715, 461.293, -39.875);
	add_zone( "transit_town_bank", "Town Bank", start_points, barriers, bounds );

	start_points = [];
	start_points[ start_points.size ] = (986.111, -1256.53, 120.125);
	start_points[ start_points.size ] = (908.499, -1262.92, 120.125);
	start_points[ start_points.size ] = (821.012, -1266.7, 120.125);
	start_points[ start_points.size ] = (725.223, -1257.07, 120.125);
	start_points[ start_points.size ] = (696.491, -1069.65, 120.125);
	start_points[ start_points.size ] = (788.858, -1084.74, 120.125);
	start_points[ start_points.size ] = (876.378, -1100.28, 120.125);
	start_points[ start_points.size ] = (982.608, -1090.21, 120.125);
	barrier_start_point = (1061.93, -1211.64, 124.125);
	next_point = get_next_point( barrier_start_point, (0, -89.9211 + 90, 0), 128 );
	barriers[ barriers.size ] = store_barrier_info( "collision_player_256x256x10", next_point, (0, -89.9211 + 90, 0) );	
	barrier_start_point = (1138.56, -830.859, 134.883);
	next_point = get_next_point( barrier_start_point, (0, 150.388 + 90, 0), 128 );
	barriers[ barriers.size ] = store_barrier_info( "collision_player_256x256x10", next_point, (0, 150.388 + 90, 0) );	
	add_zone( "transit_town_mp5", "Town Mp5", start_points, barriers, bounds );
}

on_player_connect()
{
}