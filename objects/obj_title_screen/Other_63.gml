/// @description Async Dialog result — handle get_string_async() response for name entry.
if (async_load[? "id"] == name_dialog_id) {
    name_dialog_id = -1;
    if (async_load[? "status"] == 1) {
        var _result = async_load[? "result"];
        if (_result != "") {
            global.player_name = string_copy(_result, 1, 20);
            scr_save_progress();
        }
    }
}
