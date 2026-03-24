/// @description testing tool to see font layed out on tiles
randomize();
the_phrase = "";
the_phrase = scr_pick_a_phrase();

var i;
//the code that draws available letters on the board.
//Additional code will shade or mark out the used letters
for (i=0; i < 26; i++)
{
guess_letters = instance_create(10+(36*i),room_height - 36,obj_tile_beginner);
my_letter = instance_create(guess_letters.x+6,guess_letters.y+6,obj_letters);
my_letter.image_speed = 0;
my_letter.image_index = i; 
}

//temporary test of punctuation
//instance_create(10,room_height - 72,obj_tile_beginner);
//my_letter = instance_create(10+6,room_height -72 +6 ,obj_letters);
//my_letter.image_speed = 0;
//my_letter.image_index = 29;

 
//temporary holding place for this phrase to test with
//multiple lines only for ease of GM:S editing window size
//the_phrase =  "THE QUICK BROWN FOX JUMPED OVER THE LAZY DOG. THE ";
//the_phrase += "QUICK BROWN FOX JUMPED OVER THE LAZY DOG."; 


//The code to draw the current Cryptic
phrase_length = string_length(the_phrase);
puzzle_row = 1;
puzzle_column = 0;
for (i=1; i < phrase_length+1; i++)
{
this_character = string_char_at(the_phrase,i);
if this_character != " " 
{
//
Cryptic_Tile[i] = instance_create(10+(36*puzzle_column),40 * puzzle_row,obj_tile_beginner);
with (Cryptic_Tile[i]) {image_blend = make_colour_hsv(150 + irandom(25),5 + irandom(25),231+irandom(20));} //subtle differences to tiles 
//
this_character_ascii = string_byte_at(this_character,1)
Cryptic_Phrase[i] = instance_create(Cryptic_Tile[i].x+6,Cryptic_Tile[i].y+6,obj_letters);
Cryptic_Phrase[i].image_speed = 0;
Cryptic_Phrase[i].image_index = this_character_ascii - 65;

//
Guess_Letter[i] = instance_create(Cryptic_Tile[i].x,Cryptic_Tile[i].y - 36,obj_tile_beginner);
with (Guess_Letter[i]) {image_alpha = .5;}
}
puzzle_column +=1;
if (puzzle_column == 28) 
{
puzzle_row += 2;
puzzle_column = 0;}
}



