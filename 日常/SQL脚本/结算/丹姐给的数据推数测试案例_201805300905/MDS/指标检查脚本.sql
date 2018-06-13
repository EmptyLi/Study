select
 a1.company_id,
  a1.rpt_dt,
  a1.factor_cd,
  a1.factor_value,
  d.formula_en,
  net_profit*2/(sum_sh_equity_last_y+sum_sh_equity)
from compy_factor_finance a1
  left join compy_finance a
    on a1.company_id = a.company_id
       and a1.rpt_dt = a.rpt_dt
  left join compy_finance_last_y b
    on a.company_id = b.company_id
       and a.rpt_dt = b.rpt_dt
  left join compy_finance_bf_last_y c
    on a.company_id = c.company_id
       and a.rpt_dt = c.rpt_dt
  left join factor d
    on d.isdel = 0
       and d.factor_cd = a1.factor_cd
where a1.company_id = 358876
      and a1.rpt_dt = date '2016-12-31'
      and a1.factor_cd = 'Size2'
      and a1.rpt_timetype_cd = 1
      and d.factor_cd in (select factor_cd from ray_factor_list);


select * from factor where factor_cd in (select factor_cd from ray_factor_list) and factor_cd not in ('Size2') and formula_en like '%sum_sh_equity%'
