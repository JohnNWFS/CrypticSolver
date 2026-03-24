draw_self();
image_blend = make_colour_hsv(blend_r, blend_g, blend_b);
draw_text(x-80,y-40,string_hash_to_newline(string(blend_r) + ":" + string(blend_g) + ":" +string(blend_b) + ":"));


