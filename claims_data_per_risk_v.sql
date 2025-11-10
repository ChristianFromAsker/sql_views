CREATE VIEW claims_data_per_risk_v AS
SELECT
    c.claim_id
    , bf.business_name broker_firm
    , c.claim_status
    , c.claim_date
    , c.claim_date ClaimDate
    , c.claim_closed_date
    , c.claim_closed_date ClaimClosedDate
    , FORMAT(c.claimed_loss / c.fx_rate_claim,0) claimed_amount_eur
    , c.comments
    , c.claim_currency
    , d.currency_rate_deal

    , d.deal_currency
    , d.deal_id
    , d.deal_name
    , d.drop_end
    , d.drop_period

    , FORMAT(c.estimated_loss / c.fx_rate_claim,0) estimated_loss_eur
    , d.ev
    , FORMAT(d.ev / d.currency_rate_deal, 0) AS ev_eur
    , FORMAT(d.ev / c.fx_rate_usd, 0) AS ev_usd

    , FORMAT(c.final_loss / c.fx_rate_claim,0) final_loss_eur

    , d.inception_date
    , irj.jurisdiction insured_registered_country
    , d.insured_registered_country_id
    , c.internal_advisor_fees

    , d.lowest_rp_attpoint
    , CAST(d.lowest_rp_attpoint / d.currency_rate_deal AS DECIMAL(18,0)) lowest_rp_attpoint_eur

    , pox.menu_item primary_or_xs
    , p_uw.uw_name primary_uw_full_name
    , d.primary_uw primary_uw_id
    , d.program_summary

    , c.relevant_exclusion_3
    , c.relevant_exclusion_4
    , d.retention
    , FORMAT(d.retention / d.currency_rate_deal,0) AS retention_eur
    , rc. menu_item risk_consequence
    , c.risk_consequence risk_consequence_id

    , d.secondary_uw second_uw_id
    , s_uw.uw_name second_uw_full_name
    , d.spa_law

    , d.target_desc
    , trj.jurisdiction target_registered_country
    , d.TargetDomicile target_registered_country_id
    , d.target_sub_sector_id
    , t_sub.sector_name target_sub_sector
    , d.target_super_sector_id
    , t_sup.sector_name target_super_sector
    , d.total_rp_limit_on_deal
    , CAST(d.total_rp_limit_on_deal / d.currency_rate_deal AS DECIMAL(18,0)) total_rp_limit_on_deal_eur
    , d.total_rp_premium_on_deal
    , d.total_rp_premium_on_deal / d.currency_rate_deal total_rp_premium_on_deal_eur

    , d.target_business_name

    , FORMAT(c.internal_advisor_fees / c.fx_rate_usd,0) internal_advisor_fees_usd
    , FORMAT(d.total_rp_limit_on_deal / c.fx_rate_usd,0) AS total_rp_limit_on_deal_usd
    , FORMAT(d.retention / c.fx_rate_usd,0) AS drop_start_usd
    , FORMAT(d.drop_end / c.fx_rate_usd,0) AS drop_end_usd
    , FORMAT(c.claimed_loss / c.fx_rate_usd,0) claimed_amount_usd
    , FORMAT(c.estimated_loss / c.fx_rate_usd,0) estimated_loss_usd
    , FORMAT(c.final_loss / c.fx_rate_usd,0) final_loss_usd
    , b.business_name AS broker_firm_hr
    , layer.menu_item AS primary_or_xs_hr
    , cc1.menu_item AS claim_category_1_client_hr
    , cc2.menu_item AS claim_category_2_client_hr
    , cc3.menu_item AS claim_category_3_client_hr
    , cc4.menu_item AS claim_category_4_client_hr
    , re1.menu_item AS relevant_exclusion_1_hr
    , re2.menu_item AS relevant_exclusion_2_hr
    , rc.menu_item AS risk_consequence_hr
    , rl.item_name AS risk_likelihood_hr

    , ch.uw_initials claim_handler_hr
    , cc.uw_initials claim_creator_hr

    , cs.menu_item AS claim_status_hr

FROM claims_t c
LEFT JOIN
    deals_t d
    ON c.deal_id = d.deal_id
LEFT JOIN
    broker_firms_t bf
    ON d.broker_firm_id = bf.broker_firm_id
LEFT JOIN
    stella_common.jurisdictions_t irj
    ON d.insured_registered_country_id = irj.jurisdiction_id
LEFT JOIN
    stella_common.menu_list_t pox
    ON d.primary_or_xs_id = pox.menu_id
LEFT JOIN
    stella_common.sectors_t t_sub
    ON d.target_sub_sector_id = t_sub.sector_id
LEFT JOIN
    stella_common.sectors_t t_sup
    ON d.target_super_sector_id = t_sup.sector_id
LEFT JOIN
    stella_common.jurisdictions_t trj
    ON d.TargetDomicile = trj.jurisdiction_id
LEFT JOIN
    broker_firms_t AS b
    ON b.broker_firm_id = d.broker_firm_id
LEFT JOIN
    stella_common.menu_list_t AS cc1
    ON c.claim_category_1_client  = cc1.menu_id
LEFT JOIN
    stella_common.menu_list_t AS cc2
    ON c.claim_category_2_client = cc2.menu_id
LEFT JOIN
    stella_common.menu_list_t AS cc3
    ON c.claim_category_3_client  = cc3.menu_id
LEFT JOIN
    stella_common.menu_list_t AS cc4
    ON c.claim_category_4_client = cc4.menu_id
LEFT JOIN
    stella_common.menu_list_t AS re1
    ON c.relevant_exclusion_1 = re1.menu_id
LEFT JOIN
    stella_common.menu_list_t AS re2
    ON c.relevant_exclusion_2 = re2.menu_id
LEFT JOIN
    stella_common.menu_list_t AS rc
    on c.risk_consequence = rc.menu_id
LEFT JOIN
    stella_common.claim_menus_t AS rl
    on c.risk_likelihood = rl.id
LEFT JOIN
    stella_common.menu_list_t AS layer
    on d.primary_or_xs_id = layer.menu_id
LEFT JOIN
    stella_common.menu_list_t AS cs
    ON c.claim_status = cs.menu_id
LEFT JOIN
    stella_common.underwriters_t ch
    ON c.claim_handler = ch.uw_id
LEFT JOIN
    stella_common.underwriters_t p_uw
    ON d.primary_uw = p_uw.uw_id
LEFT JOIN
    stella_common.underwriters_t s_uw
    ON d.secondary_uw = s_uw.uw_id
LEFT JOIN
    stella_common.underwriters_t cc
    ON c.claim_creator = cc.uw_id
WHERE
    c.is_deleted = 0
