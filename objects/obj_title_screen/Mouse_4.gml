/// @description Left click: select a puzzle and enter the game.
if (mouse_y < list_y1 || mouse_y >= list_y2) exit;

var row_in_view = floor((mouse_y - list_y1) / row_h);
var clicked_row = row_in_view + floor(scroll_offset / row_h);

if (clicked_row >= 0 && clicked_row < total_puzzles) {
    global.puzzle_index = clicked_row;
    room_goto(rm_game);
}
