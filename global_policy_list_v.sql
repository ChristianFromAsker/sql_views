CREATE global_policy_list_v AS
SELECT * FROM stella_common.global_policy_list_eur_v
UNION
SELECT * FROM stella_common.global_policy_list_us_v
