/// @description Draw popup: fancy win overlay or simple info/error box.
var _gw = room_width;
var _gh = room_height;

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

    // Panel geometry — taller than before to hold leaderboard section
    var _pw  = 560;
    var _ph  = 370;
    var _px  = (_gw - _pw) * 0.5;
    var _py  = _gh * 0.5 - _ph * 0.5 - 10;

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
    draw_text(_gw * 0.5, _py + 32, "*    PUZZLE  SOLVED    *");

    // Divider
    draw_set_colour(make_colour_hsv(40, 160, 180));
    draw_set_alpha(popup_alpha * 0.55);
    draw_line(_px + 24, _py + 48, _px + _pw - 24, _py + 48);
    draw_set_alpha(popup_alpha);

    // Solved phrase — rebuild from 28-col rows, trimming padding so words don't run together
    var _cols = 28;
    var _nrows = 5;
    var _disp = "";
    var _r;
    for (_r = 0; _r < _nrows; _r++) {
        var _row = string_copy(global.plain_phrase, _r * _cols + 1, _cols);
        while (string_length(_row) > 0 && string_char_at(_row, string_length(_row)) == " ") {
            _row = string_copy(_row, 1, string_length(_row) - 1);
        }
        if (_disp != "" && _row != "") { _disp += " "; }
        _disp += _row;
    }
    draw_set_font(-1);
    draw_set_colour(c_white);
    draw_set_alpha(popup_alpha * 0.92);
    draw_text_ext(_gw * 0.5, _py + 70, _disp, -1, _pw - 48);

    // Puzzle title + time + stars
    var _tsecs = floor(global.puzzle_elapsed_ms / 1000);
    var _tstr  = scr_format_time(_tsecs);

    draw_set_font(fnt_script);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(make_colour_hsv(40, 200, 255));
    draw_set_alpha(popup_alpha * 0.85);
    draw_text(_gw * 0.5 - 48, _py + 160, global.puzzle_title + "   " + _tstr);

    var _sr   = 9;
    var _sgap = 24;
    var _sx0  = _gw * 0.5 + 52;
    var _sy   = _py + 160;
    var _e;
    for (_e = 0; _e < 3; _e++) {
        var _scx   = _sx0 + _e * _sgap;
        var _sfill = (_e < global.win_stars);
        var _scol  = _sfill
                     ? make_colour_hsv(40 + _shim * 12, 230, 255)
                     : make_colour_hsv(40,               60,  140);
        draw_set_alpha(_sfill ? popup_alpha : popup_alpha * 0.5);
        scr_draw_star(_scx, _sy, _sr, _sfill, _scol);
        if (_sfill) {
            draw_set_alpha(popup_alpha * 0.6);
            scr_draw_star(_scx, _sy, _sr, false, make_colour_hsv(45, 180, 200));
        }
    }

    // ---- Leaderboard section ----
    var _lby = _py + 178;   // y where leaderboard section starts

    draw_set_colour(make_colour_hsv(40, 160, 180));
    draw_set_alpha(popup_alpha * 0.45);
    draw_line(_px + 24, _lby, _px + _pw - 24, _lby);
    draw_set_alpha(popup_alpha);

    draw_set_font(fnt_script);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(popup_alpha * 0.7);
    draw_set_colour(make_colour_hsv(40, 120, 200));
    var _pnum = (variable_global_exists("puzzle_index") ? global.puzzle_index + 1 : 0);
    draw_text(_gw * 0.5, _lby + 12, "TOP  10  —  PUZZLE  #" + string(_pnum));

    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_alpha(popup_alpha);

    var _row_y   = _lby + 26;
    var _row_h   = 14;
    var _name_x  = _px + 44;
    var _time_x  = _px + _pw - 28;
    var _star_x  = _px + _pw - 96;

    if (lb_state == "loading") {
        draw_set_colour(make_colour_hsv(0, 0, 140));
        draw_set_alpha(popup_alpha * 0.6);
        draw_set_halign(fa_center);
        draw_text(_gw * 0.5, _row_y + 40, "Loading scores...");
    } else if (lb_state == "error") {
        draw_set_colour(make_colour_hsv(0, 140, 200));
        draw_set_alpha(popup_alpha * 0.6);
        draw_set_halign(fa_center);
        draw_text(_gw * 0.5, _row_y + 40, "Leaderboard unavailable");
    } else {
        // Draw up to 5 scores
        var _count = min(array_length(lb_scores), 5);
        var _wi;
        for (_wi = 0; _wi < 5; _wi++) {
            var _ry = _row_y + _wi * _row_h;
            if (_wi < _count) {
                var _sc   = lb_scores[_wi];
                var _rank = _wi + 1;
                // Highlight row if this is the player's just-submitted score
                if (lb_submitted && lb_submit_rank > 0 && _rank == lb_submit_rank) {
                    draw_set_colour(make_colour_hsv(40, 180, 70));
                    draw_set_alpha(popup_alpha * 0.4);
                    draw_rectangle(_px + 28, _ry - 6, _px + _pw - 28, _ry + 8, false);
                }
                // Rank number
                draw_set_colour(make_colour_hsv(40, 80, 180));
                draw_set_alpha(popup_alpha * 0.8);
                draw_set_halign(fa_right);
                draw_text(_px + 40, _ry, string(_rank) + ".");
                // Name
                draw_set_colour(c_white);
                draw_set_alpha(popup_alpha * 0.9);
                draw_set_halign(fa_left);
                draw_text(_name_x, _ry, _sc.name);
                // Stars (tiny drawn stars)
                var _si;
                for (_si = 0; _si < 3; _si++) {
                    var _sfill2 = (_si < _sc.stars);
                    draw_set_alpha(_sfill2 ? popup_alpha * 0.9 : popup_alpha * 0.25);
                    scr_draw_star(_star_x + _si * 12, _ry, 4,
                                  _sfill2,
                                  make_colour_hsv(40 + _shim * 10, 220, 255));
                }
                // Time
                draw_set_colour(make_colour_hsv(40, 60, 200));
                draw_set_alpha(popup_alpha * 0.8);
                draw_set_halign(fa_right);
                draw_text(_time_x, _ry, scr_format_time(_sc.time_seconds));
            } else {
                // Empty slot
                draw_set_colour(make_colour_hsv(0, 0, 70));
                draw_set_alpha(popup_alpha * 0.35);
                draw_set_halign(fa_right);
                draw_text(_px + 40, _ry, string(_wi + 1) + ".");
                draw_set_halign(fa_left);
                draw_text(_name_x, _ry, "---");
            }
        }
    }

    // ---- Name entry / submit area ----
    var _entry_y = _py + 302;

    draw_set_colour(make_colour_hsv(40, 80, 100));
    draw_set_alpha(popup_alpha * 0.35);
    draw_line(_px + 24, _entry_y - 6, _px + _pw - 24, _entry_y - 6);
    draw_set_alpha(popup_alpha);

    if (lb_state == "ready" && lb_qualify && !lb_submitted) {
        // Row 1: "TOP 10!" header at _input_y
        var _input_y = _entry_y - 34;
        draw_set_font(fnt_script);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_colour(_gold);
        draw_set_alpha(popup_alpha);
        draw_text(_px + 28, _input_y + 8, "Top 10!");

        // Row 2: NAME: | [input box] | skip | SUBMIT  — all at _entry_y
        // "NAME:" label
        draw_set_font(fnt_script);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_colour(_gold);
        draw_set_alpha(popup_alpha);
        draw_text(_px + 28, _entry_y + 8, "NAME:");

        // Input box
        var _box_x1 = _px + 98;
        var _box_x2 = _px + _pw - 150;
        var _box_y1 = _entry_y - 1;
        var _box_y2 = _entry_y + 18;
        draw_set_colour(make_colour_hsv(0, 0, 20));
        draw_set_alpha(popup_alpha * 0.7);
        draw_rectangle(_box_x1, _box_y1, _box_x2, _box_y2, false);
        draw_set_colour(_gold);
        draw_set_alpha(popup_alpha * 0.6);
        draw_rectangle(_box_x1, _box_y1, _box_x2, _box_y2, true);

        draw_set_font(-1);
        draw_set_colour(c_white);
        draw_set_alpha(popup_alpha);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        var _cursor = ((lb_name_cursor div 30) mod 2 == 0) ? "|" : "";
        draw_text(_box_x1 + 4, _entry_y + 8, lb_name_input + _cursor);

        // Skip link — right of box
        var _sk_x = _box_x2 + 8;
        draw_set_font(-1);
        draw_set_colour(make_colour_hsv(0, 0, lb_skip_hover ? 200 : 120));
        draw_set_halign(fa_left);
        draw_set_alpha(popup_alpha * 0.6);
        draw_text(_sk_x, _entry_y + 8, "skip");

        // SUBMIT button — far right
        var _sb_cx = _px + _pw - 52;
        var _sb_cy = _entry_y + 8;
        var _sbw = 88;  var _sbh = 24;
        var _sfv = lb_submit_hover ? 190 : 155;
        draw_set_colour(make_colour_hsv(120, 150, _sfv));
        draw_set_alpha(popup_alpha);
        draw_roundrect(_sb_cx - _sbw*0.5, _sb_cy - _sbh*0.5, _sb_cx + _sbw*0.5, _sb_cy + _sbh*0.5, false);
        draw_set_colour(make_colour_hsv(120, 200, max(_sfv-50,20)));
        draw_roundrect(_sb_cx - _sbw*0.5, _sb_cy - _sbh*0.5, _sb_cx + _sbw*0.5, _sb_cy + _sbh*0.5, true);
        draw_set_font(fnt_script);
        draw_set_colour(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_sb_cx, _sb_cy, "SUBMIT");

    } else if (lb_submitted && lb_submit_rank > 0) {
        draw_set_font(fnt_script);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_colour(_gold);
        draw_set_alpha(popup_alpha);
        draw_text(_gw * 0.5, _entry_y + 8, "Submitted!  You ranked  #" + string(lb_submit_rank));
    } else if (lb_submitted) {
        // Either skipped or submit failed
        draw_set_font(-1);
        draw_set_colour(make_colour_hsv(0, 0, 120));
        draw_set_alpha(popup_alpha * 0.5);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_gw * 0.5, _entry_y + 8, "");
    } else if (lb_state == "ready" && !lb_qualify) {
        draw_set_font(-1);
        draw_set_colour(make_colour_hsv(0, 0, 110));
        draw_set_alpha(popup_alpha * 0.45);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_gw * 0.5, _entry_y + 8, "Not in the top 10 yet — keep practising!");
    }

    // ---- Navigation buttons ----
    var _bw     = 140;
    var _bh     = 28;
    var _by     = _py + _ph - 22;
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
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
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
