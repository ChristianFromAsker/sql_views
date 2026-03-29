
CREATE OR REPLACE VIEW uw_all_roles_v AS
SELECT
    u.uw_id,
    bh.budget_continent_id__jurisdictions_t budget_continent_id,
    bc.jurisdiction budget_continent_name,
    u.budget_home_id,
    bh.budget_home_name,
    u.uw_name,
    u.uw_initials,
    u.email,
    l.employee_role_link_id,
    l.employee_role_start_date,
    l.employee_role_end_date,
    r.employee_role_id        role_id,
    r.employee_role_name      role_name,
    r.employee_role_name_us   role_name_us,
    r.is_deleted              role_is_deleted,
    r.parent_employee_role_id parent_role_id,
    p.employee_role_name      parent_role_name
FROM stella_common.underwriters_t u
JOIN stella_common.employee_role_links_t l
  ON l.uw_id__underwriters_t = u.uw_id
JOIN stella_common.employee_roles_t r
  ON r.employee_role_id = l.employee_role_id__employee_roles_t
LEFT JOIN stella_common.employee_roles_t p
  ON p.employee_role_id = r.parent_employee_role_id
LEFT JOIN stella_common.budget_homes_t bh
    ON u.budget_home_id = bh.budget_home_id
LEFT JOIN stella_common.jurisdictions_t bc
    ON bh.budget_continent_id__jurisdictions_t = bc.jurisdiction_id
WHERE u.is_deleted = 0
    AND r.is_deleted = 0
    AND l.is_deleted = 0;
