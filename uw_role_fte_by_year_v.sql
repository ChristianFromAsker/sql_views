
CREATE OR REPLACE VIEW stella_common.uw_role_fte_by_year_v AS
SELECT
    t.*,
    ROUND(t.overlap_days / 365, 2) AS fte_portion
FROM (
    SELECT
        v.budget_continent_id,
        v.budget_continent_name,
        v.budget_region_id,
        v.budget_home_id,
        v.budget_home_name,
        v.email,
        v.employee_end_date,
        v.employee_nickname,
        v.employee_role_end_date,
        v.employee_role_link_id,
        v.employee_role_start_date,
        v.employee_start_date,
        v.employee_username,

        v.parent_role_id,
        v.parent_role_name,
        v.product_id,
        v.role_id,
        v.role_name,
        v.role_name_us,
        v.user_type_id,
        v.user_type_name,
        v.uw_id,
        v.uw_initials,
        v.uw_name,
        y.year,

        LEAST(
            COALESCE(v.employee_end_date, y.year_end),
            COALESCE(v.employee_role_end_date, y.year_end),
            y.year_end
        ) AS effective_end_date,

        GREATEST(
            COALESCE(v.employee_start_date, y.year_start),
            COALESCE(v.employee_role_start_date, y.year_start),
            y.year_start
        ) AS effective_start_date,

        GREATEST(
            0,
            DATEDIFF(
                LEAST(
                    COALESCE(v.employee_end_date, y.year_end),
                    COALESCE(v.employee_role_end_date, y.year_end),
                    y.year_end
                ),
                GREATEST(
                    COALESCE(v.employee_start_date, y.year_start),
                    COALESCE(v.employee_role_start_date, y.year_start),
                    y.year_start
                )
            ) + 1
        ) AS overlap_days

    FROM stella_common.employees_global_v v
    JOIN (
        SELECT
            cy.year,
            DATE(CONCAT(cy.year, '-01-01')) AS year_start,
            DATE(CONCAT(cy.year, '-12-31')) AS year_end
        FROM stella_common.calendar_years_t cy
    ) y
) t
WHERE t.overlap_days > 0
ORDER BY t.uw_name;