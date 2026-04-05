/// @description Drag threshold tracking + keyboard input.

// ---------------------------------------------------------------
// Drag: track threshold; cancel if mouse released over nothing
// ---------------------------------------------------------------
if (global.is_dragging) {
    if (!mouse_check_button(mb_left)) {
        global.is_dragging = false;
        global.drag_active = false;
        global.drag_letter = -1;
    } else if (!global.drag_active) {
        var dx = mouse_x - global.drag_press_x;
        var dy = mouse_y - global.drag_press_y;
        if ((dx * dx + dy * dy) > 64) {   // 8 px threshold
            global.drag_active = true;
        }
    }
}

// ---------------------------------------------------------------
// Action buttons — hover detection and click handling
// ---------------------------------------------------------------
var _umx = scr_ui_mouse_x();
var _umy = scr_ui_mouse_y();
var _bi;
for (_bi = 0; _bi < 4; _bi++) {
    var _hw = ui_btn_w[_bi] * 0.5;
    var _hh = ui_btn_h[_bi] * 0.5;
    ui_btn_hover[_bi] = (_umx >= ui_btn_cx[_bi] - _hw && _umx <= ui_btn_cx[_bi] + _hw
                      && _umy >= ui_btn_cy[_bi] - _hh && _umy <= ui_btn_cy[_bi] + _hh);

    if (ui_btn_hover[_bi] && mouse_check_button_pressed(mb_left)) {
        ui_btn_press[_bi] = 8;
        switch (_bi) {
            case 0: scr_use_hint(); break;
            case 1: global.puzzle_index = -1; room_goto(room); break;
            case 2: global.font_index = (global.font_index + 1) mod (global.font_list_size + 1); break;
            case 3:
                if (global.selected_bank_id != noone && instance_exists(global.selected_bank_id)) {
                    with (global.selected_bank_id) { image_blend = c_white; }
                }
                global.selected_letter  = -1;
                global.selected_bank_id = noone;
                room_goto(rm_title);
                break;
        }
    }
    if (ui_btn_press[_bi] > 0) ui_btn_press[_bi]--;
}

// ---------------------------------------------------------------
// Keyboard: A–Z selects / deselects bank letters
// ---------------------------------------------------------------
var k;
for (k = 0; k < 26; k++) {
    if (keyboard_check_pressed(ord("A") + k)) {
        if (global.selected_letter == k) {
            // Same key pressed again — deselect
            if (global.selected_bank_id != noone && instance_exists(global.selected_bank_id)) {
                with (global.selected_bank_id) { image_blend = c_white; }
            }
            global.selected_letter  = -1;
            global.selected_bank_id = noone;
            scr_update_bank_dimming();
        } else {
            // Deselect old
            if (global.selected_bank_id != noone && instance_exists(global.selected_bank_id)) {
                with (global.selected_bank_id) { image_blend = c_white; }
            }
            // Select new
            global.selected_letter  = k;
            global.selected_bank_id = bank_tile[k];
            bank_tile[k].image_blend = make_colour_hsv(40, 220, 255);  // gold = selected
        }
        break;
    }
}

// Escape deselects the current bank letter
if (keyboard_check_pressed(vk_escape)) {
    if (global.selected_bank_id != noone && instance_exists(global.selected_bank_id)) {
        with (global.selected_bank_id) { image_blend = c_white; }
    }
    global.selected_letter  = -1;
    global.selected_bank_id = noone;
    scr_update_bank_dimming();
}

// F1 uses a hint token to reveal one encrypted-letter group
if (keyboard_check_pressed(vk_f1)) {
    scr_use_hint();
}

// F2 picks a fresh random puzzle and restarts the room
if (keyboard_check_pressed(vk_f2)) {
    global.puzzle_index = -1;
    room_goto(room);
}

// F3 cycles: sprites → font 1 → font 2 → … → back to sprites
if (keyboard_check_pressed(vk_f3)) {
    global.font_index = (global.font_index + 1) mod (global.font_list_size + 1);
}

// Escape returns to the title / puzzle selector
if (keyboard_check_pressed(vk_escape)) {
    if (global.selected_bank_id != noone && instance_exists(global.selected_bank_id)) {
        with (global.selected_bank_id) { image_blend = c_white; }
    }
    global.selected_letter  = -1;
    global.selected_bank_id = noone;
    room_goto(rm_title);
}
