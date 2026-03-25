/// @description Middle click: select the guessed letter in the bank and lock all matching tiles.
if (!is_guess_tile || is_hinted) exit;  // hinted tiles cannot be changed
if (guessed_index == -1) exit;         // nothing guessed here, nothing to lock

var clicked_enc    = enc_index;
var clicked_letter = guessed_index;

// Block if this letter is already locked on a different encrypted group
var already_locked = false;
with (obj_tile_beginner) {
    if (is_guess_tile && enc_index != clicked_enc && guessed_index == clicked_letter && is_locked) {
        already_locked = true;
        break;
    }
}
if (already_locked) {
    scr_show_popup(chr(clicked_letter + 65) + " is already locked in elsewhere.\nRight-click those tiles to free it first.", "error");
    exit;
}

// Highlight the matching bank tile as if the player had clicked it
if (global.selected_bank_id != noone && instance_exists(global.selected_bank_id)) {
    with (global.selected_bank_id) { image_blend = c_white; }
}
global.selected_letter  = clicked_letter;
global.selected_bank_id = noone;

with (obj_tile_beginner) {
    if (is_bank_tile && letter_index == clicked_letter) {
        global.selected_bank_id = id;
        image_blend = make_colour_hsv(40, 220, 255);  // gold = selected in bank
        break;
    }
}

// Lock all guess tiles sharing this encrypted letter
with (obj_tile_beginner) {
    if (is_guess_tile && enc_index == clicked_enc) {
        is_locked   = true;
        image_blend = make_colour_hsv(40, 200, 240);  // gold = locked
    }
}
scr_update_bank_dimming();
with (global.game_control_id) { scr_check_win(); }
