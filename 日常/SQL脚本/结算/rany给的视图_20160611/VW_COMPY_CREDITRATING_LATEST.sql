CREATE OR REPLACE VIEW VW_COMPY_CREDITRATING_LATEST
(COMPANY_ID,COMPANY_NM,EXPOSURE_CD,MODEL_CODE,FACTOR_DT,USER_NM,QUAL_SCORE,QUAN_SCORE,TOTAL_SCORE,FINAL_RATING_RNK,FINAL_RATING,SCALED_PD,ADJUSTMENT_COMMENT,CREATION_TIME,RATING_DT,RATING_RNK,RATING,CREDIT_ORG_ID,CREDIT_ORG_NM,EXPOSURE_SID,EXPOSURE,REGION_CD,REGION_NM,SUM_ASSET,RPT_DT,CLIENT_ID)
AS
WITH
    rating_code_list AS
    (
          SELECT 1 AS rating_rnk,
               'AAA+' AS rating_code,
               'AAA1' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 2 AS rating_rnk,
               'AAA' AS rating_code,
               'AAA2' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 3 AS rating_rnk,
               'AAA-' AS rating_code,
               'AAA3' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 4 AS rating_rnk,
               'AA+' AS rating_code,
               'AA1' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 5 AS rating_rnk,
               'AA' AS rating_code,
               'AA2' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 6 AS rating_rnk,
               'AA-' AS rating_code,
               'AA3' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 7 AS rating_rnk,
               'A+' AS rating_code,
               'A1' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 8 AS rating_rnk,
               'A' AS rating_code,
               'A2' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 9 AS rating_rnk,
               'A-' AS rating_code,
               'A3' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 10 AS rating_rnk,
               'BBB+' AS rating_code,
               'BAA1' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 11 AS rating_rnk,
               'BBB' AS rating_code,
               'BAA2' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 12 AS rating_rnk,
               'BBB-' AS rating_code,
               'BAA3' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 13 AS rating_rnk,
               'BB+' AS rating_code,
               'BA1' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 14 AS rating_rnk,
               'BB' AS rating_code,
               'BA2' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 15 AS rating_rnk,
               'BB-' AS rating_code,
               'BA3' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 16 AS rating_rnk,
               'B+' AS rating_code,
               'B1' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 17 AS rating_rnk,
               'B' AS rating_code,
               'B2' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 18 AS rating_rnk,
               'B-' AS rating_code,
               'B3' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 19 AS rating_rnk,
               'CCC+' AS rating_code,
               'CAA1' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 20 AS rating_rnk,
               'CCC' AS rating_code,
               'CAA2' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 21 AS rating_rnk,
               'CCC-' AS rating_code,
               'CAA3' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 22 AS rating_rnk,
               'CC' AS rating_code,
               'CA' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 23 AS rating_rnk,
               'C' AS rating_code,
               'C' AS rating_code_moody
          from dual
        UNION ALL
        SELECT 24 AS rating_rnk,
               'D' AS rating_code,
               'D' AS rating_code_moody
          from dual
    )
  SELECT e.company_id,
         e.company_nm,
         x.exposure_cd,
         x.model_code,
         x.factor_dt,
         x.user_nm,
         x.qual_score,
         x.quan_score,
         x.total_score,
         f.rating_rnk AS final_rating_rnk,
         trim(x.final_rating) AS final_rating,
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
         to_date(y.rpt_dt, 'YYYYMMDD') AS rpt_dt,
         x.client_id
    FROM compy_basicinfo e
    LEFT JOIN (SELECT a.company_id,
                      a.exposure_sid,
                      c.exposure,
                      row_number() OVER(PARTITION BY a.company_id ORDER BY a.start_dt DESC) AS rnk
                 FROM compy_exposure a
                 JOIN exposure c
                   ON a.exposure_sid = c.exposure_sid) b
      ON b.company_id = e.company_id
     AND b.rnk = 1
    LEFT JOIN lkp_region d
      ON e.region = d.region_cd
    LEFT JOIN (SELECT a.company_id,
                      e_1.exposure_cd,
                      c."CODE" AS model_code,
                      a.factor_dt,
                      d_1.display_nm AS user_nm,
                      b_1.qual_score,
                      b_1.quan_score,
                      a.total_score,
                      a.final_rating,
                      a.scaled_pd,
                      a.adjustment_comment,
                      a.rating_start_dt AS creation_time,
                      a.client_id,
                      row_number() OVER(PARTITION BY a.company_id ORDER BY a.rating_start_dt DESC) AS rnk
                 FROM rating_record a
                 JOIN (SELECT a_1.rating_record_id AS rating_hist_id,
                             MAX(CASE
                                   WHEN b_2.type = 'DISCRETE' THEN
                                    a_1.score
                                   ELSE
                                    0
                                 END) AS qual_score,
                             MAX(CASE
                                   WHEN b_2.type in
                                        ('CONTINUOUS', 'DISCRETE_QUAN') THEN
                                    a_1.score
                                   ELSE
                                    0
                                 END) AS quan_score
                        FROM rating_detail a_1
                        JOIN rating_model_sub_model b_2
                          ON a_1.rating_model_sub_model_id = b_2.id
                       GROUP BY a_1.rating_record_id) b_1
                   ON a.rating_record_id = b_1.rating_hist_id
                 JOIN rating_model c
                   ON a.model_id = c."ID"
                 JOIN user_basicinfo d_1
                   ON a.user_id = d_1.user_id
                 JOIN exposure e_1
                   ON a.exposure_sid = e_1.exposure_sid
                WHERE a.rating_st = 1) x
      ON e.company_id = x.company_id
     AND x.rnk = 1
    LEFT JOIN (SELECT a.company_id,
                      a.rating_dt,
                      a.rating,
                      a.credit_org_id,
                      b_1.company_nm AS credit_org_nm,
                      row_number() OVER(PARTITION BY a.company_id ORDER BY a.rating_dt DESC, a.compy_creditrating_sid DESC) AS rnk
                 FROM compy_creditrating a
                 LEFT JOIN compy_basicinfo b_1
                   ON a.credit_org_id = b_1.company_id
                  AND b_1.is_del = 0
                WHERE a.isdel = 0 and nvl(b_1.company_nm,' ')<>'中国证券监督管理委员会') v
      ON e.company_id = v.company_id
     AND v.rnk = 1
    LEFT JOIN rating_code_list f
      ON (x.final_rating = f.rating_code OR x.final_rating = f.rating_code_moody)
    LEFT JOIN rating_code_list g
      ON (v.rating = g.rating_code OR v.rating = g.rating_code_moody)
    LEFT JOIN (SELECT company_id,
                      sum_asset,
                      rpt_dt,
                      row_number() OVER(PARTITION BY company_id ORDER BY rpt_dt DESC) AS rnk
                 FROM compy_balancesheet
                WHERE rpt_timetype_cd = 1
                  AND combine_type_cd = 1
                  AND data_ajust_type = 2) y
      ON e.company_id = y.company_id
     AND y.rnk = 1;
