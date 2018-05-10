
-- RAY_BOND_RATING_RESULT 生成逻辑
SELECT
  b.BOND_RATING_RECORD_SID AS "物理主键",
  a.security_snm           AS "债券简称",
  security_nm              AS "债券名称",
  security_cd              AS "债券代码",
  b.raw_lgd_score          AS "lgd得分",
  b.raw_lgd_grade          AS "lgd级别",
  a.secinner_id            AS "债券内码"
FROM
  (SELECT
     security_snm,
     security_nm,
     security_cd,
     secinner_id,
     row_number()
     OVER (
       PARTITION BY security_snm
       ORDER BY secinner_id DESC ) AS row_num
   FROM bond_basicinfo) a
  JOIN
  (
    SELECT
      BOND_RATING_RECORD_SID,
      secinner_id,
      raw_lgd_score,
      raw_lgd_grade,
      row_number()
      OVER (
        PARTITION BY secinner_id
        ORDER BY updt_dt DESC, BOND_RATING_RECORD_SID DESC ) AS row_num
    FROM BOND_RATING_RECORD
    WHERE factor_dt = DATE '2016-12-31'
          AND rating_type = 0
  ) b ON a.secinner_id = b.secinner_id
WHERE b.row_num = 1
      AND a.row_num = 1;

-- RAY_BOND_FACTOR_RET 生成逻辑
SELECT
  a.*,
  b.FACTOR_CD    AS "指标代码",
  b.FACTOR_VALUE AS "指标值",
  b.OPTION_NUM   AS "指标档位",
  b.RATIO        AS "档位系数"
FROM RAY_BOND_RATING_RESULT a
  LEFT JOIN BOND_RATING_FACTOR b
    ON b.CLIENT_ID = 4
       AND b.BOND_RATING_RECORD_SID = a."物理主键"
WHERE b.FACTOR_CD IN (
  'remain_vol' --AS "债券风险暴露ead(亿元)",
  , 'corp_nature' --AS "股权结构",
  , 'industry' --AS "发行人行业分类",
  , 'credit_region' --AS "信用环境",
  , 'bond_type' --AS "债项类型"
  , 'warrantor_nm' --AS "担保人名称",
  , 'warranty_strength' --AS "担保强度",
  , 'warrantor_type' --AS "担保人类型",
  , 'guarantee_type' --AS "担保类型",
  , 'warranty_value' --AS "担保价值",
  , 'pledge_depend' --AS "抵质押品独立性",
  , 'pledge_region' --AS "抵质押品执法环境",
  , 'pledge_control' --AS "抵质押品控制力",
  , 'pledge_type' --AS "抵质押品类型",
  , 'pledge_value' --AS "抵质押品价值"
);

-- 债券对应指标值的提取逻辑
SELECT *
FROM (
  SELECT *
  FROM RAY_BOND_FACTOR_RET)
  PIVOT (
    max("指标值") AS "指标值", max("档位") AS "指标档位", max("档位系数") AS "档位系数"
    FOR "指标代码"
    IN (
      'remain_vol' AS "债券风险暴露ead(亿元)"
      , 'corp_nature' AS "股权结构"
      , 'industry' AS "发行人行业分类"
      , 'credit_region' AS "信用环境"
      , 'bond_type' AS "债项类型"
      , 'warrantor_nm' AS "担保人名称"
      , 'warranty_strength' AS "担保强度"
      , 'warrantor_type' AS "担保人类型"
      , 'guarantee_type' AS "担保类型"
      , 'warranty_value' AS "担保价值"
      , 'pledge_depend' AS "抵质押品独立性"
      , 'pledge_region' AS "抵质押品执法环境"
      , 'pledge_control' AS "抵质押品控制力"
      , 'pledge_type' AS "抵质押品类型"
      , 'pledge_value' AS "抵质押品价值"
    )
  );

-- 子模型得分脚本
SELECT *
FROM (
  SELECT
    a.*,
    b.SCORE AS "得分",
    c.SUBMODEL_NM
  FROM RAY_BOND_RATING_RESULT a
    LEFT JOIN BOND_RATING_DETAIL b
      ON a."物理主键" = b.BOND_RATING_RECORD_SID
    LEFT JOIN BOND_RATING_SUBMODEL c
      ON c.SUBMODEL_ID = b.SUBMODEL_ID)
  PIVOT
  (
    max("得分")
    FOR SUBMODEL_NM
    IN (
      '有效的抵质押品缓释价值'
      , '债项特征调整系数'
      , '债务人特征调整系数'
      , '平均信用回收率'
      , '有效的保证人缓释价值'
      , '债券余额'
    ))
