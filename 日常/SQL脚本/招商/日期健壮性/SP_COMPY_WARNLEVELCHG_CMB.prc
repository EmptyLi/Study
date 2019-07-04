CREATE OR REPLACE PROCEDURE SP_COMPY_WARNLEVELCHG_CMB IS
  /*
  存储过程：SP_COMPY_WARNLEVELCHG_CMB
  功    能：加载-行内预警等级认定-增量（STG->TEMP->TGT）
            物理主键：任务号
            业务主键：客户号+机构+发起时间
  创 建 人：RayLee
  创建时间：2017/11/8 19:16:19
  源    表：CMAP_SYNC.STG_COMPY_WARNLEVELCHG_CMB
  中 间 表：TEMP_COMPY_WARNLEVELCHG_CMB
  目 标 表：COMPY_WARNLEVELCHG_CMB
  --------------------------------------------------------------------
  修 改 人：RAYLEE
  修改时间：2017-12-28 14:20:16
  修改内容：相同业务主键，取updt_dt较大，对于同一批次（updt_dt相同），取record_sid更大的记录
    --------------------------------------------------------------------
  修 改 人：RAYLEE
  修改时间：2018-01-03 18:59:16
  修改内容：按照任务号进行分组
  -------------------------------------------------------
  修 改 人：RayLee
  修改时间：2018-04-13 10:20:11.877052
  修改内容：日期字段添加f_str_to_date增加健壮性
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
  V_SRC_CD  TEMP_COMPY_WARNLEVELCHG_CMB.SRC_CD%TYPE := UPPER(TRIM('CMB'));
  V_UPDT_BY TEMP_COMPY_WARNLEVELCHG_CMB.UPDT_BY%TYPE := 0;
  V_ISDEL TEMP_COMPY_WARNLEVELCHG_CMB.ISDEL%TYPE := 0;

  V_EXEC_STEP VARCHAR2(100);

BEGIN

  --流程名称
  V_TASK_NAME := 'SP_COMPY_WARNLEVELCHG_CMB';

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
  INSERT INTO TEMP_COMPY_WARNLEVELCHG_CMB
    (WARNCHG_ID, --1. 任务号
     COMPANY_ID, --2. 企业标识符
     SUBMIT_DT, --3. 发起时间
     WARN_LEVEL, --4. 调整后客户风险分层
     PRE_WARN_LEVEL, --5. 调整前客户风险分层
     OPERATE_MODULE, --6. 变动来源
     OPERATE_DT, --7. 终批时间
     ISDEL, --8. 是否删除
     SRC_COMPANY_CD, --9. 源企业代码
     SRC_CD, --10.  源系统
     UPDT_BY, --11.  更新人
     UPDT_DT, --12.  更新时间
     RNK, --13.  记录序列
     RECORD_SID,  --14.流水号
     LOADLOG_SID  --15.日志号
     )
    SELECT T.WARNCHG_ID AS WARNCHG_ID, --1. 任务号
           T1.COMPANY_ID AS COMPANY_ID, --2. 企业标识符
           --TO_TIMESTAMP(T.CREATE_DT, 'YYYY-MM-DD HH24:MI:SS') AS SUBMIT_DT, --3. 发起时间
           F_STR_TO_DATE(T.CREATE_DT) AS SUBMIT_DT, --3. 发起时间
           T.WARN_LEVEL AS WARN_LEVEL, --4. 调整后客户风险分层
           T.PRE_WARN_LEVEL AS PRE_WARN_LEVEL, --5. 调整前客户风险分层
           T.OPERATE_MODULE AS OPERATE_MODULE, --6. 变动来源
           --TO_TIMESTAMP(T.OPERATE_DT, 'YYYY-MM-DD HH24:MI:SS') AS OPERATE_DT, --7. 终批时间
           F_STR_TO_DATE(T.OPERATE_DT) AS OPERATE_DT, --7. 终批时间
           V_ISDEL AS ISDEL, --8. 是否删除
           T.CUST_NO AS SRC_COMPANY_CD, --9. 源企业代码
           V_SRC_CD AS SRC_CD, --10.  源系统
           V_UPDT_BY AS UPDT_BY, --11.  更新人
           SYSTIMESTAMP AS UPDT_DT, --12.  更新时间
           ROW_NUMBER() OVER(PARTITION BY T.WARNCHG_ID ORDER BY T.UPDT_DT DESC, T.RECORD_SID DESC) AS RNK, --13.  记录序列
           T.RECORD_SID AS RECORD_SID,  --14.流水号
           T.LOADLOG_SID AS LOADLOG_SID --15.日志号
      FROM CMAP_SYNC.STG_CMB_COMPY_WARNLEVELCHG T
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
    FROM TEMP_COMPY_WARNLEVELCHG_CMB;

  --删除已经存在的增量数据
  V_EXEC_STEP := 'STEP4 删除已经存在的增量数据';
  DELETE FROM COMPY_WARNLEVELCHG_CMB
   WHERE WARNCHG_ID IN (SELECT WARNCHG_ID FROM TEMP_COMPY_WARNLEVELCHG_CMB);


  V_EXEC_STEP := 'STEP5 加载数据到目标表';
  INSERT INTO COMPY_WARNLEVELCHG_CMB
    (WARNCHG_ID, --1. 任务号
     COMPANY_ID, --2. 企业标识符
     SUBMIT_DT, --3. 发起时间
     WARN_LEVEL, --4. 调整后客户风险分层
     PRE_WARN_LEVEL, --5. 调整前客户风险分层
     OPERATE_MODULE, --6. 变动来源
     OPERATE_DT, --7. 终批时间
     ISDEL, --8. 是否删除
     SRC_COMPANY_CD, --9. 源企业代码
     SRC_CD, --10.  源系统
     UPDT_BY, --11.  更新人
     UPDT_DT --12.  更新时间
     )
    SELECT T.WARNCHG_ID     AS WARNCHG_ID, --1. 任务号
           T.COMPANY_ID     AS COMPANY_ID, --2. 企业标识符
           T.SUBMIT_DT      AS SUBMIT_DT, --3. 发起时间
           T.WARN_LEVEL     AS WARN_LEVEL, --4. 调整后客户风险分层
           T.PRE_WARN_LEVEL AS PRE_WARN_LEVEL, --5. 调整前客户风险分层
           T.OPERATE_MODULE AS OPERATE_MODULE, --6. 变动来源
           T.OPERATE_DT     AS OPERATE_DT, --7. 终批时间
           T.ISDEL          AS ISDEL, --8. 是否删除
           T.SRC_COMPANY_CD AS SRC_COMPANY_CD, --9. 源企业代码
           T.SRC_CD         AS SRC_CD, --10.  源系统
           T.UPDT_BY        AS UPDT_BY, --11.  更新人
           SYSTIMESTAMP          AS UPDT_DT --12.  更新时间
      FROM TEMP_COMPY_WARNLEVELCHG_CMB T
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

END SP_COMPY_WARNLEVELCHG_CMB;
/
