CREATE OR REPLACE PROCEDURE SP_COMPY_HIGHRISKLIST_CMB IS
  /*
  存储过程：SP_COMPY_HIGHRISKLIST_CMB
  功    能：加载-高风险类名单-增量（STG->TEMP->TGT）
            主键：流水号
            (客户+来源+客户类型+是否生效)
  创 建 人：RayLee
  创建时间：2017/11/9 10:25:27
  源    表：CMAP_SYNC.STG_CMB_COMPY_HIGHRISKLIST
  中 间 表：TEMP_CMB_COMPY_HIGHRISKLIST
  目 标 表：COMPY_HIGHRISKLIST_CMB
  --------------------------------------------------------------------
  修 改 人：RayLee
  修改时间：2017-12-28 14:28:06
  修改内容：相同业务主键，取updt_dt较大，对于同一批次（updt_dt相同），取record_sid更大的记录
  修 改 人：RayLee
  修改时间：2017-12-28 15:13:46
  修改内容：修复 业务主键去重少了blacklist_type_cd字段
  -------------------------------------------------------
  修 改 人：RayLee
  修改时间：2018-04-13 10:20:11.877052
  修改内容：日期字段添加 f_str_to_date 增加健壮性
  */

  V_ERROR_CD          VARCHAR2(100);
  V_ERROR_MESSAGE     VARCHAR2(1000);
  V_TASK_NAME         ETL_TGT_LOADLOG.PROCESS_NM%TYPE; --流程名称
  V_UPDT_DT           ETL_TGT_LOADLOG.END_DT%TYPE; --上次同步数据时间
  V_START_DT          ETL_TGT_LOADLOG.START_DT%TYPE; --开始时间
  V_END_DT            ETL_TGT_LOADLOG.END_DT%TYPE; --结束时间
  V_START_ROWID       ETL_TGT_LOADLOG.START_ROWID%TYPE; --起始行号
  V_END_ROWID         ETL_TGT_LOADLOG.END_ROWID%TYPE; --截止行号
  V_INSERT_COUNT      ETL_TGT_LOADLOG.INSERT_COUNT%TYPE; --插入记录数
  V_UPDT_COUNT        ETL_TGT_LOADLOG.UPDT_COUNT%TYPE; --更新记录数
  V_ORIG_RECORD_COUNT NUMBER(16); --原始的记录数
  V_DUP_RECORD_COUNT  NUMBER(16); --重复的记录数

  --
  V_SRC_CD  TEMP_COMPY_HIGHRISKLIST_CMB.SRC_CD%TYPE := UPPER(TRIM('CMB'));
  V_UPDT_BY TEMP_COMPY_HIGHRISKLIST_CMB.UPDT_BY%TYPE := 0;
  V_ISDEL TEMP_COMPY_HIGHRISKLIST_CMB.ISDEL%TYPE := 0;

  V_EXEC_STEP VARCHAR2(100);

