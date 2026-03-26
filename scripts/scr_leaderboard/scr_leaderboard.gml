/// @description Leaderboard macros, HTTP helpers, and qualify check.

// Base URL for the leaderboard PHP files on your server.
// Include the trailing slash.
#macro LEADERBOARD_URL     "https://johnnwfs.net/games/crypticsolver/"

// Shared secret — must match API_KEY in db_config.php on your server.
// Generate a random string (e.g. openssl rand -hex 32) and paste it in both places.
#macro LEADERBOARD_API_KEY "CHANGE_ME_BEFORE_DEPLOYMENT"

// ---------------------------------------------------------------------------
// scr_fetch_leaderboard(puzzle_idx)
// Sends an async GET for leaderboard data.
//   puzzle_idx >= 0  → top 10 for that specific puzzle
//   puzzle_idx == -1 → recent scores across all puzzles (ticker feed)
//   puzzle_idx == -2 → #1 score per puzzle (leaderboard screen overview)
// Returns the http request id.
// ---------------------------------------------------------------------------
function scr_fetch_leaderboard(puzzle_idx) {
    var _url;
    if      (puzzle_idx == -1) { _url = LEADERBOARD_URL + "get_leaderboard.php?puzzle=recent&limit=30"; }
    else if (puzzle_idx == -2) { _url = LEADERBOARD_URL + "get_leaderboard.php?puzzle=all"; }
    else                       { _url = LEADERBOARD_URL + "get_leaderboard.php?puzzle=" + string(puzzle_idx); }
    return http_get(_url);
}

// ---------------------------------------------------------------------------
// scr_submit_score(puzzle_idx, stars, time_sec, name)
// POSTs a score to the server.  Returns the http request id.
// ---------------------------------------------------------------------------
function scr_submit_score(puzzle_idx, stars, time_sec, name) {
    var _name = (string_length(string_trim(name)) == 0) ? "Anonymous" : name;
    var _body = "api_key="       + LEADERBOARD_API_KEY
              + "&puzzle_index=" + string(puzzle_idx)
              + "&stars="        + string(stars)
              + "&time_seconds=" + string(time_sec)
              + "&name="         + _name;
    return http_post_string(LEADERBOARD_URL + "submit_score.php", _body);
}

// ---------------------------------------------------------------------------
// scr_lb_qualifies(puzzle_idx, stars, time_sec)
// Returns true if this score would place in the top 10 for the puzzle.
// Requires global.lb_data[puzzle_idx] to be populated first.
// If data is not yet available, optimistically returns true.
// ---------------------------------------------------------------------------
function scr_lb_qualifies(puzzle_idx, stars, time_sec) {
    if (!variable_global_exists("lb_data"))          { return true; }
    if (puzzle_idx < 0 || puzzle_idx > 89)           { return false; }
    var _scores = global.lb_data[puzzle_idx];
    if (is_undefined(_scores))                       { return true; }
    var _count = array_length(_scores);
    if (_count < 10)                                 { return true; }
    var _worst = _scores[_count - 1];
    if (stars >  _worst.stars)                       { return true; }
    if (stars == _worst.stars && time_sec < _worst.time_seconds) { return true; }
    return false;
}

// ---------------------------------------------------------------------------
// scr_format_time(seconds)
// Returns "M:SS" string.
// ---------------------------------------------------------------------------
function scr_format_time(secs) {
    var _m  = floor(secs / 60);
    var _s  = secs mod 60;
    return string(_m) + ":" + ((_s < 10) ? "0" : "") + string(_s);
}
