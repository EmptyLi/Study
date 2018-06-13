with temp_bond_validation as
(select
   secinner_id,
   is_calculateoption,
   updt_dt,
   to_maturity,
   val_ytm,
   trade_dt,
   row_number()
   over (
     partition by secinner_id
     order by case when is_calculateoption = '推荐'
       then 1
              when is_calculateoption = '不推荐'
                then 2
              else 3 end asc
       , updt_dt desc ) as cnt
 from bond_valuations
 where secinner_id in (
   select 债券内码
   from ray_bond_list
 ) and trade_dt = date '2018-06-01' and isdel = '0')
select
  distinct
  a."债券内码",
  b.trade_dt    as "债券日分析数据日期",
  b.duration    as "久期",
  c.trade_dt    as "估值收益数据日期",
  c.to_maturity as "剩余期限",
  c.val_ytm     as "估值收益率"
from ray_bond_list a
  left join bond_danalysis b
    on a."债券内码" = b.secinner_id
       and b.trade_dt = date '2018-06-01'
       and b.isdel = '0'
  left join temp_bond_validation c
    on a."债券内码" = c.secinner_id
       and c.cnt = 1
