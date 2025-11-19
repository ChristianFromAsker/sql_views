CREATE VIEW binders_v AS
SELECT b.binder_id
    , b.binder_max_quota
    , b.binder_name
    , b.comment
    , b.default_currency
    , b.end_date

    , fe.menu_item for_eur
    , b.for_eur_id
    , fu.menu_item for_us
    , b.for_us_id
    , b.insurer_id

    , b.is_active
    , b.is_active is_active_id
    , b.max_policy_period_in_months
    , b.minimum_underlying_limit
    , b.parent_binder_id
    , b.reference_limit
    , b.start_date
    , b.unique_reference

    , pb.binder_name parent_binder_name
    , i.insurer_business_name
    , i.insurer_brand_id
    , brands.brand_name insurer_brand
    , ia.menu_item is_playing_hr
FROM stella_common.binders_t b
LEFT JOIN stella_common.insurers_t i
    ON b.insurer_id = i.id
LEFT JOIN stella_common.menu_list_t ia
    ON i.is_playing = ia.menu_item
LEFT JOIN stella_common.menu_list_t fe
    ON b.for_eur_id = fe.menu_id
LEFT JOIN stella_common.menu_list_t fu
    ON b.for_us_id = fu.menu_id
LEFT JOIN stella_common.binders_t pb
    ON b.parent_binder_id = pb.binder_id
LEFT JOIN stella_eur.brands_t brands
    ON i.insurer_brand_id = brands.brand_id
WHERE b.is_deleted = 0
