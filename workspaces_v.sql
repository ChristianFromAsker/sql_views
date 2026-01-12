CREATE VIEW stella_common.workspaces_v AS
SELECT
    workspace_record_id,
    w.create_date,
    custom1,
    custom2,
    custom2 policy_no,
    LEFT(custom2, 12) policy_no_abb,
    custom3,
    custom5,
    custom5 deal_id__workspaces_t,
    p.deal_id deal_id__layers_t,
    p.inception_date,
    p.deal_status_id,
    p.deal_status,
    custom6,
    custom7,
    custom8,
    workspace_id,
    workspace_name

FROM stella_common.workspaces_t w
LEFT JOIN stella_common.global_policy_list_v p
    ON LEFT(w.custom2, 12) = p.policy_no
WHERE
    w.is_deleted = 0
    AND NOT p.deal_id IS NULL