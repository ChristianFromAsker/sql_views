CREATE VIEW deals_v AS
SELECT
    d.deal_id

     , bf.business_name broker_firm
    , d.broker_firm_id
    , d.broker_person

     , d.deal_name
    , d.deal_status_id
    , ds.menu_item deal_status

    , d.spa_law
    , d.risk_feel_id
    , rf.menu_item risk_feel
    , d.policy_period_in_months
    , d.primary_or_xs_id
    , pox.menu_item primary_or_xs
    , d.risk_type_id
    , risk_type.risk_type_name risk_type

    , d.is_locked
    , d.MessageBoard
    , d.Comments
    , d.program_summary

    , vat_home
    , d.budget_home_id
    , bh.entity_business_name budget_home
    , bh.budget_region_id
    , br.jurisdiction budget_region

    , d.primary_uw
    , uw.uw_initials uw_initials_hr
    , uw.uw_initials primary_uw_hr
    , uw.uw_name primary_uw_full_name
    , d.secondary_uw
    , suw.uw_name secondary_uw_full_name
    , suw.uw_initials secondary_uw_hr
    , d.creating_uw
    , cu.uw_name creating_uw_hr
    , d.nbi_prepper
    , nbi_prepper.uw_name nbi_prepper_hr

    , d.UwCounselPerson1, d.UwCounselPerson2
    , uc.personal_name uw_counsel_person_1_hr

    , d.primary_insurer
    , ins.insurer_business_name primary_insurer_hr

    , d.inception_date, d.create_date, d.spa_signing_date, d.closing_date
    , d.submission_date

    , d.target_legal_name
    , d.TargetDomicile
    , d.target_business_name
    , d.target_super_sector_id
    , sup_s.sector_name target_super_sector
    , d.target_sub_sector_id
    , sub_s.sector_name target_sub_sector
    , tlj.jurisdiction target_legal_jurisdiction
    , d.target_main_jurisdiction_id
    , tmj.jurisdiction target_main_jurisdiction

    , d.insured_legal_name
    , d.insured_registered_country_id
    , irc.jurisdiction insured_registered_country
    , d.insured_main_region_id
    , d.buyer_business_name
    , d.UltimateBuyer
    , d.BuyerDomicile
    , d.buyer_financial_firm_id
    , d.buyer_law_firm_1_id, d.buyer_law_firm_2_id

    , d.seller_business_name
    , d.UltimateSeller
    , d.SellerDomicile
    , d.SellerLegalFirm

    , d.IsClosed, d.ClosingBooked, d.CounselInvoiceReceived
    , d.CounselInvoiceHandled, d.VDRReceived, d.VDRPassword
    , d.PremiumReceived

    , d.currency_rate_deal
    , d.currency_rate_local
    , d.currency_date
    , d.deal_currency
    , d.program_limit
    , d.lowest_rp_attpoint, d.EV, d.retention

    , d.uw_fee_amount
    , d.counsel_fee_amount

    , d.total_rp_limit_on_deal, d.total_rp_premium_on_deal
    , CAST(d.total_rp_premium_on_deal / d.currency_rate_deal * d.currency_rate_local AS DECIMAL(14,0)) total_rp_premium_on_deal_local
    , CAST(d.total_rp_premium_on_deal / d.currency_rate_deal AS DECIMAL(14,0)) total_rp_premium_on_deal_eur
    , CAST(d.ev / d.currency_rate_deal AS DECIMAL(14,0)) ev_eur
    , CAST(d.total_rp_limit_on_deal / d.currency_rate_deal AS DECIMAL(14,0)) total_rp_limit_on_deal_eur
    , CAST(d.lowest_rp_attpoint / d.currency_rate_deal AS DECIMAL(14,0)) lowest_rp_attpoint_eur
    , CAST(d.retention / d.currency_rate_deal AS DECIMAL(14,0)) retention_eur
    , d.max_limit_quoted

    , bh.months_before_auto_archiving
    , slf.FirmName seller_law_firm_hr
    , blf1.FirmName buyer_law_firm_1_hr
    , blf2.FirmName buyer_law_firm_2_hr

    , d.rr_done
    , d.are_emails_filed_id
    , d.is_uw_fee_received_id
    , d.is_underwritten
    , d.quote_due_date

    , wq.menu_item was_quoted,
    d.was_quoted_id


    , IF(d.inception_date IS NOT NULL, d.inception_date, d.create_date) pivot_date

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
    stella_common.menu_list_t rf
    ON d.risk_feel_id = rf.menu_id
LEFT JOIN
    stella_common.menu_list_t wq
    ON d.was_quoted_id = wq.menu_id
LEFT JOIN
    stella_common.insurers_t ins
    ON d.primary_insurer = ins.id
LEFT JOIN
    broker_firms_t bf
    ON d.broker_firm_id = bf.broker_firm_id
LEFT JOIN
    law_firms_t slf
    ON d.SellerLegalFirm = slf.law_firm_id
LEFT JOIN
    law_firms_t blf1
    ON d.buyer_law_firm_1_id = blf1.law_firm_id
LEFT JOIN
    law_firms_t blf2
    ON d. buyer_law_firm_2_id = blf2.law_firm_id
LEFT JOIN
    lawyers_t uc
    ON d.UwCounselPerson1 = uc.lawyer_id
LEFT JOIN
    stella_common.underwriters_t uw
    ON d.primary_uw = uw.uw_id
LEFT JOIN
    stella_common.underwriters_t suw
    ON d.secondary_uw = suw.uw_id
LEFT JOIN
    stella_common.underwriters_t cu
    ON d.creating_uw = cu.uw_id
LEFT JOIN stella_common.underwriters_t nbi_prepper ON d.nbi_prepper = nbi_prepper.uw_id
LEFT JOIN stella_common.jurisdictions_t ic ON d.BuyerDomicile = ic.jurisdiction_id
LEFT JOIN stella_common.jurisdictions_t irc ON d.insured_registered_country_id = irc.jurisdiction_id
LEFT JOIN stella_common.jurisdictions_t tmj ON d.target_main_jurisdiction_id = tmj.jurisdiction_id
LEFT JOIN stella_common.sectors_t sup_s ON d.target_super_sector_id = sup_s.sector_id
LEFT JOIN stella_common.sectors_t sub_s ON d.target_sub_sector_id = sub_s.sector_id
LEFT JOIN stella_common.jurisdictions_t tlj ON d.TargetDomicile = tlj.jurisdiction_id
WHERE d.is_deleted = 0
