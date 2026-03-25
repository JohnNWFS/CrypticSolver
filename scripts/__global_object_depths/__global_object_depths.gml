function __global_object_depths() {
	// Initialise the global array that allows the lookup of the depth of a given object
	// GM2.0 does not have a depth on objects so on import from 1.x a global array is created
	// NOTE: MacroExpansion is used to insert the array initialisation at import time
	gml_pragma( "global", "__global_object_depths()");

	// insert the generated arrays here
	global.__objectDepths[0] = -1; // obj_tile_beginner
	global.__objectDepths[1] = -1; // obj_select_tile
	global.__objectDepths[2] = -1; // obj_tile
	global.__objectDepths[3] = -20; // obj_letters
	global.__objectDepths[4] = 0; // obj_game_control
	global.__objectDepths[5] = -1; // obj_test


	global.__objectNames[0] = "obj_tile_beginner";
	global.__objectNames[1] = "obj_select_tile";
	global.__objectNames[2] = "obj_tile";
	global.__objectNames[3] = "obj_letters";
	global.__objectNames[4] = "obj_game_control";
	global.__objectNames[5] = "obj_test";


	// create another array that has the correct entries
	var len = array_length(global.__objectDepths);
	global.__objectID2Depth = [];
	for( var i=0; i<len; ++i ) {
		var objID = asset_get_index( global.__objectNames[i] );
		if (objID >= 0) {
			global.__objectID2Depth[ objID ] = global.__objectDepths[i];
		} // end if
	} // end for


}
