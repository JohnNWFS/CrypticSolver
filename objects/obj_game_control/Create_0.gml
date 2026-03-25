/// @description Sets up the puzzle: builds cipher, lays out letter bank and encrypted board.
randomize();

// Puzzle selection: -1 = pick randomly (set by R key or first run)
if (!variable_global_exists("puzzle_index"))        { global.puzzle_index        = -1;  }
// Font cycle: 0 = hand-drawn sprites, 1+ = entry in font_list.
// Add a font asset to font_list and the F key will pick it up automatically.
global.font_list      = [fnt_script, fnt_script_1];   // ← add more fonts here
global.font_list_size = array_length(global.font_list);
if (!variable_global_exists("font_index")) { global.font_index = 0; }
global.puzzle_title      = "";
global.puzzle_difficulty = 1;
global.hints_remaining   = 3;

// --- Build cipher and both versions of the phrase ---
scr_build_cipher();
plain_phrase     = scr_pick_a_phrase();
encrypted_phrase = scr_encrypt_phrase(plain_phrase);

// Global state shared by tile interaction
global.selected_letter  = -1;   // index 0-25 of bank letter currently selected, -1 = none
global.selected_bank_id = -1;   // instance id of the highlighted bank tile
global.game_control_id  = id;

// Drag state
global.is_dragging  = false;  // mouse held on a valid tile
global.drag_active  = false;  // threshold exceeded — actually dragging
global.drag_letter  = -1;     // letter being dragged (0-25)
global.drag_press_x = 0;
global.drag_press_y = 0;

// --- Action buttons — drawn in Draw_64, clicked in Step_0 ---
// Centered horizontally between puzzle tiles and the bank row.
var _bw  = 88;  var _bh = 24;  var _bg = 8;
var _by  = room_height - 44;
var _bx0 = (room_width - (4 * _bw + 3 * _bg)) / 2 + _bw / 2;
var _bs  = _bw + _bg;

ui_btn_cx    = [_bx0, _bx0+_bs, _bx0+_bs*2, _bx0+_bs*3];
ui_btn_cy    = [_by,  _by,      _by,         _by        ];
ui_btn_w     = [_bw,  _bw,      _bw,         _bw        ];
ui_btn_h     = [_bh,  _bh,      _bh,         _bh        ];
ui_btn_label = ["H", "NEW",  "FONT",      "MENU"     ];
ui_btn_short = ["[H]",  "[R]",  "[F]",       "[Esc]"    ];
ui_btn_hue   = [195,    35,     120,         210        ];
ui_btn_sat   = [150,    120,    90,          70         ];
ui_btn_hover = [false,  false,  false,       false      ];
ui_btn_press = [0,      0,      0,           0          ];

// --- Letter bank: A-Z tiles along the bottom ---
var i;
for (i = 0; i < 26; i++) {
    bank_tile[i] = instance_create(10 + (36 * i), room_height - 48, obj_tile_beginner);
    bank_tile[i].is_bank_tile   = true;
    bank_tile[i].is_guess_tile  = false;
    bank_tile[i].letter_index   = i;
}

// Clear-all button: one tile-width to the right of Z
var cb = instance_create(10 + (36 * 26), room_height - 44, obj_tile_beginner);
cb.is_bank_tile    = false;
cb.is_guess_tile   = false;
cb.is_clear_button = true;
cb.image_blend     = make_colour_hsv(0, 180, 160);  // muted red

// --- Encrypted puzzle board ---
phrase_length = string_length(encrypted_phrase);
puzzle_row    = 1;
puzzle_column = 0;

for (i = 1; i <= phrase_length; i++) {
    var enc_char   = string_char_at(encrypted_phrase, i);
    var plain_char = string_char_at(plain_phrase, i);

    if (enc_char != " ") {
        var enc_idx   = string_byte_at(enc_char, 1) - 65;
        var plain_idx = string_byte_at(plain_char, 1) - 65;

        // Bottom tile: shows the encrypted letter
        Cryptic_Tile[i] = instance_create(10 + (36 * puzzle_column), 40 * puzzle_row + 16, obj_tile_beginner);
        Cryptic_Tile[i].image_blend       = make_colour_hsv(150 + irandom(25), 5 + irandom(25), 231 + irandom(20));
        Cryptic_Tile[i].is_bank_tile      = false;
        Cryptic_Tile[i].is_guess_tile     = false;
        Cryptic_Tile[i].enc_display_index = enc_idx;

        // Top tile: player's guess slot (starts blank and semi-transparent)
        Guess_Letter[i] = instance_create(Cryptic_Tile[i].x, Cryptic_Tile[i].y - 36, obj_tile_beginner);
        Guess_Letter[i].image_alpha   = 0.5;
        Guess_Letter[i].is_bank_tile  = false;
        Guess_Letter[i].is_guess_tile = true;
        Guess_Letter[i].enc_index     = enc_idx;    // encrypted letter shown below
        Guess_Letter[i].plain_index   = plain_idx;  // correct plain letter (the answer)
        Guess_Letter[i].guessed_index = -1;         // player's current guess, -1 = blank
    }

    puzzle_column += 1;
    if (puzzle_column == 28) {
        puzzle_row   += 2;
        puzzle_column = 0;
    }
}
