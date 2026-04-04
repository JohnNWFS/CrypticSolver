/// @description Mouse-wheel scrolling, hover tracking, and input handling.
var visible_rows = floor((list_y2 - list_y1) / row_h);
var scroll_max   = max(0, (total_puzzles - visible_rows) * row_h);

// --- Scrollbar geometry (must match Draw_0) ---
var track_x  = list_x2 + 10;
var track_y1 = list_y1;
var track_y2 = list_y2;
var thumb_h  = (scroll_max > 0) ? max(20, (visible_rows / total_puzzles) * (track_y2 - track_y1)) : (track_y2 - track_y1);
var thumb_y  = (scroll_max > 0) ? track_y1 + (scroll_offset / scroll_max) * ((track_y2 - track_y1) - thumb_h) : track_y1;
var sb_hit_x1 = track_x - 6;   // generous hit zone around the 6-px track
var sb_hit_x2 = track_x + 12;

// --- Scrollbar drag ---
if (sb_dragging) {
    if (mouse_check_button(mb_left)) {
        var delta   = mouse_y - sb_drag_origin_y;
        var px_per_scroll = (scroll_max > 0) ? ((track_y2 - track_y1) - thumb_h) / scroll_max : 1;
        scroll_offset = clamp(sb_drag_origin_sc + delta / px_per_scroll, 0, scroll_max);
    } else {
        sb_dragging = false;
    }
}

// --- Start scrollbar drag on click ---
if (!sb_dragging && mouse_check_button_pressed(mb_left)
 && mouse_x >= sb_hit_x1 && mouse_x <= sb_hit_x2
 && mouse_y >= track_y1  && mouse_y <= track_y2) {
    if (mouse_y >= thumb_y && mouse_y <= thumb_y + thumb_h) {
        // Click on thumb — drag from here
        sb_dragging       = true;
        sb_drag_origin_y  = mouse_y;
        sb_drag_origin_sc = scroll_offset;
    } else {
        // Click on track — jump to that position
        var ratio = (mouse_y - track_y1 - thumb_h * 0.5) / ((track_y2 - track_y1) - thumb_h);
        scroll_offset = clamp(ratio * scroll_max, 0, scroll_max);
    }
}

// --- Mouse wheel ---
if (mouse_wheel_up())   { scroll_offset = max(0,          scroll_offset - row_h); }
if (mouse_wheel_down()) { scroll_offset = min(scroll_max, scroll_offset + row_h); }

// --- Arrow key scroll ---
if (keyboard_check_pressed(vk_up))   { scroll_offset = max(0,          scroll_offset - row_h); }
if (keyboard_check_pressed(vk_down)) { scroll_offset = min(scroll_max, scroll_offset + row_h); }

// --- Hover tracking (skip if over scrollbar) ---
if (mouse_y >= list_y1 && mouse_y < list_y2 && mouse_x < sb_hit_x1) {
    var row_in_view = floor((mouse_y - list_y1) / row_h);
    hovered_row = row_in_view + floor(scroll_offset / row_h);
    if (hovered_row >= total_puzzles) { hovered_row = -1; }
} else {
    hovered_row = -1;
}

// ---- Ticker advance ----
ticker_timer++;
if (ticker_timer >= TICKER_INTERVAL) {
    ticker_timer = 0;
    var _tc = array_length(global.lb_ticker_scores);
    if (_tc > 0) { ticker_idx = (ticker_idx + 1) mod _tc; }
    ticker_alpha = 0;
}
if (ticker_alpha < 1) { ticker_alpha = min(1, ticker_alpha + 0.05); }

// ---- Name input overlay ----
if (name_overlay) {
    name_input_cursor++;
    if (keyboard_check_pressed(vk_backspace) && string_length(name_input) > 0) {
        name_input = string_copy(name_input, 1, string_length(name_input) - 1);
        keyboard_string = "";
    }
    if (keyboard_string != "") {
        name_input   = string_copy(name_input + keyboard_string, 1, 20);
        keyboard_string = "";
    }
    if (keyboard_check_pressed(vk_return) || keyboard_check_pressed(vk_escape)) {
        global.player_name = name_input;
        scr_save_progress();
        name_overlay = false;
        keyboard_string = "";
    }
    exit;   // block all other input while overlay is open
}

// ---- Leaderboard button ----
var _lb_cx = room_width - 80;
var _lb_cy = room_height - 40;
lb_btn_hover = (mouse_x >= _lb_cx - 76 && mouse_x <= _lb_cx + 76
             && mouse_y >= _lb_cy - 12 && mouse_y <= _lb_cy + 12);
if (lb_btn_hover && mouse_check_button_pressed(mb_left)) {
    room_goto(rm_leaderboard);
}

// ---- Name button (bottom-left) ----
var _nm_cx = 70;
var _nm_cy = room_height - 40;
var _nm_hover = (mouse_x >= _nm_cx - 56 && mouse_x <= _nm_cx + 56
              && mouse_y >= _nm_cy - 12 && mouse_y <= _nm_cy + 12);
if (_nm_hover && mouse_check_button_pressed(mb_left)) {
    name_overlay    = true;
    name_input      = (variable_global_exists("player_name") ? global.player_name : "");
    name_input_cursor = 0;
    keyboard_string = "";
}

// F3 toggles font style — persists into the game
if (keyboard_check_pressed(vk_f3)) {
    if (!variable_global_exists("font_index")) { global.font_index = 0; }
    global.font_index = (global.font_index + 1) mod (global.font_list_size + 1);
}

// F1 = instructions / about screen
if (keyboard_check_pressed(vk_f1)) { room_goto(rm_about); }

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

// --- Select puzzle: left click on list row (not scrollbar, not dragging) ---
var select_by_click = !sb_dragging
                   && mouse_check_button_pressed(mb_left)
                   && mouse_x >= list_x1 && mouse_x < sb_hit_x1
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
