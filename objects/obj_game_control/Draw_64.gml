/// @description Draw GUI: drag ghost + info bar (hints, puzzle title, key hints).

// ---------------------------------------------------------------
// Drag ghost — follows the cursor while dragging a letter
// ---------------------------------------------------------------
if (global.drag_active && global.drag_letter >= 0) {
    draw_sprite_ext(spr_tile_beginner, 0, mouse_x, mouse_y, 1, 1, 0, make_colour_hsv(40, 200, 240), 0.85);
    if (global.font_index == 0) {
        draw_sprite_ext(spr_letters, global.drag_letter, mouse_x, mouse_y, 1, 1, 0, c_white, 1.0);
    } else {
        draw_set_font(global.font_list[global.font_index - 1]);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_colour(c_white);
        draw_text(mouse_x, mouse_y, chr(global.drag_letter + 65));
        draw_set_font(-1);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
}

// ---------------------------------------------------------------
// Info bar — drawn below the bank tiles
// ---------------------------------------------------------------
var bar_y = room_height - 62;

// Puzzle title + difficulty stars
var stars = "* ";
if (global.puzzle_difficulty == 2) stars = "** ";
if (global.puzzle_difficulty == 3) stars = "*** ";

draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
draw_set_alpha(0.85);
draw_text(8, bar_y, stars + global.puzzle_title);

// Hint token pips (filled = remaining, hollow = spent)
var pip_x = 220;
var t;
draw_text(pip_x, bar_y, "Hints:");
pip_x += 64;
for (t = 0; t < 3; t++) {
    if (t < global.hints_remaining) {
        draw_set_colour(make_colour_hsv(195, 200, 215));  // steel blue = available
    } else {
        draw_set_colour(c_dkgrey);                        // dark grey = spent
    }
    draw_rectangle(pip_x + t * 14, bar_y + 6, pip_x + t * 14 + 10, bar_y + 11, false);
}

// Running timer (mm:ss) — right-aligned
var _elapsed_s = floor((current_time - puzzle_start_time) / 1000);
var _mm = floor(_elapsed_s / 60);
var _ss = _elapsed_s mod 60;
var _time_str = string(_mm) + ":" + ((_ss < 10) ? "0" : "") + string(_ss);
draw_set_colour(make_colour_hsv(0, 0, 180));
draw_set_halign(fa_right);
draw_text(room_width - 8, bar_y, _time_str);
draw_set_halign(fa_left);

// ---------------------------------------------------------------
// Action buttons
// ---------------------------------------------------------------
var _bi;
for (_bi = 0; _bi < 4; _bi++) {
    var _cx  = ui_btn_cx[_bi];
    var _ofy = 0;
    if (ui_btn_hover[_bi])       _ofy -= 2;
    if (ui_btn_press[_bi] > 0)   _ofy += 3;
    var _cy  = ui_btn_cy[_bi] + _ofy;
    var _hw  = ui_btn_w[_bi] * 0.5;
    var _hh  = ui_btn_h[_bi] * 0.5;
    var _x1  = _cx - _hw;  var _y1 = _cy - _hh;
    var _x2  = _cx + _hw;  var _y2 = _cy + _hh;

    // Drop shadow
    if (ui_btn_press[_bi] == 0) {
        draw_set_alpha(0.22);
        draw_set_colour(c_black);
        draw_roundrect(_x1+2, _y1+4, _x2+2, _y2+4, false);
        draw_set_alpha(1);
    }
    // Face
    var _fv = ui_btn_hover[_bi] ? 190 : 158;
    if (ui_btn_press[_bi] > 0) _fv = 110;
    draw_set_colour(make_colour_hsv(ui_btn_hue[_bi], ui_btn_sat[_bi], _fv));
    draw_roundrect(_x1, _y1, _x2, _y2, false);
    // Gloss
    draw_set_alpha(0.14);
    draw_set_colour(c_white);
    draw_roundrect(_x1+1, _y1+1, _x2-1, _cy-1, false);
    draw_set_alpha(1);
    // Border
    draw_set_colour(make_colour_hsv(ui_btn_hue[_bi], min(ui_btn_sat[_bi]+70,255), max(_fv-55,20)));
    draw_roundrect(_x1, _y1, _x2, _y2, true);
    // Label
    draw_set_font(fnt_script);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(c_white);
    draw_set_alpha(ui_btn_hover[_bi] ? 1.0 : 0.90);
    draw_text(_cx, _cy, ui_btn_label[_bi]);
    draw_set_alpha(1);
    // Shortcut badge
    draw_set_font(-1);
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    draw_set_colour(make_colour_hsv(ui_btn_hue[_bi], 60, 220));
    draw_set_alpha(0.70);
	draw_set_colour(c_black);
    draw_text_transformed(_x2 - 3, _y2 - 1, ui_btn_short[_bi],.4,.4,0);
	draw_set_colour(c_white);
	draw_set_alpha(1);
}

// Reset draw state
draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
