/// @description Left released: if a drag was active, drop the letter here (locked).
if (!global.drag_active) {
    // Not a drag — reset any pending drag state and exit (click was handled on press)
    global.is_dragging = false;
    global.drag_letter = -1;
    exit;
}

// Consume the drag
var drop_letter = global.drag_letter;
global.is_dragging = false;
global.drag_active = false;
global.drag_letter = -1;

// Can only drop onto a guess tile
if (!is_guess_tile) exit;

var clicked_enc    = enc_index;
var clicked_letter = drop_letter;

// Apply "already locked elsewhere" check
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

// Place AND immediately lock on all matching tiles
with (obj_tile_beginner) {
    if (is_guess_tile && enc_index == clicked_enc) {
        guessed_index = clicked_letter;
        is_locked     = true;
        image_alpha   = 1.0;
        image_blend   = make_colour_hsv(40, 200, 240);  // gold = locked
    }
}

scr_update_bank_dimming();
with (global.game_control_id) { scr_check_win(); }
