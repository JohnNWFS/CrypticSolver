/// @description Long-press clear for mobile (hold ~0.75s to clear a guess tile).
// Only relevant for guess tiles that have a letter and haven't been hinted.
if (!is_guess_tile || is_hinted || guessed_index < 0) {
    lp_timer = 0;
    lp_fired = false;
    exit;
}

var _over = point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom);

if (_over && mouse_check_button(mb_left)) {
    lp_timer++;
    if (lp_timer >= LP_FRAMES && !lp_fired) {
        lp_fired = true;
        // Clear all guess tiles sharing this encrypted letter (same as right-click)
        var _enc = enc_index;
        with (obj_tile_beginner) {
            if (is_guess_tile && enc_index == _enc) {
                guessed_index = -1;
                is_locked     = false;
                image_alpha   = 0.5;
                image_blend   = c_white;
            }
        }
        audio_play_sound(global.snd_clear, 1, false);
        scr_update_bank_dimming();
    }
} else {
    lp_timer = 0;
    lp_fired = false;
}
