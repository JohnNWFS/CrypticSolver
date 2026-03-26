/// @description Draw the instructions and about page with scrollable content.
var cx  = room_width  / 2;
var lx  = 60;
var lh  = 19;

// Scrollable content sits between the header strip and the footer strip
var header_h = 38;
var footer_h = 36;
var content_y1 = header_h;
var content_y2 = room_height - footer_h;

// ---------------------------------------------------------------
// Fixed header (not scrolled)
// ---------------------------------------------------------------
draw_set_halign(fa_center);
draw_set_colour(make_colour_hsv(40, 200, 255));
draw_text(cx, 10, "=  C R Y P T I C   S O L V E R  =");
draw_set_colour(make_colour_hsv(0, 0, 180));
draw_set_alpha(0.7);
draw_line(lx, header_h - 2, room_width - lx, header_h - 2);
draw_set_alpha(1);

// ---------------------------------------------------------------
// Scissor-clip the content area so scrolled text doesn't bleed
// into header or footer
// ---------------------------------------------------------------
draw_set_scissor(0, content_y1, room_width, content_y2);

// All content y positions are offset by -scroll_y
var oy = content_y1 + 10 - scroll_y;

// --- Column origins ---
var col_l  = lx;           // HOW TO PLAY column
var col_r  = 490;          // CONTROLS column key
var col_rd = col_r + 195;  // CONTROLS column description

// ----------- HOW TO PLAY (left) -----------
draw_set_halign(fa_left);
draw_set_colour(make_colour_hsv(40, 200, 240));
draw_text(col_l, oy, "HOW TO PLAY");
oy += lh + 2;
draw_set_colour(make_colour_hsv(0, 0, 190));
draw_set_alpha(0.6);
draw_line(col_l, oy, col_l + 200, oy);
draw_set_alpha(1);
oy += 6;

var tips = [
    "Each encrypted letter always stands",
    "for the same plain letter — use that",
    "to crack the whole puzzle at once.",
    "",
    "Select a letter from the A-Z bank,",
    "then click a puzzle tile to guess.",
    "Click the same tile again (same letter)",
    "to LOCK your answer in gold.",
    "",
    "Right-click any tile to remove all",
    "guesses for that encrypted letter.",
    "",
    "Drag a letter from the bank straight",
    "onto a puzzle tile to lock instantly.",
    "",
    "Solve all tiles correctly to win!",
];
draw_set_colour(c_white);
var ti;
for (ti = 0; ti < array_length(tips); ti++) {
    draw_text(col_l, oy, tips[ti]);
    oy += lh;
}
var left_end_y = oy;

// ----------- CONTROLS (right) -----------
var ry = content_y1 + 10 - scroll_y;
draw_set_colour(make_colour_hsv(40, 200, 240));
draw_text(col_r, ry, "CONTROLS");
ry += lh + 2;
draw_set_colour(make_colour_hsv(0, 0, 190));
draw_set_alpha(0.6);
draw_line(col_r, ry, room_width - lx, ry);
draw_set_alpha(1);
ry += 6;

var ctrl_key = [
    "Left-click bank tile",
    "Left-click puzzle tile",
    "Click same tile again",
    "Right-click puzzle tile",
    "Middle-click puzzle tile",
    "Drag from bank to puzzle",
    "A - Z keys",
    "CLR button",
    "F1",
    "F2",
    "F3",
    "Escape",
];
var ctrl_desc = [
    "Select / deselect that letter",
    "Place your selected guess (green)",
    "Lock (gold) / unlock guess",
    "Clear all guesses for that letter",
    "Lock tile and select letter in bank",
    "Drop and lock letter onto tile",
    "Quick-select that letter",
    "Clear all guesses on the board",
    "Use a hint  (reveals one letter group)",
    "New puzzle",
    "Toggle letter font style",
    "Return to main menu",
];
var ci;
for (ci = 0; ci < array_length(ctrl_key); ci++) {
    draw_set_colour(make_colour_hsv(40, 160, 220));
    draw_text(col_r, ry, ctrl_key[ci]);
    draw_set_colour(c_white);
    draw_text(col_rd, ry, ctrl_desc[ci]);
    ry += lh;
}
var right_end_y = ry;

// ---------------------------------------------------------------
// About section — below whichever column is longer
// ---------------------------------------------------------------
var ay = max(left_end_y, right_end_y) + 12;
draw_set_colour(make_colour_hsv(0, 0, 180));
draw_set_alpha(0.5);
draw_line(lx, ay, room_width - lx, ay);
draw_set_alpha(1);
ay += 8;

draw_set_colour(make_colour_hsv(40, 200, 240));
draw_set_halign(fa_left);
draw_text(lx, ay, "ABOUT");
ay += lh + 2;
draw_set_colour(c_white);
draw_text(lx, ay, "CrypticSolver — a hand-crafted substitution cipher puzzle game.");
ay += lh;
draw_text(lx, ay, "Tiles, letters and artwork hand-drawn by the developer.");
ay += lh;
draw_set_colour(make_colour_hsv(200, 120, 200));
draw_text(lx, ay, "Contact:  [your contact info here]");
ay += lh + 10;

// Store total content size so Step_0 can clamp scroll
var content_start = content_y1 + 10;
scroll_max = max(0, (ay + scroll_y) - content_start - (content_y2 - content_y1));

// ---------------------------------------------------------------
// End scissor clip
// ---------------------------------------------------------------
draw_reset_scissor();

// ---------------------------------------------------------------
// Scroll arrows (drawn outside scissor so they're always visible)
// ---------------------------------------------------------------
var ax = room_width - 30;
var arrow_col_on  = make_colour_hsv(40, 200, 255);
var arrow_col_off = make_colour_hsv(0, 0, 70);

// Up arrow
var up_col = (scroll_y > 0) ? arrow_col_on : arrow_col_off;
draw_set_colour(up_col);
draw_set_alpha((scroll_y > 0) ? 1.0 : 0.3);
draw_triangle(ax, content_y1 + 22, ax - 10, content_y1 + 36, ax + 10, content_y1 + 36, false);

// Down arrow
var down_col = (scroll_y < scroll_max) ? arrow_col_on : arrow_col_off;
draw_set_colour(down_col);
draw_set_alpha((scroll_y < scroll_max) ? 1.0 : 0.3);
draw_triangle(ax, content_y2 - 22, ax - 10, content_y2 - 36, ax + 10, content_y2 - 36, false);

// Scroll position pip
if (scroll_max > 0) {
    var track_x  = room_width - 18;
    var track_y1 = content_y1 + 50;
    var track_y2 = content_y2 - 50;
    var pip_y    = track_y1 + (scroll_y / scroll_max) * (track_y2 - track_y1);
    draw_set_colour(make_colour_hsv(40, 160, 200));
    draw_set_alpha(0.7);
    draw_circle(track_x, pip_y, 5, false);
}

// ---------------------------------------------------------------
// Fixed footer
// ---------------------------------------------------------------
draw_set_alpha(0.7);
draw_set_colour(make_colour_hsv(0, 0, 180));
draw_line(lx, content_y2 + 2, room_width - lx, content_y2 + 2);
draw_set_halign(fa_center);
draw_set_colour(make_colour_hsv(40, 180, 220));
draw_text(cx, room_height - 24, "[ Escape  or  Backspace  to return to the menu ]");

// Reset draw state
draw_reset_scissor();
draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
