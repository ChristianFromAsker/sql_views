CREATE VIEW security_v AS
SELECT
    s.id
    , s.id security_id

    , s.added_by

    , s.binder_id
    , s.create_date_security
    , l.deal_id

    , s.max_limit_id
    , b.minimum_underlying_limit
    , s.on_policy_id
    , s.policy_id
    , l.policy_premium

    , s.referral_status_id
    , s.binder_compliant_id
    , s.default_quota
    , s.quota
    , IFNULL(edl.extra_limit, 0) AS extra_limit
    , s.manual_limit
    , s.manually_added

    , CAST(l.quota * l.layer_limit AS DECIMAL(14,0)) policy_limit
    , l.quota * s.quota layer_quota
    , (b.reference_limit + IFNULL(edl.extra_limit,0)) AS reference_limit
    , CAST(
        IF (
            s.manual_limit = 0,
            s.quota *  l.layer_limit * l.quota,
            s.manual_limit
        )
    AS DECIMAL(20,2)) binder_limit
    , CAST(s.default_quota *  l.layer_limit * l.quota AS DECIMAL(18,2)) default_binder_limit
    , bl.limit_currency max_limit_currency
    , s.max_limit_currency_to_deal_currency_fx
    , s.binder_currency_date
    , CAST(
        IF (
        s.max_limit_currency_to_deal_currency_fx = 1
        , bl.limit_amount + IFNULL(edl.extra_limit, 0)
        , ROUND(96 / 100 * bl.limit_amount * s.max_limit_currency_to_deal_currency_fx, -3)  + IFNULL(edl.extra_limit, 0)
        )
    AS DECIMAL(14,0)) max_limit_deal_currency

    , CAST(
        IF (
        s.max_limit_currency_to_deal_currency_fx = 1
        , bl.limit_amount + IFNULL(edl.extra_limit, 0)
        , ROUND((1 - deals.fx_buffer) * bl.limit_amount * s.max_limit_currency_to_deal_currency_fx, -3)  + IFNULL(edl.extra_limit, 0)
        )
    AS DECIMAL(14,0)) max_limit_deal_currency_new

    , CAST(
        IF (
        s.max_limit_currency_to_deal_currency_fx = 1,
        b.reference_limit + IFNULL(edl.extra_limit, 0),
        ROUND(96 / 100 * b.reference_limit * s.max_limit_currency_to_deal_currency_fx, -3) + IFNULL(edl.extra_limit, 0)
        )
    AS DECIMAL(14,0)) reference_limit_deal_currency

    , bl.limit_amount + IFNULL(edl.extra_limit, 0) max_binder_limit
    , bl.limit_amount max_binder_limit_ex_extra
    , CONCAT(
        bl.limit_currency, ' ', FORMAT(bl.limit_amount + IFNULL(edl.extra_limit, 0), 0)
    ) AS max_binder_limit_hr
    , b.binder_name
    , b.unique_reference
    , b.default_currency default_binder_currency
    , l.layer_no
    , lt.layer_text layer_no_text
    , IF(l.policy_no IS NOT NULL, l.policy_no,
        IF(l.rp_on_layer = 94, 'n/a', l.stella_policy_no)
    ) policy_no
    , rs.menu_item referral_status
    , op.menu_item on_policy
    , bc.menu_item binder_compliant
    , i.insurer_business_name
    , i.insurer_legal_name
    , i.insurer_brand_id
    , brands.brand_name
    , bl.limit_currency max_binder_limit_currency

    , deals.create_date create_date__deals_t
    , deals.currency_rate_deal
    , deals.currency_rate_local
    , deals.deal_currency
    , deals.deal_name
    , deals.deal_status_id

    , deals.insured_registered_country_id

    , deals.spa_law

    , l.underlying_limit
FROM
    security_t s
LEFT JOIN stella_common.binders_t b ON s.binder_id = b.binder_id
LEFT JOIN layers_t l ON s.policy_id = l.id
LEFT JOIN deals_t deals ON l.deal_id = deals.deal_id
LEFT JOIN stella_common.menu_list_t rs ON s.referral_status_id = rs.menu_id
LEFT JOIN stella_common.menu_list_t op ON s.on_policy_id = op.menu_id
LEFT JOIN stella_common.menu_list_t bc ON s.binder_compliant_id = bc.menu_id
LEFT JOIN stella_common.insurers_t i ON i.id = b.insurer_id
LEFT JOIN stella_common.cm_binder_limits_t bl ON s.max_limit_id = bl.id
LEFT JOIN
    stella_common.brands_t brands
    ON i.insurer_brand_id = brands.brand_id
LEFT JOIN
    stella_common.policy_layer_texts_t lt
    ON l.layer_no = lt.layer_no
LEFT JOIN
    cm_extra_deal_limit_t edl
    ON s.binder_id = edl.binder_id AND l.deal_id = edl.deal_id AND edl.is_deleted = 0
WHERE
    s.is_deleted = 0
    AND l.is_deleted = 0
    AND l.rp_on_layer = 93
