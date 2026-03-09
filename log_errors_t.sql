
-- Monday 9 March 2026
-- ALTER TABLE log_errors_t ADD event_id VARCHAR(100) AFTER error_id;

/*
CREATE TABLE `log_errors_t` (
  `error_id` int NOT NULL AUTO_INCREMENT,
  `system_error_text` varchar(255) DEFAULT NULL,
  `system_error_code` varchar(255) DEFAULT NULL,
  `stella_error_text` varchar(255) DEFAULT NULL,
  `routine_name` varchar(255) DEFAULT NULL,
  `call_stack` text,
  `params` varchar(255) DEFAULT NULL,
  `milestone` varchar(255) DEFAULT NULL,
  `uw_name` varchar(255) DEFAULT NULL,
  `app_name` varchar(50) DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `app_continent` varchar(50) DEFAULT NULL,
  `is_closed_id` tinyint DEFAULT '94',
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`error_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7304 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

-- */