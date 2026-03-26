/// @description Leaderboard screen setup — fetch all-puzzle overview on enter.
scroll_offset = 0;
row_h         = 22;
list_x1       = 60;
list_x2       = room_width - 60;
list_y1       = 80;
list_y2       = room_height - 100;

// Detail panel: shows top 10 for a clicked puzzle
detail_puzzle  = -1;   // -1 = no puzzle selected
detail_scores  = [];
detail_fetch_id = -1;
detail_state   = "idle";   // "idle"|"loading"|"ready"|"error"

// Scrollbar drag
sb_dragging       = false;
sb_drag_origin_y  = 0;
sb_drag_origin_sc = 0;

// Kick off the overview fetch (top-1 per puzzle)
global.lb_all_state    = "loading";
global.lb_all_fetch_id = scr_fetch_leaderboard(-2);
