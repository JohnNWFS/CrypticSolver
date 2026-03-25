/// @description Escape or click Back returns to the title screen.
if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace)) {
    room_goto(rm_title);
}

// Clicking anywhere in the footer "Back" area also works
if (mouse_check_button_pressed(mb_left) && mouse_y > room_height - 36) {
    room_goto(rm_title);
}
