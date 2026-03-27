<?php
// ============================================================
// CrypticSolver Leaderboard — Database Configuration
// ============================================================
// This file reads credentials from a .env file stored ONE LEVEL
// ABOVE your public web root (public_html / httpdocs).
// That directory is never accessible via HTTP, so credentials
// are safe from direct web requests.
//
// Setup steps:
//   1. Create the file:  ~/crypticsolver.env  (see format below)
//   2. Copy this file to  db_config.php  in the same folder as
//      submit_score.php and get_leaderboard.php.
//   3. No other changes needed — db_config.php is auto-loaded
//      by the other PHP files.
//
// ~/crypticsolver.env format (plain key=value, no quotes):
// ----------------------------------------------------------
//   DB_HOST=localhost
//   DB_NAME=your_database_name
//   DB_USER=your_database_user
//   DB_PASS=your_database_password
//   API_KEY=paste_a_long_random_string_here
// ----------------------------------------------------------
// Generate a random API key:  openssl rand -hex 32
// The same key goes into LEADERBOARD_API_KEY in GameMaker
// (scripts/scr_leaderboard/scr_leaderboard.gml).
// ============================================================

$_env_file = dirname($_SERVER['DOCUMENT_ROOT']) . '/crypticsolver.env';

if (!file_exists($_env_file)) {
    http_response_code(500);
    die(json_encode(['error' => 'Server configuration missing']));
}

$_env = parse_ini_file($_env_file);
if ($_env === false) {
    http_response_code(500);
    die(json_encode(['error' => 'Server configuration unreadable']));
}

define('DB_HOST', $_env['DB_HOST'] ?? 'localhost');
define('DB_NAME', $_env['DB_NAME'] ?? '');
define('DB_USER', $_env['DB_USER'] ?? '');
define('DB_PASS', $_env['DB_PASS'] ?? '');
define('API_KEY',  $_env['API_KEY']  ?? '');
