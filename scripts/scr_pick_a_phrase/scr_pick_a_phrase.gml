/// @description Picks a phrase from the pack and word-wraps it to a 28-column x 5-row grid.
/// Uses global.puzzle_index (-1 = pick randomly and store the result).
/// Returns a string of exactly (columns * rows) characters, space-padded.
function scr_pick_a_phrase() {
	var columns = 28;
	var rows    = 5;

	// ---------------------------------------------------------------
	// Phrase pack — easy (1-10) → medium (11-20) → hard (21-30)
	// All phrases must fit within columns * rows = 140 characters.
	// ---------------------------------------------------------------
	var pack = [
		// --- Easy ---
		"AAAAAA",//"BETTER LATE THAN NEVER",
		"FORTUNE FAVOURS THE BRAVE",
		"LAUGHTER IS THE BEST MEDICINE",
		"ACTIONS SPEAK LOUDER THAN WORDS",
		"THE EARLY BIRD CATCHES THE WORM",
		"EVERY CLOUD HAS A SILVER LINING",
		"TIME FLIES WHEN YOU ARE HAVING FUN",
		"WHERE THERE IS A WILL THERE IS A WAY",
		"THE QUICK BROWN FOX JUMPED OVER THE LAZY DOG",
		"ALL THAT GLITTERS IS NOT GOLD",
		// --- Medium ---
		"TO BE OR NOT TO BE THAT IS THE QUESTION",
		"ASK NOT WHAT YOUR COUNTRY CAN DO FOR YOU",
		"WITH GREAT POWER COMES GREAT RESPONSIBILITY",
		"ELEMENTARY MY DEAR WATSON THE GAME IS AFOOT",
		"THAT WHICH DOES NOT KILL US MAKES US STRONGER",
		"THE ONLY THING WE HAVE TO FEAR IS FEAR ITSELF",
		"IT WAS THE BEST OF TIMES IT WAS THE WORST OF TIMES",
		"IN THE BEGINNING GOD CREATED THE HEAVENS AND THE EARTH",
		"A JOURNEY OF A THOUSAND MILES BEGINS WITH A SINGLE STEP",
		"YOU MISS ONE HUNDRED PERCENT OF THE SHOTS YOU DO NOT TAKE",
		// --- Hard ---
		"FOUR SCORE AND SEVEN YEARS AGO OUR FOREFATHERS BROUGHT FORTH UPON THIS CONTINENT A NEW NATION",
		"IN THE BEGINNING WAS THE WORD AND THE WORD WAS WITH GOD AND THE WORD WAS GOD",
		"THE GREATEST GLORY IN LIVING LIES NOT IN NEVER FALLING BUT IN RISING EVERY TIME WE FALL",
		"IT WAS A DARK AND STORMY NIGHT AND THE RAIN FELL IN TORRENTS EXCEPT AT OCCASIONAL INTERVALS",
		"WE THE PEOPLE OF THE UNITED STATES IN ORDER TO FORM A MORE PERFECT UNION ESTABLISH JUSTICE",
		"WHATEVER YOU ARE BE A GOOD ONE FOR THE WORLD DOES NOT NEED ANY MORE MEDIOCRITY OR HALF MEASURES",
		"TWO ROADS DIVERGED IN A WOOD AND I TOOK THE ONE LESS TRAVELED BY AND THAT HAS MADE ALL THE DIFFERENCE",
		"I HAVE A DREAM THAT ONE DAY THIS NATION WILL RISE UP AND LIVE OUT THE TRUE MEANING OF ITS CREED",
		"IT IS NOT THE STRONGEST OF THE SPECIES THAT SURVIVES NOR THE MOST INTELLIGENT BUT THE MOST ADAPTABLE",
		"TO INFINITY AND BEYOND THE FINAL FRONTIER WHERE NO MAN HAS GONE BEFORE AND NONE SHALL EVER RETURN",
	];

	var phrase_count = array_length(pack);

	// Resolve which puzzle to use
	if (global.puzzle_index < 0 || global.puzzle_index >= phrase_count) {
		global.puzzle_index = irandom(phrase_count - 1);
	}
	global.puzzle_title = "Puzzle #" + string(global.puzzle_index + 1);
	if      (global.puzzle_index < 10) { global.puzzle_difficulty = 1; }
	else if (global.puzzle_index < 20) { global.puzzle_difficulty = 2; }
	else                               { global.puzzle_difficulty = 3; }

	var phrase = pack[global.puzzle_index];

	// --- Split phrase into words ---
	var words      = [];
	var word_count = 0;
	var cur_word   = "";
	var ph_len     = string_length(phrase);
	var i;
	for (i = 1; i <= ph_len; i++) {
		var ch = string_char_at(phrase, i);
		if (ch == " ") {
			if (string_length(cur_word) > 0) {
				words[word_count++] = cur_word;
				cur_word = "";
			}
		} else {
			cur_word += ch;
		}
	}
	if (string_length(cur_word) > 0) {
		words[word_count++] = cur_word;
	}

	// --- Pack words into rows, padding each to exactly `columns` chars ---
	var result  = "";
	var row_str = "";
	var w       = 0;
	var row_num = 0;

	while (row_num < rows) {
		if (w >= word_count) {
			while (string_length(row_str) < columns) { row_str += " "; }
			result += row_str;
			row_str = "";
			row_num++;
			continue;
		}

		var word     = words[w];
		var word_len = string_length(word);
		var row_len  = string_length(row_str);

		if (row_len == 0) {
			row_str = string_copy(word, 1, columns);
			w++;
		} else if (row_len + 1 + word_len <= columns) {
			row_str += " " + word;
			w++;
		} else {
			while (string_length(row_str) < columns) { row_str += " "; }
			result += row_str;
			row_str = "";
			row_num++;
		}
	}

	return result;
}
