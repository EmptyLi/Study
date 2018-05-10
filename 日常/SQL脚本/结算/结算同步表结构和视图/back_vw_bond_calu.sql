CREATE VIEW vw_bond_rating_cacul AS WITH client AS (
         SELECT DISTINCT client_basicinfo.client_id
           FROM client_basicinfo
        ), rating_cd1 AS (
         SELECT a_1.constant_id,
            a_1.constant_nm AS ratingcd_nm,
            a_1.constant_type
           FROM lkp_charcode a_1
          WHERE ((a_1.constant_type = ANY (ARRAY[(211)::bigint, (212)::bigint, (213)::bigint, (214)::bigint, (215)::bigint])) AND (a_1.isdel = 0))
        ), rating_cd2 AS (
         SELECT a_1.constant_id,
            a_1.constant_nm,
            b_1.ratingcd_nm,
            a_1.constant_type
           FROM (lkp_charcode a_1
             JOIN lkp_ratingcd_xw b_1 ON (((a_1.constant_nm)::text = (b_1.constant_nm)::text)))
          WHERE ((a_1.constant_type = ANY (ARRAY[(201)::bigint, (207)::bigint])) AND (a_1.isdel = 0))
        ), rating_cd_region AS (
         SELECT a_1.region_cd,
            a_1.region_nm,
            b_1.ratingcd_nm
           FROM (lkp_region a_1
             JOIN lkp_ratingcd_xw b_1 ON ((((substr((a_1.region_nm)::text, 1, 2) = substr((b_1.constant_nm)::text, 1, 2)) AND (a_1.parent_cd IS NULL)) AND (b_1.constant_type = 6))))
        ), rating_cd_industry AS (
         SELECT a_1.exposure_sid,
            a_1.exposure,
            b_1.ratingcd_nm
           FROM (exposure a_1
             JOIN lkp_ratingcd_xw b_1 ON ((((a_1.exposure)::text = (b_1.constant_nm)::text) AND (b_1.constant_type = 5))))
          WHERE (a_1.isdel = 0)
        )
 SELECT nextval('seq_bond_rating_cacul'::regclass) AS bond_rating_cacul_sid,
    a.secinner_id,
    a.security_cd,
    a.security_nm,
    d.party_id AS company_id,
    m.company_nm,
    p.factor_dt,
    e.ratingcd_nm AS bond_type,
    COALESCE((chg.remain_vol / (10000)::numeric), a.issue_vol) AS remain_vol,
    lkporgnature.constant_nm AS corp_nature,
    r2.ratingcd_nm AS credit_region,
    l.ratingcd_nm AS industry,
    l.exposure,
    b.bond_pledge_sid,
    b.pledge_nm,
    h.ratingcd_nm AS pledge_type,
    i.ratingcd_nm AS pledge_control,
    j.ratingcd_nm AS pledge_depend,
    b.pledge_value,
    b.priority_value,
    r1.ratingcd_nm AS pledge_region,
    c.bond_warrantor_sid,
    c.warrantor_nm,
    f.ratingcd_nm AS guarantee_type,
    n.ratingcd_nm AS warrantor_type,
    o.ratingcd_nm AS warranty_strength,
    p.final_rating AS warrantor_rating,
    c.warranty_amt AS warranty_value,
    t.client_id
   FROM (((((((((((((((((((bond_basicinfo a
     JOIN client t ON ((1 = 1)))
     LEFT JOIN ( SELECT a_1.secinner_id,
            a_1.remain_vol,
            row_number() OVER (PARTITION BY a_1.secinner_id ORDER BY a_1.change_dt DESC) AS rnk
           FROM (bond_opvolchg a_1
             JOIN lkp_charcode b_1 ON ((((a_1.chg_type_id = b_1.constant_id) AND (b_1.constant_type = 45)) AND ((b_1.constant_nm)::text = ANY (ARRAY[('债券偿付本金'::character varying)::text, ('回售'::character varying)::text, ('到期'::character varying)::text, ('赎回'::character varying)::text])))))
          WHERE (((a_1.change_dt IS NOT NULL) AND (a_1.change_dt <= to_date('20170430'::text, 'yyyymmdd'::text))) AND (a_1.isdel = 0))) chg ON (((a.secinner_id = chg.secinner_id) AND (chg.rnk = 1))))
     LEFT JOIN ( SELECT x.secinner_id,
            x.party_id
           FROM (bond_party x
             JOIN lkp_charcode y ON ((((x.party_type_id = y.constant_id) AND (y.constant_type = 209)) AND ((y.constant_nm)::text = ANY (ARRAY[('债务人'::character varying)::text, ('联合债务人'::character varying)::text, ('发起人'::character varying)::text])))))) d ON ((a.secinner_id = d.secinner_id)))
     LEFT JOIN compy_basicinfo m ON ((d.party_id = m.company_id)))
     LEFT JOIN bond_pledge b ON (((a.secinner_id = b.secinner_id) AND (b.isdel = 0))))
     LEFT JOIN ( SELECT bond_warrantor.bond_warrantor_sid,
            bond_warrantor.secinner_id,
            bond_warrantor.warrantor_id,
            bond_warrantor.warrantor_nm,
            bond_warrantor.warrantor_type_id,
            bond_warrantor.guarantee_type_id,
            bond_warrantor.warranty_strength_id,
            bond_warrantor.warranty_amt,
            row_number() OVER (PARTITION BY bond_warrantor.secinner_id, bond_warrantor.warrantor_nm ORDER BY bond_warrantor.src_updt_dt DESC NULLS LAST, bond_warrantor.notice_dt DESC NULLS LAST) AS row_num
           FROM bond_warrantor
          WHERE (bond_warrantor.isdel = 0)) c ON (((a.secinner_id = c.secinner_id) AND (c.row_num = 1))))
     LEFT JOIN rating_cd2 e ON ((a.security_type_id = e.constant_id)))
     LEFT JOIN compy_bondissuer bdissuer ON (((d.party_id = bdissuer.company_id) AND (bdissuer.isdel = 0))))
     LEFT JOIN lkp_charcode lkporgnature ON ((((bdissuer.org_nature_id = lkporgnature.constant_id) AND (lkporgnature.constant_type = 46)) AND (lkporgnature.isdel = 0))))
     LEFT JOIN rating_cd_region r2 ON ((bdissuer.region = r2.region_cd)))
     LEFT JOIN rating_cd1 h ON ((b.pledge_type_id = h.constant_id)))
     LEFT JOIN rating_cd1 i ON ((b.pledge_control_id = i.constant_id)))
     LEFT JOIN rating_cd1 j ON ((b.pledge_depend_id = j.constant_id)))
     LEFT JOIN rating_cd_region r1 ON ((b.region = r1.region_cd)))
     LEFT JOIN ( SELECT a_1.company_id,
            a_1.client_id,
            b_1.ratingcd_nm,
            b_1.exposure
           FROM (compy_exposure a_1
             JOIN rating_cd_industry b_1 ON ((a_1.exposure_sid = b_1.exposure_sid)))
          WHERE ((a_1.isdel = 0) AND (a_1.is_new = 1))) l ON (((COALESCE(d.party_id, bdissuer.company_id) = l.company_id) AND (l.client_id = t.client_id))))
     LEFT JOIN rating_cd2 f ON ((c.guarantee_type_id = f.constant_id)))
     LEFT JOIN rating_cd1 n ON ((c.warrantor_type_id = n.constant_id)))
     LEFT JOIN rating_cd1 o ON ((c.warranty_strength_id = o.constant_id)))
     LEFT JOIN ( SELECT rating_record.company_id,
            rating_record.client_id,
            rating_record.factor_dt,
            rating_record.final_rating,
            row_number() OVER (PARTITION BY rating_record.company_id, rating_record.client_id ORDER BY rating_record.factor_dt DESC, rating_record.rating_start_dt DESC) AS row_num
           FROM rating_record
          WHERE ((rating_record.rating_type = 2) AND (rating_record.rating_st = 1))) p ON (((((c.warrantor_id)::numeric = p.company_id) AND (p.row_num = 1)) AND (p.client_id = t.client_id))))
  WHERE (a.isdel = 0);
