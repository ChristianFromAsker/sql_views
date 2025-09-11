CREATE VIEW master_deal_list_v AS
SELECT 
d.deal_id

, bf.business_name 	broker_firm
, d.broker_firm_id
, bp.PersonalName 		broker_person
, d.broker_person 		broker_person_id
, bh.entity_business_name 		budget_home
, d.budget_home_id
, br.jurisdiction 			budget_region

, d.create_date

, d.deal_name
, ds.menu_item 	deal_status
, d.deal_status_id
, ds.menu_item_us 		deal_status_us 

, d.inception_date
	
, d.nbi_prepper 	nbi_prepper_id
	
, pox.menu_item 	primary_or_xs
, d.primary_or_xs_id
, d.primary_uw 		primary_uw_id
, uw.uw_initials 	primary_uw_initials

, risk_type.risk_type_name 		risk_type
, d.risk_type_id
, rtm.risk_type_name 	risk_type_major
, rtm.risk_type_id 		risk_type_major_id

, d.secondary_uw 	second_uw_id
, suw.uw_initials 	second_uw_initials
, d.spa_law
, stage.menu_item 		stage
, d.submission_date

, d.UwCounselPerson1 	uw_counsel_person_1_id
, uc.personal_name 		uw_counsel_person_1
, d.was_quoted_id



, d.quote_due_time
, IF(
	d.quote_due_time IS NULL
, DATE_FORMAT(d.quote_due_date, "%a %b, %e/%y")
, CONCAT(DATE_FORMAT(d. quote_due_date, "%a %b, %e/%y"), "\r\n" , d.quote_due_time)  
) nbi_deadline_us

, d.program_summary
, d.comments
, d.submission_notes
, d.deal_info
, qd.menu_item was_quoted

, d.target_business_name
, d.target_legal_name
, d.target_super_sector_id
, d.target_sub_sector_id, sup_s.sector_name target_super_sector, sub_s.sector_name target_sub_sector
, tlj.jurisdiction target_legal_jurisdiction
, d.target_desc

, d.buyer_business_name
, d.insured_legal_name, d.UltimateBuyer
, BuyerDomicile, d.insured_registered_country_id, irc.Jurisdiction insured_registered_country
, d.seller_business_name, d.UltimateSeller
, d.SellerLegalFirm seller_law_firm_id
, d.buyer_law_firm_1_id
, d.buyer_law_firm_2_id
, slf.FirmName seller_law_firm
, blf1.FirmName buyer_law_firm_1
, blf2.FirmName buyer_law_firm_2

, d.uw_fee_amount
, d.signing_invoice_amount
, d.initial_premium_received
, d.PremiumReceived premium_received

, d.currency_rate_deal
, d.currency_rate_local
, d.deal_currency
, d.drop_end
, d.drop_period
, d.retention
, CAST(d.retention / d.currency_rate_deal AS DECIMAL(14,0)) retention_eur
, d.max_limit_quoted
, d.program_limit

, d.total_rp_premium_on_deal
, CAST(d.total_rp_premium_on_deal / d.currency_rate_deal AS DECIMAL(14,0)) total_rp_premium_on_deal_eur
, CAST(d.total_rp_premium_on_deal / d.currency_rate_deal * currency_rate_eurusd AS DECIMAL(14,0)) total_rp_premium_on_deal_usd

, d.ev
, CAST(ev / d.currency_rate_deal AS DECIMAL(14,0)) ev_eur
, CAST(ev / d.currency_rate_deal * currency_rate_eurusd AS DECIMAL(14,0)) ev_usd

, d.total_rp_limit_on_deal
, CAST(d.total_rp_limit_on_deal / d.currency_rate_deal AS DECIMAL(14,0)) total_rp_limit_on_deal_eur
, CAST(d.total_rp_limit_on_deal / d.currency_rate_deal * d.currency_rate_eurusd AS DECIMAL(14,0)) total_rp_limit_on_deal_usd

, d.lowest_rp_attpoint
, CAST(lowest_rp_attpoint / currency_rate_deal AS DECIMAL(14,0)) lowest_rp_attpoint_eur

, tags.deal_tags

FROM deals_t d
LEFT JOIN 
	stella_common.entities_t bh 
	ON d.budget_home_id = bh.entity_id
LEFT JOIN 
stella_common.jurisdictions_t br 
ON bh.budget_region_id = br.jurisdiction_id
LEFT JOIN 
stella_common.menu_list_t ds 
ON d.deal_status_id = ds.menu_id
LEFT JOIN stella_common.menu_list_t pox ON d.primary_or_xs_id = pox.menu_id
LEFT JOIN 
stella_common.menu_list_t stage 
ON d.stage = stage.menu_id
LEFT JOIN 
stella_common.risk_types_t risk_type 
ON d.risk_type_id = risk_type.risk_type_id
LEFT JOIN stella_common.risk_types_t rtm ON risk_type.risk_type_major_id__risk_types_t  = rtm.risk_type_id
LEFT JOIN stella_common.menu_list_t qd ON d.was_quoted_id = qd.menu_id
LEFT JOIN broker_firms_t bf ON d.broker_firm_id = bf.broker_firm_id
LEFT JOIN broker_persons_t bp ON d.broker_person = bp.ID
LEFT JOIN law_firms_t blf1 ON d.buyer_law_firm_1_id = blf1.law_firm_id
LEFT JOIN law_firms_t blf2 ON d.buyer_law_firm_2_id = blf2.law_firm_id
LEFT JOIN law_firms_t slf ON d.SellerLegalFirm = slf.law_firm_id
LEFT JOIN lawyers_t uc ON d.UwCounselPerson1 = uc.lawyer_id
LEFT JOIN stella_common.underwriters_t uw ON d.primary_uw = uw.uw_id
LEFT JOIN stella_common.underwriters_t suw ON d.secondary_uw = suw.uw_id
LEFT JOIN stella_common.sectors_t sup_s ON d.target_super_sector_id = sup_s.sector_id
LEFT JOIN stella_common.sectors_t sub_s ON d.target_sub_sector_id = sub_s.sector_id
LEFT JOIN stella_common.jurisdictions_t tlj ON d.TargetDomicile = tlj.jurisdiction_id
LEFT JOIN stella_common.jurisdictions_t ic ON d.BuyerDomicile = ic.jurisdiction_id
LEFT JOIN stella_common.jurisdictions_t irc ON d.insured_registered_country_id = irc.jurisdiction_id
LEFT JOIN (
   	SELECT
      	kw.deal_id__deals_t AS deal_id,
      GROUP_CONCAT(tkw.tag_name ORDER BY tkw.tag_name ASC SEPARATOR ', ') AS deal_tags
    	FROM deal_tags_t kw
    	JOIN 
stella_common.template_deal_tags_t tkw
ON kw.keyword_id__template_keywords_t = tkw.tag_id
WHERE kw.is_deleted = 0
GROUP BY kw.deal_id__deals_t
) tags ON tags.deal_id = d.deal_id

WHERE d.is_deleted = 0

