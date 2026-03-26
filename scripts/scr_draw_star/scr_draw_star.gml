/// @description Draw a 5-pointed star at (cx, cy).
/// @param {real} cx        Centre x
/// @param {real} cy        Centre y
/// @param {real} r         Outer radius
/// @param {bool} filled    true = solid fill, false = outline only
/// @param {real} col       Colour (make_colour_hsv / c_* constant)
function scr_draw_star(cx, cy, r, filled, col) {
    var r_in  = r * 0.42;   // inner radius (ratio gives a classic 5-pt star)
    var pts   = 5;
    var aoff  = -90;        // start at top point

    draw_set_colour(col);

    if (filled) {
        draw_primitive_begin(pr_trianglefan);
        draw_vertex(cx, cy);   // hub
        var i;
        for (i = 0; i <= pts * 2; i++) {
            var ang = degtorad(aoff + i * (360 / (pts * 2)));
            var rad = (i mod 2 == 0) ? r : r_in;
            draw_vertex(cx + cos(ang) * rad, cy + sin(ang) * rad);
        }
        draw_primitive_end();
    } else {
        draw_primitive_begin(pr_linestrip);
        var i;
        for (i = 0; i <= pts * 2; i++) {
            var ang = degtorad(aoff + i * (360 / (pts * 2)));
            var rad = (i mod 2 == 0) ? r : r_in;
            draw_vertex(cx + cos(ang) * rad, cy + sin(ang) * rad);
        }
        draw_primitive_end();
    }
}
