/*
Log
Friday 20 December 2024: stella_policy_no is the auto-generated policy from Stella. However, sometimes, UWs get it wrong etc., and we need a way to override the auto-generated policy no. This happens by populating policy_no with whatever policy no is in the policy document.

Friday 11 October 2024, CK: Removed c5_policy_no. Will transition to only using policy_no, with the logic. Hence, policy_no_universal should be retired (this was a datapoint to cater for when we had c5 policy nos and Stella policy nos at the same time).
 */

CREATE VIEW
    policies_v AS
SELECT
    l.id
    , l.id policy_id

    , l.budget_home_id

    , l.create_date

    , d.deal_currency
    , l.deal_id
    , d.deal_name
    , CONCAT(
        l.stella_policy_no
        , ' | ', lt.layer_text
        , IF (l.policy_name IS NULL, '', CONCAT(' | ', l.policy_name))
    ) display_view

    , ie.entity_business_name 	issuing_entity
    , l.issuing_entity_id

    , l.layer_no

    , nh.navins_home
    , l.navins_home_id
    , bh.entity_business_name budget_home

    , d.budget_home_id temp_budget_home

    , lt.layer_text layer_no_text

    , IF(l.policy_no IS NOT NULL, l.policy_no,
 	    IF(l.rp_on_layer = 94, 'n/a', l.stella_policy_no)
    ) policy_no

    , IF(l.policy_no IS NOT NULL, l.policy_no,
        IF(l.rp_on_layer = 94, 'n/a', l.stella_policy_no)
    ) policy_no_universal

    , IF(
        l.rp_on_layer = 94, 'n/a'
        , l.stella_policy_no
    ) stella_policy_no

    , l.policy_name

    , CAST(l.quota * l.layer_limit AS DECIMAL(14,0)) policy_limit

    , l.underlying_limit
    , l.quota
    , l.layer_limit
    , l.rp_on_layer
    , ro.menu_item rp_on_layer_hr
    , l.broker_commission
    , l.policy_premium
    , l.policy_premium / d.currency_rate_deal policy_premium_eur
    , l.layer_premium
    , d.deal_status_id

    , d.inception_date
    , l.fundamental_limit
    , CAST(l.fundamental_limit * l.quota AS DECIMAL(14,0)) policy_fundamental_limit
    , l.fundamental_premium
    , CAST((l.quota * (l.layer_limit - l.fundamental_limit)) AS DECIMAL(14,0)) general_limit
    , CAST(l.policy_premium - l.fundamental_premium AS DECIMAL(14,0)) general_premium

FROM layers_t l
LEFT JOIN
    stella_common.menu_list_t ro
    ON l.rp_on_layer = ro.menu_id
LEFT JOIN
    deals_t d
    ON l.deal_id = d.deal_id
LEFT JOIN
    stella_common.policy_layer_texts_t lt
    ON l.layer_no = lt.layer_no
LEFT JOIN
    stella_common.entities_t ie
    ON l.issuing_entity_id = ie.entity_id
LEFT JOIN
    stella_common.navins_homes_t nh
    ON l.navins_home_id = nh.home_id
LEFT JOIN
    stella_common.entities_t bh
    ON l.budget_home_id = bh.entity_id

WHERE
    l.is_deleted = 0
    AND d.is_deleted = 0
ORDER BY layer_no
