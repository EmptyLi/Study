with temp_compy_creditrating as
(
    select
      company_id,
      rating_dt,
      rating,
      credit_org_id,
      max(rating_dt)
      over (
        partition by company_id ) as max_rating_dt
    from compy_creditrating
    where isdel = 0 and company_id <> '270238'
),
    temp_bond_creditchg as
  (
      select
        secinner_id,
        change_dt,
        rating,
        credit_nm,
        max(change_dt)
        over (
          partition by secinner_id ) as max_change_dt
      from bond_creditchg
      where isdel = 0 and credit_id <> '270238'
  ),
    TEMP_bond_warrantor_expert AS
  (
      SELECT
        secinner_id,
        LISTAGG(to_char(WARRANTOR_NM), ';')
        WITHIN GROUP (
          ORDER BY WARRANTOR_NM) AS WARRANTOR_NM
      FROM bond_warrantor
      WHERE isdel = 0
      group by secinner_id
  ),
    temp_bond_pledge as
  (
      select
        secinner_id,
        LISTAGG(to_char(pledge_nm), ';')
        WITHIN GROUP (
          ORDER BY pledge_nm) AS pledge_nm
      from bond_pledge
      where isdel = 0
      group by secinner_id
  ),
    temp_RATING_RECORD as (
      select
        COMPANY_ID,
        FACTOR_DT,
        SCALED_RATING,
        FINAL_RATING,
        row_number()
        over (
          partition by COMPANY_ID
          order by FACTOR_DT desc ) as max_Factor_dt
      from RATING_RECORD
      where CLIENT_ID = 4),
    temp_BOND_RATING_RECORD as (
      select
        SECINNER_ID,
        FACTOR_DT,
        RAW_RATING,
        ADJUST_RATING,
        row_number()
        over (
          partition by SECINNER_ID
          order by factor_dt desc ) as max_Factor_dt
      from BOND_RATING_RECORD)
select
  a.security_cd   as "债券代码",
  a.security_snm  as "债券简称",
  b.company_nm    as "发行人名称",
  d.exposure      as "敞口",
  --   e.val_ytm       as "估值收益率",
  --   k.DURATION      as "久期",
  a.puttable_dt   as "回售日期",
  l.constant_nm   as "发行方式",
  --   e.to_maturity   as "剩余期限",
  f.warrantor_nm  as "担保人名称",
  g.pledge_nm     as "抵质押品名称",
  h.rating        as "主体外部评级",
  h.rating_dt        "主体外评评级日期",
  i.company_nm    as "主体外评机构",
  j.change_dt     as "债券外评评级日期",
  j.rating        as "债券外部评级",
  j.credit_nm     as "债券外评机构",
  m.FACTOR_DT     as "主体报告期",
  m.FINAL_RATING  as "主体内评",
  n.FACTOR_DT     as "债券报告期",
  n.ADJUST_RATING as "债券内评"
from bond_basicinfo a
  inner join VW_BOND_ISSUER a1
    on a1.ISSUER_ID is not null
       and a1.SECINNER_ID = a.SECINNER_ID
  inner join compy_basicinfo b
    on a.isdel = a.isdel
       and b.COMPANY_ID = a1.ISSUER_ID
  inner join compy_exposure c
    on c.isdel = b.is_del
       and c.company_id = b.company_id
  inner join exposure d
    on d.exposure_sid = c.exposure_sid
       and d.isdel = c.isdel
  --   inner join bond_valuations e
  --     on e.isdel = d.isdel
  --        and e.secinner_id = a.secinner_id
  --        and e.trade_dt = date '2018-05-24'
  left join TEMP_bond_warrantor_expert f
    on f.secinner_id = a.secinner_id
  left join temp_bond_pledge g
    on g.secinner_id = a.secinner_id
  left join temp_compy_creditrating h
    on h.company_id = a1.ISSUER_ID
       and h.max_rating_dt = h.rating_dt
  left join compy_basicinfo i
    on i.is_del = 0
       and i.company_id = h.company_id
  left join temp_bond_creditchg j
    on j.secinner_id = a.secinner_id
       and j.change_dt = j.max_change_dt
  --   left join bond_danalysis k
  --     on k.isdel = 0
  --        and k.secinner_id = a.secinner_id
  inner join LKP_NUMBCODE l
    on l.isdel = 0
       and l.constant_type = 205
       and l.constant_cd = a.issue_type_cd
  left join temp_RATING_RECORD m
    on m.max_Factor_dt = 1
       and m.COMPANY_ID = a1.ISSUER_ID
  left join temp_BOND_RATING_RECORD n
    on n.SECINNER_ID = a.SECINNER_ID
       and n.max_Factor_dt = 1
where a.isdel = 0
--       and a.security_cd = '118359'
