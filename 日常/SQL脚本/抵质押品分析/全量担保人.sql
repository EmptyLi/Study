SELECT
  a.BOND_WARRANTOR_SID   AS "债券担保人标识符",
  a.SECINNER_ID          AS "证券内码标识符",
  a.NOTICE_DT            AS "公告日期",
  a.GUARANTEE_TYPE_ID    AS "担保类型标识符id",
  tmp6.constant_nm       AS "担保类型标识符",
  a.WARRANTOR_ID         AS "担保人标识符",
  a.WARRANTOR_NM         AS "担保人名称",
  a.WARRANTOR_TYPE_ID    AS "保证人类型id",
  tmp7.constant_nm       AS "保证人类型",
  a.WARRANTY_AMT         AS "担保金额",
  a.WARRANTY_STRENGTH_ID AS "担保强度标识符id",
  tmp8.constant_nm       AS "担保强度标识符",
  a.ISDEL                AS "是否删除",
  a.SRCID                AS "源系统主键",
  a.SRC_CD               AS "源系统",
  a.UPDT_DT              AS "更新时间"
FROM bond_warrantor_expert a
  LEFT JOIN LKP_CHARCODE tmp6
    ON tmp6.CONSTANT_TYPE = 207
       AND tmp6.constant_id = a.GUARANTEE_TYPE_ID
  LEFT JOIN LKP_CHARCODE tmp7
    ON tmp7.CONSTANT_TYPE = 214
       AND tmp7.constant_id = a.WARRANTOR_TYPE_ID
  LEFT JOIN LKP_CHARCODE tmp8
    ON tmp8.CONSTANT_TYPE = 215
       AND tmp8.constant_id = a.WARRANTY_STRENGTH_ID
