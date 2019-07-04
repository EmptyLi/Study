with temp_src_portfolio_cd as (
    select src_portfolio_cd
    from bond_basicinfo
    where secinner_id in (
      select secinner_id
      from bond_warrantor
      where isdel = 0)),
    temp_bond_basicinfo as (
      select
        a.src_portfolio_cd,
        a.secinner_id                  as "债券内码",
        a.security_cd || c.market_abbr as "债券代码",
        a.security_nm                  as "债券名称",
        c.market_nm                    as "债券交易市场",
        a.isdel                        as "债券是否生效"
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
    temp_bond_warrantor as (
      select
        bond_warrantor_sid   as "担保人物理主键",
        secinner_id          as "债券内码",
        guarantee_type_id    as "担保类型",
        warrantor_id         as "担保人id",
        warrantor_nm         as "担保人名称",
        warrantor_type_id    as "担保人类型",
        warranty_amt         as "担保金额",
        warranty_strength_id as "担保强度",
        updt_dt              as "担保人更新时间"
      from bond_warrantor
      where isdel = 0),
    temp_warrantor_info as (
      select
        "担保人物理主键",
        "债券内码",
        "担保人id",
        "担保人名称",
        "担保金额",
        tmp1.constant_nm as "担保类型名称",
        tmp2.constant_nm as "担保人类型名称",
        tmp3.constant_nm as "担保强度名称"
      from temp_bond_warrantor a
        left join lkp_charcode tmp1
          on tmp1.constant_type = 207
             and tmp1.constant_id = a."担保类型"
        left join lkp_charcode tmp2
          on tmp2.constant_type = 214
             and tmp2.constant_id = a."担保人类型"
        left join lkp_charcode tmp3
          on tmp3.constant_type = 215
             and tmp3.constant_id = a."担保强度"),
    ret as (
      select
        ret1.src_portfolio_cd,
        ret1."债券内码",
        ret1."债券代码",
        ret1."债券名称",
        ret1."债券交易市场",
        ret1."债券是否生效",
        ret2."担保人物理主键",
        ret2."担保人id",
        ret2."担保人名称",
        ret2."担保金额",
        ret2."担保类型名称",
        ret2."担保人类型名称",
        ret2."担保强度名称",
        ret2."担保金额" || ret2."担保类型名称" || ret2."担保人类型名称" || ret2."担保强度名称" || ret2."担保人名称" as "测试",
        count(distinct nvl(to_char(ret2."担保人id"), 'x'))
        over (
          partition by ret1.src_portfolio_cd )                                          as cnt1,
        count(nvl(to_char(ret2."担保人id"), 'x'))
        over (
          partition by ret1."债券内码" )                                                    as cnt2,
        count(distinct ret2."担保金额" || ret2."担保类型名称" || ret2."担保人类型名称" || ret2."担保强度名称" || ret2."担保人名称")
        over (
          partition by ret1.src_portfolio_cd )                                          as cnt3,
        sum(case when ret2."担保人类型名称" = '自然人'
          then 1
            else 0 end)
        over (
          partition by ret1."债券内码" )                                                    as cnt4
      from temp_bond_basicinfo ret1
        left join temp_warrantor_info ret2
          on ret2."债券内码" = ret1."债券内码"),
    "担保人数量不一致" as (
      select *
      from ret
      where src_portfolio_cd in (
        select src_portfolio_cd
        from ret
        where cnt1 <> cnt2
      )),
    "担保人数量一致属性不一致" as (
      select *
      from ret
      where src_portfolio_cd in (
        select src_portfolio_cd
        from ret
        where cnt1 = cnt2
        and (cnt1 <> cnt3 or cnt2 <> cnt3)
      )

            and src_portfolio_cd not in (
        select src_portfolio_cd
        from ret
        where "担保人id" is null
      )),
    "担保人id为空的情况" as (
      select *
      from ret
      where "担保人id" is null and "担保人名称" is not null),
    "担保人为自然人的情况" as (
      select *
      from ret
      where src_portfolio_cd in (
        select src_portfolio_cd
        from ret
        where cnt4 not in (0, 1)))
select *
from "担保人为自然人的情况"
