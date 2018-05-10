WITH TEMP_BOND_BASICINFO AS
(SELECT A.SECINNER_ID, A.SECURITY_CD || C.MARKET_ABBR AS SECURITY_CD
  FROM (SELECT DISTINCT SECINNER_ID, SECURITY_CD, TRADE_MARKET_ID
          FROM BOND_BASICINFO
          WHERE ISDEL = 0) A
  JOIN LKP_CHARCODE B
    ON A.TRADE_MARKET_ID = B.CONSTANT_ID
   AND B.CONSTANT_TYPE = 206
  JOIN LKP_MARKET_ABBR C
    ON B.CONSTANT_CD = C.MARKET_CD)
SELECT
  A.BOND_PLEDGE_SID   AS "债券抵质押品标识符",
  A.SECINNER_ID       AS "证券内码标识符",
  B.SECURITY_CD       AS "证券代码",
  A.NOTICE_DT         AS "公告日期",
  A.PLEDGE_NM         AS "抵质押品名称",
  A.PLEDGE_TYPE_ID    AS "抵质押品类型ID",
  TMP9.constant_nm    AS "抵质押品类型",
  A.PLEDGE_DESC       AS "抵质押品描述",
  A.PLEDGE_OWNER_ID   AS "抵质押品所有者标识符",
  A.PLEDGE_OWNER      AS "抵质押品所有者",
  A.PLEDGE_VALUE      AS "抵质押品价值",
  A.PRIORITY_VALUE    AS "优先求偿价值",
  A.PLEDGE_DEPEND_ID  AS "抵质押品独立性ID",
  TMP8.constant_nm    AS "抵质押品独立性",
  A.PLEDGE_CONTROL_ID AS "抵质押品控制力id",
  TMP7.constant_nm    AS "抵质押品控制力",
  A.REGION            AS "执法环境CD",
  TMP6.region_nm      AS "执法环境",
  A.MITIGATION_VALUE  AS "有效缓释价值",
  A.ISDEL             AS "是否删除",
  A.SRCID             AS "源系统主键",
  A.SRC_CD            AS "源系统",
  A.UPDT_BY           AS "更新人",
  A.UPDT_DT           AS "更新时间"
FROM bond_pledge a
  LEFT JOIN LKP_REGION tmp6
    ON tmp6.REGION_CD = a.REGION
  LEFT JOIN LKP_CHARCODE tmp7
    ON tmp7.CONSTANT_TYPE = 212
       AND tmp7.CONSTANT_ID = A.PLEDGE_CONTROL_ID
  LEFT JOIN LKP_CHARCODE tmp8
    ON tmp8.CONSTANT_TYPE = 213
       AND tmp8.CONSTANT_ID = A.PLEDGE_DEPEND_ID
  LEFT JOIN LKP_CHARCODE tmp9
    ON tmp9.CONSTANT_TYPE = 211
       AND tmp9.CONSTANT_ID = A.PLEDGE_TYPE_ID
  LEFT JOIN TEMP_BOND_BASICINFO B
    ON B.SECINNER_ID = A.secinner_id
order by a.secinner_id
