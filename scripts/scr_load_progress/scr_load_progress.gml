/// @description Load puzzle star ratings and best times from ini file into globals.
/// Safe to call any time — missing keys default to 0 (unplayed).
function scr_load_progress() {
    global.save_stars = array_create(PUZZLE_TOTAL, 0);
    global.save_times = array_create(PUZZLE_TOTAL, 0);

    ini_open(working_directory + "crypticsolver_save.ini");
    var i;
    for (i = 0; i < PUZZLE_TOTAL; i++) {
        global.save_stars[i] = ini_read_real("progress", "stars_" + string(i), 0);
        global.save_times[i] = ini_read_real("progress", "time_"  + string(i), 0);
    }
    global.player_name = ini_read_string("player", "name", "");
    ini_close();
}
