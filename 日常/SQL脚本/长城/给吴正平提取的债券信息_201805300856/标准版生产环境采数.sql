-- 企业外评
-- 不要中债的评级结构，只取最新的外评结果
with temp_compy_creditrating as
(
    select
      company_id,
      rating_dt,
      rating,
      credit_org_id,
      max(rating_dt)
      over (
        partition by company_id ) as max_rating_dt,
      row_number()over(partition by COMPANY_ID, RATING_DT order by UPDT_DT desc) as cnt
    from compy_creditrating
    where isdel = 0 and credit_org_id <> '270238'
),
-- 债券外评
-- 不要中债的评级结构，只取最新的外评结果
    temp_bond_creditchg as
  (
      select
        secinner_id,
        change_dt,
        rating,
        credit_nm,
        max(change_dt)
        over (
          partition by secinner_id ) as max_change_dt,
        row_number()over(partition by SECINNER_ID, CHANGE_DT order by UPDT_DT desc) as cnt
      from bond_creditchg
      where isdel = 0 and credit_id <> '270238'
  ),
  -- 债项担保人信息
  -- 按照债券内码，将所有担保人的名称聚合
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
  -- 债项抵质押品信息
  -- 按照债券内码，将所有抵质押品的名称聚合
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
  -- 企业内评结果
  temp_rating_record as (
    select COMPANY_ID, COMPANY_NM, EXPOSURE_SID, EXPOSURE, FINAL_RATING,FACTOR_DT,rating_type from compy_rating_record
  ),
      -- 债券内评结果
temp_BOND_RATING_RECORD as (
    select SECINNER_ID, SECURITY_SNM, ADJUST_RATING, FACTOR_DT, RATING_TYPE  from bond_rating_record_latest
  ),
      -- 债券内码与债券代码+交易市场的映射
  TEMP_BOND_BASICINFO AS
(SELECT A.SECINNER_ID, A.SECURITY_CD || C.MARKET_ABBR AS SECURITY_CD
  FROM (SELECT DISTINCT SECINNER_ID, SECURITY_CD, TRADE_MARKET_ID
          FROM BOND_BASICINFO
          WHERE ISDEL = 0) A
  JOIN LKP_CHARCODE B
    ON A.TRADE_MARKET_ID = B.CONSTANT_ID
   AND B.CONSTANT_TYPE = 206
  JOIN LKP_MARKET_ABBR C
    ON B.CONSTANT_CD = C.MARKET_CD)
select
  a.SECINNER_ID as "债券内码",
  o.security_cd   as "债券代码",
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
  m.rating_type   as "主体内评类型",
  n.FACTOR_DT     as "债券报告期",
  n.ADJUST_RATING as "债券内评",
  n.RATING_TYPE as "债券内评类型",
   q.债券日分析数据日期,
  q.久期,
  q.估值收益数据日期,
  q.估值收益率,
  q.剩余期限
from bond_basicinfo a
-- 取发行人
  inner join VW_BOND_ISSUER a1
    on a1.ISSUER_ID is not null
       and a1.SECINNER_ID = a.SECINNER_ID
-- 取发行人名称
  inner join compy_basicinfo b
    on a.isdel = b.IS_DEL
       and b.COMPANY_ID = a1.ISSUER_ID
-- 取企业敞口sid
  inner join compy_exposure c
    on c.isdel = b.is_del
       and c.company_id = b.company_id
  and c.IS_NEW = '1'
-- 取敞口对应的名称
  inner join exposure d
    on d.exposure_sid = c.exposure_sid
       and d.isdel = c.isdel
       -- 取债券的估值收益率
  --   inner join bond_valuations e
  --     on e.isdel = d.isdel
  --        and e.secinner_id = a.secinner_id
  --        and e.trade_dt = date '2018-05-24'
  -- 取担保人的信息
  left join TEMP_bond_warrantor_expert f
    on f.secinner_id = a.secinner_id
-- 取抵质押品的信息
  left join temp_bond_pledge g
    on g.secinner_id = a.secinner_id
    -- 取企业外评的信息
  left join temp_compy_creditrating h
    on h.company_id = a1.ISSUER_ID
       and h.max_rating_dt = h.rating_dt
    and h.cnt = 1
-- 取外评机构的名称
  left join compy_basicinfo i
    on i.is_del = 0
       and i.company_id = h.credit_org_id
-- 取债券外评的信息
  left join temp_bond_creditchg j
    on j.secinner_id = a.secinner_id
       and j.change_dt = j.max_change_dt
  and j.cnt = 1
       -- 取久期和剩余期限
  --   left join bond_danalysis k
  --     on k.isdel = 0
  --        and k.secinner_id = a.secinner_id
-- 转换发行方式
  inner join LKP_NUMBCODE l
    on l.isdel = 0
       and l.constant_type = 205
       and l.constant_cd = a.issue_type_cd
-- 取企业内评结构
  left join temp_RATING_RECORD m
       on m.COMPANY_ID = a1.ISSUER_ID
-- 取债券内评结果
  left join temp_BOND_RATING_RECORD n
    on n.SECINNER_ID = a.SECINNER_ID
-- 取债券代码+交易市场
  left join TEMP_BOND_BASICINFO o
   on a.SECINNER_ID = o.SECINNER_ID
  left join ray_tmp_tab q
    on a.SECINNER_ID = q.债券内码
where a.isdel = 0;
--       and a.security_cd = '118359';


create table ray_tmp_tab (
  债券内码 varchar2(100),
    债券日分析数据日期 varchar2(100),
    久期 varchar2(100),
    估值收益数据日期 varchar2(100),
    剩余期限 varchar2(100),
  估值收益率 varchar2(100)
)
