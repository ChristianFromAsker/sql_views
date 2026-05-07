CREATE OR REPLACE VIEW deals_ai_project_v AS
SELECT d.deal_id,
    d.broker_firm_id,
    bf.business_name broker_firm_business_name,
    d.budget_home_id,
    bh.budget_home_name,
    d.buyer_law_firm_1_id,
    blf1.FirmName buyer_law_firm_1_business_name,
    d.deal_currency,
    d.deal_info,
    d.deal_name,
    d.deal_status_id,
    ds.menu_item deal_status_name,
    d.expected_signing_text,
    d.ev,
    d.insured_registered_country_id,
    airc.jurisdiction assumed_insured_registered_country,
    d.key_financials,
    d.nbi_prepper,
    d.primary_or_xs_id,
    pox.menu_item primary_or_xs,
    d.quote_due_date,
    d.quote_due_time,
    d.risk_type_id,
    rt.risk_type_name,
    d.SellerLegalFirm,
    slf.FirmName seller_law_firm,
    d.spa_law,
    d.submission_limits,
    d.submission_notes,
    d.target_desc,
    d.target_ebitda,
    d.target_sub_sector_id,
    sub_s.sector_name target_sub_sector_name,
    d.target_super_sector_id,
    super_s.sector_name target_super_sector_name,
    d.transaction_style transaction_style_id,
    ts.menu_item transaction_style_name

FROM stella_common.deals_ai_project_t d_ai
LEFT JOIN stella_eur.deals_t d
    ON d_ai.deal_id__deals_t = d.deal_id
LEFT JOIN stella_common.budget_homes_t bh
    ON d.budget_home_id = bh.budget_home_id
LEFT JOIN broker_firms_t bf
    ON d.broker_firm_id = bf.broker_firm_id
LEFT JOIN law_firms_t blf1
    ON d.buyer_law_firm_1_id = blf1.law_firm_id
LEFT JOIN stella_common.deal_statuses_t ds
    ON d.deal_status_id = ds.menu_id
LEFT JOIN stella_common.jurisdictions_t airc
    ON d.insured_registered_country_id = airc.jurisdiction_id
LEFT JOIN stella_common.menu_list_t pox
    ON d.primary_or_xs_id = pox.menu_id
LEFT JOIN stella_common.risk_types_t rt
    ON d.risk_type_id = rt.risk_type_id
LEFT JOIN law_firms_t slf
    ON d.SellerLegalFirm = slf.law_firm_id
LEFT JOIN stella_common.sectors_t sub_s
    ON d.target_sub_sector_id = sub_s.sector_id
LEFT JOIN stella_common.sectors_t super_s
    ON d.target_super_sector_id = super_s.sector_id
LEFT JOIN stella_common.menu_list_t ts
    ON d.transaction_style = ts.menu_id
WHERE d_ai.is_deleted = 0