CREATE VIEW live_deals_v AS
SELECT
    d.deal_id

    , d.analyst_id

    , bc.jurisdiction		budget_continent
    , bc.jurisdiction_id	budget_continent_id
    , bf.business_name 	broker_firm
    , bh.entity_business_name 		budget_home
    , d.budget_home_id
    , CONCAT(
        bf.business_name
        , '\r\n'
        , IFNULL(broker_person.PersonalName,'')
      )	broker_info
    , CONCAT(bh.entity_business_name, '\r\n', d.spa_law, ' law') budget_home_spa_law
    , br.jurisdiction 		budget_region
    , br.jurisdiction_id	budget_region_id
    , d.buyer_business_name
    , blf.FirmName 		buyer_law_firm_1

    , d.deal_currency
    , d.deal_info
    , d.deal_name
    , CONCAT(d.deal_name, '\r\n', bf.business_name)		deal_name_broker_firm
    , CONCAT(d.deal_name, '\r\n', rtm.risk_type_name)	deal_name_risk_type

    , d.deal_status_id
    , ds.menu_item 	deal_status
    , ds.menu_item_us 	deal_status_us

    , CONCAT(
        d.deal_currency
        , ROUND(CAST(d.ev AS DECIMAL(14,0))/1000000,0)
        , 'M'
        , '\r\n'
        , pox.menu_item
      )	ev_deal

    , CONCAT(
        d.quote_due_date
        , ' (' , dayname(d.quote_due_date), ') '
        , IFNULL(d.quote_due_time, '')
    ) nbi_deadline

    , d.primary_or_xs_id
    , pox.order_by 		primary_or_xs_order
    , d.primary_uw primary_uw_id

    , d.quote_due_date
    , d.quote_due_time

    , d.re_quote_info
    , rt.risk_type_name
    , rt.risk_type_id
    , rtm.risk_type_name 	risk_type_major
    , rtm.risk_type_id 		risk_type_major_id
    , CONCAT(
        IFNULL(np.uw_initials, '')
        , '\r\n', IFNULL(analyst.uw_initials, '')
        , '\r\n', IFNULL(p_uw.uw_initials, '')
        , '\r\n', IFNULL(s_uw.uw_initials, '')
    ) 	roles

    , d.spa_law
    , IF(
        d.nbi_prepper IS NULL,
        ds.menu_item,
        CONCAT(ds.menu_item, '\r\n', np.uw_initials)
    ) status_nbi_prepper
    , d.secondary_uw second_uw_id
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
        d.target_super_sector_id = 1 OR d.target_super_sector_id = 2
        , 'real_estate_plus'
        , 'operational'
    ) COLLATE utf8mb4_0900_ai_ci  AS target_sector_group_2

    , CONCAT(
        d.deal_currency
        , ' ', ROUND(CAST(d.total_rp_premium_on_deal AS DECIMAL(14,0))/1000,0), 'k'
    ) total_premium

    , CONCAT_WS('\r\n', uw_law_firm.FirmName, uw_law_person.personal_name) 	uw_counsel_info
    , d.uw_progress
    , d.uw_progress_latest_change

FROM
    deals_t d
LEFT JOIN
    broker_firms_t 			bf
    ON d.broker_firm_id = 	bf.broker_firm_id
LEFT JOIN
    broker_persons_t 		broker_person
    ON d.broker_person = 	broker_person.ID
LEFT JOIN
    stella_common.menu_list_t 	ds
    ON d.deal_status_id = 			ds.menu_id
LEFT JOIN
	law_firms_t 					blf
    ON d.buyer_law_firm_1_id = 	blf.law_firm_id
LEFT JOIN
    stella_common.entities_t 		bh
    ON d.budget_home_id = 		bh.entity_id
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
LEFT JOIN
    stella_common.menu_list_t 	pox
    ON d.primary_or_xs_id = 		pox.menu_id
LEFT JOIN
	law_firms_t 				uw_law_firm
	ON d.uw_law_firm_id = 	uw_law_firm.law_firm_id
LEFT JOIN
	lawyers_t 					uw_law_person
	ON d.UWCounselPerson1 =	uw_law_person.lawyer_id
WHERE
    d.is_deleted = 0
    AND d.is_test_deal_id = 94
    AND d.deal_status_id IN (3, 4, 5)
