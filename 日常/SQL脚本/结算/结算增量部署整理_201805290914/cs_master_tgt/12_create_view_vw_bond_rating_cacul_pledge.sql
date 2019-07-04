create view vw_bond_rating_cacul_pledge as
WITH tmp_lkp_ratingcd_xw AS (
         SELECT a_1.model_id,
            a_1.constant_nm,
            a_1.ratingcd_nm,
            a_1.constant_type,
            a_1.updt_by,
            a_1.updt_dt,
            b_1.model_id,
            b_1.model_cd,
            b_1.model_nm,
            b_1.model_desc,
            b_1.formula_ch,
            b_1.formula_en,
            b_1.version,
            b_1.is_active,
            b_1.isdel,
            b_1.client_id,
            b_1.updt_by,
            b_1.updt_dt,
            c.client_id,
            c.client_nm,
            c.client_snm,
            c.client_addr,
            c.contact,
            c.phone,
            c.email,
            c.purchase_dt,
            c.updt_dt
           FROM ((lkp_ratingcd_xw a_1
             JOIN bond_rating_model b_1 ON ((((b_1.model_id = a_1.model_id) AND (b_1.isdel = 0)) AND (b_1.is_active = 1))))
             JOIN client_basicinfo c ON ((c.client_id = b_1.client_id)))
        ), rating_cd_region AS (
         SELECT a_1.region_cd,
            a_1.region_nm,
            b_1.ratingcd_nm,
            b_1.model_id
           FROM (lkp_region a_1
             JOIN tmp_lkp_ratingcd_xw b_1(model_id, constant_nm, ratingcd_nm, constant_type, updt_by, updt_dt, model_id_1, model_cd, model_nm, model_desc, formula_ch, formula_en, version, is_active, isdel, client_id, updt_by_1, updt_dt_1, client_id_1, client_nm, client_snm, client_addr, contact, phone, email, purchase_dt, updt_dt_2) ON ((((substr((a_1.region_nm)::text, 1, 2) = substr((b_1.constant_nm)::text, 1, 2)) AND (a_1.parent_cd IS NULL)) AND (b_1.constant_type = 6))))
        ), rating_cd1 AS (
         SELECT a_1.constant_id,
            a_1.constant_nm AS ratingcd_nm,
            a_1.constant_type
           FROM lkp_charcode a_1
          WHERE ((a_1.constant_type = ANY (ARRAY[(211)::bigint, (212)::bigint, (213)::bigint, (214)::bigint, (215)::bigint])) AND (a_1.isdel = 0))
        ), client AS (
         SELECT DISTINCT client_basicinfo.client_id
           FROM client_basicinfo
        )
 SELECT r1.model_id,
    a.secinner_id,
    b.rpt_dt,
    b.bond_pledge_sid,
    b.pledge_nm,
    h.ratingcd_nm AS pledge_type,
    i.ratingcd_nm AS pledge_control,
    j.ratingcd_nm AS pledge_depend,
    b.pledge_value,
    b.priority_value,
    r1.ratingcd_nm AS pledge_region,
    t.client_id
   FROM ((((((bond_basicinfo a
     JOIN client t ON ((1 = 1)))
     JOIN bond_pledge b ON (((a.secinner_id = b.secinner_id) AND (b.isdel = 0))))
     LEFT JOIN rating_cd1 h ON ((b.pledge_type_id = h.constant_id)))
     LEFT JOIN rating_cd1 i ON ((b.pledge_control_id = i.constant_id)))
     LEFT JOIN rating_cd1 j ON ((b.pledge_depend_id = j.constant_id)))
     LEFT JOIN rating_cd_region r1 ON ((b.region = r1.region_cd)))
  WHERE (a.isdel = 0);
  commit;
