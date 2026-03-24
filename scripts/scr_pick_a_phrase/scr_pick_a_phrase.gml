/// @description This script picks a phrase
function scr_pick_a_phrase() {
	var i;
	var phrase = "";
	i = floor(irandom(2)+1);

	switch (i)
	{
	case 1:
	phrase = "THE QUICK BROWN FOX DONE JUMPED OVER THE LAZY DOG."
	break;

	case 2:
	phrase = "FOUR SCORE AND SEVEN YEARS AGO, OUR DANG FOREFATHERS BROUGHT FORTH UPON THIS";
	phrase += " CONTINENT A NEW NATION";
	break;

	default: 
	phrase = "Nothing";
	break;

	}
	//show_message(phrase);
	//adjust for playing field
	//assumes board width of 28 and 4 rows available
	var i = 0; 
	var j;
	modified_phrase = "";
	last_space = 0;
	last_space_on_this_row = 0;
	columns = 28;
	rows = 4;
	row_i_am_on = 1;
	row_string_starting_point = 1;
	max_characters =  columns * rows;
	remaining_spaces_to_fill = 0;
	character_on_this_row_i_am_checking = 0;
	character_position_i_am_checking = 0;
	tempstring = "";
	temprowstring = "";
	tempchar = "";
	astring =  "";
	characters_in_string = string_length(phrase);

	while (row_i_am_on < rows + 1) 
	    {
	        i++;
	        tempchar = string_char_at(phrase,i);
	        temprowstring += tempchar;
        
	        if (string_byte_at(tempchar,1) == 32) {last_space = i; }
	        //show_message(string_char_at(phrase,i-1) + " SPACE " + string_char_at(phrase,i+1) + " and last space " + string(i));
        
	        if (i / (columns * row_i_am_on) == 1)
	        {
	            //astring +=  "I've hit then end of a row at " + string(i) + " with last space being at " + string(last_space) + "[i=" + string(i) + "]#";
	            astring = string_copy(temprowstring,row_string_starting_point,last_space);
	            if (string_length(tempstring) < columns) 
	            {
	            for (j=1; j < (columns - string_length(astring)); j++)
	                {
	                    //show_message(string(columns - string_length(tempstring)));
	                    astring += "=";
	                }
	            tempstring += astring;
	            }
	            row_string_starting_point = last_space + 1;

	            row_i_am_on += 1;
	        }
	}
	//show_message(string(astring));
	show_message(tempstring);
       



        




	//character_on_this_row_i_am_checking += 1;
	//character_position_i_am_checking += 1;
	//if (string_char_at(phrase,i) == " ") 
	//    { 
	//    last_space = i;
	//    last_space_on_this_row = character_on_this_row_i_am_checking;
	//    }
	//The quick brown fox jumped o|ver the lazy dog.
	//tempstring = tempstring + "[" + string_char_at(phrase,i) + "]:" + string((i / (row_i_am_on * columns))) + " ";
	//tempstring = tempstring + "[" + string_char_at(phrase,i) + "]: ";
	        //if ((i / (row_i_am_on * columns)) == 1)
	//   if ((i / (character_position_i_am_checking) == 1))
	//    {
	//        tempstring += "##";
	//        modified_phrase += string_copy(phrase,row_string_starting_point,last_space);
	//        show_message(string_copy(phrase,row_string_starting_point,last_space));
	//        remaining_spaces_to_fill = columns - last_space_on_this_row;
	//       for (j = 0; j < remaining_spaces_to_fill ; j++) 
	//        { 
	//            modified_phrase += "-";
	//            character_position_i_am_checking -=1;
	//        }
	//        row_i_am_on += 1;
	//        character_on_this_row_i_am_checking = 0;
	//        row_string_starting_point = last_space + 1;
	        //i = last_space + 1;
	//        remaining_spaces_to_fill = 0;
	       //show_message(string(last_space) + ":" + modified_phrase);
	       // i = max_chracters + 1;
	//    }
	//}
	//show_message((tempstring));


	//show_message(phrase);
	return(modified_phrase);



}
