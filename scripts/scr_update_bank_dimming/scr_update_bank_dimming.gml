/// @description Dims bank tiles whose letter is locked in somewhere on the board;
/// restores them when unlocked. Call this after any guess state change.
function scr_update_bank_dimming() {
    // Build a 26-element flags array: which plain letters are locked?
    var locked = array_create(26, false);
    with (obj_tile_beginner) {
        if (is_guess_tile && is_locked && guessed_index >= 0) {
            locked[guessed_index] = true;
        }
    }

    // Apply appearance to each bank tile
    with (global.game_control_id) {
        var j;
        for (j = 0; j < 26; j++) {
            // Never override the gold selection highlight
            if (j == global.selected_letter) continue;

            if (locked[j]) {
                bank_tile[j].image_blend = make_colour_hsv(0, 0, 110);  // greyed out
                bank_tile[j].image_alpha = 0.5;
            } else {
                bank_tile[j].image_blend = c_white;
                bank_tile[j].image_alpha = 1.0;
            }
        }
    }
}
