CREATE VIEW global_deal_list_v AS

SELECT
d.*
, MONTH(d.create_date) create_month
FROM
stella_common.global_deal_list_eur_v d

UNION

SELECT
d.*
, MONTH(d.create_date) create_month
FROM
stella_common.global_deal_list_us_v d
