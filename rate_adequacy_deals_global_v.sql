CREATE OR REPLACE VIEW stella_common.rate_adequacy_deals_global_v AS

SELECT *
FROM (SELECT *
      FROM stella_eur.deals_rate_adequacy_local_v d_eur

      UNION

      SELECT *
      FROM stella_us.deals_rate_adequacy_local_v d_us) d
