CREATE TABLE IF NOT EXISTS events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(128) NOT NULL,
    event_type VARCHAR(64) NOT NULL DEFAULT 'VANGUARD_CORPSE',
    status VARCHAR(16) NOT NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 0,
    active_singleton TINYINT GENERATED ALWAYS AS (CASE WHEN is_active = 1 THEN 1 ELSE NULL END) STORED,
    created_at BIGINT NOT NULL,
    started_at BIGINT DEFAULT NULL,
    ending_started_at BIGINT DEFAULT NULL,
    ended_at BIGINT DEFAULT NULL,
    UNIQUE KEY uniq_active_event (active_singleton),
    INDEX (status),
    INDEX (event_type, created_at)
);

CREATE TABLE IF NOT EXISTS event_participants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    discord_user_id VARCHAR(32) NOT NULL,
    minecraft_uuid VARCHAR(32) NOT NULL,
    minecraft_username VARCHAR(32) NOT NULL,
    signup_corpse_count INT DEFAULT NULL,
    signup_at BIGINT NOT NULL,
    UNIQUE KEY uniq_event_discord_user (event_id, discord_user_id),
    UNIQUE KEY uniq_event_minecraft_uuid (event_id, minecraft_uuid),
    INDEX (event_id)
);

CREATE TABLE IF NOT EXISTS event_snapshot_runs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    snapshot_type VARCHAR(16) NOT NULL,
    snapshot_bucket VARCHAR(32) DEFAULT NULL,
    status VARCHAR(16) NOT NULL,
    batch_size INT NOT NULL,
    batch_delay_ms BIGINT NOT NULL,
    started_at BIGINT NOT NULL,
    next_batch_at BIGINT NOT NULL,
    completed_at BIGINT DEFAULT NULL,
    total_participants INT NOT NULL DEFAULT 0,
    succeeded_count INT NOT NULL DEFAULT 0,
    failed_count INT NOT NULL DEFAULT 0,
    last_error TEXT,
    UNIQUE KEY uniq_snapshot_bucket (event_id, snapshot_type, snapshot_bucket),
    INDEX (event_id, status),
    INDEX (status, next_batch_at),
    INDEX (event_id, snapshot_type, started_at)
);

CREATE TABLE IF NOT EXISTS event_snapshot_tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    snapshot_run_id INT NOT NULL,
    participant_id INT NOT NULL,
    status VARCHAR(16) NOT NULL,
    attempt_count INT NOT NULL DEFAULT 0,
    available_at BIGINT NOT NULL,
    claimed_at BIGINT DEFAULT NULL,
    last_attempt_at BIGINT DEFAULT NULL,
    completed_at BIGINT DEFAULT NULL,
    claim_token VARCHAR(64) DEFAULT NULL,
    failure_code VARCHAR(64) DEFAULT NULL,
    failure_message TEXT,
    UNIQUE KEY uniq_snapshot_run_participant (snapshot_run_id, participant_id),
    INDEX (snapshot_run_id, status, available_at),
    INDEX (status, available_at),
    INDEX (claim_token)
);

CREATE TABLE IF NOT EXISTS event_snapshots (
    id INT AUTO_INCREMENT PRIMARY KEY,
    snapshot_run_id INT NOT NULL,
    event_id INT NOT NULL,
    participant_id INT NOT NULL,
    snapshot_type VARCHAR(16) NOT NULL,
    corpse_count INT NOT NULL,
    captured_at BIGINT NOT NULL,
    is_final_snapshot TINYINT(1) NOT NULL DEFAULT 0,
    UNIQUE KEY uniq_snapshot_result (snapshot_run_id, participant_id),
    INDEX (event_id, participant_id, captured_at),
    INDEX (event_id, snapshot_type, captured_at)
);
