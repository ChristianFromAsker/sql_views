CREATE OR REPLACE VIEW stella_us.recent_deals_v AS
SELECT d.deal_id
    , d.insured_registered_country_id
    , d.broker_firm_id
    , b.business_name broker_firm_hr
    , d.broker_person
    , bp.PersonalName broker_person_hr
    , d.budget_home_id
    , GROUP_CONCAT(
        DISTINCT CASE WHEN dp.deal_role_id__deal_roles_t = 2 THEN p.party_business_name END
        ORDER BY p.party_business_name SEPARATOR '; '
    ) AS buyer_business_names
    , d.buyer_law_firm_1_id
    , l.FirmName buyer_law_firm_1_hr

    , d.create_date

    , d.deal_info
    , d.deal_name
    , ds.menu_item 	deal_status
    , d.deal_status_id

    , d.ev
    , d.is_repeat_buyer

    , d.max_limit_quoted

    , IF(
	    d.quote_due_time IS NULL
        , DATE_FORMAT(d.quote_due_date, '%a %b, %e/%y')
        , CONCAT(DATE_FORMAT(d.quote_due_date, '%a %b, %e/%y'), '\r\n' , d.quote_due_time)
    ) nbi_deadline_full
    , d.nbi_prepper

    , d.primary_or_xs_id

    , d.quote_due_date
    , d.quote_due_time

    , d.re_quote_info
    , d.risk_type_id

    , d.stage
    , stage.menu_item stage_hr
    , d.submission_limits
    , IF(d.submission_notes IS NULL, d.comments, d.submission_notes) submission_notes

    , d.total_rp_limit_on_deal
    , GROUP_CONCAT(
        DISTINCT CASE WHEN dp.deal_role_id__deal_roles_t = 4 THEN p.party_business_name END
        ORDER BY p.party_business_name SEPARATOR '; '
    ) AS target_business_names
    , d.target_desc
    , d.target_sub_sector_id
    , d.target_super_sector_id

-- to be removed
    , d.buyer_law_firm_2_id
    , d.UltimateBuyer
    , d.target_business_name
    , d.buyer_business_name
    , d.insured_legal_name
-- end to be removed

FROM deals_t d
LEFT JOIN broker_firms_t b
    ON d.broker_firm_id = b.broker_firm_id
LEFT JOIN law_firms_t l
    ON d.buyer_law_firm_1_id = l.law_firm_id
LEFT JOIN broker_persons_t bp
    ON d.broker_person = bp.id
LEFT JOIN stella_common.menu_list_t ds
    ON d.deal_status_id = ds.menu_id
LEFT JOIN stella_common.menu_list_t stage
    ON d.stage = stage.menu_id
LEFT JOIN deal_parties_t dp
       ON dp.deal_id__deals_t = d.deal_id
      AND dp.is_deleted = 0
LEFT JOIN parties_t p
       ON p.party_id = dp.party_id__parties_t
      AND p.is_deleted = 0

WHERE
    d.create_date >= DATE_ADD(DATE(NOW()), INTERVAL -3 DAY)
    AND d.is_deleted = 0

GROUP BY d.deal_id;