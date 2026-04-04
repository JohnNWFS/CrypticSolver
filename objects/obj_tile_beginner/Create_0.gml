/// @description Initialise tile variables. Game control overrides these after creation.
is_bank_tile      = false;
is_guess_tile     = false;
is_clear_button   = false;
letter_index      = -1;    // bank tiles: which letter (0=A..25=Z)
enc_index         = -1;    // guess tiles: which encrypted letter is below
enc_display_index = -1;    // encrypted puzzle tiles: letter frame to display
plain_index       = -1;    // guess tiles: correct plain letter answer
guessed_index     = -1;    // guess tiles: player's current guess (-1 = blank)
is_locked         = false; // guess tiles: player has locked in this guess
is_hinted         = false; // guess tiles: revealed by hint — cannot be changed or cleared

// Visual variety & hover
image_angle = choose(0, 90, 180, 270);
is_hovered  = false;

// Long-press clear (mobile — no right click)
#macro LP_FRAMES 45   // ~0.75s at 60fps
lp_timer = 0;
lp_fired = false;
