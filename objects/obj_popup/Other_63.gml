/// @description Async Dialog result — handle get_string_async() response for leaderboard name.
if (async_load[? "id"] == lb_name_dialog_id) {
    lb_name_dialog_id = -1;
    if (async_load[? "status"] == 1) {
        var _result = async_load[? "result"];
        if (_result != "") {
            lb_name_input = string_copy(_result, 1, 20);
        }
    }
}
