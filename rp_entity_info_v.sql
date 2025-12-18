CREATE VIEW rp_entity_info_v AS
SELECT e.entity_id
, e.entity_id id
, e.entity_business_name
, e.entity_type
, j.jurisdiction entity_jurisdiction_hr
FROM stella_common.entities_t e
INNER JOIN stella_common.jurisdictions_t j
    ON e.entity_jurisdiction = j.jurisdiction_id
WHERE e.is_deleted = 0
