-- select * from BOND_RATING_FACTOR

-- create table ray_BOND_RATING_FACTOR as select * from BOND_RATING_FACTOR;

select BOND_RATING_FACTOR_SID
,BOND_RATING_RECORD_SID
-- ,ORIG_RECORD_SID
,FACTOR_CD
,FACTOR_NM
,FACTOR_TYPE
,FACTOR_VALUE
,OPTION_NUM
,RATIO
-- ,FACTOR_VAL_REVISED
-- ,OPTION_NUM_REVISED
-- ,RATIO_REVISED
-- ,ADJUSTMENT_COMMENT
,CLIENT_ID
,UPDT_BY
,UPDT_DT
from BOND_RATING_FACTOR;

rename BOND_RATING_FACTOR to ray_BOND_RATING_FACTOR_0516;
alter table ray_BOND_RATING_FACTOR_0516 rename CONSTRAINT PK_BOND_RATING_FACTOR to ray_PK_BOND_RATING_FACTOR;
alter index  PK_BOND_RATING_FACTOR rename to ray_PK_BOND_RATING_FACTOR;

select * from user_indexes where table_name = 'RAY_BOND_RATING_FACTOR_0516'

create table BOND_RATING_FACTOR
(
	BOND_RATING_FACTOR_SID NUMBER(16) not null
		constraint PK_BOND_RATING_FACTOR
			primary key,
	BOND_RATING_RECORD_SID NUMBER(16) not null,
   ORIG_RECORD_SID	VARCHAR2(200)	NOT NULL,
	FACTOR_CD VARCHAR2(30) not null,
	FACTOR_NM VARCHAR2(200) not null,
	FACTOR_TYPE VARCHAR2(60) not null,
	FACTOR_VALUE VARCHAR2(600) not null,
	OPTION_NUM NUMBER,
	RATIO NUMBER(10,4),
   FACTOR_VAL_REVISED	VARCHAR2(600)	,
   OPTION_NUM_REVISED	INTEGER	,
   RATIO_REVISED	NUMBER(10,4)	,
   ADJUSTMENT_COMMENT	VARCHAR2(600)	,
	CLIENT_ID NUMBER(16) not null,
	UPDT_BY NUMBER(16) not null,
	UPDT_DT TIMESTAMP(6) not null
)
/

-- backup
CREATE VIEW VW_BOND_RATING_CACUL AS WITH
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
    a."SECINNER_ID",
    a."SECURITY_CD",
    a."SECURITY_NM",
    a."COMPANY_ID",
    a."COMPANY_NM",
    a."BOND_TYPE",
    a."REMAIN_VOL",
    a."CORP_NATURE",
    a."CREDIT_REGION",
    a."INDUSTRY",
    a."EXPOSURE",
    a."CLIENT_ID"
FROM
    (
        SELECT DISTINCT
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
                AND a.isdel=0
                AND b.isdel=0)chg
        ON
            a.secinner_id=chg.secinner_id
        AND rnk=1
        LEFT JOIN
            VW_BOND_ISSUER d
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
            d.issuer_id = m.company_id
        AND m.is_del=0
        LEFT JOIN
            rating_cd2 e
        ON
            a.security_type_id = e.constant_id
        LEFT JOIN
            compy_bondissuer bdissuer
        ON
            d.issuer_id=bdissuer.company_id
        AND bdissuer.isdel=0
        LEFT JOIN
            lkp_charcode lkpOrgnature
        ON
            bdissuer.org_nature_id=lkpOrgnature.constant_id
        AND lkpOrgnature.constant_type=46
        AND lkpOrgnature.isdel=0
        LEFT JOIN
            rating_cd_region r2
        ON
            bdissuer.region = r2.region_cd
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
            a.isdel = 0 )a
/

CREATE VIEW VW_BOND_RATING_CACUL_PLEDGE AS WITH
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
    rating_cd1 AS
    (
        SELECT
            a.constant_id,
            a.constant_nm AS ratingcd_nm,
            a.constant_type
        FROM
            lkp_charcode a
        WHERE
            a.constant_type IN (211,212,213,214,215)
        AND a.isdel = 0
    )
    ,
    client AS
    (
        SELECT DISTINCT
            client_basicinfo.client_id
        FROM
            client_basicinfo
    )
SELECT
    a.secinner_id,
    b.bond_pledge_sid,
    b.pledge_nm,
    h.ratingcd_nm AS pledge_type,
    i.ratingcd_nm AS pledge_control,
    j.ratingcd_nm AS pledge_depend,
    b.pledge_value,
    b.priority_value,
    r1.ratingcd_nm AS pledge_region,
    t.client_id
FROM
    bond_basicinfo a
JOIN
    client t
ON
    1 = 1
JOIN
    bond_pledge b
ON
    a.secinner_id = b.secinner_id
AND b.isdel = 0
LEFT JOIN
    rating_cd1 h
ON
    b.pledge_type_id = h.constant_id
LEFT JOIN
    rating_cd1 i
ON
    b.pledge_control_id = i.constant_id
LEFT JOIN
    rating_cd1 j
ON
    b.pledge_depend_id = j.constant_id
LEFT JOIN
    rating_cd_region r1
ON
    b.region = r1.region_cd
WHERE
    a.isdel = 0
/


CREATE VIEW VW_BOND_RATING_CACUL_WARRANTOR AS WITH
    client AS
    (
        SELECT DISTINCT
            client_basicinfo.client_id
        FROM
            client_basicinfo
    )
    ,
    rating_cd1 AS
    (
        SELECT
            a.constant_id,
            a.constant_nm AS ratingcd_nm,
            a.constant_type
        FROM
            lkp_charcode a
        WHERE
            a.constant_type IN (211,212,213,214,215)
        AND a.isdel = 0
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
SELECT
    a.secinner_id,
    p.factor_dt,
    c.bond_warrantor_sid,
    c.warrantor_nm,
    f.ratingcd_nm  AS guarantee_type,
    n.ratingcd_nm  AS warrantor_type,
    o.ratingcd_nm  AS warranty_strength,
    p.final_rating AS warrantor_rating,
    c.warranty_amt AS warranty_value,
    t.client_id
FROM
    bond_basicinfo a
JOIN
    client t
ON
    1 = 1
JOIN
    (
        SELECT
            bond_warrantor_sid,
            secinner_id,
            warrantor_id,
            warrantor_nm,
            warrantor_type_id,
            guarantee_type_id,
            warranty_strength_id,
            warranty_amt,
            row_number() OVER (PARTITION BY secinner_id, warrantor_nm ORDER BY src_updt_dt DESC
            NULLS LAST, notice_dt DESC NULLS LAST) AS row_num
        FROM
            bond_warrantor
        WHERE
            isdel = 0 )c
ON
    a.secinner_id = c.secinner_id
AND c.row_num = 1
LEFT JOIN
    rating_cd2 f
ON
    c.guarantee_type_id = f.constant_id
LEFT JOIN
    rating_cd1 n
ON
    c.warrantor_type_id = n.constant_id
LEFT JOIN
    rating_cd1 o
ON
    c.warranty_strength_id = o.constant_id
LEFT JOIN
    (
        SELECT
            company_id,
            client_id,
            factor_dt,
            final_rating,
            row_number() OVER (PARTITION BY company_id, client_id ORDER BY factor_dt DESC,
            rating_start_dt DESC) AS row_num
        FROM
            rating_record
        WHERE
            rating_type=2
        AND RATING_ST=1 ) p
ON
    c.warrantor_id = p.company_id
AND p.row_num = 1
AND p.client_id = t.client_id
WHERE
    a.isdel = 0
/
