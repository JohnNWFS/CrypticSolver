/// @description Leaderboard screen input — scroll, back, puzzle detail.
var _total_rows = PUZZLE_TOTAL;
var visible_rows = floor((list_y2 - list_y1) / row_h);
var scroll_max   = max(0, (_total_rows - visible_rows) * row_h);

// Platform-aware mouse coordinates (GUI space)
var _mx = scr_ui_mouse_x();
var _my = scr_ui_mouse_y();

// ---- Scrollbar geometry ----
var track_x  = list_x2 + 10;
var track_y1 = list_y1;
var track_y2 = list_y2;
var thumb_h  = (scroll_max > 0) ? max(20, (visible_rows / _total_rows) * (track_y2 - track_y1)) : (track_y2 - track_y1);
var thumb_y  = (scroll_max > 0) ? track_y1 + (scroll_offset / scroll_max) * ((track_y2 - track_y1) - thumb_h) : track_y1;
var sb_hit_x1 = track_x - 6;
var sb_hit_x2 = track_x + 12;

// ---- Scrollbar drag ----
if (sb_dragging) {
    if (mouse_check_button(mb_left)) {
        var delta = _my - sb_drag_origin_y;
        var px_per_scroll = (scroll_max > 0) ? ((track_y2 - track_y1) - thumb_h) / scroll_max : 1;
        scroll_offset = clamp(sb_drag_origin_sc + delta / px_per_scroll, 0, scroll_max);
    } else {
        sb_dragging = false;
    }
}

if (!sb_dragging && mouse_check_button_pressed(mb_left)
 && _mx >= sb_hit_x1 && _mx <= sb_hit_x2
 && _my >= track_y1  && _my <= track_y2) {
    if (_my >= thumb_y && _my <= thumb_y + thumb_h) {
        sb_dragging = true;
        sb_drag_origin_y  = _my;
        sb_drag_origin_sc = scroll_offset;
    } else {
        var ratio = (_my - track_y1 - thumb_h * 0.5) / ((track_y2 - track_y1) - thumb_h);
        scroll_offset = clamp(ratio * scroll_max, 0, scroll_max);
    }
}

// ---- Mouse wheel / keys ----
if (mouse_wheel_up())                { scroll_offset = max(0,          scroll_offset - row_h); }
if (mouse_wheel_down())              { scroll_offset = min(scroll_max, scroll_offset + row_h); }
if (keyboard_check_pressed(vk_up))   { scroll_offset = max(0,          scroll_offset - row_h); }
if (keyboard_check_pressed(vk_down)) { scroll_offset = min(scroll_max, scroll_offset + row_h); }

// ---- Click a puzzle row → fetch its top 10 ----
var row_click = !sb_dragging
             && mouse_check_button_pressed(mb_left)
             && _mx >= list_x1 && _mx < sb_hit_x1
             && _my >= list_y1 && _my < list_y2;
if (row_click) {
    var _clicked_row = floor((_my - list_y1 + scroll_offset) / row_h);
    if (_clicked_row >= 0 && _clicked_row < PUZZLE_TOTAL) {
        detail_puzzle          = _clicked_row;
        detail_state           = "loading";
        global.lb_win_puzzle   = _clicked_row;
        global.lb_win_state    = "loading";
        global.lb_win_fetch_id = scr_fetch_leaderboard(_clicked_row);
    }
}

// ---- Detail panel data arrival ----
if (detail_state == "loading" && global.lb_win_state == "ready") {
    var _pidx = global.lb_win_puzzle;
    detail_scores = is_undefined(global.lb_data[_pidx]) ? [] : global.lb_data[_pidx];
    detail_state  = "ready";
}

// ---- Back button / Escape ----
var _back_cx = scr_ui_width() * 0.5;
var _back_cy = scr_ui_height() - 60;
var _back_hw = 60;  var _back_hh = 14;
var _back_hover = (_mx >= _back_cx - _back_hw && _mx <= _back_cx + _back_hw
                && _my >= _back_cy - _back_hh && _my <= _back_cy + _back_hh);
if ((_back_hover && mouse_check_button_pressed(mb_left))
 || keyboard_check_pressed(vk_escape)) {
    room_goto(rm_title);
}
