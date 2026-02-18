CREATE OR REPLACE VIEW power_bi_data_v AS
SELECT * FROM stella_eur.power_bi_data_local_v
UNION
SELECT * FROM stella_us.power_bi_data_local_v