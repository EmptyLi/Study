SELECT coalesce(ret1.factor_value::varchar, ret2.factor_value::varchar), ret.*
  FROM (SELECT bfo.company_id,
               bfo.company_nm,
               ep.exposure_sid,
               ep.exposure,
               rms.name AS sub_model_nm,
               rmf.ft_code,
               f.factor_category_cd,
               f.factor_nm,
               fo.option_num,
               f.formula_en
          FROM rating_model_factor rmf
          JOIN rating_model_sub_model rms
            ON (rmf.sub_model_id = rms.id)
          JOIN rating_model rm
            ON (rms.parent_rm_id = rm.id AND rm.is_active = 1 AND rm.isdel = 0)
          JOIN rating_model_exposure_xw rmxw
            ON (rm.id = rmxw.model_id)
          JOIN exposure ep
            ON (rmxw.exposure_sid = ep.exposure_sid AND ep.isdel = 0)
          JOIN compy_exposure cse
            ON (ep.exposure_sid = cse.exposure_sid)
          JOIN compy_basicinfo bfo
            ON (cse.company_id = bfo.company_id AND
               bfo.company_nm = '广州医药集团有限公司')
          LEFT JOIN exposure_factor_xw efx
            ON (ep.exposure_sid = efx.exposure_sid AND
               rmf.ft_code = efx.factor_cd AND efx.isdel = 0)
          LEFT JOIN factor f
            ON (rmf.ft_code = f.factor_cd AND f.isdel = 0)
          LEFT JOIN (SELECT *
                      FROM (SELECT exposure_sid,
                                   factor_cd,
                                   option_num,
                                   formula_ch,
                                   row_number() over(PARTITION BY exposure_sid, factor_cd ORDER BY option_num DESC) AS rn
                              FROM factor_option
                             WHERE isdel = 0) as ret
                     WHERE rn = 1) fo
            ON (efx.exposure_sid = fo.exposure_sid AND
               efx.factor_cd = fo.factor_cd)
         ORDER BY ep.exposure, rm.name, rms.name, rmf.ft_code, fo.option_num) as ret
left join compy_factor_finance ret1
on ret1.company_id = ret.company_id
and ret1.rpt_dt = date'2016-12-31'
and ret1.factor_cd = ret.ft_code
left join compy_factor_operation ret2
 on ret2.company_id = ret.company_id
and ret2.rpt_dt = date'2016-12-31'
and ret2.factor_cd = ret.ft_code;
