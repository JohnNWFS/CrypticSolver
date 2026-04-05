/// @description Draw the leaderboard overview screen.
var _gw = scr_ui_width();
var _gh = scr_ui_height();
var cx  = _gw * 0.5;

// ---- Title ----
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_script);
draw_set_colour(make_colour_hsv(40, 200, 255));
draw_set_alpha(1);
draw_text(cx, 22, "=  L E A D E R B O A R D  =");

draw_set_font(-1);
draw_set_colour(make_colour_hsv(0, 0, 140));
draw_text(cx, 50, "Click a puzzle to see its full top 10");

draw_set_colour(make_colour_hsv(40, 100, 160));
draw_set_alpha(0.5);
draw_line(list_x1, list_y1 - 6, list_x2, list_y1 - 6);
draw_set_alpha(1);

// ---- Puzzle list rows ----
var _total_rows  = PUZZLE_TOTAL;
var visible_rows = floor((list_y2 - list_y1) / row_h);
var scroll_max   = max(0, (_total_rows - visible_rows) * row_h);
var start_row    = floor(scroll_offset / row_h);

// Build a quick lookup: puzzle_index → best score struct (from lb_all_scores)
var _lb_map = ds_map_create();
if (global.lb_all_state == "ready") {
    var _ai;
    for (_ai = 0; _ai < array_length(global.lb_all_scores); _ai++) {
        var _as = global.lb_all_scores[_ai];
        ds_map_set(_lb_map, _as.puzzle_index, _as);
    }
}

var i;
for (i = start_row; i < min(_total_rows, start_row + visible_rows + 1); i++) {
    var ry = list_y1 + (i - start_row) * row_h - (scroll_offset mod row_h);
    if (ry + row_h < list_y1 || ry > list_y2) continue;

    // Difficulty colour
    var diff;
    if      (i < 30) { diff = 1; }
    else if (i < 60) { diff = 2; }
    else             { diff = 3; }

    var _row_col;
    if (i == detail_puzzle) {
        _row_col = make_colour_hsv(40, 200, 100);
    } else if (diff == 1) {
        _row_col = make_colour_hsv(120, 80, 45);
    } else if (diff == 2) {
        _row_col = make_colour_hsv(35, 120, 50);
    } else {
        _row_col = make_colour_hsv(0, 120, 45);
    }

    draw_set_colour(_row_col);
    draw_set_alpha(0.7);
    draw_rectangle(list_x1, ry, list_x2, ry + row_h - 2, false);
    draw_set_alpha(1);

    // Puzzle number
    draw_set_halign(fa_right);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_script);
    draw_set_colour(make_colour_hsv(40, 80, 200));
    draw_text(list_x1 + 44, ry + row_h * 0.5, "#" + string(i + 1));

    // Best score info
    draw_set_font(-1);
    draw_set_halign(fa_left);
    if (global.lb_all_state == "loading") {
        draw_set_colour(make_colour_hsv(0, 0, 100));
        draw_text(list_x1 + 52, ry + row_h * 0.5, "Loading...");
    } else if (ds_map_exists(_lb_map, i)) {
        var _best = _lb_map[? i];
        draw_set_colour(c_white);
        draw_text(list_x1 + 52, ry + row_h * 0.5, _best.name);
        // Stars
        var _si;
        for (_si = 0; _si < 3; _si++) {
            var _sfill = (_si < _best.stars);
            draw_set_alpha(_sfill ? 1 : 0.25);
            scr_draw_star(list_x1 + 200 + _si * 14, ry + row_h * 0.5, 4,
                          _sfill, make_colour_hsv(40, 220, 255));
        }
        draw_set_alpha(1);
        draw_set_colour(make_colour_hsv(40, 60, 180));
        draw_set_halign(fa_left);
        draw_text(list_x1 + 252, ry + row_h * 0.5, scr_format_time(_best.time_seconds));
    } else {
        draw_set_colour(make_colour_hsv(0, 0, 70));
        draw_set_alpha(0.5);
        draw_text(list_x1 + 52, ry + row_h * 0.5, "no scores yet");
        draw_set_alpha(1);
    }
}
ds_map_destroy(_lb_map);

// ---- Scrollbar ----
var track_x  = list_x2 + 10;
var track_y1 = list_y1;
var track_y2 = list_y2;
var thumb_h  = (scroll_max > 0) ? max(20, (visible_rows / _total_rows) * (track_y2 - track_y1)) : (track_y2 - track_y1);
var thumb_y  = (scroll_max > 0) ? track_y1 + (scroll_offset / scroll_max) * ((track_y2 - track_y1) - thumb_h) : track_y1;

