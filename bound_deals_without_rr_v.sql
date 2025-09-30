CREATE VIEW bound_deals_without_rr AS
SELECT
    d.deal_id

    , analyst.uw_name analyst_full_name
    , bh.entity_business_name budget_home
    , d.budget_home_id

    , d.ClosingBooked
    , d.create_date

    , d.deal_status_id
    , ds.menu_item deal_status
    , d.deal_name

    , closing_booked.menu_item is_closing_booked
    , d.CounselInvoiceHandled

    , d.inception_date
    , d.VDRReceived
    , d.signing_invoice_amount
    , d.total_rp_premium_on_deal - d.signing_invoice_amount closing_invoice_amount
    , d.signing_premium_received_date
    , d.closing_premium_received_date
    , d.rr_done
    , ml.menu_item rr_done_hr
    , d.are_emails_filed_id
    , ml_c5_emails.menu_item c5_emails_filed_hr
    , counsel_invoice_handled.menu_item counsel_invoice_handled_hr
    , vdr_received.menu_item vdr_received_hr
    , uw1.uw_name primary_uw_full_name
    , uw2.uw_name second_uw_full_name

FROM
    stella_eur.deals_t AS d
LEFT JOIN
    stella_common.entities_t bh
    ON d.budget_home_id = bh.entity_id
LEFT JOIN
    stella_common.menu_list_t ds
    ON d.deal_status_id = ds.menu_id
LEFT JOIN
    stella_common.menu_list_t ml
    ON d.rr_done = ml.menu_id
LEFT JOIN
    stella_common.menu_list_t ml_c5_emails
    ON d.are_emails_filed_id = ml_c5_emails.menu_id
LEFT JOIN
    stella_common.menu_list_t closing_booked
    ON d.ClosingBooked = closing_booked.menu_id
LEFT JOIN
    stella_common.menu_list_t counsel_invoice_handled
    ON d.CounselInvoiceHandled = counsel_invoice_handled.menu_id
LEFT JOIN
    stella_common.menu_list_t premium_received
    ON d.PremiumReceived = premium_received.menu_id
LEFT JOIN
    stella_common.menu_list_t vdr_received
    ON d.VDRReceived = vdr_received.menu_id
LEFT JOIN
    stella_common.underwriters_t analyst
    ON d.analyst_id = analyst.uw_id
LEFT JOIN
    stella_common.underwriters_t uw1
    ON d.primary_uw = uw1.uw_id
LEFT JOIN
    stella_common.underwriters_t uw2
    ON d.secondary_uw = uw2.uw_id
WHERE
    Year(inception_date) >= 2019
    AND d.is_deleted = 0
    AND (d.deal_status_id = 6 OR d.deal_status_id = 436)

UNION

SELECT
    d.deal_id

    , analyst.uw_name analyst_full_name
    , bh.entity_business_name budget_home
    , d.budget_home_id

    , d.ClosingBooked
    , d.create_date

    , d.deal_status_id
    , ds.menu_item deal_status
    , d.deal_name

    , closing_booked.menu_item is_closing_booked
    , d.CounselInvoiceHandled

    , d.inception_date
    , d.VDRReceived
    , d.signing_invoice_amount
    , d.total_rp_premium_on_deal - d.signing_invoice_amount closing_invoice_amount
    , d.signing_premium_received_date
    , d.closing_premium_received_date
    , d.rr_done
    , ml.menu_item rr_done_hr
    , d.are_emails_filed_id
    , ml_c5_emails.menu_item c5_emails_filed_hr
    , counsel_invoice_handled.menu_item counsel_invoice_handled_hr
    , vdr_received.menu_item vdr_received_hr
    , uw1.uw_name primary_uw_full_name
    , uw2.uw_name second_uw_full_name

FROM
    stella_us.deals_t AS d
LEFT JOIN
    stella_common.entities_t bh
    ON d.budget_home_id = bh.entity_id
LEFT JOIN
    stella_common.menu_list_t ds
    ON d.deal_status_id = ds.menu_id
LEFT JOIN
    stella_common.menu_list_t ml
    ON d.rr_done = ml.menu_id
LEFT JOIN
    stella_common.menu_list_t ml_c5_emails
    ON d.are_emails_filed_id = ml_c5_emails.menu_id
LEFT JOIN
    stella_common.menu_list_t closing_booked
    ON d.ClosingBooked = closing_booked.menu_id
LEFT JOIN
    stella_common.menu_list_t counsel_invoice_handled
    ON d.CounselInvoiceHandled = counsel_invoice_handled.menu_id
LEFT JOIN
    stella_common.menu_list_t premium_received
    ON d.PremiumReceived = premium_received.menu_id
LEFT JOIN
    stella_common.menu_list_t vdr_received
    ON d.VDRReceived = vdr_received.menu_id
LEFT JOIN
    stella_common.underwriters_t analyst
    ON d.analyst_id = analyst.uw_id
LEFT JOIN
    stella_common.underwriters_t uw1
    ON d.primary_uw = uw1.uw_id
LEFT JOIN
    stella_common.underwriters_t uw2
    ON d.secondary_uw = uw2.uw_id
WHERE
    Year(inception_date) >= 2019
    AND d.is_deleted = 0
    AND (d.deal_status_id = 6 OR d.deal_status_id = 436)