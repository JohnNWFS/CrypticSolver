<?php
// ============================================================
// CrypticSolver Leaderboard — Database Configuration Template
// ============================================================
// 1. Copy this file to  db_config.php  in the same directory.
// 2. Fill in your GoDaddy MySQL credentials below.
// 3. Generate a random API key (e.g. openssl rand -hex 32) and
//    paste it here AND into the LEADERBOARD_API_KEY macro inside
//    GameMaker (scripts/scr_leaderboard/scr_leaderboard.gml).
// 4. NEVER commit db_config.php to version control — it contains
//    your live credentials.
// ============================================================

define('DB_HOST', 'localhost');           // usually 'localhost' on GoDaddy
define('DB_NAME', 'your_database_name');
define('DB_USER', 'your_database_user');
define('DB_PASS', 'your_database_password');

// Shared secret — must match LEADERBOARD_API_KEY in GameMaker
define('API_KEY', 'CHANGE_ME_TO_A_LONG_RANDOM_STRING');
