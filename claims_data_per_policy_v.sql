CREATE VIEW claims_data_per_policy_v AS
SELECT l.id policy_id
, IF (l.policy_no IS NOT NULL
    , l.policy_no
    , l.stella_policy_no
  ) policy_no
, l.layer_no
, l.deal_id
, c.claim_id
, c.claim_status
, c.claim_notice_date
, c.claim_notice_date ClaimDate
, c.claim_closed_date
, c.claim_closed_date ClaimClosedDate
, c.claim_currency
, c.relevant_exclusion_3
, c.relevant_exclusion_3 RelevantExclusion3
, c.relevant_exclusion_4
, c.relevant_exclusion_4 RelevantExclusion4
, c.comments

, d.buyer_business_name
, d.insured_legal_name
, d.spa_law
, d.deal_name
, d.inception_date
, d.currency_rate_deal
, d.program_summary
, d.drop_period
, ij.jurisdiction insured_jurisdiction
, d.target_desc
, tj.jurisdiction target_jurisdiction
, super_s.sector_name target_super_sector
, sub_s.sector_name target_sub_sector

, FORMAT(c.internal_advisor_fees / c.fx_rate_claim,0) internal_advisor_fees_eur
, FORMAT(d.ev / d.currency_rate_deal, 0) AS ev_eur
, FORMAT(d.total_rp_limit_on_deal / d.currency_rate_deal,0) AS total_rp_limit_on_deal_eur
, FORMAT(d.retention / d.currency_rate_deal,0) AS retention_eur
, FORMAT(d.retention / d.currency_rate_deal,0) AS drop_start_eur
, FORMAT(d.drop_end / d.currency_rate_deal,0) AS drop_end_eur
, FORMAT(c.claimed_loss / c.fx_rate_claim,0) claimed_amount_eur
, FORMAT(c.estimated_loss / c.fx_rate_claim,0) estimated_loss_eur
, FORMAT(c.final_loss / c.fx_rate_claim,0) final_loss_eur
, FORMAT((l.layer_limit * l.quota) / d.currency_rate_deal,0) policy_limit_eur
, FORMAT(l.attach / d.currency_rate_deal,0) underlying_limit_eur
, FORMAT(l.attach / d.currency_rate_deal + d.retention / d.currency_rate_deal,0) attachment_point_eur
, FORMAT(IF(c.claimed_loss / c.fx_rate_claim <= l.attach / d.currency_rate_deal + d.retention / d.currency_rate_deal
	,0,
	If(c.claimed_loss / c.fx_rate_claim >= l.attach / d.currency_rate_deal + d.retention / d.currency_rate_deal + l.layer_limit / 	d.currency_rate_deal,
		l.layer_limit / d.currency_rate_deal * l.quota,
	(c.claimed_loss / c.fx_rate_claim - l.attach / d.currency_rate_deal - d.retention / d.currency_rate_deal) * l.quota)),0) max_exposure_eur

, FORMAT(c.internal_advisor_fees / c.fx_rate_usd,0) internal_advisor_fees_usd
, FORMAT(d.ev / c.fx_rate_usd, 0) AS ev_usd
, FORMAT(d.total_rp_limit_on_deal / c.fx_rate_usd,0) AS total_rp_limit_on_deal_usd
, FORMAT(d.retention / c.fx_rate_usd,0) AS drop_start_usd
, FORMAT(d.drop_end / c.fx_rate_usd,0) AS drop_end_usd
, FORMAT(c.claimed_loss / c.fx_rate_usd,0) claimed_amount_usd
, FORMAT(c.estimated_loss / c.fx_rate_usd,0) estimated_loss_usd
, FORMAT(c.final_loss / c.fx_rate_usd,0) final_loss_usd
, FORMAT((l.layer_limit * l.quota) / c.fx_rate_usd,0) policy_limit_usd
, FORMAT(l.attach / c.fx_rate_usd,0) underlying_limit_usd
, FORMAT(l.attach / c.fx_rate_usd + d.retention / c.fx_rate_usd,0) attachment_point_usd
, FORMAT(IF(c.claimed_loss / c.fx_rate_usd <= l.attach / c.fx_rate_usd + d.retention / c.fx_rate_usd
	,0,
	If(c.claimed_loss / c.fx_rate_usd >= l.attach / c.fx_rate_usd + d.retention / c.fx_rate_usd + l.layer_limit / c.fx_rate_usd,
		l.layer_limit / c.fx_rate_usd * l.quota,
	(c.claimed_loss / c.fx_rate_usd - l.attach / c.fx_rate_usd - d.retention / c.fx_rate_usd) * l.quota)),0) max_exposure_usd

, FORMAT(c.indemnity_paid / c.fx_rate_claim,0)	indemnity_paid_eur

, b.business_name AS broker_firm
, pox.menu_item primary_or_xs
, cc1.menu_item AS claim_category_1_client_hr
, cc1.menu_item AS claimcategory1client_hr
, cc2.menu_item AS claim_category_2_client_hr
, cc2.menu_item AS claimcategory2client_hr
, cc3.menu_item AS claim_category_3_client_hr
, cc3.menu_item AS claimcategory3client_hr
, cc4.menu_item AS claim_category_4_client_hr
, cc4.menu_item AS claimcategory4client_hr
, re1.menu_item AS relevant_exclusion_1_hr
, re1.menu_item AS relevantexclusion1_hr
, re2.menu_item AS relevant_exclusion_2_hr
, re2.menu_item AS relevantexclusion2_hr
, rc.menu_item AS risk_consequence_hr
, rc.menu_item RiskFeel_hr

, rl.item_name AS risk_likelihood_hr
, ch.uw_initials AS claim_handler_hr
, cs.menu_item AS claim_status_hr

FROM layers_t l
LEFT JOIN
deals_t AS d
ON l.deal_id = d.deal_id
LEFT JOIN claims_t c ON c.deal_id = d.deal_id
LEFT JOIN
    broker_firms_t b
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
    ON c.risk_consequence = rc.menu_id
LEFT JOIN
    claim_menus_t AS rl
    ON c.risk_likelihood = rl.id
LEFT JOIN
    stella_common.menu_list_t pox
    ON d.primary_or_xs_id = pox.menu_id
LEFT JOIN
    stella_common.menu_list_t AS cs
    ON c.claim_status = cs.menu_id
LEFT JOIN
    stella_common.underwriters_t ch
    ON c.claim_handler = ch.uw_id
LEFT JOIN
    stella_common.jurisdictions_t ij
    ON d.insured_registered_country_id = ij.jurisdiction_id
LEFT JOIN
    stella_common.jurisdictions_t tj
    ON d.TargetDomicile = tj.jurisdiction_id
LEFT JOIN
    stella_common.sectors_t super_s
    ON d.target_super_sector_id = super_s.sector_id
LEFT JOIN
    stella_common.sectors_t sub_s
    ON d.target_sub_sector_id = sub_s.sector_id
WHERE
    c.is_deleted = 0
    AND l.is_deleted = 0
    AND l.rp_on_layer = 93
    AND d.is_deleted = 0
