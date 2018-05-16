CREATE OR REPLACE VIEW VW_BOND_RATING_CACUL_WARRANTOR AS
WITH client AS (
         SELECT DISTINCT client_basicinfo.client_id
           FROM client_basicinfo
        ),
		rating_cd1 AS (
         SELECT a.constant_id,
            a.constant_nm AS ratingcd_nm,
            a.constant_type
           FROM lkp_charcode a
          WHERE a.constant_type in (211,212,213,214,215) AND a.isdel = 0
        ),
		rating_cd2 AS (
         SELECT a.constant_id,
            a.constant_nm,
            b.ratingcd_nm,
            a.constant_type
           FROM lkp_charcode a
             JOIN lkp_ratingcd_xw b ON a.constant_nm= b.constant_nm
          WHERE a.constant_type in (201, 207) AND a.isdel = 0
        )
 SELECT
    a.secinner_id,
    p.factor_dt,
    c.bond_warrantor_sid,
    c.warrantor_nm,
    f.ratingcd_nm AS guarantee_type,
    n.ratingcd_nm AS warrantor_type,
    o.ratingcd_nm AS warranty_strength,
    p.final_rating AS warrantor_rating,
    c.warranty_amt AS warranty_value,
    t.client_id
   FROM bond_basicinfo a
     JOIN client t ON 1 = 1
     JOIN ( SELECT bond_warrantor_sid,
						secinner_id,
						warrantor_id,
						warrantor_nm,
						warrantor_type_id,
						guarantee_type_id,
						warranty_strength_id,
						warranty_amt,
						row_number() OVER (PARTITION BY secinner_id, warrantor_nm ORDER BY src_updt_dt DESC NULLS LAST, notice_dt DESC NULLS LAST) AS row_num
				FROM bond_warrantor
				WHERE isdel = 0
				)c ON a.secinner_id = c.secinner_id AND c.row_num = 1
     LEFT JOIN rating_cd2 f ON c.guarantee_type_id = f.constant_id
     LEFT JOIN rating_cd1 n ON c.warrantor_type_id = n.constant_id
     LEFT JOIN rating_cd1 o ON c.warranty_strength_id = o.constant_id
     LEFT JOIN (SELECT 	company_id,
						client_id,
						factor_dt,
						final_rating,
						row_number() OVER (PARTITION BY company_id, client_id ORDER BY factor_dt DESC, rating_start_dt DESC) AS row_num
				FROM rating_record
				where rating_type=2 and RATING_ST=1
				) p ON c.warrantor_id = p.company_id AND p.row_num = 1 AND p.client_id = t.client_id
  WHERE a.isdel = 0;
