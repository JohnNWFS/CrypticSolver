/// @description Checks whether every guess tile has been correctly solved.
/// Call this after every guess placement. Runs in the context of obj_game_control.
function scr_check_win() {
	// Use globals for counters — avoids var-inside-with scoping issues in GMS 2.3+
	global._cw_total  = 0;
	global._cw_solved = 0;

	with (obj_tile_beginner) {
		if (is_guess_tile) {
			global._cw_total++;
			if (guessed_index == plain_index) {
				global._cw_solved++;
			}
		}
	}

	if (global._cw_total > 0 && global._cw_solved == global._cw_total) {
		// Record elapsed time
		global.puzzle_elapsed_ms = current_time - global.puzzle_start_time;

		// Flash every guess tile gold
		with (obj_tile_beginner) {
			if (is_guess_tile) {
				image_blend = make_colour_hsv(40, 220, 255);
			}
		}

		// Star rating: scaled thresholds by difficulty
		var _secs = global.puzzle_elapsed_ms / 1000;
		var _diff = global.puzzle_difficulty;
		if      (_secs <= 60  * _diff) { global.win_stars = 3; }
		else if (_secs <= 120 * _diff) { global.win_stars = 2; }
		else                           { global.win_stars = 1; }

		scr_show_popup("", "win");
	}
}
