CREATE VIEW budget_homes_v AS
SELECT
    bh.budget_home_id
    , bc.jurisdiction       budget_continent
    , bh.budget_continent_id__jurisdictions_t		budget_continent_id
    , br.jurisdiction       budget_region
    , bh.budget_region_id__jurisdictions_t budget_region_id
    , bh.budget_home_name   budget_home
    , bh.local_currency
FROM
    stella_common.budget_homes_t bh
LEFT JOIN
	stella_common.jurisdictions_t bc
    ON bh.budget_continent_id__jurisdictions_t = bc.jurisdiction_id
LEFT JOIN
	stella_common.jurisdictions_t br
    ON bh.budget_region_id__jurisdictions_t = br.jurisdiction_id
WHERE
    bh.is_deleted = 0
