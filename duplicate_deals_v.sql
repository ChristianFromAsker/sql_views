
CREATE OR REPLACE VIEW stella_eur.duplicate_deals_v AS
SELECT d.deal_id,
    bf.business_name broker_firm_name,
    d.broker_firm_id,
    d.budget_home_id,
    bh.budget_home_name,
    CONCAT(bh.budget_home_name, '<br><br>', d.spa_law) budget_home_spa_law,
    d.create_date,
    CONCAT(
        '<i>deal name</i>:  ', d.deal_name, '<br>',
        '<i>risk type</i>:  ', IFNULL(rt.risk_type_name, ''), '<br>',
        '<i>deal status</i>:  ', ds.menu_item, '<br>',
        '<i>broker firm</i>:  ', IFNULL(bf.business_name, ''), '<br>',
        '<i>spa law</i>:  ', d.spa_law, '<br>',
        '<i>1st uw</i>:  ', IFNULL(pu.uw_name, ''), '<br>'
    ) deal_data,
    d.deal_name,
    CONCAT(d.deal_name, '<br><br>', bf.business_name) deal_name_broker_firm,
    d.deal_status_id,
    ds.menu_item deal_status,
    CONCAT(ds.menu_item, '<br><br>', rt.risk_type_name, '<br>', ' ' , '<br>', d.deal_id) deal_status_risk_type,
    d.ev,
    d.inception_date,
    d.primary_uw primary_uw_id,
    pu.uw_name primary_uw_name,
    CONCAT(NULLIF(pu.uw_name, 'not provided'), '<br><br>', NULLIF(su.uw_name, 'not provided')) primary_uw_second_uw,
    d.risk_type_id,
    rt.risk_type_name,
    d.secondary_uw second_uw_id,
    su.uw_name second_uw_name,
    d.spa_law,

    -- All insured business names for the deal
    NULLIF(
        GROUP_CONCAT(DISTINCT CASE WHEN r.deal_role_name = 'insured' THEN CONCAT(p.party_business_name, '<br>', p.party_legal_name ) END
            ORDER BY p.party_business_name SEPARATOR ',<br><br>'
        ),
      ''
    ) AS insureds,

    -- All Target business names for the deal
    NULLIF(
        GROUP_CONCAT(DISTINCT CASE WHEN r.deal_role_name = 'target' THEN p.party_business_name END
            ORDER BY p.party_business_name SEPARATOR ',<br>'),
      ''
    ) AS targets,

    -- All Buyer business names for the deal
    NULLIF(
        GROUP_CONCAT(DISTINCT CASE WHEN r.deal_role_name = 'buyer' THEN p.party_business_name END
            ORDER BY p.party_business_name SEPARATOR ',<br>'),
      ''
    ) AS buyers,

    -- All Seller business names for the deal
    NULLIF(
        GROUP_CONCAT(DISTINCT CASE WHEN r.deal_role_name = 'seller' THEN CONCAT(p.party_business_name, '<br>', p.party_legal_name ) END
            ORDER BY p.party_business_name SEPARATOR ',<br><br>'
        ),
      ''
    ) AS sellers

FROM deals_t d
LEFT JOIN broker_firms_t bf
    ON d.broker_firm_id = bf.broker_firm_id
LEFT JOIN deal_parties_t dp
    ON dp.deal_id__deals_t = d.deal_id
LEFT JOIN parties_t p
    ON p.party_id = dp.party_id__parties_t
LEFT JOIN stella_common.budget_homes_t bh
    ON d.budget_home_id = bh.budget_home_id
LEFT JOIN stella_common.deal_roles_t r
    ON r.deal_role_id = dp.deal_role_id__deal_roles_t
LEFT JOIN stella_common.deal_statuses_t ds
    ON ds.menu_id = d.deal_status_id
LEFT JOIN stella_common.risk_types_t rt
    ON d.risk_type_id = rt.risk_type_id
LEFT JOIN stella_common.underwriters_t pu
    ON d.primary_uw = pu.uw_id
LEFT JOIN stella_common.underwriters_t su
    ON d.secondary_uw = su.uw_id
WHERE r.is_deleted = 0
    AND dp.is_deleted = 0
GROUP BY
    d.deal_id, d.deal_name
ORDER BY d.deal_id DESC;
