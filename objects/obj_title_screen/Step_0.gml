/// @description Mouse-wheel scrolling, hover tracking, and input handling.
var visible_rows = floor((list_y2 - list_y1) / row_h);
var scroll_max   = max(0, (total_puzzles - visible_rows) * row_h);

// --- Scroll ---
if (mouse_wheel_up())   { scroll_offset = max(0,          scroll_offset - row_h); }
if (mouse_wheel_down()) { scroll_offset = min(scroll_max, scroll_offset + row_h); }

// --- Arrow key scroll ---
if (keyboard_check_pressed(vk_up))   { scroll_offset = max(0,          scroll_offset - row_h); }
if (keyboard_check_pressed(vk_down)) { scroll_offset = min(scroll_max, scroll_offset + row_h); }

// --- Hover tracking ---
if (mouse_y >= list_y1 && mouse_y < list_y2) {
    var row_in_view = floor((mouse_y - list_y1) / row_h);
    hovered_row = row_in_view + floor(scroll_offset / row_h);
    if (hovered_row >= total_puzzles) { hovered_row = -1; }
} else {
    hovered_row = -1;
}

// F toggles letter style (sprites vs font) — persists into the game
if (keyboard_check_pressed(ord("F"))) {
    if (!variable_global_exists("use_sprite_letters")) { global.use_sprite_letters = true; }
    global.use_sprite_letters = !global.use_sprite_letters;
}

// H = instructions / about screen
if (keyboard_check_pressed(ord("H"))) { room_goto(rm_about); }

// --- Bottom buttons hover + click ---
var _tbi;
for (_tbi = 0; _tbi < 2; _tbi++) {
    var _thw = ts_btn_w[_tbi] * 0.5;
    var _thh = ts_btn_h[_tbi] * 0.5;
    ts_btn_hover[_tbi] = (mouse_x >= ts_btn_cx[_tbi] - _thw && mouse_x <= ts_btn_cx[_tbi] + _thw
                       && mouse_y >= ts_btn_cy[_tbi] - _thh && mouse_y <= ts_btn_cy[_tbi] + _thh);
    if (ts_btn_hover[_tbi] && mouse_check_button_pressed(mb_left)) {
        ts_btn_press[_tbi] = 8;
        switch (_tbi) {
            case 0:  // PLAY
                if (hovered_row >= 0) { global.puzzle_index = hovered_row; }
                room_goto(rm_game);
                break;
            case 1:  // HELP
                room_goto(rm_about);
                break;
        }
    }
    if (ts_btn_press[_tbi] > 0) ts_btn_press[_tbi]--;
}

// --- Select puzzle: left click OR Enter/Space on hovered row ---
var select_by_click = mouse_check_button_pressed(mb_left)
                   && mouse_y >= list_y1 && mouse_y < list_y2;
var select_by_key   = keyboard_check_pressed(vk_enter)
                   || keyboard_check_pressed(vk_space);

if (select_by_click) {
    var row_in_view = floor((mouse_y - list_y1) / row_h);
    var clicked_row = row_in_view + floor(scroll_offset / row_h);
    if (clicked_row >= 0 && clicked_row < total_puzzles) {
        global.puzzle_index = clicked_row;
        room_goto(rm_game);
    }
} else if (select_by_key && hovered_row >= 0 && hovered_row < total_puzzles) {
    global.puzzle_index = hovered_row;
    room_goto(rm_game);
}
