<?php
// ============================================================
// CrypticSolver Leaderboard — Get Scores Endpoint
//
// GET ?puzzle=<0-89>   → top 10 for one puzzle
//   {"puzzle":5,"scores":[{"rank":1,"name":"John","stars":3,"time_seconds":143}, ...]}
//
// GET ?puzzle=recent&limit=30  → latest submissions across all puzzles
//   {"type":"recent","scores":[{"puzzle_index":5,"name":"John","stars":3,"time_seconds":143}, ...]}
//
// GET ?puzzle=all      → #1 score per puzzle (for leaderboard screen)
//   {"type":"all","scores":[{"puzzle_index":0,"name":"...","stars":3,"time_seconds":90}, ...]}
// ============================================================
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

require_once __DIR__ . '/db_config.php';

try {
    $pdo = new PDO(
        'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=utf8mb4',
        DB_USER, DB_PASS,
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, PDO::ATTR_TIMEOUT => 5]
    );
} catch (PDOException $e) {
    http_response_code(503);
    echo json_encode(['error' => 'Database unavailable']);
    exit;
}

$puzzle_param = isset($_GET['puzzle']) ? trim($_GET['puzzle']) : '';

// ---- Top 10 for a specific puzzle ----
if (is_numeric($puzzle_param)) {
    $puzzle_index = intval($puzzle_param);
    if ($puzzle_index < 0 || $puzzle_index > 89) {
        http_response_code(400);
        echo json_encode(['error' => 'Invalid puzzle_index']);
        exit;
    }
    $stmt = $pdo->prepare(
        'SELECT player_name AS name, stars, time_seconds
         FROM cryptic_scores
         WHERE puzzle_index = ?
         ORDER BY stars DESC, time_seconds ASC
         LIMIT 10'
    );
    $stmt->execute([$puzzle_index]);
    $rows   = $stmt->fetchAll(PDO::FETCH_ASSOC);
    $scores = [];
    foreach ($rows as $i => $r) {
        $scores[] = [
            'rank'         => $i + 1,
            'name'         => $r['name'],
            'stars'        => (int)$r['stars'],
            'time_seconds' => (int)$r['time_seconds'],
        ];
    }
    echo json_encode(['puzzle' => $puzzle_index, 'scores' => $scores]);

// ---- Recent submissions (title screen ticker) ----
} elseif ($puzzle_param === 'recent') {
    $limit = isset($_GET['limit']) ? min(max(intval($_GET['limit']), 1), 50) : 20;
    // LIMIT cannot be a PDO bound param on some MySQL versions — embed safely as validated int
    $stmt  = $pdo->query(
        'SELECT puzzle_index, player_name AS name, stars, time_seconds
         FROM cryptic_scores
         ORDER BY submitted_at DESC
         LIMIT ' . $limit
    );
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
    foreach ($rows as &$r) {
        $r['puzzle_index'] = (int)$r['puzzle_index'];
        $r['stars']        = (int)$r['stars'];
        $r['time_seconds'] = (int)$r['time_seconds'];
    }
    echo json_encode(['type' => 'recent', 'scores' => $rows]);

// ---- Best score per puzzle (leaderboard screen overview) ----
} elseif ($puzzle_param === 'all') {
    // Fetch all rows ordered best-first, then pick one per puzzle in PHP
    $stmt = $pdo->query(
        'SELECT puzzle_index, player_name AS name, stars, time_seconds
         FROM cryptic_scores
         ORDER BY puzzle_index ASC, stars DESC, time_seconds ASC'
    );
    $all_rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
    // Keep only the first (best) row per puzzle_index
    $seen = [];
    $rows = [];
    foreach ($all_rows as $r) {
        $pi = (int)$r['puzzle_index'];
        if (!isset($seen[$pi])) {
            $seen[$pi] = true;
            $rows[] = [
                'puzzle_index' => $pi,
                'name'         => $r['name'],
                'stars'        => (int)$r['stars'],
                'time_seconds' => (int)$r['time_seconds'],
            ];
        }
    }
    echo json_encode(['type' => 'all', 'scores' => $rows]);

} else {
    http_response_code(400);
    echo json_encode(['error' => 'Missing or invalid puzzle parameter. Use puzzle=<0-89>, puzzle=recent, or puzzle=all']);
}
