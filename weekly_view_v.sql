CREATE VIEW weekly_view_v AS
SELECT
    d.deal_id

    , d.aim_for_xs
    , d.analyst_id
    , analyst.uw_name analyst_full_name

    , bc.jurisdiction		budget_continent
    , bc.jurisdiction_id	budget_continent_id
    , bf.business_name 	broker_firm
    , bh.entity_business_name 		budget_home
    , d.budget_home_id
    , CONCAT_WS(
        '\r\n'
        , bf.business_name
        , broker_person.PersonalName
    ) 	broker_info
    , CONCAT(bh.entity_business_name, '\r\n', d.spa_law, ' law')
    budget_home_spa_law
    , br.jurisdiction 		budget_region
    , br.jurisdiction_id	budget_region_id
    , d.buyer_business_name
    , blf.FirmName buyer_law_firm_1

    , d.create_date

    , d.deal_currency
    , d.deal_info
    , d.deal_name
    , CONCAT(d.deal_name, '\r\n', bf.business_name)			deal_name_broker_firm
    , CONCAT_WS('\r\n', d.deal_name, rt.risk_type_name)	deal_name_risk_type

    , d.deal_status_id 	status_id
    , ds.menu_item 	    deal_status
     , IF(d.aim_for_xs = 'yes',CONCAT(ds.menu_item, ' - aim for xs' ), ds.menu_item_us) deal_status_xs
    , ds.menu_item_us 	deal_status_us
    , IF(d.aim_for_xs = 'yes',CONCAT(ds.menu_item_us, ' - aim for xs' ), ds.menu_item_us) deal_status_us_xs

    , CONCAT(d.deal_currency, ' ', ROUND(CAST(d.ev AS DECIMAL(14,0))/1000000,0), 'M')  	ev_deal
    , CONCAT(ROUND(CAST(d.ev / d.currency_rate_deal AS DECIMAL(14,0))/1000000,0), 'M')  	ev_eur
    , CONCAT(ROUND(CAST(d.ev / d.currency_rate_deal * d.currency_rate_local AS DECIMAL(14,0))/1000000,0), 'M')  	ev_local

    , d.is_repeat_buyer

    , d.max_limit_quoted
    , CONCAT(
        d.quote_due_date, ' (' , dayname(d.quote_due_date), ') ', IFNULL(d.quote_due_time, '')
    ) nbi_deadline
    , d.nbi_prepper		nbi_prepper_id
    , np.uw_name nbi_prepper_full_name

    , d.primary_uw
    , p_uw.uw_name primary_uw_full_name

    , d.quote_due_date
    , d.quote_due_time

    , d.re_quote_info
    , rt.risk_type_name risk_type
    , rt.risk_type_name
    , rt.risk_type_id
    , rtm.risk_type_name 	risk_type_major
    , rtm.risk_type_id 		risk_type_major_id

    , d.secondary_uw
    , s_uw.uw_name second_uw_full_name
    , d.spa_law
    , IF(
    d.nbi_prepper IS NULL,
    ds.menu_item,
    CONCAT(ds.menu_item, '\r\n', np.uw_initials)
    ) status_nbi_prepper
    , d.submission_limits
    , d.submission_notes
    , d.submission_date

    , d.target_business_name
    , d.target_desc

    , IF(d.target_super_sector_id IN (1,2,7)
    , 're_ren_infra'
    , 'operational'
    ) target_sector_group

    , IF(
    d.target_super_sector_id = 1
    OR d.target_super_sector_id = 2
    , 'real_estate_plus'
    , 'operational'
    ) COLLATE utf8mb4_0900_ai_ci  AS target_sector_group_2

    , CONCAT('Week ', WEEK(
        IF(
            d.quote_due_date IS NULL,
            d.submission_date,
            d.quote_due_date
        )
    ) + 1) week_no
    , WEEK(IF(
        d.quote_due_date IS NULL,
        d.submission_date,
        d.quote_due_date
    )) week_no_number

    , CONCAT(
        IFNULL(np.uw_initials, '')
        , '\r\n', IFNULL(analyst.uw_initials, '')
        , '\r\n', IFNULL(p_uw.uw_initials, '')
        , '\r\n', IFNULL(s_uw.uw_initials, '')
    ) 	roles

FROM deals_t d
LEFT JOIN
    stella_common.menu_list_t ds
    ON d.deal_status_id = ds.menu_id
LEFT JOIN
    broker_firms_t bf
    ON d.broker_firm_id = bf.broker_firm_id
LEFT JOIN
    broker_persons_t broker_person
    ON d.broker_person = broker_person.ID
LEFT JOIN
	law_firms_t blf
    ON d.buyer_law_firm_1_id = blf.law_firm_id
LEFT JOIN
    stella_common.entities_t bh
    ON d.budget_home_id = bh.entity_id
LEFT JOIN
    stella_common.jurisdictions_t br
    ON bh.budget_region_id = br.jurisdiction_id
LEFT JOIN
    stella_common.jurisdictions_t bc
    ON bh.entity_continent_id__jurisdictions_t = bc.jurisdiction_id
LEFT JOIN
    stella_common.underwriters_t np
    ON d.nbi_prepper = np.uw_id
LEFT JOIN
stella_common.underwriters_t analyst
ON d.analyst_id = analyst.uw_id
LEFT JOIN
    stella_common.underwriters_t p_uw
    ON d.primary_uw = p_uw.uw_id
LEFT JOIN
    stella_common.underwriters_t s_uw
    ON d.secondary_uw = s_uw.uw_id
LEFT JOIN
    stella_common.risk_types_t rt
    ON d.risk_type_id = rt.risk_type_id
LEFT JOIN
    stella_common.risk_types_t rtm
    ON rt.risk_type_major_id__risk_types_t  = rtm.risk_type_id

WHERE
    d.is_deleted = 0
    AND d.create_date >= (CURRENT_DATE - INTERVAL 2 YEAR)
    AND d.is_test_deal_id = 94
