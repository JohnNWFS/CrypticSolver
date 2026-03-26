-- ============================================================
-- CrypticSolver Leaderboard — Database Schema
-- ============================================================
-- Run this once on your MySQL / MariaDB database to create the
-- leaderboard table.  Compatible with MySQL 5.6+ and MariaDB 10.1+.
--
-- Steps:
--   1. Create a database (e.g. CREATE DATABASE crypticsolver;)
--   2. Run this file:  mysql -u user -p crypticsolver < create_tables.sql
--   3. Copy db_config_template.php → db_config.php and fill in credentials.
--   4. Upload all PHP files to /games/crypticsolver/ on your server.
-- ============================================================

CREATE TABLE IF NOT EXISTS `cryptic_scores` (
  `id`           INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  `puzzle_index` TINYINT UNSIGNED NOT NULL COMMENT 'Puzzle number 0–89',
  `player_name`  VARCHAR(50)      NOT NULL DEFAULT 'Anonymous',
  `stars`        TINYINT UNSIGNED NOT NULL COMMENT '1–3 stars awarded',
  `time_seconds` SMALLINT UNSIGNED NOT NULL COMMENT 'Solve time in whole seconds',
  `submitted_at` TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_puzzle_rank` (`puzzle_index`, `stars` DESC, `time_seconds` ASC),
  INDEX `idx_recent`      (`submitted_at` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
