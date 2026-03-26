/// @description Persist all puzzle star ratings and best times to ini file.
function scr_save_progress() {
    ini_open(working_directory + "crypticsolver_save.ini");
    var i;
    for (i = 0; i < 30; i++) {
        ini_write_real("progress", "stars_" + string(i), global.save_stars[i]);
        ini_write_real("progress", "time_"  + string(i), global.save_times[i]);
    }
    ini_close();
}