BEGIN

  --流程名称
  V_TASK_NAME := 'SP_COMPY_HIGHRISKLIST_CMB';

  --开始时间
  V_START_DT := SYSTIMESTAMP;

  --获取上次同步数据的时间,如果是第一次运行没有记录会发生NO_DATA_FOUND异常
  V_EXEC_STEP := 'STEP1 获取上次同步时间';
  BEGIN
    SELECT NVL(MAX(END_DT),TO_DATE('1900-1-1', 'yyyy-mm-dd'))
      INTO V_UPDT_DT
      FROM ETL_TGT_LOADLOG
     WHERE PROCESS_NM = V_TASK_NAME;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      V_UPDT_DT := TO_DATE('1900-1-1', 'yyyy-mm-dd');
  END;

  --获取本次增量数据插入到临时表
  V_EXEC_STEP := 'STEP2 获取本次增量数据插入到临时表';
  INSERT INTO TEMP_COMPY_HIGHRISKLIST_CMB
    (HISHGRISKLIST_ID, --1. 流水号
     COMPANY_ID, --2. 企业标识符
     LIST_TYPE_CD, --3. 名单类型
     BLACKLIST_SRCCD, --4. 黑名单来源
     BLACKLIST_TYPE_CD, --5. 黑名单客户类型
     EFF_DT, --6. 生效日期
     CONFIRM_REASON, --7. 认定原因
     CTL_MEASURE, --8. 管控措施
     EFF_FLAG, --9. 是否生效
     ISDEL, --10.  是否删除
     SRC_COMPANY_CD, --11.  源企业代码
     SRC_CD, --12.  源系统
     UPDT_BY, --13.  更新人
     UPDT_DT, --14.  更新时间
     RNK ,--15.  记录序列
     RECORD_SID,  --16.流水号
     LOADLOG_SID  --17.日志号

     )
    SELECT T.HISHGRISKLIST_ID AS HISHGRISKLIST_ID, --1. 流水号
           T1.COMPANY_ID AS COMPANY_ID, --2. 企业标识符
           T.LIST_TYPE_CD AS LIST_TYPE_CD, --3. 名单类型
           T.BLACKLIST_SRCCD AS BLACKLIST_SRCCD, --4. 黑名单来源
           T.BLACKLIST_TYPE_CD AS BLACKLIST_TYPE_CD, --5. 黑名单客户类型
           --TO_DATE(T.EFF_DT, 'YYYY-MM-DD') AS EFF_DT, --6. 生效日期
           f_str_to_date(T.EFF_DT) AS EFF_DT, --6. 生效日期
           T.CONFIRM_REASON AS CONFIRM_REASON, --7. 认定原因
           T.CTL_MEASURE AS CTL_MEASURE, --8. 管控措施
           T.EFF_FLAG AS EFF_FLAG, --9. 是否生效
           V_ISDEL AS ISDEL, --10.  是否删除
           T.CUST_NO AS SRC_COMPANY_CD, --11.  源企业代码
           V_SRC_CD AS SRC_CD, --12.  源系统
           V_UPDT_BY AS UPDT_BY, --13.  更新人
           SYSTIMESTAMP AS UPDT_DT, --14.  更新时间
           ROW_NUMBER() OVER(PARTITION BY T.CUST_NO, T.BLACKLIST_SRCCD, T.EFF_FLAG, T.BLACKLIST_TYPE_CD ORDER BY T.UPDT_DT DESC, T.RECORD_SID DESC) RNK, --15.  记录序列
           T.RECORD_SID AS RECORD_SID,  --16.流水号
           T.LOADLOG_SID AS LOADLOG_SID  --17.日志号
      FROM CMAP_SYNC.STG_CMB_COMPY_HIGHRISKLIST T
      LEFT JOIN CUSTOMER_CMB T1
        ON T1.CUST_NO = T.CUST_NO
     WHERE T.UPDT_DT > V_UPDT_DT
       AND T1.COMPANY_ID IS NOT NULL;

  --结束时间
  V_END_DT := SYSTIMESTAMP;

  --获取日志参数
  V_EXEC_STEP := 'STEP3 获取日志参数';
  SELECT COUNT(1) AS ORIG_RECORD_COUNT, --原始的记录数
         NVL(SUM(CASE
                   WHEN RNK > 1 THEN
                    1
                   ELSE
                    0
                 END),
             0) AS DUP_RECORD_COUNT, --重复的记录数
         MIN(RECORD_SID) AS START_ROWID, --起始行号
         MAX(RECORD_SID) AS END_ROWID --截止行号
    INTO V_ORIG_RECORD_COUNT,
         V_DUP_RECORD_COUNT,
         V_START_ROWID,
         V_END_ROWID
    FROM TEMP_COMPY_HIGHRISKLIST_CMB;

  --删除已经存在的增量数据
  V_EXEC_STEP := 'STEP4 删除已经存在的增量数据';

  DELETE FROM COMPY_HIGHRISKLIST_CMB
   WHERE (COMPANY_ID, BLACKLIST_SRCCD, EFF_FLAG, BLACKLIST_TYPE_CD) IN
         (SELECT COMPANY_ID, BLACKLIST_SRCCD, EFF_FLAG, BLACKLIST_TYPE_CD
            FROM TEMP_COMPY_HIGHRISKLIST_CMB);

  V_EXEC_STEP := 'STEP5 加载数据到目标表';
  INSERT INTO COMPY_HIGHRISKLIST_CMB
    (HISHGRISKLIST_ID, --1. 流水号
     COMPANY_ID, --2. 企业标识符
     LIST_TYPE_CD, --3. 名单类型
     BLACKLIST_SRCCD, --4. 黑名单来源
     BLACKLIST_TYPE_CD, --5. 黑名单客户类型
     EFF_DT, --6. 生效日期
     CONFIRM_REASON, --7. 认定原因
     CTL_MEASURE, --8. 管控措施
     EFF_FLAG, --9. 是否生效
     ISDEL, --10.  是否删除
     SRC_COMPANY_CD, --11.  源企业代码
     SRC_CD, --12.  源系统
     UPDT_BY, --13.  更新人
     UPDT_DT --14.  更新时间
     )
    SELECT HISHGRISKLIST_ID, --1. 流水号
           COMPANY_ID, --2. 企业标识符
           LIST_TYPE_CD, --3. 名单类型
           BLACKLIST_SRCCD, --4. 黑名单来源
           BLACKLIST_TYPE_CD, --5. 黑名单客户类型
           EFF_DT, --6. 生效日期
           CONFIRM_REASON, --7. 认定原因
           CTL_MEASURE, --8. 管控措施
           EFF_FLAG, --9. 是否生效
           ISDEL, --10.  是否删除
           SRC_COMPANY_CD, --11.  源企业代码
           SRC_CD, --12.  源系统
           UPDT_BY, --13.  更新人
           UPDT_DT --14.  更新时间
      FROM TEMP_COMPY_HIGHRISKLIST_CMB T
     WHERE RNK = '1';

  V_INSERT_COUNT := SQL%ROWCOUNT;
  COMMIT;

  --插入数据到LOG表中
  V_EXEC_STEP := 'STEP6 插入数据到LOG表中';
  INSERT INTO ETL_TGT_LOADLOG
    (LOADLOG_SID,
     BATCH_SID,
     PROCESS_NM,
     ORIG_RECORD_COUNT,
     DUP_RECORD_COUNT,
     INSERT_COUNT,
     UPDT_COUNT,
     START_DT,
     END_DT,
     START_ROWID,
     END_ROWID)
  VALUES
    (SEQ_ETL_TGT_LOADLOG.NEXTVAL,
     0,
     V_TASK_NAME,
     V_ORIG_RECORD_COUNT,
     V_DUP_RECORD_COUNT,
     V_INSERT_COUNT,
     NVL(V_UPDT_COUNT,0),
     V_START_DT,
     V_END_DT,
     V_START_ROWID,
     V_END_ROWID);
  COMMIT;

  --报错处理
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    V_ERROR_CD      := SQLCODE;
    V_ERROR_MESSAGE := V_EXEC_STEP || SUBSTR(SQLERRM, 1, 900);
    DBMS_OUTPUT.PUT_LINE('failed! ERROR:' || V_ERROR_CD || ' ,' ||
                         V_ERROR_MESSAGE);
    RAISE_APPLICATION_ERROR(-20021, V_ERROR_MESSAGE);
    RETURN;

    COMMIT;

END SP_COMPY_HIGHRISKLIST_CMB;
/
