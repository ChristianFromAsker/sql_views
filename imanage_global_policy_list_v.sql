CREATE VIEW imanage_global_policy_list_v AS
SELECT
    p.id
    , p.deal_id
    , p.layer_no
    , IF (p.policy_no IS NOT NULL, p.stella_policy_no, p.stella_policy_no) policy_no
    , nh.navins_abb
    , nh.navins_home

    , d.deal_name
    , d.insured_legal_name
    , d.insured_navins_code
    , d.workspace_id

FROM stella_eur.layers_t p
LEFT JOIN stella_eur.deals_t d
    ON p.deal_id = d.deal_id
LEFT JOIN stella_common.navins_homes_t nh
    ON p.navins_home_id = nh.home_id
WHERE p.rp_on_layer = 93 AND p.is_deleted = 0 AND d.is_deleted = 0

UNION

SELECT
    p.id
    , p.deal_id
    , p.layer_no
    , IF (p.policy_no IS NOT NULL, p.stella_policy_no, p.stella_policy_no) policy_no
    , nh.navins_abb
    , nh.navins_home

    , d.deal_name
    , d.insured_legal_name
    , d.insured_navins_code
    , d.workspace_id

FROM stella_us.layers_t p
LEFT JOIN stella_us.deals_t d
    ON p.deal_id = d.deal_id
LEFT JOIN stella_common.navins_homes_t nh
    ON p.navins_home_id = nh.home_id
WHERE p.rp_on_layer = 93 AND p.is_deleted = 0 AND d.is_deleted = 0
