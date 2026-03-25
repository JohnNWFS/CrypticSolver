/// @description Creates (or replaces) the on-screen popup notification.
/// @param {string} message   Text to display. Use \n for line breaks.
/// @param {string} type      "info" | "error" | "win"
function scr_show_popup(message, type) {
    // Destroy any existing popup so only one shows at a time
    with (obj_popup) { instance_destroy(); }

    var p = instance_create_depth(0, 0, -9999, obj_popup);
    p.popup_message = message;
    p.popup_type    = type;
}
