/// @description Fade in; click anywhere to dismiss.
/// Win popups return to the title screen; others just close.
popup_alpha = min(1, popup_alpha + 0.07);

if (popup_alpha >= 1 && mouse_check_button_pressed(mb_left)) {
    if (popup_type == "win") {
        instance_destroy();
        room_goto(rm_title);
    } else {
        instance_destroy();
    }
}
