/// @description Draw popup: fancy win overlay or simple info/error box.
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// ---------------------------------------------------------------
// WIN SCREEN
// ---------------------------------------------------------------
if (popup_type == "win") {

    // Full-screen dim
    draw_set_colour(c_black);
    draw_set_alpha(popup_alpha * 0.75);
    draw_rectangle(0, 0, _gw, _gh, false);

    // Sparkles
    var s;
    for (s = 0; s < 40; s++) {
        var sp  = win_sparkles[s];
        var _a  = (sp.life / sp.maxl) * popup_alpha * 0.9;
        draw_set_colour(make_colour_hsv(sp.hue, 210, 255));
        draw_set_alpha(_a);
        draw_circle(sp.x, sp.y, sp.sz, false);
    }
    draw_set_alpha(popup_alpha);

    // Panel geometry
    var _pw  = 520;
    var _ph  = 210;
    var _px  = (_gw - _pw) * 0.5;
    var _py  = _gh * 0.5 - _ph * 0.5 - 30;

    // Animated shimmer hue
    var _shim = (popup_timer mod 90) / 90;
    var _gold = make_colour_hsv(40 + _shim * 16, 220, 255);

    // Panel shadow
    draw_set_colour(c_black);
    draw_set_alpha(popup_alpha * 0.55);
    draw_roundrect(_px + 7, _py + 7, _px + _pw + 7, _py + _ph + 7, false);

    // Panel fill
    draw_set_colour(make_colour_hsv(38, 130, 38));
    draw_set_alpha(popup_alpha * 0.96);
    draw_roundrect(_px, _py, _px + _pw, _py + _ph, false);

    // Shimmer border
    draw_set_colour(_gold);
    draw_set_alpha(popup_alpha);
    draw_roundrect(_px, _py, _px + _pw, _py + _ph, true);

    // Header text
  
	draw_set_font(fnt_script);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(_gold);
	draw_text(_gw * 0.5, _py + 48,"*    PUZZLE  SOLVED    *");	

    // Divider
    draw_set_colour(make_colour_hsv(40, 160, 180));
    draw_set_alpha(popup_alpha * 0.55);
    draw_line(_px + 24, _py + 62, _px + _pw - 24, _py + 62);
    draw_set_alpha(popup_alpha);

    // Solved phrase
    draw_set_font(-1);
    draw_set_colour(c_white);
    draw_set_alpha(popup_alpha * 0.92);
    draw_text_ext(_gw * 0.5, _py + 94, global.plain_phrase, -1, _pw - 48);

    // Time taken
    var _tsecs = floor(global.puzzle_elapsed_ms / 1000);
    var _tmm   = floor(_tsecs / 60);
    var _tss   = _tsecs mod 60;
    var _tstr  = string(_tmm) + ":" + ((_tss < 10) ? "0" : "") + string(_tss);

    // Puzzle title + time (centred, left of stars)
    draw_set_font(fnt_script);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(make_colour_hsv(40, 200, 255));
    draw_set_alpha(popup_alpha * 0.85);
    draw_text(_gw * 0.5 - 48, _py + _ph - 22, global.puzzle_title + "   " + _tstr);

    // Drawn stars (3 total, filled up to win_stars)
    var _sr   = 9;                     // outer radius
    var _sgap = 24;                    // centre-to-centre gap
    var _sx0  = _gw * 0.5 + 52;       // x of first star
    var _sy   = _py + _ph - 22;
    var _e;
    for (_e = 0; _e < 3; _e++) {
        var _scx   = _sx0 + _e * _sgap;
        var _sfill = (_e < global.win_stars);
        var _scol  = _sfill
                     ? make_colour_hsv(40 + _shim * 12, 230, 255)   // gold fill
                     : make_colour_hsv(40,               60,  140);  // dim outline
        draw_set_alpha(_sfill ? popup_alpha : popup_alpha * 0.5);
        scr_draw_star(_scx, _sy, _sr, _sfill, _scol);
        // outline ring on filled stars for crispness
        if (_sfill) {
            draw_set_alpha(popup_alpha * 0.6);
            scr_draw_star(_scx, _sy, _sr, false, make_colour_hsv(45, 180, 200));
        }
    }

    // Buttons
    var _bw     = 140;
    var _bh     = 28;
    var _by     = _gh * 0.5 + 120;
    var _btn_cx = [_gw * 0.5 - 78, _gw * 0.5 + 78];
    var _labels = ["NEXT PUZZLE", "MAIN MENU"];
    var _bhues  = [120, 210];

    var _bi;
    for (_bi = 0; _bi < 2; _bi++) {
        var _cx  = _btn_cx[_bi];
        var _ofy = 0;
        if (win_btn_hover[_bi])      _ofy -= 2;
        if (win_btn_press[_bi] > 0)  _ofy += 3;
        var _cy  = _by + _ofy;
        var _x1  = _cx - _bw * 0.5;  var _y1 = _cy - _bh * 0.5;
        var _x2  = _cx + _bw * 0.5;  var _y2 = _cy + _bh * 0.5;

        if (win_btn_press[_bi] == 0) {
            draw_set_colour(c_black);
            draw_set_alpha(popup_alpha * 0.22);
            draw_roundrect(_x1+2, _y1+4, _x2+2, _y2+4, false);
        }
        var _fv = win_btn_hover[_bi] ? 190 : 158;
        if (win_btn_press[_bi] > 0) _fv = 110;
        draw_set_colour(make_colour_hsv(_bhues[_bi], 140, _fv));
        draw_set_alpha(popup_alpha);
        draw_roundrect(_x1, _y1, _x2, _y2, false);
        draw_set_colour(c_white);
        draw_set_alpha(popup_alpha * 0.14);
        draw_roundrect(_x1+1, _y1+1, _x2-1, _cy-1, false);
        draw_set_colour(make_colour_hsv(_bhues[_bi], 210, max(_fv - 55, 20)));
        draw_set_alpha(popup_alpha);
        draw_roundrect(_x1, _y1, _x2, _y2, true);
        draw_set_font(fnt_script);
        draw_set_colour(c_white);
        draw_set_alpha(popup_alpha * (win_btn_hover[_bi] ? 1.0 : 0.90));
        draw_text(_cx, _cy, _labels[_bi]);
        draw_set_font(-1);
    }

// ---------------------------------------------------------------
// INFO / ERROR POPUP
// ---------------------------------------------------------------
} else {
    var _padding  = 24;
    var _max_tw   = 420;

    var _tw = string_width_ext(popup_message, -1, _max_tw);
    var _th = string_height_ext(popup_message, -1, _max_tw);
    var _bw = _tw + _padding * 2;
    var _bh = _th + _padding * 2 + 22;
    var _bx = (_gw - _bw) * 0.5;
    var _by = (_gh - _bh) * 0.5;

    var _col_bg, _col_border;
    if (popup_type == "error") {
        _col_bg     = make_colour_hsv(0,   160, 45);
        _col_border = make_colour_hsv(0,   200, 230);
    } else {
        _col_bg     = make_colour_hsv(200, 60,  40);
        _col_border = make_colour_hsv(120, 100, 180);
    }

    draw_set_colour(c_black);
    draw_set_alpha(popup_alpha * 0.45);
    draw_roundrect(_bx+5, _by+5, _bx+_bw+5, _by+_bh+5, false);

    draw_set_colour(_col_bg);
    draw_set_alpha(popup_alpha * 0.93);
    draw_roundrect(_bx, _by, _bx+_bw, _by+_bh, false);

    draw_set_colour(_col_border);
    draw_set_alpha(popup_alpha);
    draw_roundrect(_bx, _by, _bx+_bw, _by+_bh, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_colour(c_white);
    draw_set_alpha(popup_alpha);
    draw_text_ext(_bx + _bw * 0.5, _by + _padding, popup_message, -1, _max_tw);

    draw_set_alpha(popup_alpha * 0.55);
    draw_set_colour(c_ltgray);
    draw_text(_bx + _bw * 0.5, _by + _bh - 18, "click anywhere to dismiss");
}

// Reset draw state
draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
