CREATE OR REPLACE VIEW brands_v AS
SELECT b.brand_id,
    b.brand_name,
    b.is_active,
    b.is_broker,
    b.is_competitor,
    b.is_advisor,
    b.is_party
FROM stella_common.brands_t b
WHERE is_deleted = 0