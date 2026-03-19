CREATE OR REPLACE VIEW stella_common.log_errors_v AS
SELECT
CONCAT(l.error_id, '_', l.app_continent, '\r\n', 'closed: ', ic.menu_item) error_id
, l.event_id
, l.system_error_text
, l.system_error_code
, l.stella_error_text
, l.routine_name
, l.call_stack
, l.params
, l.milestone
, l.uw_name
, l.app_name
, l.app_continent
, l.file_path
, l.is_closed_id
, l.create_date
FROM stella_eur.log_errors_t l
LEFT JOIN stella_common.menu_list_t ic ON l.is_closed_id = ic.menu_id

UNION

SELECT
CONCAT(l.error_id, '_', l.app_continent, '\r\n', 'closed: ', ic.menu_item) error_id
, l.event_id
, l.system_error_text
, l.system_error_code
, l.stella_error_text
, l.routine_name
, l.call_stack
, l.params
, l.milestone
, l.uw_name
, l.app_name
, l.app_continent
, l.file_path
, l.is_closed_id
, l.create_date
FROM stella_us.log_errors_t l
LEFT JOIN stella_common.menu_list_t ic ON l.is_closed_id = ic.menu_id
