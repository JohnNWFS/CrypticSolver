/// @description Title screen setup.
scroll_offset = 0;
hovered_row   = -1;
total_puzzles = PUZZLE_TOTAL;
row_h         = 26;
list_x1       = 80;
list_x2       = room_width - 80;
list_y1       = 110;
list_y2       = room_height - 66;

// Ensure puzzle globals exist
if (!variable_global_exists("puzzle_index")) { global.puzzle_index = -1; }

// Load saved star ratings and best times
scr_load_progress();

// --- Inline action buttons drawn in Draw_0, clicked in Step_0 ---
var _by = room_height - 40;
ts_btn_cx    = [room_width / 2 - 56, room_width / 2 + 56];
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

// Kick off ticker fetch
if (global.lb_ticker_state != "ready") {
    global.lb_ticker_state    = "loading";
    global.lb_ticker_fetch_id = scr_fetch_leaderboard(-1);
}
keyboard_string = "";
