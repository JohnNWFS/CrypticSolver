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
		// All tiles correctly filled — flash every guess tile gold then show win message
		with (obj_tile_beginner) {
			if (is_guess_tile) {
				image_blend = make_colour_hsv(40, 220, 255);  // gold
			}
		}
		scr_show_popup("", "win");
	}
}
