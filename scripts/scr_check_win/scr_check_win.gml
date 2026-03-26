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

		// Star rating: speed-based, then capped by hints used
		var _secs      = global.puzzle_elapsed_ms / 1000;
		var _diff      = global.puzzle_difficulty;
		var _hints_used = 3 - global.hints_remaining;
		var _max_stars  = max(1, 3 - _hints_used);   // 0 hints=3, 1 hint=2, 2-3 hints=1

		if      (_secs <= 60  * _diff) { global.win_stars = 3; }
		else if (_secs <= 120 * _diff) { global.win_stars = 2; }
		else                           { global.win_stars = 1; }

		global.win_stars = min(global.win_stars, _max_stars);

		// Ensure save arrays exist (guard against bypassing title screen)
		if (!variable_global_exists("save_stars")) { scr_load_progress(); }

		// Save progress if this puzzle index is valid and it's a new best
		var _pi = global.puzzle_index;
		if (_pi >= 0 && _pi < 30) {
			var _new_secs = global.puzzle_elapsed_ms / 1000;
			var _prev_stars = global.save_stars[_pi];
			var _prev_time  = global.save_times[_pi];
			var _is_better  = (_prev_stars == 0)                                  // first time
			               || (global.win_stars > _prev_stars)                    // more stars
			               || (global.win_stars == _prev_stars && _new_secs < _prev_time); // same stars, faster
			if (_is_better) {
				global.save_stars[_pi] = global.win_stars;
				global.save_times[_pi] = _new_secs;
				scr_save_progress();
			}
		}

		audio_play_sound(global.snd_win, 1, false);
		scr_show_popup("", "win");
	}
}
