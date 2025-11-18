/*
14 November 2025, CK: This view is not actually stored as VBA/MySQL cannot send parameters as below.
I considered storing the view without the WHERE clause, but decided to generate everything at runtime. TBD whether that is the best approach,
but as this is not used in production, speed/performance is less important and the WHERE clause is a substantial part of this.
 */


set @deal_id = 29500;

SELECT
    data_set_id
    , change_source
    , field_name
    , new_value
    , l.executed_sql
    , changer_id
    , l.create_date
    , record_id
    , r.deal_id deal_id_referral
    , p.deal_id deal_id_policy
    , d.deal_name
FROM
    stella_eur.log_data_t l
LEFT JOIN
    stella_eur.cm_referrals_t r
    ON r.id = l.record_id AND data_set_id LIKE "%cm_referrals_t"
LEFT JOIN
    stella_eur.deals_t d
    ON d.deal_id = l.record_id AND data_set_id = "deals_t"
LEFT JOIN
    stella_eur.cm_deal_questions_t dq
    ON dq.id = l.record_id AND data_set_id LIKE '%cm_deal_questions_t'
LEFT JOIN
    stella_eur.layers_t p
    ON p.id = l.record_id AND l.data_set_id LIKE "%layers_t"
WHERE
    (
        l.record_id = @deal_id
        AND data_set_id IN ("deals_t", "stella_eur.cm_deals_t")
    )
    OR (p.deal_id = @deal_id)
    OR (r.deal_id = @deal_id)
    OR dq.deal_id = @deal_id
ORDER BY l.create_date DESC



set @deal_id = 29500;

SELECT
    data_set_id
    , change_source
    , field_name
    , new_value
    , l.executed_sql
    , changer_id
    , l.create_date
    , record_id
    , r.deal_id deal_id_referral
    , p.deal_id deal_id_policy
    , d.deal_name
FROM stella_eur.log_data_t l
LEFT JOIN stella_eur.cm_referrals_t r
    ON r.id = l.record_id AND data_set_id LIKE '%cm_referrals_t'
LEFT JOIN stella_eur.deals_t d
    ON d.deal_id = l.record_id AND data_set_id = 'deals_t'
LEFT JOIN stella_eur.cm_deal_questions_t dq
    ON dq.id = l.record_id AND data_set_id LIKE '%cm_deal_questions_t'
LEFT JOIN stella_eur.layers_t p
    ON p.id = l.record_id AND l.data_set_id LIKE '%layers_t'
LEFT JOIN stella_eur.security_t s
    ON s.id = l.record_id
    AND l.data_set_id LIKE '%security_t'
LEFT JOIN stella_eur.layers_t lp
    ON lp.id = s.policy_id
WHERE
    (
        l.record_id = @deal_id
        AND data_set_id IN ('deals_t', 'stella_eur.cm_deals_t')
    )
    OR (p.deal_id = @deal_id)
    OR (r.deal_id = @deal_id)
    OR dq.deal_id = @deal_id
    OR (
        l.data_set_id LIKE '%security_t'
        AND lp.deal_id = @deal_id
    )
ORDER BY l.create_date DESC