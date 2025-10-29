CREATE VIEW global_policy_list_eur_v AS
SELECT
    p.id
    , p.id policy_id

    , p.broker_commission
    , bf.business_name broker_firm
    , d.budget_home_id
    , d.broker_firm_id
    , d.buyer_business_name

    , d.closing_date
    , d.create_date

    , d.currency_date 	fx_date
    , d.currency_rate_deal 		fx_deal_eur
    , d.currency_rate_local		fx_local_eur
    , d.currency_rate_eurusd	fx_usd_eur

    , p.deal_id
    , d.deal_name
    , ds.menu_item deal_status
    , d.deal_status_id

    , d.inception_date
    , ie.entity_business_name issuing_entity
    , p.issuing_entity_id
    , d.insured_registered_country_id
    , irc.jurisdiction insured_registered_country

    , IF(
        p.layer_no = 0
        , 'Primary'
        , 'XS'
    ) layer_group
    , p.layer_limit
    , p.layer_no

    , navins.navins_home navins_home
    , p.navins_home_id

    , pds.menu_item parent_deal_status
    , IF (p.policy_no IS NOT NULL, p.policy_no, p.stella_policy_no) policy_no
    , CAST(p.quota * p.layer_limit AS DECIMAL(15,0)) policy_limit
    , CAST(p.quota * p.layer_limit / d.currency_rate_deal AS DECIMAL(15,0)) policy_limit_eur
    , p.policy_premium
    , CAST(p.policy_premium / d.currency_rate_deal AS DECIMAL(15,0)) policy_premium_eur

    , p.quota

    , IF(
        d.target_super_sector_id = 1
        OR d.target_super_sector_id = 2
        OR d.target_super_sector_id = 7
        , 're_ren_infra'
        , 'operational '
    ) target_sector_group

    , p.underlying_limit
    , CAST(p.underlying_limit / d.currency_rate_deal AS DECIMAL(15,0)) underlying_limit_eur

    , bc.jurisdiction budget_continent
    , bh.budget_home_name budget_home
    , br.jurisdiction budget_region

    , d.primary_or_xs_id
    , pox.menu_item primary_or_xs
    , d.risk_type_id
    , rt.risk_type_name risk_type
    , rtm.risk_type_name risk_type_major
    , rtm.risk_type_id risk_type_major_id

    , d.target_business_name
    , d.target_super_sector_id
    , ss.sector_name target_super_sector
    , d.target_sub_sector_id
    , sub_s.sector_name target_sub_sector
    , tj.jurisdiction target_jurisdiction
    , tjr.jurisdiction target_region

    , d.spa_law
    , slr.jurisdiction spa_law_region
    , d.deal_currency
    , d.retention

    , CAST(d.retention / d.currency_rate_deal AS DECIMAL(15,0))retention_eur
    , d.total_rp_premium_on_deal
    , CAST(d.total_rp_premium_on_deal / d.currency_rate_deal AS DECIMAL(15,0)) total_rp_premium_on_deal_eur
    , CAST(d.total_rp_limit_on_deal / d.currency_rate_deal AS DECIMAL(14,0)) total_rp_limit_on_deal_eur
    , CAST(d.lowest_rp_attpoint / d.currency_rate_deal AS DECIMAL(14,0)) lowest_rp_attpoint_eur

    , p.fundamental_limit
    , CAST(p.fundamental_limit * p.quota / d.currency_rate_deal AS DECIMAL(14,0)) policy_fundamental_limit_eur
    , CAST(p.fundamental_premium / d.currency_rate_deal AS DECIMAL(14,0)) fundamental_premium_eur
    , CAST((p.quota * (p.layer_limit - p.fundamental_limit) / d.currency_rate_deal) AS DECIMAL(14,0)) policy_general_limit_eur
    , CAST((p.policy_premium - p.fundamental_premium) / d.currency_rate_deal AS DECIMAL(14,0)) general_premium_eur

    , CAST(d.ev / d.currency_rate_deal AS DECIMAL(14,0)) ev_eur

FROM stella_.layers_t p
LEFT JOIN
    stella_.deals_t d
    ON p.deal_id = d.deal_id
LEFT JOIN
    stella_.broker_firms_t bf
    ON d.broker_firm_id = bf.broker_firm_id
LEFT JOIN
    stella_common.deal_statuses_t ds
    ON d.deal_status_id = ds.menu_id
LEFT JOIN
    stella_common.deal_statuses_t pds
    ON ds.parent_status_eur_id = pds.menu_id
LEFT JOIN
    stella_common.menu_list_t pox
    ON d.primary_or_xs_id = pox.menu_id
LEFT JOIN
    stella_common.risk_types_t rt
    ON d.risk_type_id = rt.risk_type_id
LEFT JOIN
    stella_common.risk_types_t rtm
    ON rt.risk_type_major_id__risk_types_t  = rtm.risk_type_id
LEFT JOIN
    stella_common.navins_homes_t navins
    ON p.navins_home_id = navins.home_id
LEFT JOIN
    stella_common.entities_t ie
    ON p.issuing_entity_id = ie.entity_id
LEFT JOIN
    stella_common.budget_homes_t bh
    ON d.budget_home_id = bh.budget_home_id
LEFT JOIN
    stella_common.jurisdictions_t bc
    ON bh.budget_continent_id__jurisdictions_t = bc.jurisdiction_id
LEFT JOIN
    stella_common.jurisdictions_t br
    ON bh.budget_region_id__jurisdictions_t = br.jurisdiction_id
LEFT JOIN
    stella_common.sectors_t ss
    ON d.target_super_sector_id = ss.sector_id
LEFT JOIN
    stella_common.sectors_t sub_s
    ON d.target_sub_sector_id = sub_s.sector_id
LEFT JOIN
    stella_common.jurisdictions_t irc
    ON d.insured_registered_country_id = irc.jurisdiction_id
LEFT JOIN
    stella_common.jurisdictions_t tj
    ON d.TargetDomicile = tj.jurisdiction_id
LEFT JOIN
	stella_common.jurisdictions_t tjr
    ON tj.rp_region_id = tjr.jurisdiction_id
LEFT JOIN
	stella_common.jurisdictions_t sl
    ON d.spa_law = sl.jurisdiction
LEFT JOIN
	stella_common.jurisdictions_t slr
    ON sl.rp_region_id = slr.jurisdiction_id

WHERE
    p.rp_on_layer = 93
    AND p.is_deleted = 0
    AND d.is_deleted = 0
    AND d.is_test_deal_id = 94
