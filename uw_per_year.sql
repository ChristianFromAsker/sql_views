-- TOTAL FTES PER YEAR
Set @input_year = 2025;

SELECT
  -- SUM(fte_portion) AS total_fte_portion
     *
FROM (
    SELECT uws.uw_id
       , uws.uw_name
       , bc.jurisdiction

       , ROUND(
        GREATEST(
            0
            , LEAST(
                    DATEDIFF(
                            LEAST(
                                 COALESCE(end_date, MAKEDATE(@input_year + 1, 1) - INTERVAL 1 DAY)
                                , MAKEDATE(@input_year + 1, 1) - INTERVAL 1 DAY
                            )
                        , GREATEST(start_date, MAKEDATE(@input_year, 1))
                    ) + 1
                , 365
              )
        ) / 365
    , 2
    ) fte_portion

FROM
    stella_common.underwriters_t uws
LEFT JOIN stella_common.entities_t bh
    ON uws.budget_home_id = bh.entity_id
LEFT JOIN stella_common.jurisdictions_t br
    ON bh.budget_region_id = br.jurisdiction_id
LEFT JOIN stella_common.jurisdictions_t bc
    ON bh.entity_continent_id__jurisdictions_t = bc.jurisdiction_id
LEFT JOIN stella_common.menu_list_t mut
    ON uws.user_type_id = mut.menu_id
LEFT JOIN stella_common.menu_list_t haa
   ON uws.has_admin_access_id = haa.menu_id
LEFT JOIN stella_common.entities_t ei
   ON uws.budget_home_id = ei.entity_id
LEFT JOIN stella_common.menu_list_t nh
    ON ei.navins_home_id = nh.menu_id
LEFT JOIN stella_common.menu_list_t ccg
    ON uws.can_change_general_id = ccg.menu_id
LEFT JOIN stella_common.menu_list_t ccj
    ON uws.can_change_jurisdictions_id = ccj.menu_id
LEFT JOIN stella_common.menu_list_t ccu
    ON uws.can_change_uws_id = ccu.menu_id
LEFT JOIN stella_common.menu_list_t ccbh
    ON uws.can_change_budget_home_id = ccbh.menu_id
LEFT JOIN stella_common.menu_list_t is_dev
    ON uws.is_dev_id = is_dev.menu_id
LEFT JOIN stella_common.menu_list_t isdt
    ON uws.is_super_duper_trusted_id = isdt.menu_id
WHERE
    uws.is_deleted = 0
    AND uws.budget_home_id <> 93
    AND uws.is_employed_id = 93
    AND user_type_id IN (149, 150, 620)
) as sub
ORDER BY uw_name
-- */


-- LIST OF EMPLOYEES PER YEAR
/*
Set @input_year = 2025;

SELECT
    uws.uw_id
       , uws.uw_name
       , bc.jurisdiction

       , ROUND(
        GREATEST(
                0
            , LEAST(
                        DATEDIFF(
                                LEAST(
                                     COALESCE(end_date, MAKEDATE(@input_year + 1, 1) - INTERVAL 1 DAY)
                                    , MAKEDATE(@input_year + 1, 1) - INTERVAL 1 DAY
                                )
                            , GREATEST(start_date, MAKEDATE(@input_year, 1))
                        ) + 1
                    , 365
              )
        ) / 365
    , 2
    ) fte_portion

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
   ON uws.can_change_general_id = ccg.menu_id
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
    -- AND NOT bc.jurisdiction = 'North America'
    AND user_type_id IN (149, 150, 620)
-- */
