CREATE VIEW binders_v AS
SELECT b.binder_id
    , b.binder_name
    , b.start_date
    , b.end_date
    , b.insurer_id
    , b.unique_reference
    , b.is_active
    , b.is_active is_active_id
    , b.comment
    , b.parent_binder_id
    , b.default_currency
    , b.reference_limit
    , b.minimum_underlying_limit
    , b.binder_max_quota
    , b.for_eur_id
    , fe.menu_item for_eur
    , b.for_us_id
    , fu.menu_item for_us
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
