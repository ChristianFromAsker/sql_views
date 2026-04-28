
CREATE OR REPLACE VIEW stella_common.employees_global_v AS
SELECT
    bc.jurisdiction                              budget_continent_name,
    bh.budget_continent_id__jurisdictions_t     budget_continent_id,
    bh.budget_home_id                           budget_home_id,
    bh.budget_home_name                         budget_home_name,
    br.jurisdiction                             budget_region,
    br.jurisdiction_id                          budget_region_id,
    cbh.menu_item                               can_change_budget_home,
    u.can_change_budget_home_id,
    u.email,
    pl.employee_product_end_date,
    pl.employee_product_link_id,
    pl.employee_product_start_date,
    u.end_date                                  employee_end_date,
    u.nickname                                  employee_nickname,
    l.employee_role_end_date,
    l.employee_role_link_id,
    l.employee_role_start_date,
    u.start_date                                employee_start_date,
    u.user_name                                 employee_username,
    ppr.employee_product_name                  parent_product_name,
    pr.parent_employee_product_id__employee_products_t  parent_product_id,
    p.employee_role_name                        parent_role_name,
    r.parent_employee_role_id                  parent_role_id,
    pl.product_allocation,
    pr.employee_product_id                     product_id,
    pr.employee_product_name                   product_name,
    pr.employee_product_name_us                product_name_us,
    pr.is_deleted                               product_is_deleted,
    r.employee_role_id                          role_id,
    r.employee_role_name                        role_name,
    r.employee_role_name_us                     role_name_us,
    r.is_deleted                                role_is_deleted,
    ut.menu_item                                user_type_name,
    u.user_type_id,
    u.uw_id,
    u.uw_initials,
    u.uw_name

FROM stella_common.underwriters_t u

LEFT JOIN stella_common.employee_role_links_t l
    ON u.uw_id = l.uw_id__underwriters_t
    AND l.is_deleted = 0

LEFT JOIN stella_common.employee_roles_t r
    ON r.employee_role_id = l.employee_role_id__employee_roles_t
    AND r.is_deleted = 0

LEFT JOIN stella_common.employee_roles_t p
    ON p.employee_role_id = r.parent_employee_role_id

LEFT JOIN stella_common.employee_product_links_t pl
    ON u.uw_id = pl.uw_id__underwriters_t
    AND pl.is_deleted = 0
    AND (
        l.employee_role_link_id IS NULL
        OR EXISTS (
            SELECT 1
            FROM stella_common.employee_role_links_t l2
            WHERE l2.uw_id__underwriters_t = u.uw_id
            AND l2.is_deleted = 0
            AND pl.employee_product_start_date <= COALESCE(l2.employee_role_end_date, '9999-12-31')
            AND COALESCE(pl.employee_product_end_date, '9999-12-31') >= l2.employee_role_start_date
        )
    )

LEFT JOIN stella_common.employee_products_t pr
    ON pr.employee_product_id = pl.employee_product_id__employee_products_t
    AND pr.is_deleted = 0

LEFT JOIN stella_common.employee_products_t ppr
    ON ppr.employee_product_id = pr.parent_employee_product_id__employee_products_t

LEFT JOIN stella_common.budget_homes_t bh
    ON u.budget_home_id = bh.budget_home_id

LEFT JOIN stella_common.jurisdictions_t br
    ON bh.budget_region_id__jurisdictions_t = br.jurisdiction_id

LEFT JOIN stella_common.jurisdictions_t bc
    ON bh.budget_continent_id__jurisdictions_t = bc.jurisdiction_id

LEFT JOIN stella_common.menu_list_t ut
    ON u.user_type_id = ut.menu_id

LEFT JOIN stella_common.menu_list_t cbh
    ON u.can_change_budget_home_id = cbh.menu_id

WHERE u.is_deleted = 0;
