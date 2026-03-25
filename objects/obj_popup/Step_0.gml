/// @description Fade in, animate sparkles, handle win buttons / info dismiss.
popup_alpha = min(1, popup_alpha + 0.06);
popup_timer++;

if (popup_type == "win") {
    // Animate sparkles
    var s;
    for (s = 0; s < 40; s++) {
        var sp  = win_sparkles[s];
        sp.x   += sp.vx;
        sp.y   += sp.vy;
        sp.life--;
        if (sp.life <= 0) {
            sp.x    = irandom(display_get_gui_width());
            sp.y    = display_get_gui_height() + 10;
            sp.vx   = random_range(-1.5, 1.5);
            sp.vy   = random_range(-2.5, -0.8);
            var _l  = 60 + irandom(120);
            sp.life = _l;
            sp.maxl = _l;
            sp.sz   = 2 + random(4);
        }
    }

    // Button positions (match Draw_64)
    var _gw  = display_get_gui_width();
    var _gh  = display_get_gui_height();
    var _bw  = 140;
    var _bh  = 28;
    var _by  = _gh * 0.5 + 120;
    var _cx0 = _gw * 0.5 - 78;
    var _cx1 = _gw * 0.5 + 78;

    var _mx  = device_mouse_x_to_gui(0);
    var _my  = device_mouse_y_to_gui(0);

    var _btn_cx = [_cx0, _cx1];
    var _bi;
    for (_bi = 0; _bi < 2; _bi++) {
        win_btn_hover[_bi] = (_mx >= _btn_cx[_bi] - _bw * 0.5 && _mx <= _btn_cx[_bi] + _bw * 0.5
                           && _my >= _by - _bh * 0.5          && _my <= _by + _bh * 0.5);
        if (win_btn_hover[_bi] && mouse_check_button_pressed(mb_left) && popup_alpha >= 0.9) {
            win_btn_press[_bi] = 8;
            if (_bi == 0) {
                // Next puzzle
                global.puzzle_index = (global.puzzle_index + 1) mod 30;
                instance_destroy();
                room_restart();
            } else {
                // Main menu
                instance_destroy();
                room_goto(rm_title);
            }
        }
        if (win_btn_press[_bi] > 0) win_btn_press[_bi]--;
    }

} else {
    if (popup_alpha >= 1 && mouse_check_button_pressed(mb_left)) {
        instance_destroy();
    }
}
