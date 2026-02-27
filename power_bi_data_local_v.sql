-- Monday 6 January 2025, CK: Because this is fed to Power BI, and since Power Bi does not like changes, any new data point must be added at the end of the view.

CREATE OR REPLACE VIEW power_bi_data_local_v AS
SELECT
    d.deal_id
    , d.deal_name
    , ds.menu_item deal_status

    , d.spa_law
    , bf.business_name broker_firm
    , d.inception_date
    , d.uw_fee_received_date

    , pox.menu_item primary_or_xs
    , risk_type.risk_type_name risk_type
    , bh.budget_home_name budget_home
    , br.jurisdiction budget_region
    , d.create_date

    , d.submission_date

    , d.deal_name navins_home
    , qd.menu_item was_quoted
    , sup_s.sector_name target_super_sector
    , sub_s.sector_name target_sub_sector

    , tlj.jurisdiction target_legal_jurisdiction
    , irj.jurisdiction insured_registered_jurisdiction

    , d.deal_currency
    , CAST(total_rp_premium_on_deal / currency_rate_deal AS DECIMAL(14,0)) total_rp_premium_on_deal_eur
    , CAST(ev / currency_rate_deal AS DECIMAL(14,0)) ev_eur
    , CAST(total_rp_limit_on_deal / currency_rate_deal AS DECIMAL(14,0)) total_rp_limit_on_deal_eur
    , CAST(lowest_rp_attpoint / currency_rate_deal AS DECIMAL(14,0)) lowest_rp_attpoint_eur
    , CAST(d.retention / d.currency_rate_deal AS DECIMAL(14,0)) retention_eur
    , CAST((d.uw_fee_amount - d.counsel_fee_amount) / d.currency_rate_deal AS DECIMAL(14,0)) uw_fee_for_rp_eur
    , rtm.risk_type_name risk_type_major
    , bc.jurisdiction budget_continent

    , CAST(total_rp_premium_on_deal / currency_rate_deal * currency_rate_eurusd AS DECIMAL(14,0)) total_rp_premium_on_deal_usd
    , CAST(total_rp_limit_on_deal / currency_rate_deal * currency_rate_eurusd AS DECIMAL(14,0)) total_rp_limit_on_deal_usd
    , CAST(ev / currency_rate_deal * currency_rate_eurusd AS DECIMAL(14,0)) ev_usd

    , slf.FirmName seller_law_firm
    , blf1.FirmName buyer_law_firm_1
    , blf2.FirmName buyer_law_firm_2
    , pds.menu_item parent_deal_status
    , CASE WHEN bc.jurisdiction = 'America' THEN
        CASE
            WHEN
                d.deal_status_id = 4
                OR d.deal_status_id = 5
                OR d.deal_status_id = 6
                OR d.deal_status_id = 436
                THEN 'yes'
            ELSE 'no'
        END
    ELSE
        CASE
            WHEN
                d.deal_status_id = 3
                OR d.deal_status_id = 4
                OR d.deal_status_id = 5
                OR d.deal_status_id = 6
                OR d.deal_status_id = 436
                THEN 'yes'
            ELSE 'no'
        END
    END COLLATE utf8mb4_0900_ai_ci AS is_won
, CAST((d.uw_fee_amount - d.counsel_fee_amount) / d.currency_rate_deal * d.currency_rate_eurusd AS DECIMAL(14,0)) uw_fee_for_rp_usd

FROM deals_t d
LEFT JOIN stella_common.budget_homes_t bh
    ON d.budget_home_id = bh.budget_home_id
LEFT JOIN stella_common.jurisdictions_t bc
    ON bh.budget_continent_id__jurisdictions_t = bc.jurisdiction_id
LEFT JOIN stella_common.jurisdictions_t br
    ON bh.budget_region_id__jurisdictions_t = br.jurisdiction_id
LEFT JOIN stella_common.deal_statuses_t ds
    ON d.deal_status_id = ds.menu_id
LEFT JOIN stella_common.deal_statuses_t pds
    ON ds.parent_status_eur_id = pds.menu_id
LEFT JOIN stella_common.menu_list_t pox
    ON d.primary_or_xs_id = pox.menu_id
LEFT JOIN stella_common.risk_types_t risk_type
    ON d.risk_type_id = risk_type.risk_type_id
LEFT JOIN stella_common.risk_types_t rtm
    ON risk_type.risk_type_major_id__risk_types_t  = rtm.risk_type_id
LEFT JOIN stella_common.menu_list_t qd
    ON d.was_quoted_id = qd.menu_id
LEFT JOIN broker_firms_t bf
    ON d.broker_firm_id = bf.broker_firm_id
LEFT JOIN stella_common.sectors_t sup_s
    ON d.target_super_sector_id = sup_s.sector_id
LEFT JOIN stella_common.sectors_t sub_s
    ON d.target_sub_sector_id = sub_s.sector_id
LEFT JOIN stella_common.jurisdictions_t tlj
    ON d.TargetDomicile = tlj.jurisdiction_id
LEFT JOIN stella_common.jurisdictions_t irj
    ON d.insured_registered_country_id = irj.jurisdiction_id
LEFT JOIN law_firms_t blf1
    ON d.buyer_law_firm_1_id = blf1.law_firm_id
LEFT JOIN law_firms_t blf2
    ON d.buyer_law_firm_2_id = blf2.law_firm_id
LEFT JOIN law_firms_t slf
    ON d.SellerLegalFirm = slf.law_firm_id
WHERE
    d.is_deleted = 0
    AND NOT d.deal_name IS NULL
    AND NOT d.broker_firm_id IS NULL
    AND d.is_test_deal_id = 94
