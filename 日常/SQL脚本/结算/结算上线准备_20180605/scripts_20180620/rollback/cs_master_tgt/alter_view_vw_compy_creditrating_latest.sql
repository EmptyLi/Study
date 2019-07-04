create view vw_compy_creditrating_latest as
  WITH rating_code_list AS (
    SELECT
      1              AS rating_rnk,
      'AAA+' :: text AS rating_code,
      'AAA1' :: text AS rating_code_moody
    UNION ALL
    SELECT
      2,
      'AAA' :: text  AS text,
      'AAA2' :: text AS text
    UNION ALL
    SELECT
      3,
      'AAA-' :: text AS text,
      'AAA3' :: text AS text
    UNION ALL
    SELECT
      4,
      'AA+' :: text AS text,
      'AA1' :: text AS text
    UNION ALL
    SELECT
      5,
      'AA' :: text  AS text,
      'AA2' :: text AS text
    UNION ALL
    SELECT
      6,
      'AA-' :: text AS text,
      'AA3' :: text AS text
    UNION ALL
    SELECT
      7,
      'A+' :: text AS text,
      'A1' :: text AS text
    UNION ALL
    SELECT
      8,
      'A' :: text  AS text,
      'A2' :: text AS text
    UNION ALL
    SELECT
      9,
      'A-' :: text AS text,
      'A3' :: text AS text
    UNION ALL
    SELECT
      10,
      'BBB+' :: text AS text,
      'BAA1' :: text AS text
    UNION ALL
    SELECT
      11,
      'BBB' :: text  AS text,
      'BAA2' :: text AS text
    UNION ALL
    SELECT
      12,
      'BBB-' :: text AS text,
      'BAA3' :: text AS text
    UNION ALL
    SELECT
      13,
      'BB+' :: text AS text,
      'BA1' :: text AS text
    UNION ALL
    SELECT
      14,
      'BB' :: text  AS text,
      'BA2' :: text AS text
    UNION ALL
    SELECT
      15,
      'BB-' :: text AS text,
      'BA3' :: text AS text
    UNION ALL
    SELECT
      16,
      'B+' :: text AS text,
      'B1' :: text AS text
    UNION ALL
    SELECT
      17,
      'B' :: text  AS text,
      'B2' :: text AS text
    UNION ALL
    SELECT
      18,
      'B-' :: text AS text,
      'B3' :: text AS text
    UNION ALL
    SELECT
      19,
      'CCC+' :: text AS text,
      'CAA1' :: text AS text
    UNION ALL
    SELECT
      20,
      'CCC' :: text  AS text,
      'CAA2' :: text AS text
    UNION ALL
    SELECT
      21,
      'CCC-' :: text AS text,
      'CAA3' :: text AS text
    UNION ALL
    SELECT
      22,
      'CC' :: text AS text,
      'CA' :: text AS text
    UNION ALL
    SELECT
      23,
      'C' :: text AS text,
      'C' :: text AS text
    UNION ALL
    SELECT
      24,
      'D' :: text AS text,
      'D' :: text AS text
  )
  SELECT
    b.company_id,
    e.company_nm,
    x.exposure_cd,
    x.model_code,
    x.factor_dt,
    x.user_nm,
    x.qual_score,
    x.quan_score,
    x.total_score,
    f.rating_rnk                                    AS final_rating_rnk,
    btrim((x.final_rating) :: text)                 AS final_rating,
    x.scaled_pd,
    x.adjustment_comment,
    x.creation_time,
    v.rating_dt,
    g.rating_rnk,
    v.rating,
    v.credit_org_id,
    v.credit_org_nm,
    b.exposure_sid,
    b.exposure,
    d.region_cd,
    d.region_nm,
    y.sum_asset,
    to_date((y.rpt_dt) :: text, 'YYYYMMDD' :: text) AS rpt_dt,
    x.client_id
  FROM (((((((compy_basicinfo e
    LEFT JOIN (SELECT
                 a.company_id,
                 a.exposure_sid,
                 c.exposure,
                 row_number()
                 OVER (
                   PARTITION BY a.company_id
                   ORDER BY a.start_dt DESC ) AS rnk
               FROM (compy_exposure a
                 JOIN exposure c ON ((a.exposure_sid = c.exposure_sid)))) b
      ON (((b.company_id = e.company_id) AND (b.rnk = 1))))
    LEFT JOIN lkp_region d ON ((e.region = d.region_cd)))
    LEFT JOIN (SELECT
                 a.company_id,
                 e_1.exposure_cd,
                 c.code                              AS model_code,
                 a.factor_dt,
                 d_1.display_nm                      AS user_nm,
                 b_1.qual_score,
                 b_1.quan_score,
                 a.total_score,
                 a.final_rating,
                 a.scaled_pd,
                 a.adjustment_comment,
                 a.rating_start_dt                   AS creation_time,
                 a.client_id,
                 row_number()
                 OVER (
                   PARTITION BY a.company_id
                   ORDER BY a.rating_start_dt DESC ) AS rnk
               FROM ((((rating_record a
                 JOIN (SELECT
                         a_1.rating_record_id AS rating_hist_id,
                         max(
                             CASE
                             WHEN ((b_2.type) :: text = 'DISCRETE' :: text)
                               THEN a_1.score
                             ELSE NULL :: numeric
                             END)             AS qual_score,
                         max(
                             CASE
                             WHEN ((b_2.type) :: text = ANY (ARRAY ['CONTINUOUS' :: text, 'DISCRETE_QUAN' :: text]))
                               THEN a_1.score
                             ELSE NULL :: numeric
                             END)             AS quan_score
                       FROM (rating_detail a_1
                         JOIN rating_model_sub_model b_2 ON ((a_1.rating_model_sub_model_id = b_2.id)))
                       GROUP BY a_1.rating_record_id) b_1 ON ((a.rating_record_id = b_1.rating_hist_id)))
                 JOIN rating_model c ON ((a.model_id = (c.id) :: numeric)))
                 JOIN user_basicinfo d_1 ON (((a.user_id) :: numeric = (d_1.user_id) :: numeric)))
                 JOIN exposure e_1 ON ((a.exposure_sid = (e_1.exposure_sid) :: numeric)))
               WHERE (a.rating_st = 1)) x ON ((((b.company_id) :: numeric = x.company_id) AND (x.rnk = 1))))
    LEFT JOIN (SELECT
                 a.company_id,
                 a.rating_dt,
                 a.rating,
                 a.credit_org_id,
                 b_1.company_nm                                               AS credit_org_nm,
                 row_number()
                 OVER (
                   PARTITION BY a.company_id
                   ORDER BY a.rating_dt DESC, a.compy_creditrating_sid DESC ) AS rnk
               FROM (compy_creditrating a
                 LEFT JOIN compy_basicinfo b_1 ON (((a.credit_org_id = b_1.company_id) AND (b_1.is_del = 0))))
               WHERE (a.isdel = 0)) v ON (((b.company_id = v.company_id) AND (v.rnk = 1))))
    LEFT JOIN rating_code_list f
      ON ((((x.final_rating) :: text = f.rating_code) OR ((x.final_rating) :: text = f.rating_code_moody))))
    LEFT JOIN rating_code_list g
      ON ((((v.rating) :: text = g.rating_code) OR ((v.rating) :: text = g.rating_code_moody))))
    LEFT JOIN (SELECT
                 compy_balancesheet.company_id,
                 compy_balancesheet.sum_asset,
                 (compy_balancesheet.rpt_dt) :: character varying AS rpt_dt,
                 row_number()
                 OVER (
                   PARTITION BY compy_balancesheet.company_id
                   ORDER BY compy_balancesheet.rpt_dt DESC )      AS rnk
               FROM compy_balancesheet
               WHERE (((compy_balancesheet.rpt_timetype_cd = 1) AND (compy_balancesheet.combine_type_cd = 1)) AND
                      (compy_balancesheet.data_ajust_type = 2))) y
      ON (((b.company_id = y.company_id) AND (y.rnk = 1))));

