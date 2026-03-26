/// @description Generate all game sound effects from PCM buffers.
/// Stores sounds in global.snd_* variables. Safe to call once at startup.
/// No audio files required — all waveforms are computed in code.
function scr_init_sounds() {
    var _r = 44100;  // sample rate

    // --- Click: bank tile selected (short, crisp tick) ---
    {
        var _n = floor(_r * 0.035);
        var _b = buffer_create(_n * 2, buffer_fixed, 1);
        var _i;
        for (_i = 0; _i < _n; _i++) {
            var _p   = _i / _n;
            var _env = (1 - _p) * (1 - _p);
            var _s   = sin(2 * pi * 650 * _i / _r) * _env * 0.28 * 32767;
            buffer_write(_b, buffer_s16, clamp(round(_s), -32767, 32767));
        }
        global.snd_click = audio_create_buffer_sound(_b, buffer_s16, _r, 0, _n * 2, audio_mono);
        buffer_delete(_b);
    }

    // --- Place: tentative green guess placed (soft bell) ---
    {
        var _n = floor(_r * 0.065);
        var _b = buffer_create(_n * 2, buffer_fixed, 1);
        var _i;
        for (_i = 0; _i < _n; _i++) {
            var _p   = _i / _n;
            var _env = sin(_p * pi);   // smooth bell arc
            var _s   = sin(2 * pi * 523 * _i / _r) * _env * 0.22 * 32767;
            buffer_write(_b, buffer_s16, clamp(round(_s), -32767, 32767));
        }
        global.snd_place = audio_create_buffer_sound(_b, buffer_s16, _r, 0, _n * 2, audio_mono);
        buffer_delete(_b);
    }

    // --- Lock: letter locked gold (punchy pluck) ---
    {
        var _n = floor(_r * 0.090);
        var _b = buffer_create(_n * 2, buffer_fixed, 1);
        var _i;
        for (_i = 0; _i < _n; _i++) {
            var _p   = _i / _n;
            var _env = exp(-_p * 5);   // exponential decay
            var _s   = sin(2 * pi * 880 * _i / _r) * _env * 0.32 * 32767;
            buffer_write(_b, buffer_s16, clamp(round(_s), -32767, 32767));
        }
        global.snd_lock = audio_create_buffer_sound(_b, buffer_s16, _r, 0, _n * 2, audio_mono);
        buffer_delete(_b);
    }

    // --- Clear: board cleared (descending glide) ---
    {
        var _n = floor(_r * 0.090);
        var _b = buffer_create(_n * 2, buffer_fixed, 1);
        var _i;
        for (_i = 0; _i < _n; _i++) {
            var _p   = _i / _n;
            var _env = 1 - _p;
            // Integrate frequency for correct phase during glide: freq 400→200 Hz
            var _t     = _i / _r;
            var _phase = 2 * pi * (400 * _t - 100 * _t * _t);
            var _s     = sin(_phase) * _env * 0.20 * 32767;
            buffer_write(_b, buffer_s16, clamp(round(_s), -32767, 32767));
        }
        global.snd_clear = audio_create_buffer_sound(_b, buffer_s16, _r, 0, _n * 2, audio_mono);
        buffer_delete(_b);
    }

    // --- Hint: chime (two harmonics, slow bell) ---
    {
        var _n = floor(_r * 0.180);
        var _b = buffer_create(_n * 2, buffer_fixed, 1);
        var _i;
        for (_i = 0; _i < _n; _i++) {
            var _p   = _i / _n;
            var _env = sin(_p * pi) * sin(_p * pi);  // squared bell, softer
            var _s   = (sin(2 * pi * 1047 * _i / _r) * 0.7
                     +  sin(2 * pi * 2094 * _i / _r) * 0.3) * _env * 0.25 * 32767;
            buffer_write(_b, buffer_s16, clamp(round(_s), -32767, 32767));
        }
        global.snd_hint = audio_create_buffer_sound(_b, buffer_s16, _r, 0, _n * 2, audio_mono);
        buffer_delete(_b);
    }

    // --- Win fanfare: C5-E5-G5-C6 arpeggio ---
    {
        var _freqs   = [523, 659, 784, 1047];  // C5 E5 G5 C6
        var _note_n  = floor(_r * 0.130);      // 130 ms per note
        var _gap_n   = floor(_r * 0.018);      // 18 ms silence gap
        var _total_n = (_note_n + _gap_n) * 4;
        var _b       = buffer_create(_total_n * 2, buffer_fixed, 1);
        var _ni, _i;
        for (_ni = 0; _ni < 4; _ni++) {
            var _f = _freqs[_ni];
            for (_i = 0; _i < _note_n; _i++) {
                var _p   = _i / _note_n;
                var _env = exp(-_p * 4);
                var _s   = sin(2 * pi * _f * _i / _r) * _env * 0.30 * 32767;
                buffer_write(_b, buffer_s16, clamp(round(_s), -32767, 32767));
            }
            for (_i = 0; _i < _gap_n; _i++) {
                buffer_write(_b, buffer_s16, 0);
            }
        }
        global.snd_win = audio_create_buffer_sound(_b, buffer_s16, _r, 0, _total_n * 2, audio_mono);
        buffer_delete(_b);
    }
}
