
/*
-- 13 February 2026
ALTER TABLE stella_common.brands_t
ADD is_party DECIMAL(1,0) DEFAULT 0,
ADD is_broker DECIMAL(1,0) DEFAULT 0,
ADD is_competitor DECIMAL(1,0) DEFAULT 0,
ADD is_vendor DECIMAL(1,0) DEFAULT 0
-- */

/*
CREATE TABLE brands_t (
  brand_id int NOT NULL AUTO_INCREMENT,
  brand_name varchar(100) DEFAULT NULL,
  is_deleted int DEFAULT (0),
  brand_type_id int DEFAULT NULL,
  is_active int DEFAULT (93),
  PRIMARY KEY (brand_id)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
-- */