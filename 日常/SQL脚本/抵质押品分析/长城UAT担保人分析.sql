
WITH tmp1 AS
 (SELECT src_portfolio_cd,
         secinner_id,
         security_nm,
         trade_market_id,
         mrty_dt,
         count(*) OVER(PARTITION BY src_portfolio_cd) AS sec_cnt
    FROM bond_basicinfo
   WHERE isdel = 0
     AND mrty_dt > systimestamp),
tmp2 AS
 (SELECT tmp1.src_portfolio_cd,
         tmp1.secinner_id,
         tmp1.security_nm,
         tmp1.trade_market_id,
         tmp1.mrty_dt,
         tmp1.sec_cnt,
         a.BOND_WARRANTOR_SID,
         a.warrantor_nm,
         a.WARRANTY_AMT,
         a.GUARANTEE_TYPE_ID,
         a.WARRANTOR_ID,
         a.WARRANTOR_TYPE_ID,
         a.WARRANTY_STRENGTH_ID,
         a.WARRANTY_TYPE_ID,
         a.updt_dt,
         sum(CASE
               WHEN a.warrantor_nm IS NULL THEN
                1
               ELSE
                0
             END) OVER(PARTITION BY tmp1.src_portfolio_cd) AS pledge_cnt
    FROM tmp1
    LEFT JOIN bond_warrantor a
      ON a.isdel = 0
     AND a.secinner_id = tmp1.secinner_id
   WHERE sec_cnt > 1
   ORDER BY tmp1.src_portfolio_cd),
tmp22 as
--     如果对应有担保人信息的同一债所对应的所有担保人ID
 (select tmp2.src_portfolio_cd, count(distinct WARRANTOR_nm) as src_cnt
    FROM tmp2
   WHERE tmp2.pledge_cnt = 0
   group by tmp2.src_portfolio_cd),
tmp3 AS
 (SELECT tmp2.src_portfolio_cd,
         tmp2.secinner_id,
         tmp2.security_nm,
         tmp2.trade_market_id,
         tmp2.mrty_dt,
         tmp2.sec_cnt,
         tmp2.BOND_WARRANTOR_SID,
         tmp2.warrantor_nm,
         tmp2.GUARANTEE_TYPE_ID,
         tmp2.WARRANTOR_ID,
         tmp2.WARRANTOR_TYPE_ID,
         tmp2.WARRANTY_STRENGTH_ID,
         tmp2.WARRANTY_TYPE_ID,
         tmp2.updt_dt,
         tmp22.src_cnt AS src_cnt,
         count(tmp2.WARRANTOR_nm) OVER(PARTITION BY tmp2.SRC_PORTFOLIO_CD, tmp2.SECINNER_ID) AS sec_cnt1
    FROM tmp2
    left join tmp22
      on tmp22.src_portfolio_cd = tmp2.src_portfolio_cd
   WHERE tmp2.pledge_cnt = 0)
SELECT tmp3.BOND_WARRANTOR_SID as "担保人的物理主键",
       tmp3.src_portfolio_cd as "标识同一只债券的编码",
       tmp3.secinner_id      as "债券内码",
       tmp3.security_nm      as "债券名称",
       --   tmp3.trade_market_id as "",
       tmp3.mrty_dt as "债券到期日",
       --   tmp3.sec_cnt as "",

       tmp3.WARRANTOR_ID as "担保人ID",
       tmp3.warrantor_nm   as "担保人名称",
--        tmp3.GUARANTEE_TYPE_ID,
       tmp6.CONSTANT_NM,
--        tmp3.WARRANTOR_TYPE_ID,
       tmp7.CONSTANT_NM,
--        tmp3.WARRANTY_STRENGTH_ID,
       tmp8.CONSTANT_NM,
       tmp3.updt_dt     as "担保人更新时间",
       tmp5.market_abbr as "交易市场后缀",
       tmp5.MARKET_NM   as "交易市场名称",
  src_cnt,
  sec_cnt1
  FROM tmp3
  LEFT JOIN LKP_CHARCODE TMP4
    ON TMP4.constant_type = 206
   AND TMP4.constant_id = tmp3.trade_market_id
   AND TMP4.isdel = 0
  LEFT JOIN LKP_MARKET_ABBR tmp5
    ON tmp5.isdel = 0
   AND tmp5.market_cd = tmp4.constant_cd
  left join LKP_CHARCODE tmp6
    on tmp6.CONSTANT_TYPE = 207
   and tmp6.constant_id = tmp3.GUARANTEE_TYPE_ID
  left join LKP_CHARCODE tmp7
    on tmp7.CONSTANT_TYPE = 214
   and tmp7.constant_id = tmp3.WARRANTOR_TYPE_ID
    left join LKP_CHARCODE tmp8
    on tmp8.CONSTANT_TYPE = 215
   and tmp8.constant_id = tmp3.WARRANTY_STRENGTH_ID
 WHERE src_portfolio_cd in (
   select src_portfolio_cd from tmp3 where src_cnt <> sec_cnt1
 )
order by src_portfolio_cd, SECINNER_ID;
