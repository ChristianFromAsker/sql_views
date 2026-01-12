/*
For US,
    replace stella_eur.deals_t with stella_us.deals_t
    replace stella_eur.layers_t with stella_us.layers_t
*/

CREATE VIEW global_deal_list_eur_v AS

WITH policy_counts_eur AS (
  	SELECT p.deal_id, COUNT(p.id) policy_count
  	FROM stella_us.layers_t p
  	WHERE p.is_deleted = 0 AND p.rp_on_layer = 93
  	GROUP BY p.deal_id
)

SELECT
    d.deal_id

    , bf.business_name 	broker_firm
    , d.broker_firm_id
    , bc.jurisdiction 		budget_continent
    , bh.entity_business_name 	budget_home
    , d.budget_home_id
    , br.jurisdiction 		budget_region
    , br.jurisdiction_id	budget_region_id

    , d.closing_date
    , d.create_date
    , d.deal_name
    , ds.menu_item 	deal_status
    , d.deal_status_id

    , d.currency_date 	fx_date
    , d.currency_rate_deal 		fx_deal_eur
    , d.currency_rate_local		fx_local_eur
    , d.currency_rate_eurusd	fx_usd_eur

    , d.inception_date
    , d.insured_registered_country_id
    , irc.jurisdiction insured_registered_country

    , pds.menu_item 	parent_deal_status
    , p_uw.uw_name primary_uw_full_name
    , d.primary_or_xs_id
    , pox.menu_item primary_or_xs
    , d.program_limit / d.currency_rate_deal program_limit_eur
    , d.program_summary

    , d.risk_type_id
    , rt.risk_type_name 	risk_type
    , rtm.risk_type_name 	risk_type_major
    , rtm.risk_type_id 		risk_type_major_id

    , s_uw.uw_name second_uw_full_name
    , d.spa_signing_date
    , CAST(d.signing_invoice_amount / currency_rate_deal AS DECIMAL(14,0))		signing_invoice_amount_eur
    , d.spa_law
    , slr.jurisdiction spa_law_region

    , IF(
        d.target_super_sector_id = 1
        OR d.target_super_sector_id = 2
        OR d.target_super_sector_id = 7
        , 're_ren_infra'
        , 'operational '
    ) target_sector_group

    , wq.menu_item 	was_quoted
    , d.was_quoted_id

    , d.target_super_sector_id
    , ss.sector_name target_super_sector
    , d.target_sub_sector_id
    , sub_s.sector_name target_sub_sector
    , tj.jurisdiction target_jurisdiction
    , tjr.jurisdiction target_region

    , d.deal_currency
    , d.total_rp_premium_on_deal

    , COALESCE(pce.policy_count, 0) policy_count

    , CAST(d.counsel_fee_amount / currency_rate_deal AS DECIMAL(14,0)) 	counsel_fee_amount_eur
    , CAST(d.ev / currency_rate_deal AS DECIMAL(14,0)) 	ev_eur
    , CAST(lowest_rp_attpoint / currency_rate_deal AS DECIMAL(14,0)) 	lowest_rp_attpoint_eur
    , CAST(d.retention / d.currency_rate_deal AS DECIMAL(14,0)) 	retention_eur
    , CAST(d.total_rp_premium_on_deal / d.currency_rate_deal AS DECIMAL(15,0)) 	total_rp_premium_on_deal_eur
    , CAST(total_rp_limit_on_deal / currency_rate_deal AS DECIMAL(14,0)) 	total_rp_limit_on_deal_eur
    , CAST(d.total_rp_premium_on_deal / d.currency_rate_deal * d.currency_rate_local AS DECIMAL(14,0)) 	total_rp_premium_on_deal_local
    , CAST(d.total_rp_premium_on_deal / d.currency_rate_deal * currency_rate_eurusd AS DECIMAL(14,0)) 	total_rp_premium_on_deal_usd
    , CAST(d.uw_fee_amount / currency_rate_deal AS DECIMAL(14,0)) 	uw_fee_amount_eur
    , CAST((d.uw_fee_amount  - d.counsel_fee_amount) / currency_rate_deal AS DECIMAL(14,0)) 	uw_fee_we_keep_eur

    , slf.FirmName seller_law_firm
    , blf1.FirmName buyer_law_firm_1
    , blf2.FirmName buyer_law_firm_2

FROM
    stella_us.deals_t d
LEFT JOIN
    policy_counts_eur pce
    ON d.deal_id = pce.deal_id
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
    stella_common.menu_list_t wq
    ON d.was_quoted_id = wq.menu_id
LEFT JOIN
    stella_common.risk_types_t rt
    ON d.risk_type_id = rt.risk_type_id
LEFT JOIN
    stella_common.risk_types_t rtm
    ON rt.risk_type_major_id__risk_types_t  = rtm.risk_type_id
LEFT JOIN
    stella_common.entities_t bh
    ON d.budget_home_id = bh.entity_id
LEFT JOIN
    stella_common.jurisdictions_t bc
    ON bh.entity_continent_id__jurisdictions_t = bc.jurisdiction_id
LEFT JOIN
    stella_common.jurisdictions_t br
    ON bh.budget_region_id = br.jurisdiction_id
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
LEFT JOIN
    stella_eur.broker_firms_t bf
    ON d.broker_firm_id = bf.broker_firm_id
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
    stella_eur.law_firms_t blf1
    ON d.buyer_law_firm_1_id = blf1.law_firm_id
LEFT JOIN
    stella_eur.law_firms_t blf2
    ON d.buyer_law_firm_2_id = blf2.law_firm_id
LEFT JOIN
    stella_eur.law_firms_t slf
    ON d.SellerLegalFirm = slf.law_firm_id
LEFT JOIN stella_common.underwriters_t p_uw
    ON d.primary_uw = p_uw.uw_id
LEFT JOIN stella_common.underwriters_t s_uw
    ON d.secondary_uw = s_uw.uw_id

WHERE d.is_deleted = 0 AND d.is_test_deal_id = 94
