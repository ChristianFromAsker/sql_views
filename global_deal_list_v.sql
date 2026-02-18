CREATE OR REPLACE VIEW global_deal_list_v AS

SELECT
d.*
, MONTH(d.create_date) create_month
FROM
stella_eur.global_deal_list_local_v d

UNION

SELECT
d.*
, MONTH(d.create_date) create_month
FROM
stella_us.global_deal_list_local_v d
