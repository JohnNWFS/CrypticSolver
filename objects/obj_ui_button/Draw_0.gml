/// @description Draw a polished rounded-rectangle button with shadow, hover lift and press sink.

// Vertical offset: hover lifts, press sinks
var off_y = 0;
if (is_hovered)       off_y -= 2;
if (press_frames > 0) off_y += 3;

var cx = x;
var cy = y + off_y;
var hw = btn_w * 0.5;
var hh = btn_h * 0.5;
var x1 = cx - hw;
var y1 = cy - hh;
var x2 = cx + hw;
var y2 = cy + hh;
// --- Drop shadow (suppressed while pressed) ---
if (press_frames == 0) {
    draw_set_alpha(0.22);
    draw_set_colour(c_black);
    draw_roundrect(x1 + 2, y1 + 4, x2 + 2, y2 + 4, false);
    draw_set_alpha(1);
}

// --- Button face ---
var face_v  = is_hovered ? 190 : 158;
if (press_frames > 0) face_v = 110;
draw_set_colour(make_colour_hsv(btn_hue, btn_sat, face_v));
draw_roundrect(x1, y1, x2, y2, false);

// --- Top highlight stripe (subtle gloss) ---
draw_set_alpha(0.14);
draw_set_colour(c_white);
draw_roundrect(x1 + 1, y1 + 1, x2 - 1, cy - 1, false);
draw_set_alpha(1);

// --- Border ---
draw_set_colour(make_colour_hsv(btn_hue, min(btn_sat + 70, 255), max(face_v - 55, 20)));
draw_roundrect(x1, y1, x2, y2, true);

// --- Label ---
draw_set_font(fnt_script);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_colour(c_white);
draw_set_alpha(is_hovered ? 1.0 : 0.90);
draw_text(cx, cy, label);
draw_set_alpha(1);

// --- Shortcut badge (bottom-right, small default font) ---
if (shortcut != "") {
    draw_set_font(-1);
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    draw_set_colour(make_colour_hsv(btn_hue, 60, 220));
    draw_set_alpha(0.70);
    draw_text(x2 - 3, y2 - 1, shortcut);
    draw_set_alpha(1);
}

// --- Reset draw state ---
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
