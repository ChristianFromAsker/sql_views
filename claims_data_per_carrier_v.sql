CREATE VIEW stella_us.claims_data_per_carrier_v AS
SELECT
IF (
    l.policy_no IS NULL
    , l.stella_policy_no
    , l.policy_no
) policy_no
, l.layer_no, l.deal_id
, c.claim_id
, c.claim_category_1_client
, c.claim_date
, c.claim_closed_date
, c.claim_currency
, c.relevant_exclusion_3
, c.relevant_exclusion_4
, c.comments
, d.spa_law
, d.deal_name
, d.inception_date, d.currency_rate_deal
, d.TargetDomicile target_jurisdiction_id, tj.jurisdiction target_jurisdiction
, d.insured_registered_country_id
, ij.jurisdiction insured_jurisdiction

, FORMAT(d.ev / d.currency_rate_deal, 0) AS ev_eur
, FORMAT(d.total_rp_limit_on_deal / d.currency_rate_deal,0) AS total_rp_limit_on_deal_eur
, FORMAT(d.retention / d.currency_rate_deal,0) AS retention_eur
, FORMAT((l.layer_limit * l.quota) / d.currency_rate_deal,0) policy_limit_eur
, CAST((l.layer_limit * l.quota * sec.quota / d.currency_rate_deal) AS DECIMAL(15,0)) carrier_limit_eur
, FORMAT(l.underlying_limit / d.currency_rate_deal,0) underlying_limit_eur
, FORMAT(l.underlying_limit / d.currency_rate_deal + d.retention / d.currency_rate_deal,0) attachment_point_eur

, CAST((c.internal_advisor_fees / c.fx_rate_claim) AS DECIMAL(15,0)) internal_advisor_fees_eur
, FORMAT(c.claimed_loss / c.fx_rate_claim,0) claimed_amount_eur
, CAST(c.estimated_loss / c.fx_rate_claim AS DECIMAL(15,0)) estimated_loss_eur
, CAST(c.estimated_loss / c.fx_rate_claim * sec.quota AS DECIMAL(15,0)) carrier_estimated_loss_eur
, FORMAT(c.final_loss / c.fx_rate_claim,0) final_loss_eur
, CAST(c.final_loss / c.fx_rate_claim * sec.quota AS DECIMAL(15,0)) carrier_final_loss_eur
, CAST(c.indemnity_paid / c.fx_rate_claim AS DECIMAL(15,0)) indemnity_paid_eur
, CAST(c.interests_paid / c.fx_rate_claim AS DECIMAL(15,0)) interests_paid_eur
, CAST(c.expenses_paid_rp / c.fx_rate_claim AS DECIMAL(15,0)) expenses_paid_eur
, CAST((c.indemnity_paid + c.expenses_paid_rp  + c.interests_paid)/ c.fx_rate_claim AS DECIMAL(15,0)) total_paid_eur

, CAST(IF(
c.claimed_loss / c.fx_rate_claim <= l.underlying_limit / d.currency_rate_deal + d.retention / d.currency_rate_deal
	,0
,If(
c.claimed_loss / c.fx_rate_claim >= (l.underlying_limit / d.currency_rate_deal + d.retention / d.currency_rate_deal + l.layer_limit / d.currency_rate_deal) * l.quota
,l.layer_limit / d.currency_rate_deal * l.quota
,(c.claimed_loss / c.fx_rate_claim - l.underlying_limit / d.currency_rate_deal - d.retention / d.currency_rate_deal) * l.quota
)
) AS DECIMAL(15,0)) total_max_exposure_eur

, sec.quota carrier_quota

, CAST(IF(
c.claimed_loss / c.fx_rate_claim <= l.underlying_limit / d.currency_rate_deal + d.retention / d.currency_rate_deal
	,0
,If(
c.claimed_loss / c.fx_rate_claim >= l.underlying_limit / d.currency_rate_deal + d.retention / d.currency_rate_deal + l.layer_limit / d.currency_rate_deal
,l.layer_limit / d.currency_rate_deal * l.quota * sec.quota
,(c.claimed_loss / c.fx_rate_claim - l.underlying_limit / d.currency_rate_deal - d.retention / d.currency_rate_deal) * l.quota * sec.quota
)
) AS DECIMAL(15,0)) carrier_max_exposure_eur
, ins.insurer_legal_name

, b.business_name AS broker_firm
, layer.menu_item primary_or_xs
, cc1.menu_item ClaimCategory1Client_hr
, cc2.menu_item ClaimCategory2Client_hr
, cc3.menu_item ClaimCategory3Client_hr
, cc4.menu_item ClaimCategory4Client_hr
, re1.menu_item RelevantExclusion1_hr
, re2.menu_item RelevantExclusion2_hr
, rf.menu_item RiskFeel_hr
, rl.item_name AS risk_likelihood_hr
, ch.uw_initials AS claim_handler_hr
, cs.menu_item AS claim_status_hr

FROM layers_t l
LEFT JOIN security_t sec ON sec.policy_id = l.id
LEFT JOIN stella_common.binders_t bin ON sec.binder_id  = bin.binder_id
LEFT JOIN stella_common.insurers_t ins ON bin.insurer_id = ins.id
LEFT JOIN deals_t AS d ON l.deal_id = d.deal_id
LEFT JOIN claims_t c ON c.deal_id = d.deal_id
LEFT JOIN broker_firms_t AS b ON d.broker_firm_id = b.broker_firm_id

LEFT JOIN stella_common.menu_list_t AS cc1 ON c.claim_category_1_client  = cc1.menu_id
LEFT JOIN stella_common.menu_list_t cc2 ON c.claim_category_2_client = cc2.menu_id
LEFT JOIN stella_common.menu_list_t cc3 ON c.claim_category_3_client  = cc3.menu_id
LEFT JOIN stella_common.menu_list_t cc4 ON c.claim_category_4_client = cc4.menu_id
LEFT JOIN stella_common.menu_list_t re1 ON c.relevant_exclusion_1 = re1.menu_id
LEFT JOIN stella_common.menu_list_t re2 ON c.relevant_exclusion_2 = re2.menu_id
LEFT JOIN stella_common.menu_list_t rf on c.risk_consequence = rf.menu_id
LEFT JOIN stella_common.menu_list_t layer on d.primary_or_xs_id = layer.menu_id
LEFT JOIN stella_common.menu_list_t cs ON c.claim_status = cs.menu_id

LEFT JOIN claim_menus_t AS rl ON c.risk_likelihood = rl.id
LEFT JOIN
stella_common.underwriters_t AS ch
ON c.claim_handler = ch.uw_id
LEFT JOIN stella_common.jurisdictions_t tj ON d.TargetDomicile = tj.jurisdiction_id
LEFT JOIN stella_common.jurisdictions_t ij ON d.insured_registered_country_id = ij.jurisdiction_id

WHERE c.is_deleted = 0
AND l.is_deleted = 0
AND l.rp_on_layer = 93
AND bin.is_deleted = 0
AND sec.on_policy_id = 93
AND sec.is_deleted = 0

ORDER BY policy_no
