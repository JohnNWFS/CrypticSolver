/// @description Cross-platform coordinate helpers.
/// In HTML5 with external CSS scaling, display_get_gui_width/height()
/// returns the CSS viewport size (inflated), and device_mouse_x/y_to_gui()
/// likewise returns inflated values.  mouse_x/y and room_width/height always
/// reflect the game's native 1024x480 coordinate space on all platforms.
///
/// On Windows (and other desktop targets), device_mouse_x/y_to_gui() and
/// display_get_gui_width/height() return the correct GUI-space values.
///
/// These four helpers let every object use the right value without
/// scattering os_browser checks everywhere.

/// @returns {bool} true if running inside a web browser
function scr_is_html5() {
    return (os_browser != browser_not_a_browser);
}

/// @returns {real} Mouse x in GUI / UI coordinate space
function scr_ui_mouse_x() {
    return scr_is_html5() ? mouse_x : device_mouse_x_to_gui(0);
}

/// @returns {real} Mouse y in GUI / UI coordinate space
function scr_ui_mouse_y() {
    return scr_is_html5() ? mouse_y : device_mouse_y_to_gui(0);
}

/// @returns {real} UI layer width (matches where Draw_64 content is positioned)
function scr_ui_width() {
    return scr_is_html5() ? room_width : display_get_gui_width();
}

/// @returns {real} UI layer height (matches where Draw_64 content is positioned)
function scr_ui_height() {
    return scr_is_html5() ? room_height : display_get_gui_height();
}
