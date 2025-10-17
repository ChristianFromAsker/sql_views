CREATE VIEW sub_control_v AS
SELECT
    d.deal_id
    , d.deal_name
    , d.deal_status_id
    , d.budget_home_id
    , d.deal_currency
    , d.ev
    , d.spa_law
    , d.key_financials
    , d.target_business_name
    , d.target_legal_name
    , d.broker_firm_id
    , d.primary_or_xs_id
    , d.transaction_style
    , d.target_super_sector_id
    , d.target_sub_sector_id
    , tss.sector_name target_super_sector
    , tsubs.sector_name target_sub_sector
    , tlj.jurisdiction target_legal_jurisdiction
    , d.TargetDomicile target_legal_jurisdiction_id
    , d.risk_type_id
    , rt.risk_type_name risk_type
    , rtm.risk_type_id risk_type_major_id

    , d.buyer_business_name
    , d.buyer_law_firm_1_id, d.buyer_financial_firm_id buyer_financial_advisor
    , d.seller_business_name, d.SellerLegalFirm seller_law_firm
    , d.target_ebitda
    , d.submission_limits
    , d.expected_signing_text
    , d.deal_info
    , d.submission_notes
    , d.latest_status_change
    , d.nbi_prepper, d.primary_uw, d.secondary_uw
    , d.quote_due_time due_time
    , d.quote_due_date due_date
    , IF(
        blf1.FirmName IS NULL, IF(
            fa.firm_name IS NULL, '', fa.firm_name
        ), IF(
            fa.firm_name IS NULL, blf1.FirmName, CONCAT(blf1.FirmName, ' and ', fa.firm_name)
        )
    ) advisors_hr
    , IF(
        slf.FirmName IS NULL, '', slf.FirmName
    ) seller_advisors_hr
    , CONCAT(bf.business_name, '<br>', 'SPA law: ', d.spa_law) broker_firm_spa
    , ts.menu_item transaction_style_hr
    , px.menu_item primary_or_xs_hr
    , re.entity_business_name rp_entity_hr
    , np.uw_initials nbi_prepper_hr
    , puw.uw_initials primary_uw_hr
    , au.uw_initials analyst_initials
    , IF(
        d.deal_status_id = 481 OR d.deal_status_id = 2,
        IF(
    d.nbi_prepper IS NULL,
    s.menu_item,
    CONCAT(s.menu_item, ' (NBI prepper: ', np.uw_initials, ')')
        ),
        s.menu_item
    ) status_with_nbi_prepper
    , s.menu_item status_hr
    , CONCAT(d.quote_due_date, ' (' , dayname(d.quote_due_date), ') ', d.quote_due_time) due_hr

FROM deals_t d
LEFT JOIN
    broker_firms_t bf
    ON d.broker_firm_id = bf.broker_firm_id
LEFT JOIN
    stella_common.menu_list_t ts
    ON d.transaction_style = ts.menu_id
LEFT JOIN
    stella_common.menu_list_t px
    ON d.primary_or_xs_id = px.menu_id
LEFT JOIN
    stella_common.menu_list_t s
    ON d.deal_status_id = s.menu_id
LEFT JOIN
    stella_common.risk_types_t rt
    ON d.risk_type_id = rt.risk_type_id
LEFT JOIN
    stella_common.risk_types_t rtm
    ON rt.risk_type_major_id__risk_types_t  = rtm.risk_type_id
LEFT JOIN
    stella_common.entities_t re
    ON d.budget_home_id = re.entity_id
LEFT JOIN
    law_firms_t blf1
    ON d.buyer_law_firm_1_id = blf1.law_firm_id
LEFT JOIN
    law_firms_t slf
    ON d.SellerLegalFirm = slf.law_firm_id
LEFT JOIN
    financial_advisors_t fa
    ON d.buyer_financial_firm_id = financial_advisor_id
LEFT JOIN
    stella_common.sectors_t tss
    ON d.target_super_sector_id = tss.sector_id
LEFT JOIN
    stella_common.sectors_t tsubs
    ON d.target_sub_sector_id = tsubs.sector_id
LEFT JOIN
    stella_common.underwriters_t np
    ON d.nbi_prepper = np.uw_id
LEFT JOIN
    stella_common.underwriters_t puw
    ON d.primary_uw = puw.uw_id
LEFT JOIN
    stella_common.underwriters_t au
    ON d.analyst_id = au.uw_id
LEFT JOIN
    stella_common.jurisdictions_t tlj
    ON d.TargetDomicile = tlj.jurisdiction_id

WHERE
    d.is_deleted = 0
    AND (NOT d.deal_status_id = 6 OR NOT d.deal_status_id = 436)
    AND d.create_date_year > (YEAR(NOW()) - 3)
    AND d.is_test_deal_id = 94;
