/// @description Title screen setup.
scroll_offset = 0;
hovered_row   = -1;
total_puzzles = PUZZLE_TOTAL;
row_h         = 26;
list_x1       = 80;
list_x2       = room_width - 80;
list_y1       = 110;
list_y2       = list_y1 + 10 * 26;   // exactly 10 rows visible

// Ensure puzzle globals exist
if (!variable_global_exists("puzzle_index")) { global.puzzle_index = -1; }

// Load saved star ratings and best times
scr_load_progress();

// --- Inline action buttons drawn in Draw_0, clicked in Step_0 ---
var _by = room_height - 32;
ts_btn_cx    = [650, 800];
ts_btn_cy    = [_by, _by];
ts_btn_w     = [100, 84];
ts_btn_h     = [24,  24];
ts_btn_label = ["PLAY", "HELP"];
ts_btn_short = ["[Enter]", "[F1]"];
ts_btn_hue   = [100, 210];
ts_btn_sat   = [140, 80];
ts_btn_hover = [false, false];
ts_btn_press = [0, 0];

// Scrollbar drag state
sb_dragging       = false;
sb_drag_origin_y  = 0;
sb_drag_origin_sc = 0;

// Leaderboard button (bottom-right area)
lb_btn_hover  = false;

// Ticker state
ticker_idx    = 0;     // which ticker entry is currently shown
ticker_timer  = 0;     // counts up; advances entry at TICKER_INTERVAL
ticker_alpha  = 1;     // for fade transition
#macro TICKER_INTERVAL 180   // steps between ticker advances

// Name input overlay
name_overlay   = false;    // is the name entry overlay open?
name_input     = (variable_global_exists("player_name") ? global.player_name : "");
name_input_cursor = 0;

// Ensure lb globals exist (obj_game_control may not have run yet)
if (!variable_global_exists("lb_ticker_state"))    { global.lb_ticker_state    = "idle"; }
if (!variable_global_exists("lb_ticker_fetch_id")) { global.lb_ticker_fetch_id = -1; }
if (!variable_global_exists("lb_ticker_scores"))   { global.lb_ticker_scores   = []; }
if (!variable_global_exists("lb_all_state"))       { global.lb_all_state       = "idle"; }
if (!variable_global_exists("lb_all_fetch_id"))    { global.lb_all_fetch_id    = -1; }
if (!variable_global_exists("lb_all_scores"))      { global.lb_all_scores      = []; }
if (!variable_global_exists("lb_win_state"))       { global.lb_win_state       = "idle"; }
if (!variable_global_exists("lb_win_fetch_id"))    { global.lb_win_fetch_id    = -1; }
if (!variable_global_exists("lb_win_puzzle"))      { global.lb_win_puzzle      = -1; }
if (!variable_global_exists("lb_submit_state"))    { global.lb_submit_state    = "idle"; }
if (!variable_global_exists("lb_submit_id"))       { global.lb_submit_id       = -1; }
if (!variable_global_exists("lb_submit_rank"))     { global.lb_submit_rank     = 0; }
if (!variable_global_exists("lb_data")) {
    global.lb_data = array_create(PUZZLE_TOTAL);
    var _i;
    for (_i = 0; _i < PUZZLE_TOTAL; _i++) { global.lb_data[_i] = undefined; }
}

// Kick off ticker fetch
if (global.lb_ticker_state != "ready" && global.lb_ticker_state != "loading") {
    global.lb_ticker_state    = "loading";
    global.lb_ticker_fetch_id = scr_fetch_leaderboard(-1);
}
keyboard_string = "";
