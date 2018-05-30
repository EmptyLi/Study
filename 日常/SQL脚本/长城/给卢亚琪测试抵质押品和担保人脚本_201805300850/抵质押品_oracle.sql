with temp_src_portfolio_cd as (
    select src_portfolio_cd
    from bond_basicinfo
    where secinner_id in (
      select secinner_id
      from bond_pledge
      where isdel = 0)),
    temp_bond_basicinfo as (
      select
        a.src_portfolio_cd,
        a.secinner_id                       as "债券内码",
        a.security_cd || c.market_abbr      as "债券代码",
        a.security_nm                       as "债券名称",
        c.market_nm                         as "债券交易市场",
        a.isdel                             as "债券是否生效",
        count(*)
        over (
          partition by a.SRC_PORTFOLIO_CD ) as "交易市场个数"
      from bond_basicinfo a
        left join lkp_charcode b
          on a.isdel = b.isdel
             and b.constant_type = '206'
             and a.trade_market_id = b.constant_id
        left join lkp_market_abbr c
          on c.isdel = b.isdel
             and b.constant_cd = c.market_cd
      where src_portfolio_cd in (
        select src_portfolio_cd
        from temp_src_portfolio_cd
      )),
    temp_bond_pledge as (
      select
        bond_pledge_sid   as "抵质押品物理主键",
        secinner_id       as "债券内码",
        pledge_nm         as "抵质押品名称",
        pledge_type_id    as "抵质押品类型",
        pledge_value      as "抵质押品价值",
        pledge_depend_id  as "抵质押品独立性",
        pledge_control_id as "抵质押品控制力",
        region            as "执法环境",
        updt_dt           as "抵质押品更新时间"
      from bond_pledge
      where isdel = 0),
    temp_pledge_info as (
      select
        "抵质押品物理主键",
        "债券内码",
        "抵质押品名称",
        "抵质押品价值",
        tmp1.constant_nm as "抵质押品类型名称",
        tmp2.constant_nm as "抵质押品独立性名称",
        tmp3.constant_nm as "抵质押品控制力名称",
        tmp4.region_nm   as "执法环境名称",
        "抵质押品更新时间"
      from temp_bond_pledge a
        left join lkp_charcode tmp1
          on tmp1.constant_type = 211
             and tmp1.constant_id = a."抵质押品类型"
        left join lkp_charcode tmp2
          on tmp2.constant_type = 213
             and tmp2.constant_id = a."抵质押品独立性"
        left join lkp_charcode tmp3
          on tmp3.constant_type = 212
             and tmp3.constant_id = a."抵质押品控制力"
        left join lkp_region tmp4
          on tmp4.region_cd = a."执法环境"),
    ret as (
      select
        ret1.src_portfolio_cd,
        ret1."债券内码",
        ret1."债券代码",
        ret1."债券名称",
        ret1."债券交易市场",
        ret1."债券是否生效",
        ret2."抵质押品物理主键",
        ret2."抵质押品名称",
        ret2."抵质押品价值",
        ret2."抵质押品类型名称",
        ret2."抵质押品独立性名称",
        ret2."抵质押品控制力名称",
        ret2."执法环境名称",
        ret2."抵质押品更新时间",
        count(distinct ret2."抵质押品名称")
        over (
          partition by ret1.src_portfolio_cd ) as cnt1,
        count(ret2."抵质押品名称")
        over (
          partition by ret1."债券内码" )           as cnt2,
        count(distinct ret2."抵质押品价值" || ret2."抵质押品类型名称" || ret2."抵质押品独立性名称" || ret2."抵质押品控制力名称" || ret2."执法环境名称")
        over (
          partition by ret1.src_portfolio_cd ) as cnt3

      from temp_bond_basicinfo ret1
        left join temp_pledge_info ret2
          on ret2."债券内码" = ret1."债券内码"
      where ret1."交易市场个数" <> 1),
    "抵质押品数量不一致" as (
      select *
      from ret
      where src_portfolio_cd in (select src_portfolio_cd
                                 from ret
                                 where cnt1 <> cnt2)
      order by src_portfolio_cd desc),
    "抵质押品数量一致属性不一致" as (
      select *
      from ret
      where SRC_PORTFOLIO_CD in (select src_portfolio_cd
                                 from ret
                                 where cnt1 = cnt2
      and (cnt2 <> cnt3 or cnt1 <> cnt3))

            and cnt2 <> 0),
    "正常数据" as (
      select *
      from ret
      where SRC_PORTFOLIO_CD not in (
        select SRC_PORTFOLIO_CD
        from "抵质押品数量不一致"
        union
        select SRC_PORTFOLIO_CD
        from "抵质押品数量一致属性不一致"
      ))
select *
from "抵质押品数量一致属性不一致"
