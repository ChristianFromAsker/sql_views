


-- 20 February 2026
-- ALTER TABLE cm_policies_t ADD insured_main_region_id INTEGER AFTER insured_registered_country_id

-- 29 January 2026
-- ALTER TABLE cm_policies_t ADD deal_id__deals_t INTEGER AFTER create_date;
-- ALTER TABLE cm_policies_t ADD policy_id__layers_t INTEGER;

/*
CREATE TABLE cm_policies_t (
    cm_policy_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    insured_registered_country_id INTEGER,
    insured_id INTEGER,
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    inception_date date,
    is_deleted INTEGER DEFAULT 0,
    policy_id__layers_t INTEGER
);
-- */