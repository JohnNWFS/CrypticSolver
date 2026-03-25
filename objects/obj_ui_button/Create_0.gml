/// @description UI button defaults — set these immediately after instance_create_depth().
label        = "BUTTON";   // main label text
shortcut     = "";         // key hint badge in bottom-right corner, e.g. "[H]"
btn_w        = 88;         // total width  in pixels
btn_h        = 24;         // total height in pixels
btn_hue      = 35;         // HSV hue  for the base colour
btn_sat      = 120;        // HSV saturation for the base colour
is_hovered   = false;
press_frames = 0;          // counts down after click for the press-sink animation
action       = function() {};   // override with a bound method or function
