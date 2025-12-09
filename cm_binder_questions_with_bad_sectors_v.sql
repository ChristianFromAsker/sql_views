/*
24 February 2025, CK: The purpose of this view is to facilitate the auto_referral function in the Compliance Module.
The view combines binders, template_questions, bad_sectors, sectors and deal_questions into one, which, when filtered on
deal_id and (target_sub_sector and target_sub_sector) shows all variations of binders and bad_sectors (if any) on the
deal. In case of no hits, the query returns no records. Every record returned is a referral.
*/

CREATE VIEW cm_binder_questions_with_bad_sectors_v AS
SELECT
bs.bad_sector_id
, bs.sector_id__sectors_t sector_id
, s.sector_name
, bq.binder_id
, b.binder_name
, tq.id template_question_id
, tq.question
, tq.auto_referral_type
, bq.id binder_question_id
, bq.binder_id binder_id__binder_questions_t
, bq.template_question_id template_question_id__binder_questions_t
, CASE WHEN bq.template_question_id IS NOT NULL AND bq.is_deleted = 0
    THEN 'yes'
    ELSE 'no'
END template_question_on_binder
, cdq.deal_id
, cdq.id deal_question_id
, cdq.answer_id

FROM stella_common.cm_binder_questions_t bq
LEFT JOIN stella_common.cm_bad_sectors_t bs
	ON bq.binder_id = bs.binder_id
LEFT JOIN stella_common.cm_template_questions_t tq
    ON bq.template_question_id = tq.id
LEFT JOIN stella_common.binders_t b
	ON bq.binder_id = b.binder_id
LEFT JOIN stella_common.sectors_t s
    ON bs.sector_id__sectors_t = s.sector_id
LEFT JOIN cm_deal_questions_t cdq
    ON bq.template_question_id = cdq.template_question_id
WHERE
    bs.is_deleted = 0
    AND bq.is_deleted = 0
    AND b.is_deleted = 0
    AND tq.is_deleted = 0
    AND cdq.is_deleted = 0
    AND bs.is_retired = 94
    AND bq.is_retired = 94

AND tq.auto_referral_type IS NOT NULL
