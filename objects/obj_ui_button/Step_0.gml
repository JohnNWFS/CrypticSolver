/// @description Hover detection and click handling via bounding-box check.
var hw = btn_w * 0.5;
var hh = btn_h * 0.5;

is_hovered = (mouse_x >= x - hw) && (mouse_x <= x + hw)
          && (mouse_y >= y - hh) && (mouse_y <= y + hh);

if (is_hovered && mouse_check_button_pressed(mb_left)) {
    press_frames = 8;
    action();
}

if (press_frames > 0) press_frames--;
