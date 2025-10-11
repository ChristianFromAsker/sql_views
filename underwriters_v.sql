-- To get FTEs for a year, with a fraction for leavers or joiners during the year, use:

Set @input_year = [desired year];

, ROUND(
    GREATEST(
        0
        , LEAST(
            DATEDIFF(
                LEAST(
                    COALESCE(end_date, MAKEDATE(@input_year + 1, 1) - INTERVAL 1 DAY)
                    , MAKEDATE(@input_year + 1, 1) - INTERVAL 1 DAY)
                    , GREATEST(start_date, MAKEDATE(@input_year, 1
                )
            ) + 1
            , 365
        )
    ) / 365
    , 2
) fte_portion

-- CREATE VIEW underwriters_v AS
SELECT uws.uw_id

, bc.jurisdiction 		budget_continent
, bc.jurisdiction_id		budget_continent_id
, br.jurisdiction 		budget_region
, br.jurisdiction_id	budget_region_id
, ei.entity_business_name 	budget_home
, ei.entity_id
, ei.entity_id 	budget_home_id

, uws.email
, uws.is_employed_id 	employed
, uws.end_date

, uws.is_employed_id

, uws.nickname
, uws.personalised_stella

, uws.start_date
, uws.user_name
, uws.user_type_id 		user_type
, uws.user_type_id 		user_type_id
, mut.menu_item 		user_type_hr
, uws.uw_initials
, uws.uw_name

, uws.is_dev_id
, is_dev.menu_item 	is_dev
, uws.has_admin_access_id 	has_admin_access_id
, haa.menu_item 				has_admin_access
, uws.can_change_general_id
, ccg.menu_item 				can_change_general
, uws.can_change_jurisdictions_id
, ccj.menu_item can_change_jurisdictions
, uws.can_change_uws_id
, ccu.menu_item can_change_uws
, uws.can_change_budget_home_id
, ccbh.menu_item can_change_budget_home
, uws.is_super_duper_trusted_id
, isdt.menu_item is_super_duper_trusted
, ei.navins_home_id
, nh.menu_item navins_home

, uws.uw_id id
FROM
    stella_common.underwriters_t uws
LEFT JOIN
    stella_common.entities_t bh
    ON uws.budget_home_id = bh.entity_id
LEFT JOIN
    stella_common.jurisdictions_t br
    ON bh.budget_region_id = br.jurisdiction_id
LEFT JOIN
    stella_common.jurisdictions_t bc
    ON bh.entity_continent_id__jurisdictions_t = bc.jurisdiction_id
LEFT JOIN
    stella_common.menu_list_t mut
    ON uws.user_type_id = mut.menu_id
LEFT JOIN
    stella_common.menu_list_t haa
    ON uws.has_admin_access_id = haa.menu_id
LEFT JOIN
    stella_common.entities_t ei
    ON uws.budget_home_id = ei.entity_id
LEFT JOIN
    stella_common.menu_list_t nh
    ON ei.navins_home_id = nh.menu_id
LEFT JOIN
    stella_common.menu_list_t ccg
    ON uws.can_change_general_id =  ccg.menu_id
LEFT JOIN
    stella_common.menu_list_t ccj
    ON uws.can_change_jurisdictions_id = ccj.menu_id
LEFT JOIN
    stella_common.menu_list_t ccu
    ON uws.can_change_uws_id = ccu.menu_id
LEFT JOIN
    stella_common.menu_list_t ccbh
    ON uws.can_change_budget_home_id = ccbh.menu_id
LEFT JOIN
    stella_common.menu_list_t is_dev
    ON uws.is_dev_id = is_dev.menu_id
LEFT JOIN
    stella_common.menu_list_t isdt
    ON uws.is_super_duper_trusted_id = isdt.menu_id

WHERE
    uws.is_deleted = 0
