create view vw_bond_rating_cacul as
WITH client AS (
         SELECT DISTINCT client_basicinfo.client_id
           FROM client_basicinfo
        ), tmp_lkp_ratingcd_xw AS (
         SELECT a_1.model_id,
            a_1.constant_nm,
            a_1.ratingcd_nm,
            a_1.constant_type,
            a_1.updt_by,
            a_1.updt_dt
           FROM ((lkp_ratingcd_xw a_1
             JOIN bond_rating_model b ON ((((b.model_id = a_1.model_id) AND (b.isdel = 0)) AND (b.is_active = 1))))
             JOIN client_basicinfo c ON ((c.client_id = b.client_id)))
        ), rating_cd2 AS (
         SELECT a_1.constant_id,
            a_1.constant_nm,
            b.ratingcd_nm,
            a_1.constant_type,
            b.model_id
           FROM (lkp_charcode a_1
             JOIN tmp_lkp_ratingcd_xw b ON (((a_1.constant_nm)::text = (b.constant_nm)::text)))
          WHERE ((a_1.constant_type = ANY (ARRAY[(201)::bigint, (207)::bigint])) AND (a_1.isdel = 0))
        ), rating_cd_region AS (
         SELECT a_1.region_cd,
            a_1.region_nm,
            b.ratingcd_nm,
            b.model_id
           FROM (lkp_region a_1
             JOIN tmp_lkp_ratingcd_xw b ON ((((substr((a_1.region_nm)::text, 1, 2) = substr((b.constant_nm)::text, 1, 2)) AND (a_1.parent_cd IS NULL)) AND (b.constant_type = 6))))
        ), rating_cd_industry AS (
         SELECT a_1.exposure_sid,
            a_1.exposure,
            b.ratingcd_nm,
            b.model_id
           FROM (exposure a_1
             JOIN tmp_lkp_ratingcd_xw b ON ((((a_1.exposure_sid)::text = (b.constant_nm)::text) AND (b.constant_type = 5))))
          WHERE (a_1.isdel = 0)
        )
 SELECT row_number() OVER (ORDER BY NULL::text) AS bond_rating_cacul_sid,
    a.model_id,
    a.secinner_id,
    a.security_cd,
    a.security_nm,
    a.company_id,
    a.company_nm,
    a.bond_type,
    a.remain_vol,
    a.corp_nature,
    a.credit_region,
    a.industry,
    a.exposure,
    a.client_id
   FROM ( SELECT DISTINCT COALESCE(e.model_id, r2.model_id, l.model_id) AS model_id,
            a_1.secinner_id,
            a_1.security_cd,
            a_1.security_nm,
            d.issuer_id AS company_id,
            m.company_nm,
            e.ratingcd_nm AS bond_type,
            COALESCE((chg.remain_vol / (10000)::numeric), a_1.issue_vol) AS remain_vol,
            lkporgnature.constant_nm AS corp_nature,
            r2.ratingcd_nm AS credit_region,
            l.ratingcd_nm AS industry,
            l.exposure,
            t.client_id
           FROM (((((((((bond_basicinfo a_1
             JOIN client t ON ((1 = 1)))
             LEFT JOIN ( SELECT a_2.secinner_id,
                    a_2.remain_vol,
                    row_number() OVER (PARTITION BY a_2.secinner_id ORDER BY a_2.change_dt DESC) AS rnk
                   FROM (bond_opvolchg a_2
                     JOIN lkp_charcode b ON ((((a_2.chg_type_id = b.constant_id) AND (b.constant_type = 45)) AND ((b.constant_nm)::text = ANY (ARRAY[('债券偿付本金'::character varying)::text, ('回售'::character varying)::text, ('到期'::character varying)::text, ('赎回'::character varying)::text])))))
                  WHERE ((((a_2.change_dt IS NOT NULL) AND (a_2.change_dt <= now())) AND (a_2.isdel = 0)) AND (b.isdel = 0))) chg ON (((a_1.secinner_id = chg.secinner_id) AND (chg.rnk = 1))))
             LEFT JOIN vw_bond_issuer d ON ((a_1.secinner_id = d.secinner_id)))
             LEFT JOIN compy_basicinfo m ON (((d.issuer_id = m.company_id) AND (m.is_del = 0))))
             LEFT JOIN rating_cd2 e ON ((a_1.security_type_id = e.constant_id)))
             LEFT JOIN compy_bondissuer bdissuer ON (((d.issuer_id = bdissuer.company_id) AND (bdissuer.isdel = 0))))
             LEFT JOIN lkp_charcode lkporgnature ON ((((bdissuer.org_nature_id = lkporgnature.constant_id) AND (lkporgnature.constant_type = 46)) AND (lkporgnature.isdel = 0))))
             LEFT JOIN rating_cd_region r2 ON ((bdissuer.region = r2.region_cd)))
             LEFT JOIN ( SELECT a_2.company_id,
                    a_2.client_id,
                    b.ratingcd_nm,
                    b.exposure,
                    b.model_id
                   FROM (compy_exposure a_2
                     JOIN rating_cd_industry b ON ((a_2.exposure_sid = b.exposure_sid)))
                  WHERE ((a_2.isdel = 0) AND (a_2.is_new = 1))) l ON (((COALESCE(d.issuer_id, bdissuer.company_id) = l.company_id) AND (l.client_id = t.client_id))))
          WHERE (a_1.isdel = 0)) a;
