/// @description Title screen setup.
scroll_offset = 0;
hovered_row   = -1;
total_puzzles = 30;
row_h         = 26;
list_y1       = 110;
list_y2       = room_height - 66;

// Ensure puzzle globals exist
if (!variable_global_exists("puzzle_index")) { global.puzzle_index = -1; }

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
