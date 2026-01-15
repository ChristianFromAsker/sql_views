CREATE VIEW deals_for_auto_archiving_v AS
SELECT d.deal_id, d.create_date
FROM deals_t d
WHERE d.is_deleted = 0
    AND (d.deal_status_id = 481 OR d.deal_status_id = 2)
    AND (
    (d.submission_date IS NOT NULL
        AND DATEDIFF(CURRENT_DATE(), d.submission_date) > 56)
        OR
    (d.submission_date IS NULL
        AND DATEDIFF(CURRENT_DATE(), d.create_date) > 120)
    )
