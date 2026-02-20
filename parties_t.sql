


-- 20 February 2026
-- ALTER TABLE parties_t ALTER COLUMN party_main_region_id__jurisdictions_t SET DEFAULT 442;

-- 19 February 2026
-- ALTER TABLE parties_t ADD party_main_country_id__jurisdictions_t INTEGER AFTER party_legal_name

/*
CREATE TABLE `parties_t` (
  `party_id` int NOT NULL AUTO_INCREMENT,
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `creator` varchar(100) DEFAULT NULL,
  `is_deleted` int DEFAULT '0',
  `party_brand_id__brands_t` int DEFAULT NULL,
  `party_business_name` varchar(100) DEFAULT NULL,
  `party_city` varchar(100) DEFAULT NULL,
  `party_legal_name` varchar(100) DEFAULT NULL,
  `party_main_region_id__jurisdictions_t` int DEFAULT NULL,
  `party_reg_no` varchar(100) DEFAULT NULL,
  `party_registered_country_id__jurisdictions_t` int DEFAULT NULL,
  `party_registered_region_id__jurisdictions_t` int DEFAULT NULL,
  `party_street_1` varchar(100) DEFAULT NULL,
  `party_street_2` varchar(100) DEFAULT NULL,
  `party_sub_sector_id__sectors_t` int DEFAULT NULL,
  `party_super_sector_id__sectors_t` int DEFAULT NULL,
  `party_zip_code` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`party_id`)
) ENGINE=InnoDB AUTO_INCREMENT=51245 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
-- */