/// @description Checks whether every guess tile has been correctly solved.
/// Call this after every guess. Runs in the context of obj_game_control.
function scr_check_win() {
	var total  = 0;
	var solved = 0;

	with (obj_tile_beginner) {
		if (is_guess_tile) {
			total++;
			if (guessed_index == plain_index) {
				solved++;
			}
		}
	}

	if (total > 0 && solved == total) {
		// Record elapsed time
		global.puzzle_elapsed_ms = current_time - puzzle_start_time;

		// Flash every guess tile gold
		with (obj_tile_beginner) {
			if (is_guess_tile) {
				image_blend = make_colour_hsv(40, 220, 255);
			}
		}

		// Star rating based on seconds taken (scaled by difficulty)
		var _secs  = global.puzzle_elapsed_ms / 1000;
		var _diff  = global.puzzle_difficulty;
		// Thresholds (seconds): 3-star / 2-star — harder puzzles get more time
		var _t3 = 60  * _diff;   // e.g. easy=60s, medium=120s, hard=180s
		var _t2 = 120 * _diff;
		var _stars;
		if (_secs <= _t3) {
			_stars = 3;
		} else if (_secs <= _t2) {
			_stars = 2;
		} else {
			_stars = 1;
		}
		global.win_stars = _stars;

		scr_show_popup("", "win");
	}
}
