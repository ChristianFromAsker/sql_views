CREATE VIEW law_firms_v AS
SELECT l.law_firm_id id
, l.law_firm_id
, l.FirmName
, FirmName AS firm_name
, Jurisdiction
, l.brand
, l.us_relevant
, l.comments
, l.is_counsel
FROM law_firms_t l
WHERE is_deleted = 0 AND NOT l.FirmName IS NULL

