/// @description Draw popup centred on screen using the GUI layer.
var gui_w    = display_get_gui_width();
var gui_h    = display_get_gui_height();
var padding  = 24;
var max_tw   = 420;
var line_sep = -1;

// Measure text
var tw = string_width_ext(popup_message, line_sep, max_tw);
var th = string_height_ext(popup_message, line_sep, max_tw);

var box_w = tw + padding * 2;
var box_h = th + padding * 2 + 22;
var box_x = (gui_w - box_w) * 0.5;
var box_y = (gui_h - box_h) * 0.5;

// Style by type
var col_bg, col_border;
if (popup_type == "win") {
    col_bg     = make_colour_hsv(40,  160,  55);
    col_border = make_colour_hsv(40,  220, 255);
} else if (popup_type == "error") {
    col_bg     = make_colour_hsv(0,   160,  45);
    col_border = make_colour_hsv(0,   200, 230);
} else {
    col_bg     = make_colour_hsv(200,  60,  40);
    col_border = make_colour_hsv(120, 100, 180);
}

// Drop shadow
draw_set_colour(c_black);
draw_set_alpha(popup_alpha * 0.45);
draw_roundrect(box_x + 5, box_y + 5, box_x + box_w + 5, box_y + box_h + 5, false);

// Background fill
draw_set_colour(col_bg);
draw_set_alpha(popup_alpha * 0.93);
draw_roundrect(box_x, box_y, box_x + box_w, box_y + box_h, false);

// Border outline
draw_set_colour(col_border);
draw_set_alpha(popup_alpha);
draw_roundrect(box_x, box_y, box_x + box_w, box_y + box_h, true);

// Message text
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_colour(c_white);
draw_set_alpha(popup_alpha);
draw_text_ext(box_x + box_w * 0.5, box_y + padding, popup_message, line_sep, max_tw);

// Dismiss hint
draw_set_alpha(popup_alpha * 0.55);
draw_set_colour(c_ltgray);
draw_text_ext(box_x + box_w * 0.5, box_y + box_h - 18, "click anywhere to dismiss", line_sep, max_tw);

// Reset draw state
draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
