CREATE OR REPLACE VIEW VW_BOND_RATING_CACUL AS
WITH
    client AS
    (
        SELECT DISTINCT
            client_basicinfo.client_id
        FROM
            client_basicinfo
    )
   ,
    rating_cd2 AS
    (
        SELECT
            a.constant_id,
            a.constant_nm,
            b.ratingcd_nm,
            a.constant_type
        FROM
            lkp_charcode a
        JOIN
            lkp_ratingcd_xw b
        ON
            a.constant_nm= b.constant_nm
        WHERE
            a.constant_type IN (201,
                                207)
        AND a.isdel = 0
    )
    ,
    rating_cd_region AS
    (
        SELECT
            a.region_cd,
            a.region_nm,
            b.ratingcd_nm
        FROM
            lkp_region a
        JOIN
            lkp_ratingcd_xw b
        ON
            SUBSTR(a.region_nm, 1, 2) = SUBSTR(b.constant_nm , 1, 2)
        AND a.parent_cd IS NULL
        AND b.constant_type=6
    )
    ,
    rating_cd_industry AS
    (
        SELECT
            a.exposure_sid,
            a.exposure,
            b.ratingcd_nm
        FROM
            exposure a
        JOIN
            lkp_ratingcd_xw b
        ON
            a.exposure= b.constant_nm
        AND constant_type=5
        WHERE
            a.isdel=0
    )
SELECT
    row_number()over(ORDER BY NULL) AS bond_rating_cacul_sid,
  a."SECINNER_ID",a."SECURITY_CD",a."SECURITY_NM",a."COMPANY_ID",a."COMPANY_NM",a."BOND_TYPE",a."REMAIN_VOL",a."CORP_NATURE",a."CREDIT_REGION",a."INDUSTRY",a."EXPOSURE",a."CLIENT_ID"
from
    (
  select distinct
    a.secinner_id,
    a.security_cd,
    a.security_nm,
    d.issuer_id AS company_id,
    m.company_nm,
    e.ratingcd_nm                              AS bond_type,
    COALESCE(chg.remain_vol/10000,a.issue_vol) AS remain_vol,
    lkpOrgnature.constant_nm                   AS corp_nature,
    r2.ratingcd_nm                             AS credit_region,
    l.ratingcd_nm                              AS industry,
    l.exposure,
    t.client_id
FROM
    bond_basicinfo a
JOIN
    client t
ON
    1 = 1
LEFT JOIN
    (
        SELECT
            a.secinner_id,
            a.remain_vol,
            row_number()over(partition BY a.secinner_id ORDER BY a.change_dt DESC) AS rnk
        FROM
            bond_opvolchg a
        JOIN
            lkp_charcode b
        ON
            a.chg_type_id=b.constant_id
        AND b.constant_type=45
        AND b.constant_nm IN ('债券偿付本金',
                              '回售',
                              '到期',
                              '赎回')
        WHERE
            a.change_dt IS NOT NULL
        AND a.change_dt<=systimestamp
        AND a.isdel=0 and b.isdel=0)chg
ON
    a.secinner_id=chg.secinner_id
AND rnk=1
LEFT JOIN VW_BOND_ISSUER d
-- LEFT JOIN
    -- (
        -- SELECT
            -- x.secinner_id,
            -- x.party_id
        -- FROM
            -- bond_party x
        -- JOIN
            -- lkp_charcode y
        -- ON
            -- x.party_type_id = y.constant_id
        -- AND y.constant_type = 209
        -- AND y.constant_nm IN ('债务人',
                              -- '联合债务人',
                              -- '发起人')
    -- and y.isdel=0
        -- where x.isdel=0
    -- and  sysdate > nvl(x.START_DT, sysdate -  1)
    -- and sysdate <= nvl(x.END_DT, sysdate + 1)
    -- )d
ON
    a.secinner_id = d.secinner_id
LEFT JOIN
    compy_basicinfo m
ON
    d.issuer_id = m.company_id and m.is_del=0
LEFT JOIN
    rating_cd2 e
ON
    a.security_type_id = e.constant_id
LEFT JOIN
    compy_bondissuer bdissuer
  ON d.issuer_id=bdissuer.company_id AND bdissuer.isdel=0
LEFT JOIN
    lkp_charcode lkpOrgnature
   ON bdissuer.org_nature_id=lkpOrgnature.constant_id
  AND lkpOrgnature.constant_type=46
  AND lkpOrgnature.isdel=0
LEFT JOIN
    rating_cd_region r2
    ON bdissuer.region = r2.region_cd
LEFT JOIN
    (
        SELECT
            a.company_id,
            a.client_id,
            b.ratingcd_nm,
            b.exposure
        FROM
            compy_exposure a
        JOIN
            rating_cd_industry b
        ON
            a.exposure_sid = b.exposure_sid
        WHERE
            a.isdel=0
        AND a.is_new=1 ) l
ON
    COALESCE(d.issuer_id,bdissuer.company_id) = l.company_id
AND l.client_id = t.client_id
WHERE
    a.isdel = 0

)a
;
