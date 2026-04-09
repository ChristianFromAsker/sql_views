CREATE OR REPLACE VIEW deals_rate_adequacy_local_v AS
SELECT d.deal_id
, d.deal_name
, d.spa_law
, d.deal_status_id
, d.primary_or_xs_id
, d.risk_type_id
, d.budget_home_id
, bh.budget_home_name budget_home
, br.jurisdiction budget_region
, br.budget_home_id budget_region_id
, rp_r.rp_region_id

, d.inception_date
, d.create_date
, d.submission_date

, d.target_super_sector_id
, d.target_sub_sector_id
, sup_s.sector_bucket_id

, CAST(total_rp_premium_on_deal / currency_rate_deal AS DECIMAL(14,0)) total_rp_premium_on_deal_eur
, CAST(ev / currency_rate_deal AS DECIMAL(14,0)) ev_eur
, CAST(total_rp_limit_on_deal / currency_rate_deal AS DECIMAL(14,0)) total_rp_limit_on_deal_eur
, CAST(lowest_rp_attpoint / currency_rate_deal AS DECIMAL(14,0)) lowest_rp_attpoint_eur
, CAST(d.retention / d.currency_rate_deal AS DECIMAL(14,0)) retention_eur

FROM deals_t d
LEFT JOIN stella_common.budget_homes_t bh
    ON d.budget_home_id = bh.budget_home_id
LEFT JOIN stella_common.jurisdictions_t br
    ON bh.budget_region_id__jurisdictions_t = br.jurisdiction_id
LEFT JOIN stella_common.jurisdictions_t rp_r
    ON d.spa_law = rp_r.jurisdiction
LEFT JOIN stella_common.sectors_t sup_s
    ON d.target_super_sector_id = sup_s.sector_id
WHERE
    d.is_deleted = 0
    AND (d.deal_status_id = 6 OR d.deal_status_id = 436)
    AND d.is_test_deal_id = 94

