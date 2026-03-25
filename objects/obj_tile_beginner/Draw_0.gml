/// @description Draw tile and its letter centered on (x, y), shift up on hover.
var hover_off = is_hovered ? -4 : 0;
var draw_y    = y + hover_off;

// Draw the tile — origin is Middle Centre so (x, draw_y) is the visual centre.
draw_sprite_ext(sprite_index, image_index, x, draw_y, 1, 1, image_angle, image_blend, image_alpha);

// Decide what to draw on top of the tile.
if (is_clear_button) {
    // Draw "CLR" label centred on the tile
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(c_white);
    draw_set_alpha(image_alpha);
    draw_text(x, draw_y, "CLR");
    draw_set_valign(fa_top);
    draw_set_halign(fa_left);
    draw_set_alpha(1);
} else {
    var letter_to_draw = -1;
    if (is_bank_tile) {
        letter_to_draw = letter_index;        // A–Z label on the bank tile
    } else if (!is_guess_tile) {
        letter_to_draw = enc_display_index;   // encrypted letter on the puzzle tile
    } else if (guessed_index >= 0) {
        letter_to_draw = guessed_index;       // player's current guess on the guess tile
    }

    if (letter_to_draw >= 0) {
        if (global.font_index == 0) {
            // Hand-drawn sprite letters
            draw_sprite_ext(spr_letters, letter_to_draw, x, draw_y, 1, 1, 0, c_black, image_alpha);
        } else {
            // Font from the cycle list
            draw_set_font(global.font_list[global.font_index - 1]);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_colour(c_black);
            draw_set_alpha(image_alpha);
            draw_text(x, draw_y, chr(letter_to_draw + 65));
            draw_set_font(-1);
            draw_set_valign(fa_top);
            draw_set_halign(fa_left);
            draw_set_alpha(1);
        }
    }
}
