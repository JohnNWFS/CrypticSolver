/// @description Uses one hint token to reveal a random unsolved encrypted-letter group.
function scr_use_hint() {
    if (global.hints_remaining <= 0) {
        scr_show_popup("No hints remaining!\nSolve the rest yourself!", "error");
        exit;
    }

    // Collect all enc_index groups that still have at least one wrong / blank tile
    var checked = array_create(26, false);
    var pool    = [];
    var pool_n  = 0;

    with (obj_tile_beginner) {
        if (is_guess_tile && !is_hinted && guessed_index != plain_index) {
            if (!checked[enc_index]) {
                checked[enc_index] = true;
                pool[pool_n++]     = enc_index;
            }
        }
    }

    if (pool_n == 0) {
        scr_show_popup("The puzzle is already solved!", "info");
        exit;
    }

    // Pick one enc_index at random and reveal the whole group
    var pick = pool[irandom(pool_n - 1)];

    with (obj_tile_beginner) {
        if (is_guess_tile && enc_index == pick) {
            guessed_index = plain_index;
            is_locked     = true;
            is_hinted     = true;
            image_alpha   = 1.0;
            image_blend   = make_colour_hsv(195, 200, 215);  // steel blue = hinted
        }
    }

    global.hints_remaining--;
    audio_play_sound(global.snd_hint, 1, false);
    scr_update_bank_dimming();
    with (global.game_control_id) { scr_check_win(); }
}
