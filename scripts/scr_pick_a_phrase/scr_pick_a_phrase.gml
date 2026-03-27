/// @description Picks a phrase from the pack and word-wraps it to a 28-column x 5-row grid.
/// Uses global.puzzle_index (-1 = pick randomly and store the result).
/// Returns a string of exactly (columns * rows) characters, space-padded.

#macro PUZZLE_TOTAL 90   // update this + the arrays below when adding more puzzles

function scr_pick_a_phrase() {
	var columns = 28;
	var rows    = 5;

	// ---------------------------------------------------------------
	// Phrase pack
	//   Easy   :  0 – 29  (short, common words)
	//   Medium : 30 – 59  (moderate length, familiar quotes)
	//   Hard   : 60 – 89  (long, complex phrasing)
	// All phrases must fit within columns * rows = 140 characters.
	// ---------------------------------------------------------------
	var pack = [
		// ===================== EASY (0-29) =====================
		"KEEP CALM AND CARRY ON",                                           // 0
		"FORTUNE FAVOURS THE BRAVE",                                        // 1
		"LAUGHTER IS THE BEST MEDICINE",                                    // 2
		"ACTIONS SPEAK LOUDER THAN WORDS",                                  // 3
		"THE EARLY BIRD CATCHES THE WORM",                                  // 4
		"EVERY CLOUD HAS A SILVER LINING",                                  // 5
		"TIME FLIES WHEN YOU ARE HAVING FUN",                               // 6
		"WHERE THERE IS A WILL THERE IS A WAY",                             // 7
		"THE QUICK BROWN FOX JUMPED OVER THE LAZY DOG",                     // 8
		"ALL THAT GLITTERS IS NOT GOLD",                                    // 9
		"PRACTICE MAKES PERFECT",                                           // 10
		"HONESTY IS THE BEST POLICY",                                       // 11
		"LOOK BEFORE YOU LEAP",                                             // 12
		"TWO HEADS ARE BETTER THAN ONE",                                    // 13
		"KNOWLEDGE IS POWER",                                               // 14
		"BETTER LATE THAN NEVER",                                           // 15
		"SLOW AND STEADY WINS THE RACE",                                    // 16
		"CURIOSITY KILLED THE CAT",                                         // 17
		"THE PEN IS MIGHTIER THAN THE SWORD",                               // 18
		"BIRDS OF A FEATHER FLOCK TOGETHER",                                // 19
		"ABSENCE MAKES THE HEART GROW FONDER",                              // 20
		"WHEN LIFE GIVES YOU LEMONS MAKE LEMONADE",                         // 21
		"A PENNY SAVED IS A PENNY EARNED",                                  // 22
		"EVERY DOG HAS ITS DAY",                                            // 23
		"THE GRASS IS GREENER ON THE OTHER SIDE",                           // 24
		"STRIKE WHILE THE IRON IS HOT",                                     // 25
		"A STITCH IN TIME SAVES NINE",                                      // 26
		"DO NOT COUNT YOUR CHICKENS BEFORE THEY HATCH",                     // 27
		"IF AT FIRST YOU DO NOT SUCCEED TRY TRY AGAIN",                     // 28
		"GREAT MINDS THINK ALIKE",                                          // 29

		// ===================== MEDIUM (30-59) =====================
		"TO BE OR NOT TO BE THAT IS THE QUESTION",                          // 30
		"ASK NOT WHAT YOUR COUNTRY CAN DO FOR YOU",                         // 31
		"WITH GREAT POWER COMES GREAT RESPONSIBILITY",                      // 32
		"ELEMENTARY MY DEAR WATSON THE GAME IS AFOOT",                      // 33
		"THAT WHICH DOES NOT KILL US MAKES US STRONGER",                    // 34
		"THE ONLY THING WE HAVE TO FEAR IS FEAR ITSELF",                    // 35
		"IT WAS THE BEST OF TIMES IT WAS THE WORST OF TIMES",               // 36
		"IN THE BEGINNING GOD CREATED THE HEAVENS AND THE EARTH",           // 37
		"A JOURNEY OF A THOUSAND MILES BEGINS WITH A SINGLE STEP",          // 38
		"YOU MISS ONE HUNDRED PERCENT OF THE SHOTS YOU DO NOT TAKE",        // 39
		"IMAGINATION IS MORE IMPORTANT THAN KNOWLEDGE",                     // 40
		"IN THE MIDDLE OF DIFFICULTY LIES OPPORTUNITY",                     // 41
		"LIFE IS WHAT HAPPENS WHEN YOU ARE BUSY MAKING OTHER PLANS",        // 42
		"IT ALWAYS SEEMS IMPOSSIBLE UNTIL IT IS DONE",                      // 43
		"NOT ALL THOSE WHO WANDER ARE LOST",                                // 44
		"BE YOURSELF EVERYONE ELSE IS ALREADY TAKEN",                       // 45
		"YOU CAN FOOL SOME OF THE PEOPLE ALL OF THE TIME",                  // 46
		"SUCCESS IS NOT FINAL AND FAILURE IS NOT FATAL",                    // 47
		"THE ONLY WAY TO DO GREAT WORK IS TO LOVE WHAT YOU DO",             // 48
		"IN THE END IT IS NOT THE YEARS IN YOUR LIFE THAT COUNT",           // 49
		"WELL BEHAVED WOMEN SELDOM MAKE HISTORY",                           // 50
		"THE WOODS ARE LOVELY DARK AND DEEP BUT I HAVE PROMISES TO KEEP",   // 51
		"EVERY ACCOMPLISHMENT STARTS WITH THE DECISION TO TRY",             // 52
		"WHEN THE GOING GETS TOUGH THE TOUGH GET GOING",                    // 53
		"WE ARE ALL IN THE GUTTER BUT SOME OF US ARE LOOKING AT THE STARS", // 54
		"THERE IS NOTHING EITHER GOOD OR BAD BUT THINKING MAKES IT SO",     // 55
		"CHOOSE A JOB YOU LOVE AND YOU WILL NEVER WORK A DAY IN YOUR LIFE", // 56
		"THE DIFFERENCE BETWEEN GENIUS AND STUPIDITY IS GENIUS HAS ITS LIMITS", // 57
		"THE BEST WAY TO PREDICT THE FUTURE IS TO CREATE IT YOURSELF",      // 58
		"TO THE WELL ORGANISED MIND DEATH IS BUT THE NEXT GREAT ADVENTURE", // 59

		// ===================== HARD (60-89) =====================
		"FOUR SCORE AND SEVEN YEARS AGO OUR FOREFATHERS BROUGHT FORTH UPON THIS CONTINENT A NEW NATION",            // 60
		"IN THE BEGINNING WAS THE WORD AND THE WORD WAS WITH GOD AND THE WORD WAS GOD",                            // 61
		"THE GREATEST GLORY IN LIVING LIES NOT IN NEVER FALLING BUT IN RISING EVERY TIME WE FALL",                 // 62
		"IT WAS A DARK AND STORMY NIGHT AND THE RAIN FELL IN TORRENTS EXCEPT AT OCCASIONAL INTERVALS",             // 63
		"WE THE PEOPLE OF THE UNITED STATES IN ORDER TO FORM A MORE PERFECT UNION ESTABLISH JUSTICE",              // 64
		"WHATEVER YOU ARE BE A GOOD ONE FOR THE WORLD DOES NOT NEED ANY MORE MEDIOCRITY OR HALF MEASURES",         // 65
		"TWO ROADS DIVERGED IN A WOOD AND I TOOK THE ONE LESS TRAVELED BY AND THAT HAS MADE ALL THE DIFFERENCE",   // 66
		"I HAVE A DREAM THAT ONE DAY THIS NATION WILL RISE UP AND LIVE OUT THE TRUE MEANING OF ITS CREED",         // 67
		"IT IS NOT THE STRONGEST OF THE SPECIES THAT SURVIVES NOR THE MOST INTELLIGENT BUT THE MOST ADAPTABLE",    // 68
		"TO INFINITY AND BEYOND THE FINAL FRONTIER WHERE NO MAN HAS GONE BEFORE AND NONE SHALL EVER RETURN",       // 69
		"THE ONLY THING NECESSARY FOR THE TRIUMPH OF EVIL IS FOR GOOD MEN TO DO NOTHING AT ALL",                   // 70
		"WE SHALL FIGHT ON THE BEACHES WE SHALL FIGHT ON THE LANDING GROUNDS WE SHALL NEVER SURRENDER",            // 71
		"WHETHER YOU THINK YOU CAN OR WHETHER YOU THINK YOU CANNOT YOU ARE ABSOLUTELY RIGHT EITHER WAY",           // 72
		"HAPPINESS IS NOT SOMETHING READY MADE IT COMES FROM YOUR OWN ACTIONS AND CHOICES EACH DAY",               // 73
		"IN THREE WORDS I CAN SUM UP EVERYTHING I HAVE LEARNED ABOUT LIFE AND THAT IS IT GOES ON",                 // 74
		"LIFE IS TEN PERCENT WHAT HAPPENS TO YOU AND NINETY PERCENT HOW YOU RESPOND TO IT IN THE END",             // 75
		"NOT ALL THOSE WHO WANDER ARE LOST AND NOT ALL THOSE WHO ARE LOST WANDER WITHOUT PURPOSE OR PLAN",         // 76
		"EDUCATION IS THE MOST POWERFUL WEAPON WHICH YOU CAN USE TO CHANGE THE WORLD FOR THE BETTER",             // 77
		"THE MAN WHO DOES NOT READ HAS NO ADVANTAGE OVER THE MAN WHO CANNOT READ AT ALL IN ANY WAY",              // 78
		"FIRST THEY IGNORE YOU THEN THEY LAUGH AT YOU THEN THEY FIGHT YOU AND THEN YOU WIN IN THE END",            // 79
		"PEOPLE WILL FORGET WHAT YOU SAID AND WHAT YOU DID BUT NEVER HOW YOU MADE THEM FEEL EACH DAY",            // 80
		"IF YOU WANT TO KNOW WHAT A MAN IS LIKE TAKE A LOOK AT HOW HE TREATS HIS INFERIORS NOT EQUALS",           // 81
		"IT DOES NOT MATTER HOW SLOWLY YOU GO AS LONG AS YOU DO NOT STOP MOVING TOWARD YOUR GOAL EVER",           // 82
		"THE FUTURE BELONGS TO THOSE WHO BELIEVE IN THE BEAUTY OF THEIR DREAMS AND WORK HARD EACH DAY",           // 83
		"TWENTY YEARS FROM NOW YOU WILL BE MORE DISAPPOINTED BY THE THINGS THAT YOU DID NOT DO IN LIFE",          // 84
		"AS YOU THINK SO SHALL YOU BE AND THE THOUGHTS YOU CHOOSE WILL SHAPE THE COURSE OF YOUR LIFE",            // 85
		"WHEN THE WINDS OF CHANGE BLOW SOME PEOPLE BUILD WALLS AND OTHERS BUILD WINDMILLS TO HARNESS IT",         // 86
		"SPEAK SOFTLY AND CARRY A BIG STICK AND YOU WILL GO FAR BECAUSE PEOPLE ALWAYS RESPECT STRENGTH",          // 87
		"BETWEEN STIMULUS AND RESPONSE THERE IS A SPACE AND IN THAT SPACE IS OUR POWER TO CHOOSE OUR WAY",        // 88
		"THE PESSIMIST SEES DIFFICULTY IN EVERY OPPORTUNITY AND THE OPTIMIST SEES OPPORTUNITY IN EVERY DIFFICULTY", // 89
	];

	var phrase_count = array_length(pack);

	// Resolve which puzzle to use
	if (global.puzzle_index < 0 || global.puzzle_index >= phrase_count) {
		global.puzzle_index = irandom(phrase_count - 1);
	}
	global.puzzle_title = "Puzzle #" + string(global.puzzle_index + 1);
	if      (global.puzzle_index < 30) { global.puzzle_difficulty = 1; }
	else if (global.puzzle_index < 60) { global.puzzle_difficulty = 2; }
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
