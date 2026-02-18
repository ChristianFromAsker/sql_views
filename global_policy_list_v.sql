CREATE OR REPLACE VIEW global_policy_list_v AS
SELECT * FROM stella_eur.global_policy_list_local_v
UNION
SELECT * FROM stella_us.global_policy_list_local_v
