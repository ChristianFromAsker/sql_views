CREATE VIEW claims_list_v AS
SELECT
    c.claim_id
    , cs.menu_item 	claim_status
    , c.claim_status claim_status_id
    , c.c5_claim_no
    , c.claim_name

    , c.deal_id
    , d.deal_name
    , d.spa_law

FROM claims_t c
LEFT JOIN
    deals_t d
    on c.deal_id = d.deal_id
LEFT JOIN
    stella_common.menu_list_t cs
    ON c.claim_status = cs.menu_id
WHERE
    c.is_deleted = 0
