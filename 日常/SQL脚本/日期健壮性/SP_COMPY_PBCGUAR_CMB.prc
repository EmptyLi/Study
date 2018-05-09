CREATE OR REPLACE PROCEDURE SP_COMPY_PBCGUAR_CMB IS
  /*
  存储过程：SP_COMPY_PBCGUAR_CMB
  功    能：加载-担保信息-增量（STG->TEMP->TGT）
  创 建 人：RayLee
  创建时间：2017/11/8 19:16:19
  源    表：CMAP_SYNC.STG_COMPY_PBCGUAR_CMB
  中 间 表：TEMP_COMPY_PBCGUAR_CMB
  目 标 表：COMPY_PBCGUAR_CMB
  --------------------------------------------------------------------
  修 改 人：RayLee
  修改时间：2017-12-28 14:30:40
  修改内容：相同业务主键，取updt_dt较大，对于同一批次（updt_dt相同），取record_sid更大的记录
  修 改 人：RayLee
  修改时间：2018-01-08 16:14:35
  修改内容：被担保人核心客户号   关联客户表，取company_id
            被担保人核心客户号   关联客户表，取company_nm
  修 改 人：RayLee
  修改时间：2018-03-20 18:09:00.064000
  修改内容：修复seq
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
  V_SRC_CD  TEMP_COMPY_PBCGUAR_CMB.SRC_CD%TYPE := UPPER(TRIM('CMB'));
  V_UPDT_BY TEMP_COMPY_PBCGUAR_CMB.UPDT_BY%TYPE := 0;
  V_ISDEL TEMP_COMPY_PBCGUAR_CMB.ISDEL%TYPE := 0;

  V_EXEC_STEP VARCHAR2(100);

BEGIN

  --流程名称
  V_TASK_NAME := 'SP_COMPY_PBCGUAR_CMB';

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
  INSERT INTO TEMP_COMPY_PBCGUAR_CMB
    (COMPY_PBCGUAR_SID, --1. 评级业务编号
     MSG_ID, --2. 报文标识符
     GRTSER_ID, --3. 担保合同流水号
     GRTBUSSER_ID, --4. 被担保业务流水号
     COMPANY_ID, --5. 企业标识符
     RPT_DT, --6. 报告日期
     WARRANTEE_ID, --7. 被担保人核心客户号
     WARRANTEE_NM, --8. 被担保人名称
     CURRENCY, --9. 担保币种
     GUAR_AMT, --10.  担保金额
     GUAR_TYPE_CD, --11.  担保形式
     BALANCE, --12.  被担保业务余额
     END_DT, --13.  被担保业务结清（到期）日期
     FIVE_CLASS_CD, --14.  被担保业务五级分类
     WARRANTEE_CURRENCY, --15.  被担保业务币种
     ISDEL, --16.  是否删除
     SRC_COMPANY_CD, --17.  源企业代码
     SRC_CD, --18.  源系统
     UPDT_BY, --19.  更新人
     UPDT_DT, --20.  更新时间
     RNK ,--13.  记录序列
     RECORD_SID,  --14.流水号
     LOADLOG_SID  --15.日志号

     )
    SELECT SEQ_COMPY_PBCGUAR_CMB.NEXTVAL AS COMPY_PBCGUAR_SID, --1. 评级业务编号
           T.MSG_ID AS MSG_ID, --2. 报文标识符
           T.GRTSER_ID AS GRTSER_ID, --3. 担保合同流水号
           T.GRTBUSSER_ID AS GRTBUSSER_ID, --4. 被担保业务流水号
           T.CUST_NO AS COMPANY_ID, --5. 企业标识符
           --TO_DATE(T.RPT_DT, 'YYYY-MM-DD') AS RPT_DT, --6. 报告日期
           F_STR_TO_DATE(T.RPT_DT) AS RPT_DT, --6. 报告日期
           --T.WARRANTEE_CUST_NO AS WARRANTEE_ID, --7. 被担保人核心客户号
           T2.COMPANY_ID AS WARRANTEE_ID, --7. 被担保人核心客户号
           --T.WARRANTEE_CUST_NO AS WARRANTEE_NM, --8. 被担保人名称
           T2.CUSTOMER_NM AS WARRANTEE_NM, --8. 被担保人名称
           T.CURRENCY AS CURRENCY, --9. 担保币种
           T.GUAR_AMT AS GUAR_AMT, --10.  担保金额
           T.GUAR_TYPE AS GUAR_TYPE_CD, --11.  担保形式
           T.BALANCE AS BALANCE, --12.  被担保业务余额
           --TO_DATE(T.END_DT, 'YYYY-MM-DD') AS END_DT, --13.  被担保业务结清（到期）日期
           F_STR_TO_DATE(T.END_DT) AS END_DT, --13.  被担保业务结清（到期）日期
           T.FIVE_CLASS AS FIVE_CLASS_CD, --14.  被担保业务五级分类
           T.WARRANTEE_CURRENCY AS WARRANTEE_CURRENCY, --15.  被担保业务币种
           V_ISDEL AS ISDEL, --16.  是否删除
           T.CUST_NO AS SRC_COMPANY_CD, --17.  源企业代码
           V_SRC_CD AS SRC_CD, --18.  源系统
           V_UPDT_BY AS UPDT_BY, --19.  更新人
           SYSTIMESTAMP AS UPDT_DT, --20.  更新时间
           ROW_NUMBER() OVER(PARTITION BY T.MSG_ID, T.GRTSER_ID, T.GRTBUSSER_ID ORDER BY T.UPDT_DT DESC,T.RECORD_SID DESC) AS RNK, --13.  记录序列
           T.RECORD_SID AS RECORD_SID,  --14.流水号
           T.LOADLOG_SID AS LOADLOG_SID  --15.日志号
      FROM CMAP_SYNC.STG_CMB_COMPY_PBCGUAR T
      LEFT JOIN CUSTOMER_CMB T1
        ON T1.CUST_NO = T.CUST_NO
      LEFT JOIN CUSTOMER_CMB T2
        ON T2.CUST_NO = T.WARRANTEE_CUST_NO
     WHERE T.UPDT_DT > V_UPDT_DT;

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
    FROM TEMP_COMPY_PBCGUAR_CMB;

  --删除已经存在的增量数据
  V_EXEC_STEP := 'STEP4 删除已经存在的增量数据';

  DELETE FROM COMPY_PBCGUAR_CMB A
   WHERE EXISTS (SELECT 1
            FROM TEMP_COMPY_PBCGUAR_CMB B
           WHERE A.MSG_ID = B.MSG_ID
             AND A.GRTSER_ID = B.GRTSER_ID
             AND A.GRTBUSSER_ID = B.GRTBUSSER_ID);

  V_EXEC_STEP := 'STEP5 加载数据到目标表';
  INSERT INTO COMPY_PBCGUAR_CMB
    (COMPY_PBCGUAR_SID, --1. 评级业务编号
     MSG_ID, --2. 报文标识符
     GRTSER_ID, --3. 担保合同流水号
     GRTBUSSER_ID, --4. 被担保业务流水号
     COMPANY_ID, --5. 企业标识符
     RPT_DT, --6. 报告日期
     WARRANTEE_ID, --7. 被担保人核心客户号
     WARRANTEE_NM, --8. 被担保人名称
     CURRENCY, --9. 担保币种
     GUAR_AMT, --10.  担保金额
     GUAR_TYPE_CD, --11.  担保形式
     BALANCE, --12.  被担保业务余额
     END_DT, --13.  被担保业务结清（到期）日期
     FIVE_CLASS_CD, --14.  被担保业务五级分类
     WARRANTEE_CURRENCY, --15.  被担保业务币种
     ISDEL, --16.  是否删除
     SRC_COMPANY_CD, --17.  源企业代码
     SRC_CD, --18.  源系统
     UPDT_BY, --19.  更新人
     UPDT_DT --20.  更新时间

     )
    SELECT COMPY_PBCGUAR_SID, --1. 评级业务编号
           MSG_ID, --2. 报文标识符
           GRTSER_ID, --3. 担保合同流水号
           GRTBUSSER_ID, --4. 被担保业务流水号
           COMPANY_ID, --5. 企业标识符
           RPT_DT, --6. 报告日期
           WARRANTEE_ID, --7. 被担保人核心客户号
           WARRANTEE_NM, --8. 被担保人名称
           CURRENCY, --9. 担保币种
           GUAR_AMT, --10.  担保金额
           GUAR_TYPE_CD, --11.  担保形式
           BALANCE, --12.  被担保业务余额
           END_DT, --13.  被担保业务结清（到期）日期
           FIVE_CLASS_CD, --14.  被担保业务五级分类
           WARRANTEE_CURRENCY, --15.  被担保业务币种
           ISDEL, --16.  是否删除
           SRC_COMPANY_CD, --17.  源企业代码
           SRC_CD, --18.  源系统
           UPDT_BY, --19.  更新人
           UPDT_DT --20.  更新时间
      FROM TEMP_COMPY_PBCGUAR_CMB T
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

END SP_COMPY_PBCGUAR_CMB;
/
