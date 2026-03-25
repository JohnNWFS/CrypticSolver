/// @description Draw the instructions and about page.
var cx   = room_width / 2;
var lx   = 60;   // left column x
var rx   = 540;  // right column x
var _y    = 14;
var lh   = 19;   // line height

// ---------------------------------------------------------------
// Header
// ---------------------------------------------------------------
draw_set_halign(fa_center);
draw_set_colour(make_colour_hsv(40, 200, 255));
draw_text(cx, _y, "=  C R Y P T I C   S O L V E R  =");
_y += lh + 4;

draw_set_colour(make_colour_hsv(0, 0, 180));
draw_line(lx, y, room_width - lx, y);
_y += 8;

// ---------------------------------------------------------------
// Two-column layout: HOW TO PLAY (left) | CONTROLS (right)
// ---------------------------------------------------------------
var col_top = _y;

// --- Left: How to Play ---
draw_set_halign(fa_left);
draw_set_colour(make_colour_hsv(40, 200, 240));
draw_text(lx, _y, "HOW TO PLAY");
_y += lh + 2;
draw_set_colour(make_colour_hsv(0, 0, 190));
draw_line(lx, _y, lx + 200, _y);
_y += 6;

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
    "Drag a letter straight from the bank",
    "to a puzzle tile to lock it instantly.",
    "",
    "Solve all tiles correctly to win!",
];
draw_set_colour(c_white);
var ti;
for (ti = 0; ti < array_length(tips); ti++) {
    draw_text(lx, _y, tips[ti]);
    _y += lh;
}

// --- Right: Controls ---
var ry = col_top;
draw_set_colour(make_colour_hsv(40, 200, 240));
draw_text(rx, ry, "CONTROLS");
ry += lh + 2;
draw_set_colour(make_colour_hsv(0, 0, 190));
draw_line(rx, ry, rx + 400, ry);
ry += 6;

var ctrl_key = [
    "Left-click bank tile",
    "Left-click puzzle tile",
    "Click same tile again",
    "Right-click puzzle tile",
    "Middle-click puzzle tile",
    "Drag from bank to puzzle",
    "A - Z keys",
    "Escape",
    "R key",
    "CLR button",
    "H key (title screen)",
    "F key (anywhere)",
];
var ctrl_desc = [
    "Select / deselect that letter",
    "Place your selected guess",
    "Lock (gold) / unlock guess",
    "Clear all guesses for that letter",
    "Lock tile and select letter in bank",
    "Drop letter locked onto tile",
    "Select that letter from keyboard",
    "Deselect current letter",
    "New random puzzle",
    "Clear all guesses on the board",
    "Show this help screen",
    "Toggle hand-drawn / script font letters",
];
var ci;
for (ci = 0; ci < array_length(ctrl_key); ci++) {
    draw_set_colour(make_colour_hsv(40, 160, 220));
    draw_text(rx, ry, ctrl_key[ci]);
    draw_set_colour(c_white);
    draw_text(rx + 210, ry, ctrl_desc[ci]);
    ry += lh;
}

// ---------------------------------------------------------------
// About section
// ---------------------------------------------------------------
var ay = max(_y, ry) + 10;
draw_set_colour(make_colour_hsv(0, 0, 180));
draw_line(lx, ay, room_width - lx, ay);
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

// ---------------------------------------------------------------
// Footer — Back button
// ---------------------------------------------------------------
draw_set_colour(make_colour_hsv(0, 0, 180));
draw_line(lx, room_height - 34, room_width - lx, room_height - 34);

draw_set_halign(fa_center);
draw_set_colour(make_colour_hsv(40, 180, 220));
draw_text(cx, room_height - 26, "[ Escape  or  Backspace  or  click here  to return to the menu ]");

// Reset draw state
draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
