/// @description Popup notification. Set popup_message and popup_type after creation.
popup_message = "";
popup_type    = "info";   // "info" | "error" | "win"
popup_alpha   = 0;
popup_timer   = 0;

// Win-screen: sparkles and inline buttons
var _gw = scr_ui_width();
var _gh = scr_ui_height();
var s;
win_sparkles = array_create(40);
for (s = 0; s < 40; s++) {
    var _life = 60 + irandom(120);
    win_sparkles[s] = {
        x    : irandom(_gw),
        y    : irandom(_gh),
        vx   : random_range(-1.5, 1.5),
        vy   : random_range(-2.5, -0.8),
        life : _life,
        maxl : _life,
        hue  : choose(40, 48, 55, 195, 120),
        sz   : 2 + random(4),
    };
}

win_btn_hover = [false, false];
win_btn_press = [0, 0];

// Leaderboard section state
lb_state        = "loading";   // "loading"|"ready"|"error"
lb_scores       = [];          // top-10 score structs for current puzzle
lb_qualify      = false;       // player's score beats the top 10
lb_submitted    = false;       // true after a successful submit
lb_submit_rank  = 0;           // rank returned by server after submit
lb_name_input   = (variable_global_exists("player_name") ? global.player_name : "");
lb_name_focused = true;        // name field auto-focused when qualify
lb_name_cursor  = 0;           // timer for blinking cursor
lb_submit_hover  = false;
lb_skip_hover    = false;
lb_name_dialog_id = -1;   // tracks get_string_async() request on HTML5

// Kick off the leaderboard fetch
if (variable_global_exists("puzzle_index") && global.puzzle_index >= 0) {
    global.lb_win_puzzle   = global.puzzle_index;
    global.lb_win_state    = "loading";
    global.lb_win_fetch_id = scr_fetch_leaderboard(global.puzzle_index);
    keyboard_string = "";      // clear so name input starts fresh
}
