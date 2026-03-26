/// @description Draw the title screen and scrollable puzzle list.
var cx = room_width / 2;

// --- Title ---
draw_set_halign(fa_center);
draw_set_colour(make_colour_hsv(40, 200, 255));
draw_set_alpha(1);
draw_text(cx, 18, "=  C R Y P T I C   S O L V E R  =");

draw_set_colour(c_white);
draw_text(cx, 46, "Decipher the hidden phrase — choose a puzzle to begin");

draw_set_colour(make_colour_hsv(0, 0, 160));
draw_text(cx, 70, "Easy  (1-10)     Medium  (11-20)     Hard  (21-30)");

// Divider
draw_set_colour(make_colour_hsv(40, 120, 180));
draw_set_alpha(0.6);
draw_line(80, 90, room_width - 80, 90);
draw_set_alpha(1);

// --- Puzzle list ---
var list_x1  = 80;
var list_x2  = room_width - 80;
var start_row    = floor(scroll_offset / row_h);
var visible_rows = floor((list_y2 - list_y1) / row_h);

// Scroll region clip effect — fade rows that are at the boundary
var i;
for (i = start_row; i < min(total_puzzles, start_row + visible_rows + 1); i++) {
    var ry = list_y1 + (i - start_row) * row_h - (scroll_offset mod row_h);
    if (ry + row_h < list_y1 || ry > list_y2) continue;

    var diff;
    if      (i < 10) { diff = 1; }
    else if (i < 20) { diff = 2; }
    else             { diff = 3; }

    // Row background colour by difficulty, brighter on hover
    var row_col;
    if (i == hovered_row) {
        row_col = make_colour_hsv(40, 200, 180);     // gold hover
    } else if (diff == 1) {
        row_col = make_colour_hsv(120, 80, 55);      // easy — deep green
    } else if (diff == 2) {
        row_col = make_colour_hsv(35, 120, 60);      // medium — amber
    } else {
        row_col = make_colour_hsv(0, 120, 55);       // hard — deep red
    }

    draw_set_colour(row_col);
    draw_set_alpha(0.75);
    draw_rectangle(list_x1, ry, list_x2, ry + row_h - 2, false);

    // Puzzle number
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_colour(c_white);
    draw_text(list_x1 + 10, ry + 5, "Puzzle  #" + string(i + 1));

    // Difficulty label
    var diff_label;
    var diff_col;
    if (diff == 1) {
        diff_label = "Easy";
        diff_col   = make_colour_hsv(120, 180, 220);
    } else if (diff == 2) {
        diff_label = "Medium";
        diff_col   = make_colour_hsv(40, 200, 255);
    } else {
        diff_label = "Hard";
        diff_col   = make_colour_hsv(0, 200, 230);
    }
    draw_set_halign(fa_right);
    draw_set_colour(diff_col);
    draw_text(list_x2 - 76, ry + 5, diff_label);

    // Earned stars (3 small drawn stars)
    var _earned = variable_global_exists("save_stars") ? global.save_stars[i] : 0;
    var _star_r  = 5;
    var _star_gap = 14;
    var _star_x0  = list_x2 - 56;
    var _star_y   = ry + row_h * 0.5;
    var _si;
    for (_si = 0; _si < 3; _si++) {
        var _filled = (_si < _earned);
        var _scol   = _filled
                      ? make_colour_hsv(42, 220, 255)   // gold
                      : make_colour_hsv(0,   0,   70);  // dark empty
        draw_set_alpha(_filled ? 1.0 : 0.45);
        scr_draw_star(_star_x0 + _si * _star_gap, _star_y, _star_r, _filled, _scol);
    }
    draw_set_alpha(1);
}

// --- Bottom action buttons ---
var _tbi;
for (_tbi = 0; _tbi < 2; _tbi++) {
    var _cx  = ts_btn_cx[_tbi];
    var _ofy = 0;
    if (ts_btn_hover[_tbi])      _ofy -= 2;
    if (ts_btn_press[_tbi] > 0)  _ofy += 3;
    var _cy  = ts_btn_cy[_tbi] + _ofy;
    var _hw  = ts_btn_w[_tbi] * 0.5;
    var _hh  = ts_btn_h[_tbi] * 0.5;
    var _x1  = _cx - _hw;  var _y1 = _cy - _hh;
    var _x2  = _cx + _hw;  var _y2 = _cy + _hh;

    if (ts_btn_press[_tbi] == 0) {
        draw_set_alpha(0.22);  draw_set_colour(c_black);
        draw_roundrect(_x1+2, _y1+4, _x2+2, _y2+4, false);
        draw_set_alpha(1);
    }
    var _fv = ts_btn_hover[_tbi] ? 190 : 158;
    if (ts_btn_press[_tbi] > 0) _fv = 110;
    draw_set_colour(make_colour_hsv(ts_btn_hue[_tbi], ts_btn_sat[_tbi], _fv));
    draw_roundrect(_x1, _y1, _x2, _y2, false);
    draw_set_alpha(0.14);  draw_set_colour(c_white);
    draw_roundrect(_x1+1, _y1+1, _x2-1, _cy-1, false);
    draw_set_alpha(1);
    draw_set_colour(make_colour_hsv(ts_btn_hue[_tbi], min(ts_btn_sat[_tbi]+70,255), max(_fv-55,20)));
    draw_roundrect(_x1, _y1, _x2, _y2, true);
    draw_set_font(fnt_script);
    draw_set_halign(fa_center);  draw_set_valign(fa_middle);
    draw_set_colour(c_white);
    draw_set_alpha(ts_btn_hover[_tbi] ? 1.0 : 0.90);
    draw_text(_cx, _cy, ts_btn_label[_tbi]);
    draw_set_alpha(1);
    draw_set_font(-1);
    draw_set_halign(fa_right);  draw_set_valign(fa_bottom);
    draw_set_colour(make_colour_hsv(ts_btn_hue[_tbi], 60, 220));
    draw_set_alpha(0.70);
	draw_set_colour(c_black);
    draw_text_transformed(_x2 , _y2 - 1, ts_btn_short[_tbi],.4,.4,0);
    draw_set_colour(c_white);
	draw_set_alpha(1);
}
draw_set_halign(fa_left);  draw_set_valign(fa_top);  draw_set_font(-1);

// --- Scroll indicator ---
var scroll_max = max(0, (total_puzzles - visible_rows) * row_h);
if (scroll_max > 0) {
    var track_x  = list_x2 + 10;
    var track_y1 = list_y1;
    var track_y2 = list_y2;
    var thumb_h  = max(20, (visible_rows / total_puzzles) * (track_y2 - track_y1));
    var thumb_y  = track_y1 + (scroll_offset / scroll_max) * ((track_y2 - track_y1) - thumb_h);
    draw_set_colour(make_colour_hsv(0, 0, 80));
    draw_set_alpha(0.5);
    draw_rectangle(track_x, track_y1, track_x + 6, track_y2, false);
    draw_set_colour(make_colour_hsv(40, 160, 200));
    draw_set_alpha(0.9);
    draw_rectangle(track_x, thumb_y, track_x + 6, thumb_y + thumb_h, false);
}

// --- Footer ---
draw_set_halign(fa_center);
draw_set_colour(make_colour_hsv(0, 0, 130));
draw_set_alpha(0.8);
draw_line(80, list_y2 + 2, room_width - 80, list_y2 + 2);
draw_set_alpha(0.7);
draw_text(cx, list_y2 + 46, "F1 = instructions   |   F3 = toggle letter style");

// Reset draw state
draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
