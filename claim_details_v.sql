CREATE VIEW claim_details_v AS
SELECT
    c.claim_id
    , c.create_date
    , c.claim_creator
    , c.claim_handler
    , c.claim_name
    , c.c5_claim_no

    , c.claim_date
    , c.claim_jurisdiction
    , c.claim_category_1_client
    , c.claim_category_2_client
    , c.claim_category_3_client
    , c.claim_category_4_client
    , c.claim_category_1_final
    , c.claim_category_2_final
    , c.claim_category_3_final
    , c.claim_category_4_final
    , c.claim_category_1_result
    , c.claim_category_2_result
    , c.claim_category_3_result
    , c.claim_category_4_result
    , c.claim_closed_date
    , c.claim_status
    , c.claimed_loss
    , c.claim_currency
    , c.Comments
    , d.currency_rate_deal

    , c.deal_id
    , d.deal_currency
    , c.defence_costs

    , c.expenses_paid_rp
    , d.ev
    , FORMAT(d.ev / d.currency_rate_deal, 0) AS ev_eur
    , c.estimated_loss

    , c.final_loss
    , c.fx_rate_claim
    , c.investigation_costs_paid
    , c.internal_advisor_fees
    , FORMAT(c.internal_advisor_fees / c.fx_rate_claim,0) internal_advisor_fees_eur
    , c.is_third_party_demand_id
    , c.indemnity_paid
    , c.interests_paid

    , d.program_summary

    , c.relevant_exclusion_1
    , c.relevant_exclusion_2
    , c.relevant_exclusion_3
    , c.relevant_exclusion_4
    , c.risk_consequence
    , c.risk_likelihood

    , d.lowest_rp_attpoint
    , d.retention
    , d.drop_end
    , d.spa_law
    , d.deal_name
    , d.inception_date
    , d.drop_period
    , d.primary_or_xs_id primary_or_xs

    , d.target_desc
    , d.target_sub_sector_id sub_sector
    , d.target_super_sector_id super_sector
    , c.total_loss_paid
    , c.total_amount_paid
    , d.total_rp_limit_on_deal
    , d.total_rp_premium_on_deal


    , FORMAT(d.total_rp_limit_on_deal / d.currency_rate_deal,0) AS total_rp_limit_on_deal_eur
    , FORMAT(d.retention/ d.currency_rate_deal,0) AS drop_start_eur
    , FORMAT(d.drop_end / d.currency_rate_deal,0) AS drop_end_eur
    , FORMAT(c.claimed_loss / c.fx_rate_claim,0) claimed_amount_eur
    , FORMAT(c.estimated_loss / c.fx_rate_claim,0) estimated_loss_eur
    , FORMAT(c.final_loss / c.fx_rate_claim,0) final_loss_eur
    , b.business_name 		broker_firm_hr
    , layer.menu_item 		primary_or_xs_hr
    , cc1.menu_item claim_category_1_client_hr
    , cc2.menu_item claim_category_2_client_hr
    , cc3.menu_item claim_category_3_client_hr
    , cc4.menu_item claim_category_4_client_hr
    , re1.menu_item AS relevant_exclusion_1_hr
    , re2.menu_item AS relevant_exclusion_2_hr
    , rc.menu_item AS risk_consequence_hr
    , rl.item_name AS risk_likelihood_hr
    , ch.uw_initials AS claim_handler_hr
    , cc.uw_initials claim_creator_hr
    , cs.menu_item AS claim_status_hr

    -- to be deleted
    , d.insured_registered_country_id insured_jurisdiction
    , d.target_business_name
    , d.insured_legal_name
    , d.TargetDomicile target_jurisdiction

    -- end to be deleted

FROM claims_t c
LEFT JOIN
    deals_t d
    ON c.deal_id = d.deal_id
LEFT JOIN
    broker_firms_t b
    ON b.broker_firm_id = d.broker_firm_id
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
LEFT JOIN
    stella_common.menu_list_t re1
    ON c.relevant_exclusion_1 = re1. menu_id
LEFT JOIN
    stella_common.menu_list_t re2
    ON c.relevant_exclusion_2 = re2. menu_id
LEFT JOIN
    stella_common.menu_list_t rc
    on c.risk_consequence = rc. menu_id
LEFT JOIN
    stella_common.menu_list_t AS layer
    ON d.primary_or_xs_id = layer.menu_id
LEFT JOIN
    stella_common.menu_list_t AS cs
    ON c.claim_status = cs. menu_id
LEFT JOIN
    claim_menus_t rl
    on c.risk_likelihood = rl.id
LEFT JOIN
    stella_common.underwriters_t AS ch
    ON c.claim_handler = ch.uw_id
LEFT JOIN
    stella_common.underwriters_t cc
    ON c.claim_creator = cc.uw_id
WHERE
    c.is_deleted = 0
