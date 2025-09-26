CREATE view sectors_v AS
SELECT
    s.sector_id
    , s.sector_name
    , s.sector_type sector_type_id
    , st.menu_item sector_type
    , s.parent_sector_id
    , ps.sector_name parent_sector
    , s.include_in_extracts_id
    , s.sector_bucket_id
    , sb.sector_name sector_bucket
    , psb.sector_name parent_sector_bucket

FROM
    stella_common.sectors_t s
LEFT JOIN
    stella_common.sectors_t ps
    ON s.parent_sector_id = ps.sector_id
LEFT JOIN
    stella_common.sectors_t sb
    ON s.sector_bucket_id = sb.sector_id
LEFT JOIN
    stella_common.menu_list_t st
    ON s.sector_type = st.menu_id
LEFT JOIN
    stella_common.sectors_t psb
    ON ps.sector_bucket_id = psb.sector_id
WHERE
    s.is_deleted = 0