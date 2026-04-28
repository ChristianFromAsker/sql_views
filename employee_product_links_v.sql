
CREATE OR REPLACE VIEW stella_common.employee_product_links_v AS
SELECT
    u.uw_id,

    u.email,
    pl.employee_product_link_id,
    pl.employee_product_start_date,
    pl.employee_product_end_date,

    u.end_date      employee_end_date,
    u.start_date    employee_start_date,
    u.user_name     employee_username,

    pr.parent_employee_product_id__employee_products_t parent_product_id,
    ppr.employee_product_name       parent_product_name,
    pr.employee_product_id          product_id,
    pr.employee_product_name        product_name,
    pr.employee_product_name_us     product_name_us,
    pl.product_allocation,

    u.uw_initials,
    u.uw_name

FROM stella_common.employee_product_links_t pl

LEFT JOIN stella_common.underwriters_t u
  ON pl.uw_id__underwriters_t = u.uw_id
 AND u.is_deleted = 0

LEFT JOIN stella_common.employee_products_t pr
  ON pr.employee_product_id = pl.employee_product_id__employee_products_t
 AND pr.is_deleted = 0

LEFT JOIN stella_common.employee_products_t ppr
  ON ppr.employee_product_id = pr.parent_employee_product_id__employee_products_t

WHERE pl.is_deleted = 0;
