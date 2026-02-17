CREATE OR REPLACE VIEW deal_folder_help_v AS
SELECT d.deal_id
, d.deal_name
, d.deal_status_id
, d.spa_law
, d.target_business_name
, bf.business_name 	broker_firm
, ds.setting1 		status_folder
, ds.setting1_us 	status_folder_us
, fr.menu_item 		folder_region
, sl.abbrevation 	spa_law_abbreviation
, d.create_date_year
, d.create_date_year 	create_year
, YEAR(d.inception_date) inception_year
FROM deals_t d
LEFT JOIN broker_firms_t bf
    ON d.broker_firm_id = bf.broker_firm_id
LEFT JOIN stella_common.jurisdictions_t sl
    ON d.spa_law = sl.jurisdiction
LEFT JOIN stella_common.menu_list_t ds
    ON d.deal_status_id = ds.menu_id
LEFT JOIN    stella_common.menu_list_t fr
    ON sl.working_folder_id = fr.menu_id
WHERE d.is_deleted = 0
