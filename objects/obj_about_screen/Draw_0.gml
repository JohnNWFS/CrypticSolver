/// @description Draw the instructions and about page with scrollable content.
var cx  = room_width  / 2;
var lx  = 60;
var lh  = 19;

var header_h   = 38;
var footer_h   = 36;
var content_y1 = header_h;
var content_y2 = room_height - footer_h;

// ---------------------------------------------------------------
// SCROLLABLE CONTENT  (drawn first — may bleed into header/footer,
// those bands are painted over afterwards)
// ---------------------------------------------------------------
var col_l  = lx;
var col_r  = 450;
var col_rd = col_r + 224;

// All content offset by scroll
var oy = content_y1 + 10 - scroll_y;

// --- HOW TO PLAY (left column) ---
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
    "Use F1 for a hint when stuck.",
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

// --- CONTROLS (right column) ---
var ry = content_y1 + 10 - scroll_y;
draw_set_colour(make_colour_hsv(40, 200, 240));
draw_text(col_r, ry, "CONTROLS");
ry += lh + 2;
draw_set_colour(make_colour_hsv(0, 0, 190));
draw_set_alpha(0.6);
draw_line(col_r, ry, room_width - lx - 24, ry);
draw_set_alpha(1);
ry += 6;

var ctrl_key = [
    "Left-click bank tile",
    "Left-click puzzle tile",
    "Click same tile again",
    "Right-click puzzle tile",
    "Middle-click puzzle tile",
    "Drag bank → puzzle tile",
    "A – Z keys",
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

// --- ABOUT section ---
var ay = max(left_end_y, right_end_y) + 12;
draw_set_colour(make_colour_hsv(0, 0, 180));
draw_set_alpha(0.5);
draw_line(lx, ay, room_width - lx - 24, ay);
draw_set_alpha(1);
ay += 8;

draw_set_colour(make_colour_hsv(40, 200, 240));
draw_set_halign(fa_left);
draw_text(lx, ay, "ABOUT");
ay += lh + 2;
draw_set_colour(c_white);
draw_text(lx, ay, "CrypticSolver is a hand-crafted substitution cipher puzzle game.");
ay += lh;
draw_text(lx, ay, "All tiles and the main letter font were hand-drawn by the developer.");
ay += lh;
draw_text(lx, ay, "The baseline game engine was hand-coded from scratch, then refined");
ay += lh;
draw_text(lx, ay, "with assistance from Claude Code, Claude, Codex, and ChatGPT.");
ay += lh + 4;
draw_set_colour(make_colour_hsv(40, 160, 220));
draw_text(lx, ay, "Dedicated to Bates L. Lowry III — beloved father, forever remembered.");
ay += lh + 4;
draw_set_colour(make_colour_hsv(200, 120, 200));
draw_text(lx, ay, "Contact:  JohnNWFSDeveloper@gmail.com");
ay += lh + 16;

// Store scroll_max for Step_0
scroll_max = max(0, (ay + scroll_y) - (content_y1 + 10) - (content_y2 - content_y1));

// ---------------------------------------------------------------
// PAINT OVER header and footer bands with the felt background
// so scrolled text doesn't bleed through
// ---------------------------------------------------------------
draw_set_colour(c_white);
draw_set_alpha(1);
draw_sprite_stretched(bgrnd_felt, 0, 0, 0,            room_width, header_h + 2);
draw_sprite_stretched(bgrnd_felt, 0, 0, content_y2 - 2, room_width, footer_h + 4);

// ---------------------------------------------------------------
// HEADER  (drawn on top of the painted band)
// ---------------------------------------------------------------
draw_set_halign(fa_center);
draw_set_colour(make_colour_hsv(40, 200, 255));
draw_text(cx, 10, "=  C R Y P T I C   S O L V E R  =");
draw_set_colour(make_colour_hsv(0, 0, 180));
draw_set_alpha(0.7);
draw_line(lx, header_h - 2, room_width - lx, header_h - 2);
draw_set_alpha(1);

// ---------------------------------------------------------------
// FOOTER  (drawn on top of the painted band)
// ---------------------------------------------------------------
draw_set_alpha(0.7);
draw_set_colour(make_colour_hsv(0, 0, 180));
draw_line(lx, content_y2 + 2, room_width - lx, content_y2 + 2);
draw_set_halign(fa_center);
draw_set_colour(make_colour_hsv(40, 180, 220));
draw_set_alpha(1);
var _back_label = scr_is_html5()
    ? "[ Tap here  /  Escape  /  Backspace  to return ]"
    : "[ Escape  or  Backspace  to return to the menu ]";
draw_text(cx, room_height - 24, _back_label);

// ---------------------------------------------------------------
// SCROLL ARROWS  (always on top)
// ---------------------------------------------------------------
var ax = room_width - 22;

draw_set_alpha((scroll_y > 0) ? 1.0 : 0.25);
draw_set_colour((scroll_y > 0) ? make_colour_hsv(40, 200, 255) : make_colour_hsv(0, 0, 80));
draw_triangle(ax, content_y1 + 18, ax - 10, content_y1 + 34, ax + 10, content_y1 + 34, false);

draw_set_alpha((scroll_y < scroll_max) ? 1.0 : 0.25);
draw_set_colour((scroll_y < scroll_max) ? make_colour_hsv(40, 200, 255) : make_colour_hsv(0, 0, 80));
draw_triangle(ax, content_y2 - 18, ax - 10, content_y2 - 34, ax + 10, content_y2 - 34, false);

// Scroll pip
if (scroll_max > 0) {
    var pip_y = (content_y1 + 52) + (scroll_y / scroll_max) * ((content_y2 - 52) - (content_y1 + 52));
    draw_set_colour(make_colour_hsv(40, 160, 200));
    draw_set_alpha(0.8);
    draw_circle(ax, pip_y, 5, false);
}

// Reset draw state
draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
