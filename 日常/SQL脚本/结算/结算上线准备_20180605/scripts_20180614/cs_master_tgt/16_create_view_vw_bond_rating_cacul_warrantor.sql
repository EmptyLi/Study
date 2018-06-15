create or replace view vw_bond_rating_cacul_warrantor as
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
             JOIN client_basicinfo c_1 ON ((c_1.client_id = b.client_id)))
        ), rating_cd1 AS (
         SELECT a_1.constant_id,
            a_1.constant_nm AS ratingcd_nm,
            a_1.constant_type
           FROM lkp_charcode a_1
          WHERE ((a_1.constant_type = ANY (ARRAY[(211)::bigint, (212)::bigint, (213)::bigint, (214)::bigint, (215)::bigint])) AND (a_1.isdel = 0))
        ), rating_cd2 AS (
         SELECT a_1.constant_id,
            a_1.constant_nm,
            b.ratingcd_nm,
            a_1.constant_type,
            b.model_id
           FROM (lkp_charcode a_1
             JOIN tmp_lkp_ratingcd_xw b ON (((a_1.constant_nm)::text = (b.constant_nm)::text)))
          WHERE ((a_1.constant_type = ANY (ARRAY[(201)::bigint, (207)::bigint])) AND (a_1.isdel = 0))
        )
 SELECT f.model_id,
    a.secinner_id,
    c.rpt_dt,
    p.factor_dt,
    c.bond_warrantor_sid,
    c.warrantor_nm,
    f.ratingcd_nm AS guarantee_type,
    n.ratingcd_nm AS warrantor_type,
    o.ratingcd_nm AS warranty_strength,
    p.final_rating AS warrantor_rating,
    c.warranty_amt AS warranty_value,
    t.client_id
   FROM ((((((bond_basicinfo a
     JOIN client t ON ((1 = 1)))
     JOIN ( SELECT bond_warrantor.bond_warrantor_sid,
            bond_warrantor.rpt_dt,
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
