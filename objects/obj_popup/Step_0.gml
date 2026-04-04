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
            sp.x    = irandom(room_width);
            sp.y    = room_height + 10;
            sp.vx   = random_range(-1.5, 1.5);
            sp.vy   = random_range(-2.5, -0.8);
            var _l  = 60 + irandom(120);
            sp.life = _l;
            sp.maxl = _l;
            sp.sz   = 2 + random(4);
        }
    }

    // ---- Leaderboard data arrival ----
    if (lb_state == "loading") {
        if (global.lb_win_state == "ready") {
            var _pidx = global.lb_win_puzzle;
            lb_scores = (is_undefined(global.lb_data[_pidx])) ? [] : global.lb_data[_pidx];
            lb_qualify = !lb_submitted
                      && scr_lb_qualifies(_pidx,
                             global.win_stars,
                             floor(global.puzzle_elapsed_ms / 1000));
            lb_state = "ready";
        } else if (global.lb_win_state == "error") {
            lb_state = "error";
        }
    }

    // ---- Leaderboard submit result ----
    if (global.lb_submit_state == "success" && !lb_submitted) {
        lb_submitted   = true;
        lb_submit_rank = global.lb_submit_rank;
        global.lb_submit_state = "idle";
        // Save name for next time
        global.player_name = lb_name_input;
        scr_save_progress();
    } else if (global.lb_submit_state == "error" && !lb_submitted) {
        lb_submitted   = true;   // stop retrying
        lb_submit_rank = 0;
        global.lb_submit_state = "idle";
    }

    // ---- Name input (when qualifying and not yet submitted) ----
    lb_name_cursor++;
    if (lb_state == "ready" && lb_qualify && !lb_submitted && lb_name_focused) {
        if (keyboard_check_pressed(vk_backspace) && string_length(lb_name_input) > 0) {
            lb_name_input = string_copy(lb_name_input, 1, string_length(lb_name_input) - 1);
            keyboard_string = "";
        }
        if (keyboard_string != "") {
            lb_name_input   = string_copy(lb_name_input + keyboard_string, 1, 20);
            keyboard_string = "";
        }
    } else {
        keyboard_string = "";
    }

    // ---- Button geometry (matches Draw_64) ----
    var _gw  = room_width;
    var _gh  = room_height;
    var _pw  = 560;
    var _ph  = 370;
    var _py  = _gh * 0.5 - _ph * 0.5 - 10;
    var _bw  = 140;
    var _bh  = 28;
    var _by  = _py + _ph - 22;
    var _cx0 = _gw * 0.5 - 78;
    var _cx1 = _gw * 0.5 + 78;
    var _mx  = mouse_x;
    var _my  = mouse_y;

    // Submit / Skip buttons (only when qualifying and data ready)
    if (lb_state == "ready" && lb_qualify && !lb_submitted) {
        var _sb_cx  = _gw * 0.5 + 218;   // matches Draw_64: _px + _pw - 62
        var _sk_cx  = _gw * 0.5 - 60;
        var _btn_y  = _py + 310;          // matches Draw_64: _entry_y + 8 = (_py+302)+8
        var _sbw    = 100;   var _sbh = 24;
        lb_submit_hover = (_mx >= _sb_cx - _sbw*0.5 && _mx <= _sb_cx + _sbw*0.5
                        && _my >= _btn_y - _sbh*0.5 && _my <= _btn_y + _sbh*0.5);
        lb_skip_hover   = (_mx >= _sk_cx - _sbw*0.5 && _mx <= _sk_cx + _sbw*0.5
                        && _my >= _btn_y - _sbh*0.5 && _my <= _btn_y + _sbh*0.5);
        if (lb_submit_hover && mouse_check_button_pressed(mb_left) && popup_alpha >= 0.8) {
            global.lb_submit_state = "pending";
            global.lb_submit_id = scr_submit_score(global.lb_win_puzzle,
                                                    global.win_stars,
                                                    floor(global.puzzle_elapsed_ms / 1000),
                                                    lb_name_input);
        }
        if (lb_skip_hover && mouse_check_button_pressed(mb_left) && popup_alpha >= 0.8) {
            lb_submitted = true;
        }
    }

    // Main NEXT / MENU buttons
    var _btn_cx = [_cx0, _cx1];
    var _bi;
    for (_bi = 0; _bi < 2; _bi++) {
        win_btn_hover[_bi] = (_mx >= _btn_cx[_bi] - _bw * 0.5 && _mx <= _btn_cx[_bi] + _bw * 0.5
                           && _my >= _by - _bh * 0.5          && _my <= _by + _bh * 0.5);
        if (win_btn_hover[_bi] && mouse_check_button_pressed(mb_left) && popup_alpha >= 0.9) {
            win_btn_press[_bi] = 8;
            if (_bi == 0) {
                // Next puzzle
                global.puzzle_index   = (global.puzzle_index + 1) mod PUZZLE_TOTAL;
                global.lb_win_state   = "idle";
                global.lb_submit_state = "idle";
                instance_destroy();
                room_restart();
            } else {
                // Main menu
                global.lb_win_state   = "idle";
                global.lb_submit_state = "idle";
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
