CREATE VIEW risk_details_f_v AS
SELECT d.deal_id

    , d.analyst_id
    , analyst.uw_initials 	analyst_initials
    , analyst.uw_name 		analyst_full_name

    , bf.business_name 	broker_firm
    , d.broker_firm_id
    , d.broker_person

    , d.create_date
    , d.creating_uw creating_uw_id
    , cu.uw_name creating_uw
    , d.currency_date_manual

    , d.deal_name
    , d.deal_stage_id
    , ds.menu_item 	deal_status
    , d.deal_status_id

    , d.fx_buffer

    , d.internal_approver internal_approver_quote_id
    , iaq.uw_name internal_approver_quote_full_name
    , d.internal_approver_at_signing internal_approver_binding_id
    , iab.uw_name internal_approver_binding_full_name
    , d.inception_date
    , d.is_test_deal_id

    , nbi_prepper.uw_name 	nbi_prepper
    , d.nbi_prepper 	nbi_prepper_id

    , uw.uw_name 		primary_uw_full_name
    , d.primary_uw 		primary_uw_id

    , d.quote_due_date

    , d.risk_feel_id
    , risk_type.risk_type_name 		risk_type
    , d.risk_type_id
    , rtm.risk_type_name 	risk_type_major
    , rtm.risk_type_id 	risk_type_major_id

    , d.secondary_uw 	secondary_uw_id
    , suw.uw_name 	secondary_uw_full_name
    , d.spa_law
    , d.stage

    , d.was_quoted_id

    , d.primary_or_xs_id
    , pox.menu_item primary_or_xs
    , d.budget_home_id
    , bh.entity_business_name budget_home
    , d.program_limit
    , d.primary_insurer
    , ins.insurer_business_name primary_insurer_hr
    , d.retention
    , d.drop_end
    , d.drop_period
    , d.policy_period_in_months

    , d.deal_currency
    , d.EV
    , d.target_legal_name
    , d.target_business_name
    , d.TargetDomicile
    , d.target_desc
    , d.target_super_sector_id
    , sup_s.sector_name target_super_sector
    , d.target_sub_sector_id
    , sub_s.sector_name target_sub_sector
    , d.target_sic_code
    , d.target_naic_code
    , d.target_main_jurisdiction_id
    , d.spa_signing_date
    , d.closing_date

    , d.buyer_financial_firm_id
    , d.buyer_law_firm_1_id
    , blf1.FirmName buyer_law_firm_1
    , d.buyer_law_firm_2_id
    , blf2.FirmName buyer_law_firm_2
    , d.uw_law_firm_id
    , d.UwCounselPerson1
    , d.uw_financial_advisor_id
    , d.UwCounselPerson2

    , d.submission_notes reviewer_notes
    , d.deal_info
    , d.submission_limits

    , d.surplus_broker_firm
    , d.surplus_broker_person
    , d.surplus_broker_license_no
    , d.us_producer_no
    , d.is_underwritten
    , d.MessageBoard
    , d.Comments
    , d.program_summary

    , d.vat_home

    , d.submission_date

    , d.insured_legal_name
    , d.insured_registered_country_id
    , irc.jurisdiction insured_registered_country
    , d.insured_navins_code
    , d.insured_main_region_id
    , d.buyer_business_name
    , d.UltimateBuyer
    , d.BuyerDomicile

    , d.seller_business_name
    , d.UltimateSeller
    , d.SellerDomicile
    , d.SellerLegalFirm

    , d.ClosingBooked
    , d.CounselInvoiceReceived
    , d.CounselInvoiceHandled
    , d.VDRReceived
    , d.VDRPassword
    , d.PremiumReceived
    , d.closing_set_received_id

    , d.currency_rate_deal
    , d.currency_rate_local
    , d.currency_date
    , d.lowest_rp_attpoint

    , d.uw_fee_amount
    , d.uw_fee_due_date
    , d.uw_fee_received_date
    , d.counsel_fee_due_date
    , d.counsel_fee_amount
    , d.counsel_fee_received_date
    , d.signing_invoice_amount
    , d.signing_premium_due_date
    , d.signing_premium_received_date
    , d.closing_premium_due_date
    , d.closing_premium_received_date

    , d.total_rp_limit_on_deal
    , d.total_rp_premium_on_deal
    , d.max_limit_quoted

    , d.sanction_checks_done
    , d.esg_country
    , d.esg_company
    , d.rr_done
    , d.are_emails_filed_id
    , d.is_uw_fee_received_id

    , d.is_locked

    , CAST(d.total_rp_premium_on_deal / d.currency_rate_deal * d.currency_rate_local AS DECIMAL(14,0)) total_rp_premium_on_deal_local
    , CAST(d.total_rp_premium_on_deal / d.currency_rate_deal AS DECIMAL(14,0)) total_rp_premium_on_deal_eur
    , CAST(d.signing_invoice_amount / d.currency_rate_deal AS DECIMAL(14,0)) signing_invoice_amount_eur

FROM deals_t d
LEFT JOIN
    stella_common.underwriters_t analyst
    ON d.analyst_id = analyst.uw_id
LEFT JOIN
    stella_common.entities_t bh
    ON d.budget_home_id = bh.entity_id
LEFT JOIN
    stella_common.menu_list_t ds
    ON d.deal_status_id = ds.menu_id
LEFT JOIN
    stella_common.menu_list_t pox
    ON d.primary_or_xs_id = pox.menu_id
LEFT JOIN
    stella_common.risk_types_t risk_type
    ON d.risk_type_id = risk_type.risk_type_id
LEFT JOIN
    stella_common.risk_types_t rtm
    ON risk_type.risk_type_major_id__risk_types_t  = rtm.risk_type_id
LEFT JOIN
    stella_common.insurers_t ins
    ON d.primary_insurer = ins.id
LEFT JOIN
    broker_firms_t bf
    ON d.broker_firm_id = bf.broker_firm_id
LEFT JOIN
    stella_common.underwriters_t uw
    ON d.primary_uw = uw.uw_id
LEFT JOIN
    stella_common.underwriters_t suw
    ON d.secondary_uw = suw.uw_id
LEFT JOIN
    stella_common.underwriters_t nbi_prepper
    ON d.nbi_prepper = nbi_prepper.uw_id
LEFT JOIN
    stella_common.underwriters_t cu
    ON d.creating_uw = cu.uw_id
LEFT JOIN
    stella_common.jurisdictions_t ic
    ON d.BuyerDomicile = ic.jurisdiction_id
LEFT JOIN
    stella_common.jurisdictions_t irc
    ON d.insured_registered_country_id = irc.jurisdiction_id
LEFT JOIN
    stella_common.sectors_t sup_s
    ON d.target_super_sector_id = sup_s.sector_id
LEFT JOIN
    stella_common.sectors_t sub_s
    ON d.target_sub_sector_id = sub_s.sector_id
LEFT JOIN
    stella_common.underwriters_t iaq
    ON d.internal_approver = iaq.uw_id
LEFT JOIN
    stella_common.underwriters_t iab
    ON d.internal_approver_at_signing = iab.uw_id
LEFT JOIN
    law_firms_t blf1
    ON d.buyer_law_firm_1_id = blf1.law_firm_id
LEFT JOIN
    law_firms_t blf2
    ON d.buyer_law_firm_2_id = blf2.law_firm_id

WHERE d.is_deleted = 0
