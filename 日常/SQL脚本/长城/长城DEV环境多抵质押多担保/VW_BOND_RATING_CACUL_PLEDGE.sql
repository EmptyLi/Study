CREATE OR REPLACE VIEW VW_BOND_RATING_CACUL_PLEDGE AS
WITH rating_cd_region AS (
         SELECT a.region_cd,
            a.region_nm,
            b.ratingcd_nm
           FROM lkp_region a
             JOIN lkp_ratingcd_xw b ON substr(a.region_nm, 1, 2) = substr(b.constant_nm , 1, 2) AND a.parent_cd IS NULL and b.constant_type=6
        ),
		rating_cd1 AS (
         SELECT a.constant_id,
            a.constant_nm AS ratingcd_nm,
            a.constant_type
           FROM lkp_charcode a
          WHERE a.constant_type in (211,212,213,214,215) AND a.isdel = 0
        ),
		client AS (
         SELECT DISTINCT client_basicinfo.client_id
           FROM client_basicinfo
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
   FROM bond_basicinfo a
     JOIN client t ON 1 = 1
     JOIN bond_pledge b ON a.secinner_id = b.secinner_id AND b.isdel = 0
     LEFT JOIN rating_cd1 h ON b.pledge_type_id = h.constant_id
     LEFT JOIN rating_cd1 i ON b.pledge_control_id = i.constant_id
     LEFT JOIN rating_cd1 j ON b.pledge_depend_id = j.constant_id
     LEFT JOIN rating_cd_region r1 ON b.region = r1.region_cd
 WHERE a.isdel = 0;
