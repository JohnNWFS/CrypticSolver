/// @description Left click: select a bank letter, place/lock a guess across all matching tiles.
// Also starts drag tracking — drag is handled on Mouse_7 (release).

// --- Clear button: wipe every non-hinted guess off the board ---
if (is_clear_button) {
    audio_play_sound(global.snd_clear, 1, false);
    with (obj_tile_beginner) {
        if (is_guess_tile && !is_hinted) {
            guessed_index = -1;
            is_locked     = false;
            image_alpha   = 0.5;
            image_blend   = c_white;
        }
    }
    if (global.selected_bank_id != noone && instance_exists(global.selected_bank_id)) {
        with (global.selected_bank_id) { image_blend = c_white; }
    }
    global.selected_letter  = -1;
    global.selected_bank_id = noone;
    scr_update_bank_dimming();
    exit;
}

// Record drag start on any valid tile
if (is_bank_tile) {
    global.is_dragging  = true;
    global.drag_active  = false;
    global.drag_letter  = letter_index;
    global.drag_press_x = mouse_x;
    global.drag_press_y = mouse_y;
} else if (is_guess_tile && guessed_index != -1) {
    global.is_dragging  = true;
    global.drag_active  = false;
    global.drag_letter  = guessed_index;
    global.drag_press_x = mouse_x;
    global.drag_press_y = mouse_y;
}

// --- Bank tile: select / deselect ---
if (is_bank_tile) {
    if (global.selected_letter == letter_index) {
        // Click the already-selected letter → deselect
        global.selected_letter  = -1;
        global.selected_bank_id = noone;
        image_blend = c_white;
    } else {
        // Deselect whatever was previously selected
        if (global.selected_bank_id != noone && instance_exists(global.selected_bank_id)) {
            with (global.selected_bank_id) { image_blend = c_white; }
        }
        // Select this tile
        global.selected_letter  = letter_index;
        global.selected_bank_id = id;
        image_blend = make_colour_hsv(40, 220, 255);  // gold highlight
        audio_play_sound(global.snd_click, 1, false);
    }
    exit;
}

// --- Guess tile: place or lock across all tiles sharing this encrypted letter ---
if (is_guess_tile) {
    if (is_hinted) exit;                    // hint-revealed tiles are permanent
    if (global.selected_letter == -1) exit;

    var clicked_enc    = enc_index;
    var clicked_letter = global.selected_letter;

    if (guessed_index == clicked_letter) {
        // Same letter already here — toggle locked/unlocked on ALL matching tiles
        var new_locked = !is_locked;
        with (obj_tile_beginner) {
            if (is_guess_tile && enc_index == clicked_enc) {
                is_locked = new_locked;
                if (is_locked) {
                    image_blend = make_colour_hsv(40, 200, 240);   // gold = locked/confident
                } else {
                    image_blend = make_colour_hsv(120, 150, 220);  // green = tentative guess
                }
            }
        }
        audio_play_sound(new_locked ? global.snd_lock : global.snd_place, 1, false);
    } else {
        // Different letter — check it isn't already locked on another encrypted group
        global._lock_check = false;
        with (obj_tile_beginner) {
            if (is_guess_tile && enc_index != clicked_enc && guessed_index == clicked_letter) {
                global._lock_check = true;
                break;
            }
        }
        if (global._lock_check) {
            scr_show_popup(chr(clicked_letter + 65) + " is already in use elsewhere.\nRight-click those tiles to clear it first.", "error");
            exit;
        }

        // Place it as a fresh tentative guess on ALL matching tiles
        with (obj_tile_beginner) {
            if (is_guess_tile && enc_index == clicked_enc) {
                guessed_index = clicked_letter;
                is_locked     = false;
                image_alpha   = 1.0;
                image_blend   = make_colour_hsv(120, 150, 220);  // green = tentative
            }
        }
        audio_play_sound(global.snd_place, 1, false);
    }

    scr_update_bank_dimming();
    with (global.game_control_id) { scr_check_win(); }
    exit;
}
