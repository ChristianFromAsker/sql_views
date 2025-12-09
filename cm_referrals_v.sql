CREATE VIEW cm_referrals_v AS
SELECT r.id
    , r.id referral_id
    , cdq.deal_id
    , r.deal_question_id
    , r.referral_status_id
    , r.binder_id

    , rs.menu_item referral_status
    , tq.question_type_id__cm_question_types_t question_type_id
    , qt.question_type
    , cdq.template_question_id
    , tq.good_answer_id

    , tq.question referral_trigger
    , tq.question template_question
    , tq.due_time_for_referral_id
    , tq.auto_referral_type

    , IF(
        tq.referral_help = '' OR tq.referral_help IS NULL
        , 'no referral help'
        , tq.referral_help
    ) referral_help

    , dt.menu_item due_time_for_referral

    , an.menu_item answer

    , ga.menu_item good_answer
    , rl.menu_item referral_level
    , b.binder_name
    , IF (
        b.binder_name IS NULL
        , 'InAR'
        , b.binder_name
    ) AS referral_source
    , IF(
        r.uw_referral_comment IS NULL OR r.uw_referral_comment = ''
        , ''
        , CONCAT('<b>UW comment</b>: ', r.uw_referral_comment)
    ) uw_referral_comment_display

    , r.uw_referral_comment
    , r.auto_referral_comment
    , r.create_date

FROM cm_referrals_t r

LEFT JOIN cm_deal_questions_t cdq
    ON r.deal_question_id = cdq.id
LEFT JOIN stella_common.cm_template_questions_t tq
    ON cdq.template_question_id = tq.id
LEFT JOIN stella_common.binders_t b
    ON r.binder_id = b.binder_id
LEFT JOIN stella_common.menu_list_t an
    ON cdq.answer_id = an.menu_id
LEFT JOIN stella_common.menu_list_t ga
    ON tq.good_answer_id = ga.menu_id
LEFT JOIN stella_common.menu_list_t rs
    ON r.referral_status_id = rs.menu_id
LEFT JOIN stella_common.menu_list_t rl
    ON tq.referral_level_id = rl.menu_id
LEFT JOIN stella_common.menu_list_t dt
    ON tq.due_time_for_referral_id = dt.menu_id
LEFT JOIN stella_common.cm_question_types_t qt
    ON tq.question_type_id__cm_question_types_t = qt.question_type_id
WHERE
    r.is_deleted = 0
