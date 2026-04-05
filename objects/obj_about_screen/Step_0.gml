/// @description Handle scrolling and navigation for the about screen.

// --- Keyboard navigation ---
if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace)) {
    room_goto(rm_title);
}
if (keyboard_check_pressed(vk_up)   || keyboard_check_pressed(vk_pageup))   { scroll_y -= scroll_speed * 3; }
if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(vk_pagedown)) { scroll_y += scroll_speed * 3; }

// --- Mouse wheel ---
if (mouse_wheel_up())   { scroll_y -= scroll_speed; }
if (mouse_wheel_down()) { scroll_y += scroll_speed; }

// --- Click on arrows ---
var ax      = room_width - 30;
var footer_h = 36;
var header_h = 38;
var content_y1 = header_h;
var content_y2 = room_height - footer_h;

if (mouse_check_button_pressed(mb_left)) {
    // Up arrow hitbox
    if (point_in_circle(mouse_x, mouse_y, ax, content_y1 + 29, 16)) {
        scroll_y -= scroll_speed * 3;
    }
    // Down arrow hitbox
    if (point_in_circle(mouse_x, mouse_y, ax, content_y2 - 29, 16)) {
        scroll_y += scroll_speed * 3;
    }
    // Footer "Escape or Backspace to return" — tap anywhere in the footer band
    if (mouse_y >= content_y2) {
        room_goto(rm_title);
    }
}

// Clamp
scroll_y = clamp(scroll_y, 0, max(0, scroll_max));
