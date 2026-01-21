
CREATE OR REPLACE VIEW stella_eur.duplicate_deals_v AS
SELECT d.deal_id,
    bf.business_name broker_firm_name,
    d.broker_firm_id,
    d.budget_home_id,
    bh.budget_home_name,
    d.create_date,
    d.deal_name,
    CONCAT(d.deal_name, '\n', ' ' , '\n', bf.business_name) deal_name_broker_firm,
    d.deal_status_id,
    ds.menu_item deal_status,
    CONCAT(ds.menu_item, '\n', ' ' , '\n', rt.risk_type_name) deal_status_risk_type,
    d.ev,
    d.inception_date,
    d.primary_uw primary_uw_id,
    pu.uw_name primary_uw_name,
    d.risk_type_id,
    rt.risk_type_name,
    d.secondary_uw second_uw_id,
    su.uw_name second_uw_name,
    d.spa_law,

    -- All Target business names for the deal
    NULLIF(
        GROUP_CONCAT(DISTINCT CASE WHEN r.deal_role_name = 'target' THEN p.party_business_name END
            ORDER BY p.party_business_name SEPARATOR ', \n'),
      ''
    ) AS target_business_name,

    -- All Buyer business names for the deal
    NULLIF(
        GROUP_CONCAT(DISTINCT CASE WHEN r.deal_role_name = 'buyer' THEN p.party_business_name END
            ORDER BY p.party_business_name SEPARATOR ', \n'),
      ''
    ) AS buyer_business_name,

    -- All Seller business names for the deal
    NULLIF(
        GROUP_CONCAT(DISTINCT CASE WHEN r.deal_role_name = 'seller' THEN p.party_business_name END
            ORDER BY p.party_business_name SEPARATOR ', \n'),
      ''
    ) AS seller_business_name

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
    d.deal_id, d.deal_name;
