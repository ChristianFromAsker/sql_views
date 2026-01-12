CREATE VIEW deal_parties_v AS
SELECT
    dp.deal_party_id,
    dp.create_date create_date_deal_party,
    dp.deal_id__deals_t deal_id,
    dr.deal_role_name,
    dr.deal_role_id,
    dp.party_percentage,
    p.party_brand_id__brands_t party_brand_id,
    p.party_business_name,
    p.party_city,
    p.party_legal_name,
    p.party_main_region_id__jurisdictions_t party_main_region_id,
    p.party_reg_no,
    j.jurisdiction                                  party_registered_country,
    p.party_registered_country_id__jurisdictions_t  party_registered_country_id,
    p.party_street_1,
    p.party_street_2,
    sub_s.sector_name                   party_sub_sector,
    p.party_sub_sector_id__sectors_t    party_sub_sector_id,
    super_s.sector_name                 party_super_sector,
    p.party_super_sector_id__sectors_t  party_super_sector_id,
    p.party_zip_code,
    p.party_id
FROM
    deal_parties_t dp
LEFT JOIN stella_common.deal_roles_t dr
    ON dp.deal_role_id__deal_roles_t = dr.deal_role_id
LEFT JOIN parties_t p
    ON dp.party_id__parties_t = p.party_id
LEFT JOIN stella_common.jurisdictions_t j
    ON p.party_registered_country_id__jurisdictions_t = j.jurisdiction_id
LEFT JOIN stella_common.sectors_t sub_s
    ON p.party_sub_sector_id__sectors_t = sub_s.sector_id
LEFT JOIN stella_common.sectors_t super_s
    ON p.party_super_sector_id__sectors_t = super_s.sector_id
WHERE
    dp.is_deleted = 0

