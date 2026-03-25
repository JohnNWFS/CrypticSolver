/// @description Right click: clear this guess AND all other tiles sharing the same encrypted letter.
if (!is_guess_tile || is_hinted) exit;  // hinted tiles cannot be cleared

var clicked_enc = enc_index;

with (obj_tile_beginner) {
    if (is_guess_tile && enc_index == clicked_enc) {
        guessed_index = -1;
        is_locked     = false;
        image_alpha   = 0.5;
        image_blend   = c_white;
    }
}
scr_update_bank_dimming();
