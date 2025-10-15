CREATE VIEW claim_details_v AS
SELECT c.*
, d.program_summary
, d.deal_currency
, d.ev
, d.currency_rate_deal
, d.lowest_rp_attpoint
, d.drop_start
, d.drop_end
, d.spa_law
, d.deal_name
, d.inception_date
, d.drop_period
, d.target_desc
, d.target_business_name
, d.insured_legal_name
, d.total_rp_limit_on_deal, d.total_rp_premium_on_deal
, FORMAT(c.internal_advisor_fees / c.fx_rate_claim,0) internal_advisor_fees_eur
, FORMAT(d.ev / d.currency_rate_deal, 0) AS ev_eur
, FORMAT(d.total_rp_limit_on_deal / d.currency_rate_deal,0) AS total_rp_limit_on_deal_eur
, FORMAT(d.drop_start / d.currency_rate_deal,0) AS drop_start_eur
, FORMAT(d.drop_end / d.currency_rate_deal,0) AS drop_end_eur
, FORMAT(c.claimed_loss / c.fx_rate_claim,0) claimed_amount_eur
, FORMAT(c.estimated_loss / c.fx_rate_claim,0) estimated_loss_eur
, FORMAT(c.final_loss / c.fx_rate_claim,0) final_loss_eur
, b.business_name 		broker_firm_hr
, layer.menu_item 		primary_or_xs_hr
, cc1.menu_item 		claim_category_1_client_hr
, cc2.menu_item 		claim_category_2_client_hr
, cc3.menu_item 		claim_category_3_client_hr
, cc4.menu_item AS claim_category_4_client_hr
, re1.menu_item AS relevant_exclusion_1_hr
, re2.menu_item AS relevant_exclusion_2_hr
, rc.menu_item AS risk_consequence_hr
, rl.item_name AS risk_likelihood_hr
, ch.uw_initials AS claim_handler_hr
, cc.uw_initials claim_creator_hr
, cs.menu_item AS claim_status_hr
, c5h.menu_item c5_home_hr

FROM claims_us_t c
LEFT JOIN
    deals_t d
    ON c.deal_id = d.deal_id
LEFT JOIN
    broker_firms_t b
    ON b.broker_firm_id = d.broker_firm
LEFT JOIN
    stella_common.menu_list_t cc1
    ON c.claim_category_1_client  = cc1.menu_id
LEFT JOIN
    stella_common.menu_list_t cc2
    ON c.claim_category_2_client = cc2. menu_id
LEFT JOIN
    stella_common.menu_list_t cc3
    ON c.claim_category_3_client  = cc3. menu_id
LEFT JOIN
    stella_common.menu_list_t cc4
    ON c.claim_category_4_client = cc4. menu_id
LEFT JOIN stella_common.menu_list_t AS re1 ON c.relevant_exclusion_1 = re1. menu_id
LEFT JOIN stella_common.menu_list_t AS re2 ON c.relevant_exclusion_2 = re2. menu_id
LEFT JOIN stella_common.menu_list_t AS rc on c.risk_consequence = rc. menu_id
LEFT JOIN
    stella_common.menu_list_t AS layer
    ON d.primary_or_xs_id = layer.menu_id
LEFT JOIN
    stella_common.menu_list_t AS cs
    ON c.claim_status = cs. menu_id
LEFT JOIN
    stella_common.menu_list_t c5h
    ON d.c5home = c5h.menu_id
LEFT JOIN claim_menus_t AS rl on c.risk_likelihood = rl.id
LEFT JOIN
stella_common.underwriters_t AS ch
ON c.claim_handler = ch.uw_id
LEFT JOIN
stella_common.underwriters_t AS cc
ON c.claim_creator = cc.uw_id
WHERE c.is_deleted = 0
