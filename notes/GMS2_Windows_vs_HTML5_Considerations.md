# GMS2 Cross-Platform Considerations: Windows vs HTML5

> **Audience:** Human developers and LLM coding assistants working on GameMaker Studio 2 projects
> that must run on both Windows desktop and HTML5 (browser) targets.
>
> **Source:** Lessons learned building CrypticSolver — a puzzle game shipping on Windows and
> web (desktop + Android Chrome / Edge / default browser).

---

## Table of Contents

1. [Platform Detection](#1-platform-detection)
2. [Coordinate Systems — The Core Problem](#2-coordinate-systems--the-core-problem)
3. [The scr_platform Helper Pattern](#3-the-scr_platform-helper-pattern)
4. [Canvas Scaling on HTML5](#4-canvas-scaling-on-html5)
5. [Android Chrome viewport bug](#5-android-chrome-viewport-bug)
6. [Button and Hitbox Placement](#6-button-and-hitbox-placement)
7. [Virtual Keyboards on Mobile](#7-virtual-keyboards-on-mobile)
8. [Text Input — Using get_string() on HTML5](#8-text-input--using-get_string-on-html5)
9. [Room Restart vs Room Goto](#9-room-restart-vs-room-goto)
10. [GUI Layer vs Room Space](#10-gui-layer-vs-room-space)
11. [Touch and Mouse Events](#11-touch-and-mouse-events)
12. [Scrollbars and Drag Interactions](#12-scrollbars-and-drag-interactions)
13. [HTML5 JS Prepend — Injecting Startup Code](#13-html5-js-prepend--injecting-startup-code)
14. [Backend / PHP / MySQL Gotchas](#14-backend--php--mysql-gotchas)
15. [Debugging Checklist](#15-debugging-checklist)
16. [Quick Reference — What to Use Where](#16-quick-reference--what-to-use-where)

---

## 1. Platform Detection

### The One Reliable Test

```gml
function scr_is_html5() {
    return (os_browser != browser_not_a_browser);
}
```

- `os_browser` returns a browser constant on HTML5 targets, and `browser_not_a_browser` on
  Windows/desktop targets.
- Do **not** use `os_type == os_windows` as the only check — it fails when running from the
  GMS2 IDE on Windows in HTML5 mode.
- This check works correctly in both the GMS2 HTML5 runner and all desktop runners.

### Where to Put It

Wrap `scr_is_html5()` in a dedicated script (e.g. `scr_platform.gml`) alongside all other
platform-aware helpers. Every GUI object imports from that single source of truth.

---

## 2. Coordinate Systems — The Core Problem

This is the single biggest source of bugs when porting from Windows to HTML5.

### Windows

| What you want | What to use |
|---|---|
| Mouse position in GUI space | `device_mouse_x_to_gui(0)` / `device_mouse_y_to_gui(0)` |
| Canvas / GUI dimensions | `display_get_gui_width()` / `display_get_gui_height()` |
| Room dimensions | `room_width` / `room_height` |

On Windows, `display_get_gui_width/height()` can differ from `room_width/height` depending on
your scaling settings. Always use the GUI functions in Draw_GUI events.

### HTML5

| What you want | What to use |
|---|---|
| Mouse position in GUI space | `mouse_x` / `mouse_y` (already in game-native coords) |
| Canvas / GUI dimensions | `room_width` / `room_height` |

On HTML5, `display_get_gui_width/height()` and `device_mouse_x/y_to_gui(0)` return
**inflated CSS-pixel values** that do not correspond to game coordinates. The canvas is scaled
by the browser but GMS2 does not compensate — you get values that are 1.5× to 3× too large,
making all hit detection fail silently.

### The Safe Pattern

Never write raw `mouse_x` or `device_mouse_x_to_gui(0)` in GUI hit-detection code. Always
route through a platform-aware wrapper (see Section 3).

---

## 3. The scr_platform Helper Pattern

Create `scripts/scr_platform/scr_platform.gml` and put **all** platform-divergent coordinate
logic there. Every object's Step and Draw_GUI events call these instead of the raw GML functions.

```gml
function scr_is_html5() {
    return (os_browser != browser_not_a_browser);
}

/// Mouse position — safe in both Draw_GUI and Step events
function scr_ui_mouse_x() {
    return scr_is_html5() ? mouse_x : device_mouse_x_to_gui(0);
}
function scr_ui_mouse_y() {
    return scr_is_html5() ? mouse_y : device_mouse_y_to_gui(0);
}

/// Canvas / GUI dimensions
function scr_ui_width() {
    return scr_is_html5() ? room_width : display_get_gui_width();
}
function scr_ui_height() {
    return scr_is_html5() ? room_height : display_get_gui_height();
}
```

### Usage in objects

```gml
// Step_0 or Draw_64 — works identically on Windows and HTML5
var _mx = scr_ui_mouse_x();
var _my = scr_ui_mouse_y();
var _gw = scr_ui_width();
var _gh = scr_ui_height();

var _hit = (_mx >= btn_x1 && _mx <= btn_x2 && _my >= btn_y1 && _my <= btn_y2);
```

---

## 4. Canvas Scaling on HTML5

### The Problem

GMS2's HTML5 runner sets the canvas pixel size via inline `style="width:Xpx; height:Ypx"`
on the `<canvas>` element. By default on mobile browsers this means the game renders at
1024×480 (or whatever your room size is) even on a 390px-wide phone screen — it just gets
clipped.

### The Solution — JS Prepend with a Dynamic Resizer

In **Project Settings → HTML5 → Advanced → JS Prepend**, inject a JavaScript block that:

1. Styles `html` and `body` to fill the viewport and flex-center the canvas.
2. Creates a **dynamic** style element that computes canvas pixel dimensions using
   `window.innerWidth` / `window.innerHeight` (not `vw`/`vh` CSS units — see Section 5).
3. Re-runs the calculation on `resize` and `orientationchange` events.

```javascript
document.addEventListener('DOMContentLoaded', function () {

    // Static layout styles
    var s = document.createElement('style');
    s.textContent = [
        'html, body {',
        '  margin: 0; padding: 0; width: 100%; height: 100%;',
        '  background: #000;',
        '  display: flex; justify-content: center; align-items: center;',
        '  overflow: hidden;',
        '}',
        'canvas { touch-action: none; }',   // prevents scroll-jank on drag
    ].join('');
    document.head.appendChild(s);

    // Dynamic canvas size — updated on every resize
    var d = document.createElement('style');
    document.head.appendChild(d);

    var GAME_W = 1024, GAME_H = 480;   // <-- match your room size

    function resize() {
        var scale = Math.min(window.innerWidth / GAME_W, window.innerHeight / GAME_H);
        var w = Math.floor(GAME_W * scale);
        var h = Math.floor(GAME_H * scale);
        d.textContent = 'canvas { width: ' + w + 'px !important; height: ' + h + 'px !important; }';
    }

    resize();
    window.addEventListener('resize', resize);
    window.addEventListener('orientationchange', function () {
        setTimeout(resize, 150);   // Android needs a moment to settle after rotation
    });
});
```

> **Why `!important`?**
> GMS2's runner injects inline `style` attributes on the canvas element after the DOM loads.
> Inline styles beat normal stylesheet rules. `!important` is the only way to override them
> from a stylesheet.

---

## 5. Android Chrome viewport bug

### The Problem

CSS `100vh` on **Android Chrome** equals the **physical screen height**, including the address
bar area — even when the address bar is visible and taking up space. This means a canvas sized
to `100vh` is taller than the actual visible area, clipping the bottom of the game.

**Edge, Firefox, Samsung Internet, and the Android default browser** all handle `100vh`
correctly (visible viewport only). Chrome is the outlier.

### The Fix

Use `window.innerHeight` in JavaScript instead of `100vh` in CSS. `window.innerHeight` always
returns the **actually visible** area on every browser, correctly excluding the address bar.

This is exactly what the JS resizer in Section 4 does. Never use `vh`/`vw` CSS units for
canvas sizing in a GMS2 HTML5 game.

---

## 6. Button and Hitbox Placement

### Positioning Strategy

Always anchor buttons relative to `room_width` / `room_height` (or their `scr_ui_*` wrappers),
not to hardcoded pixel values. This keeps buttons in the right visual position regardless of
GUI scaling.

```gml
// Good — relative anchor
var _btn_cy = room_height - 44;

// Bad — breaks on any non-standard resolution
var _btn_cy = 436;
```

### Hitbox Must Match Draw Position Exactly

The single most common bug: the draw code and the step/hit-detection code compute positions
with slightly different formulas and diverge. Rules:

- Define button geometry **once**, either in Create_0 as instance variables (for buttons that
  don't move) or as local vars computed identically in both Draw_64 and Step_0.
- If you compute `_px = (_gw - _pw) * 0.5` in Draw_64, compute the exact same expression in
  Step_0. Do not approximate.
- Include any visual offsets (hover lift, press push) in the **draw** position only, never
  in the hitbox position.

### Windows GUI Height Discrepancy

On Windows, `display_get_gui_height()` can be less than `room_height` depending on viewport
settings. A button drawn at `room_height - 60` (room space) may sit at a different y-coordinate
in GUI space. Use `scr_ui_height()` for sizing/centering, but keep visual anchors in room
coordinates and compare mouse against `scr_ui_mouse_y()`.

---

## 7. Virtual Keyboards on Mobile

### Why `keyboard_virtual_show()` Usually Fails on Android

`keyboard_virtual_show()` calls `input.focus()` on a hidden HTML input element. Android Chrome
and Edge enforce a strict **user-gesture policy**: `focus()` is only permitted when called
synchronously inside a native browser event handler (touchstart, touchend, click, etc.).

GMS2's entire game loop runs inside `requestAnimationFrame`. The browser does **not** consider
`rAF` callbacks as user-gesture contexts. This means `keyboard_virtual_show()` calls in GML
Step events, alarm events, or async HTTP callbacks are **silently ignored** by Android Chrome
and Edge, regardless of where you place them.

There is no reliable workaround within GML for this restriction.

### The Reliable Alternative — `get_string()`

On HTML5, `get_string(prompt, default)` maps to `window.prompt(prompt, default)` — a
**native browser dialog**. The browser manages the keyboard entirely; the gesture policy does
not apply.

```gml
if (scr_is_html5()) {
    var _result = get_string("Enter your name:", global.player_name);
    if (_result != "") {
        global.player_name = string_copy(_result, 1, 20);
    }
} else {
    // Windows: open your custom in-game overlay
    name_overlay = true;
}
```

Downsides: the prompt is a plain OS/browser dialog, not styled to match the game. This is
acceptable for infrequent text entry (player name, leaderboard entry). For frequent text input
consider a third-party virtual keyboard extension or an entirely custom on-screen key grid.

---

## 8. Text Input — Using get_string() on HTML5

Beyond the keyboard issue, custom in-game text-input overlays have additional HTML5 problems:

- `keyboard_string` may not receive input reliably on some mobile browsers when the virtual
  keyboard is not visible.
- Backspace key events are often swallowed by the browser's back-navigation handler.
- IME composition (Asian languages, emoji) is not handled by GMS2's `keyboard_string`.

**Recommendation:** For any text the player must type (names, search, codes), use
`get_string()` on HTML5 and your custom overlay on Windows. Gate on `scr_is_html5()`.

---

## 9. Room Restart vs Room Goto

### The Problem

`room_restart()` is unreliable on HTML5. In some configurations it causes a black screen or
fails to reinitialize global state correctly.

### The Fix

Replace all `room_restart()` calls with `room_goto(room)`:

```gml
// Unreliable on HTML5
room_restart();

// Safe on all platforms
room_goto(room);  // 'room' is a built-in GML variable: the current room's index
```

`room_goto(room)` is semantically identical — it navigates to the current room, triggering
all Create events — but goes through the standard room-transition pipeline that HTML5 handles
correctly.

---

## 10. GUI Layer vs Room Space

GMS2 has two distinct coordinate spaces that can diverge, especially on Windows:

| Space | When active | Coordinate origin |
|---|---|---|
| **Room space** | Draw events, Step events | Top-left of room |
| **GUI space** | Draw_GUI events | Top-left of display |

On **HTML5**: room space and GUI space are always the same. `mouse_x == device_mouse_x_to_gui(0)`,
`room_width == display_get_gui_width()`.

On **Windows**: GUI space can differ from room space if the room is scaled or the GUI layer
resolution is set independently.

**Rule:** In Draw_GUI events, use `scr_ui_width/height()` and `scr_ui_mouse_x/y()`. In Draw
(non-GUI) events, use `room_width/height` and `mouse_x/y` directly.

---

## 11. Touch and Mouse Events

On HTML5, GMS2 translates touch events into mouse events:

- Single finger tap → `mouse_check_button_pressed(mb_left)`
- `mouse_x / mouse_y` follow the first active touch point
- Multi-touch is not available through standard GML mouse functions

`touch-action: none` on the canvas element (added in the JS prepend) is important: without it,
the browser may try to pan/scroll the page during a drag gesture and cancel the touch, causing
stuttering or dropped input on Android.

---

## 12. Scrollbars and Drag Interactions

Scrollbar click-and-drag works on HTML5 and Windows but requires care:

- Track whether a drag is in progress with a boolean (e.g. `sb_dragging`).
- In the drag handler, check `mouse_check_button(mb_left)` (held), not `_pressed` (one frame).
- On release, detect `!mouse_check_button(mb_left)` and set `sb_dragging = false`.
- Use `mouse_x/y` (room space) consistently throughout the scrollbar — do not mix with GUI
  helpers unless you are in a Draw_GUI event.

Row-click formula for scrolled lists:

```gml
var _clicked_row = floor((_my - list_y1 + scroll_offset) / row_h);
```

The `+ scroll_offset` term is critical. Without it, the clicked row is calculated relative to
the top of the visible list, not the full dataset, causing the wrong row to highlight.

---

## 13. HTML5 JS Prepend — Injecting Startup Code

The **JS Prepend** field in HTML5 options (`option_html5_jsprepend` in the `.yy` file) runs
before the GMS2 runner initializes. Use it for:

- Viewport/canvas scaling (Section 4)
- Adding CSS resets
- Registering global event listeners

**Syntax warning:** The `.yy` file stores this as a single JSON string. Escape rules:
- Use `'` (single quotes) inside the JS — avoids needing to escape `"`
- Escape any literal backslashes as `\\`
- Do not use template literals (backticks) — they may not survive the JSON round-trip

**Editing tip:** Write the JS in a separate `.js` file, test it in a browser, then
minify/collapse it to a single line for pasting into the `.yy` field.

---

## 14. Backend / PHP / MySQL Gotchas

If your HTML5 game communicates with a PHP/MySQL leaderboard backend:

### API Key / POST Body Encoding

GMS2's `http_post_string()` does **not** URL-encode the POST body. Special characters in
API keys or data — particularly `#`, `^`, `&`, `=`, `+` — will be truncated or
misinterpreted by the server.

**Fix:** Use only alphanumeric characters and safe symbols (`-`, `_`) in API keys and any
POST body values.

```gml
// Bad — '#' truncates the key at the server side
var _key = "MyKey#45abc^99";

// Good — alphanumeric only
var _key = "MyKey45abc99xJ9mLqR7";
```

### PDO LIMIT Binding (GoDaddy / Percona MySQL)

Some MySQL configurations (GoDaddy Percona in particular) reject bound parameters for `LIMIT`
clauses — they quote the value as a string (`'30'`) rather than an integer, causing a syntax
error.

```php
// Broken on strict MySQL
$stmt = $pdo->prepare("SELECT * FROM scores LIMIT ?");
$stmt->execute([$limit]);

// Safe — validate as int, embed directly
$limit = (int)$limit;
$rows = $pdo->query("SELECT * FROM scores LIMIT $limit")->fetchAll();
```

### MySQL ONLY_FULL_GROUP_BY

Percona and newer MySQL enforce `ONLY_FULL_GROUP_BY` strict mode. Any `GROUP BY` query where
the `SELECT` list contains columns not in the `GROUP BY` clause or an aggregate function will
fail with an error.

**Fix:** Either include all selected columns in `GROUP BY`, use aggregate functions, or
perform the deduplication in PHP after a plain `SELECT … ORDER BY`.

---

## 15. Debugging Checklist

When a button works on Windows but not on HTML5:

- [ ] Is mouse position coming from `scr_ui_mouse_x/y()` rather than raw `mouse_x/y` or
      `device_mouse_x/y_to_gui()`?
- [ ] Does the hitbox formula exactly match the draw formula?
- [ ] Is `room_restart()` used anywhere in the click action? (Replace with `room_goto(room)`)
- [ ] Are coordinates anchored to `room_width/height` not hardcoded pixels?

When the canvas is clipped or off-screen on mobile:

- [ ] Is the JS prepend resizer using `window.innerWidth/innerHeight` not `vw/vh`?
- [ ] Are both `width` and `height` set with `!important` on the canvas?
- [ ] Is there an `orientationchange` handler with a `setTimeout` delay?

When the keyboard won't appear on Android:

- [ ] Is `keyboard_virtual_show()` being called from a Step/Alarm/HTTP event? (Will be blocked)
- [ ] Is `get_string()` being used instead for HTML5 text entry?

When leaderboard data is wrong or crashes:

- [ ] Does the API key contain `#`, `^`, `&`, or other special characters?
- [ ] Are any `LIMIT` parameters embedded directly as validated ints (not bound via PDO)?
- [ ] Do all `GROUP BY` queries include every non-aggregate column in the `SELECT`?

---

## 16. Quick Reference — What to Use Where

| Task | Windows | HTML5 |
|---|---|---|
| Mouse X in GUI event | `device_mouse_x_to_gui(0)` | `mouse_x` |
| Mouse Y in GUI event | `device_mouse_y_to_gui(0)` | `mouse_y` |
| Canvas/GUI width | `display_get_gui_width()` | `room_width` |
| Canvas/GUI height | `display_get_gui_height()` | `room_height` |
| Restart current room | `room_goto(room)` | `room_goto(room)` ✓ |
| ~~`room_restart()`~~ | works | unreliable ✗ |
| Player text input | custom overlay + `keyboard_string` | `get_string()` |
| Virtual keyboard | `keyboard_virtual_show()` | unreliable — use `get_string()` |
| Canvas scaling | GMS2 handles natively | JS prepend with `window.innerWidth/Height` |

| Coordinate helper | Returns |
|---|---|
| `scr_ui_mouse_x()` | Correct mouse X in GUI space on both platforms |
| `scr_ui_mouse_y()` | Correct mouse Y in GUI space on both platforms |
| `scr_ui_width()` | Correct GUI/canvas width on both platforms |
| `scr_ui_height()` | Correct GUI/canvas height on both platforms |
| `scr_is_html5()` | `true` on HTML5, `false` on Windows |

---

*Document generated from CrypticSolver development experience, April 2026.*
*Tested on: Windows 11, Android Chrome 124, Android Edge 124, Android Samsung Internet.*