draw_set_colour(make_colour_hsv(0, 0, 30));
draw_set_alpha(0.6);
draw_rectangle(track_x - 2, track_y1, track_x + 8, track_y2, false);
draw_set_colour(make_colour_hsv(40, 120, 160));
draw_set_alpha(0.85);
draw_rectangle(track_x - 2, thumb_y, track_x + 8, thumb_y + thumb_h, false);
draw_set_alpha(1);

// ---- Detail panel (right side overlay) ----
if (detail_puzzle >= 0) {
    var _dx  = list_x2 - 240;
    var _dy  = list_y1;
    var _dw  = 280;
    var _dh  = 12 + 11 * 18 + 8;

    draw_set_colour(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(_dx, _dy, _dx + _dw, _dy + _dh, false);
    draw_set_colour(make_colour_hsv(40, 120, 160));
    draw_set_alpha(0.85);
    draw_rectangle(_dx, _dy, _dx + _dw, _dy + _dh, true);
    draw_set_alpha(1);

    draw_set_font(fnt_script);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(make_colour_hsv(40, 200, 255));
    draw_text(_dx + _dw * 0.5, _dy + 12, "Puzzle #" + string(detail_puzzle + 1) + " — Top 10");

    draw_set_font(-1);
    draw_set_halign(fa_left);

    if (detail_state == "loading") {
        draw_set_colour(make_colour_hsv(0, 0, 140));
        draw_set_alpha(0.7);
        draw_text(_dx + 16, _dy + 32, "Loading...");
    } else if (detail_state == "ready") {
        var _dc = array_length(detail_scores);
        var _di;
        for (_di = 0; _di < 10; _di++) {
            var _drow_y = _dy + 28 + _di * 18;
            draw_set_colour(make_colour_hsv(40, 80, 160));
            draw_set_halign(fa_right);
            draw_text(_dx + 24, _drow_y, string(_di + 1) + ".");
            if (_di < _dc) {
                var _ds = detail_scores[_di];
                draw_set_colour(c_white);
                draw_set_halign(fa_left);
                draw_text(_dx + 28, _drow_y, _ds.name);
                var _si2;
                for (_si2 = 0; _si2 < 3; _si2++) {
                    draw_set_alpha((_si2 < _ds.stars) ? 1 : 0.25);
                    scr_draw_star(_dx + 148 + _si2 * 14, _drow_y + 1, 4,
                                  (_si2 < _ds.stars), make_colour_hsv(40, 220, 255));
                }
                draw_set_alpha(1);
                draw_set_colour(make_colour_hsv(40, 60, 180));
                draw_set_halign(fa_right);
                draw_text(_dx + _dw - 8, _drow_y, scr_format_time(_ds.time_seconds));
            } else {
                draw_set_colour(make_colour_hsv(0, 0, 60));
                draw_set_alpha(0.5);
                draw_set_halign(fa_left);
                draw_text(_dx + 28, _drow_y, "---");
                draw_set_alpha(1);
            }
        }
    }
}

// ---- Back button ----
// Position based on room_height so the button sits at the visual bottom
// on both Windows and HTML5. Hit detection uses mouse_x/y (room space)
// which correctly maps to that position on all platforms.
var _back_cx = _gw * 0.5;
var _back_cy = room_height - 60;
var _back_hw = 60;  var _back_hh = 14;
var _back_hover = (mouse_x >= _back_cx - _back_hw && mouse_x <= _back_cx + _back_hw
                && mouse_y >= _back_cy - _back_hh && mouse_y <= _back_cy + _back_hh);
var _bfv = _back_hover ? 180 : 140;
draw_set_colour(make_colour_hsv(210, 100, _bfv));
draw_set_alpha(0.85);
draw_roundrect(_back_cx - _back_hw, _back_cy - _back_hh,
               _back_cx + _back_hw, _back_cy + _back_hh, false);
draw_set_colour(make_colour_hsv(210, 180, max(_bfv - 40, 20)));
draw_roundrect(_back_cx - _back_hw, _back_cy - _back_hh,
               _back_cx + _back_hw, _back_cy + _back_hh, true);
draw_set_alpha(1);
draw_set_font(fnt_script);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_colour(c_white);
draw_text(_back_cx, _back_cy, "BACK  [Esc]");

// Reset state
draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
