SELECT *
FROM (
       SELECT
         war.*,
         -- 取债券最新报告期的日期
		 max(rpt_dt)
         OVER (
           PARTITION BY secinner_id ) AS max_rpt_dt,
         -- 对于同一只债券的同一个担保人的数据进行去重，业务主键=债券内码+报告期+担保人名称+担保类型
		 row_number()
         OVER (
           PARTITION BY secinner_id, to_char(rpt_dt,'yyyy'), warrantor_nm, warrantor_type
           ORDER BY rpt_dt desc)             rk
       FROM vw_bond_rating_cacul_warrantor AS war) AS ret
WHERE rpt_dt = max_rpt_dt
      AND rk = 1