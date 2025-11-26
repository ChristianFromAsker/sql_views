CREATE VIEW us_rr_v AS
SELECT d.deal_id
    , d.buyer_business_name
    , bf.business_name 	broker_firm
    , blf.FirmName 		buyer_law_firm_1

    , d.closing_date
    , d.comments
    , d.deal_currency
    , d.deal_name
    , d.drop_end, FORMAT(d.drop_end,0) drop_end_hr
    , d.drop_period
    , FORMAT(d.retention,0) drop_start_hr

    , FORMAT(d.ev,0) ev_hr
    , d.inception_date
    , FORMAT(d.max_limit_quoted,0) max_limit_quoted_hr

    , poe.menu_item 	primary_or_xs_hr
    , uw1.uw_name primary_uw_hr
    , d.program_summary
    , d.retention
    , rt.menu_item 		risk_type
    , CONCAT(FORMAT(d.total_rp_premium_on_deal / d.total_rp_limit_on_deal * 100, 4), '%') 		rol_hr

    , uw2.uw_name secondary_uw_hr

    , d.target_business_name
    , d.target_desc
    , FORMAT(d.total_rp_premium_on_deal,0) 		total_rp_premium_on_deal_hr
    , FORMAT(d.total_rp_limit_on_deal,0) 			total_rp_limit_on_deal_hr

    , fa.firm_name uw_financial_advisor_hr
    , lf.FirmName uw_law_firm_hr

FROM stella_eur.deals_t d
LEFT JOIN stella_common.underwriters_t uw1
    ON d.primary_uw= uw1.uw_id
LEFT JOIN stella_common.underwriters_t uw2
    ON d.secondary_uw = uw2.uw_id
LEFT JOIN financial_advisors_t fa
    ON d.uw_financial_advisor_id = fa.financial_advisor_id
LEFT JOIN law_firms_t lf
    ON d.uw_law_firm_id = lf.law_firm_id
LEFT JOIN stella_common.menu_list_t poe
    ON d.primary_or_xs_id = poe.menu_id
LEFT JOIN stella_common.menu_list_t rt
    ON d.risk_type_id = rt.menu_id
LEFT JOIN broker_firms_t bf
    ON d.broker_firm_id = bf.broker_firm_id
LEFT JOIN law_firms_t blf
    ON d.buyer_law_firm_1_id = blf.law_firm_id
WHERE d.is_deleted = 0
