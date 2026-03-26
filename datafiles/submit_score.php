<?php
// ============================================================
// CrypticSolver Leaderboard — Submit Score Endpoint
// POST params: api_key, puzzle_index, stars, time_seconds, name
// Returns JSON: {"success":true,"rank":3,"name":"John"}
//            or {"success":false,"error":"reason"}
// ============================================================
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

require_once __DIR__ . '/db_config.php';

function json_error($msg, $code = 400) {
    http_response_code($code);
    echo json_encode(['success' => false, 'error' => $msg]);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    json_error('Method not allowed', 405);
}

// ---- Validate API key ----
$api_key = isset($_POST['api_key']) ? trim($_POST['api_key']) : '';
if (!hash_equals(API_KEY, $api_key)) {
    json_error('Unauthorized', 401);
}

// ---- Validate inputs ----
$puzzle_index = isset($_POST['puzzle_index']) ? intval($_POST['puzzle_index']) : -1;
if ($puzzle_index < 0 || $puzzle_index > 89) { json_error('Invalid puzzle_index'); }

$stars = isset($_POST['stars']) ? intval($_POST['stars']) : 0;
if ($stars < 1 || $stars > 3) { json_error('Invalid stars'); }

$time_seconds = isset($_POST['time_seconds']) ? intval($_POST['time_seconds']) : 0;
if ($time_seconds < 1 || $time_seconds > 86400) { json_error('Invalid time_seconds'); }

$name = isset($_POST['name']) ? trim($_POST['name']) : '';
$name = mb_substr($name, 0, 50, 'UTF-8');
$name = htmlspecialchars($name, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
if ($name === '') { $name = 'Anonymous'; }

// ---- Connect ----
try {
    $pdo = new PDO(
        'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=utf8mb4',
        DB_USER, DB_PASS,
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, PDO::ATTR_TIMEOUT => 5]
    );
} catch (PDOException $e) {
    json_error('Database unavailable', 503);
}

// ---- Insert ----
$stmt = $pdo->prepare(
    'INSERT INTO cryptic_scores (puzzle_index, player_name, stars, time_seconds)
     VALUES (?, ?, ?, ?)'
);
$stmt->execute([$puzzle_index, $name, $stars, $time_seconds]);

// ---- Determine rank of the new score ----
$stmt = $pdo->prepare(
    'SELECT COUNT(*) FROM cryptic_scores
     WHERE puzzle_index = ?
       AND (stars > ? OR (stars = ? AND time_seconds < ?))'
);
$stmt->execute([$puzzle_index, $stars, $stars, $time_seconds]);
$rank = (int)$stmt->fetchColumn() + 1;

echo json_encode(['success' => true, 'rank' => $rank, 'name' => $name]);
