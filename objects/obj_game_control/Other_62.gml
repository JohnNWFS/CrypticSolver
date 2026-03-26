/// @description Async HTTP handler — routes leaderboard responses to globals.
var _id     = async_load[? "id"];
var _status = async_load[? "status"];   // 0=complete, -1=error
var _http   = async_load[? "http_status"];
var _result = async_load[? "result"];

// On network error or non-200 response, mark the matching request as failed.
if (_status < 0 || _http != 200) {
    if (_id == global.lb_win_fetch_id)    { global.lb_win_state    = "error"; global.lb_win_fetch_id    = -1; }
    if (_id == global.lb_submit_id)       { global.lb_submit_state = "error"; global.lb_submit_id       = -1; }
    if (_id == global.lb_ticker_fetch_id) { global.lb_ticker_state = "error"; global.lb_ticker_fetch_id = -1; }
    if (_id == global.lb_all_fetch_id)    { global.lb_all_state    = "error"; global.lb_all_fetch_id    = -1; }
    exit;
}

// ---- Win screen: top 10 for current puzzle ----
if (_id == global.lb_win_fetch_id) {
    var _p = json_parse(_result);
    if (variable_struct_exists(_p, "scores")) {
        global.lb_data[global.lb_win_puzzle] = _p.scores;
    }
    global.lb_win_state    = "ready";
    global.lb_win_fetch_id = -1;
    exit;
}

// ---- Score submit result ----
if (_id == global.lb_submit_id) {
    var _p = json_parse(_result);
    if (variable_struct_exists(_p, "success") && _p.success) {
        global.lb_submit_rank  = variable_struct_exists(_p, "rank") ? _p.rank : 0;
        global.lb_submit_state = "success";
    } else {
        global.lb_submit_state = "error";
    }
    global.lb_submit_id = -1;
    exit;
}

// ---- Title screen ticker: recent scores ----
if (_id == global.lb_ticker_fetch_id) {
    var _p = json_parse(_result);
    if (variable_struct_exists(_p, "scores")) {
        global.lb_ticker_scores = _p.scores;
    }
    global.lb_ticker_state    = "ready";
    global.lb_ticker_fetch_id = -1;
    exit;
}

// ---- Leaderboard screen: #1 per puzzle overview ----
if (_id == global.lb_all_fetch_id) {
    var _p = json_parse(_result);
    if (variable_struct_exists(_p, "scores")) {
        global.lb_all_scores = _p.scores;
    }
    global.lb_all_state    = "ready";
    global.lb_all_fetch_id = -1;
    exit;
}
