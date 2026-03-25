/// @description Popup notification. Set popup_message and popup_type after creation.
popup_message = "";
popup_type    = "info";   // "info" | "error" | "win"
popup_alpha   = 0;
popup_timer   = 0;

// Win-screen: sparkles and inline buttons
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var s;
win_sparkles = array_create(40);
for (s = 0; s < 40; s++) {
    var _life = 60 + irandom(120);
    win_sparkles[s] = {
        x    : irandom(_gw),
        y    : irandom(_gh),
        vx   : random_range(-1.5, 1.5),
        vy   : random_range(-2.5, -0.8),
        life : _life,
        maxl : _life,
        hue  : choose(40, 48, 55, 195, 120),
        sz   : 2 + random(4),
    };
}

win_btn_hover = [false, false];
win_btn_press = [0, 0];
