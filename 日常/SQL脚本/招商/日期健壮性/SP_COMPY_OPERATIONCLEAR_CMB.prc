CREATE OR REPLACE PROCEDURE SP_COMPY_OPERATIONCLEAR_CMB IS
  /*
  存储过程：SP_COMPY_OPERATIONCLEAR_CMB
  功    能：加载-经营指标及结算汇总表-增量（STG->TEMP->TGT）
            主键：流水号
            (客户+来源+客户类型+是否生效)
  创 建 人：RayLee
  创建时间：2017/11/9 10:25:27
  源    表：CMAP_SYNC.STG_CMB_COMPY_OPERATIONCLEAR
  中 间 表：TEMP_COMPY_OPERATIONCLEAR_CMB
  目 标 表：COMPY_OPERATIONCLEAR_CMB
  --------------------------------------------------------------------
  修 改 人：RayLee
  修改时间：2017-12-19 09:51
  修改内容：转换币种代码
  修 改 人：RayLee
  修改时间：2017-12-28 14:22:54
  修改内容：相同业务主键，取updt_dt较大，对于同一批次（updt_dt相同），取record_sid更大的记录
  修 改 人：RayLee
  修改时间：2018-01-11 20:53:00.018000
  修改内容：添加字段，过去一年有无逾期记
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
  V_SRC_CD  TEMP_COMPY_OPERATIONCLEAR_CMB.SRC_CD%TYPE := UPPER(TRIM('CMB'));
  V_UPDT_BY TEMP_COMPY_OPERATIONCLEAR_CMB.UPDT_BY%TYPE := 0;
  V_ISDEL   TEMP_COMPY_OPERATIONCLEAR_CMB.ISDEL%TYPE := 0;

  V_EXEC_STEP VARCHAR2(100);

BEGIN

  --流程名称
  V_TASK_NAME := 'SP_COMPY_OPERATIONCLEAR_CMB';

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
  INSERT INTO TEMP_COMPY_OPERATIONCLEAR_CMB
    (COMPY_OPERATIONCLEAR_SID, --1. 经营指标及结算汇总编号
     COMPANY_ID, --2. 企业标识符
     RPT_DT, --3. 日期
     CURRENCY, --4. 币种代码
     ALL_AMT_IN, --5. 合计资金转入
     ALL_AMT_OUT, --6. 合计资金转出
     AVG_BALANCE_CURY, --7. 本年存款日均余额
     AVG_GRTBALANCE_CURY, --8. 本年保证金日均余额
     AVG_LOANBALANCE_CURY, --9. 本年贷款日均余额
     LOAN_DEPOSIT_RATIO, --10.  存贷比
     GUR_GROUP, --11.  担保圈
     BALANCE_SIXMON, --12.  结算账户近6个月月均余额
     BAL_1Y_UPTIMES, --13.  客户过去一年月末存款余额发生大额增加的次数_U卡
     BAL_1Y_UPTIMES_GROUP, --14.  客户过去一年月末存款余额发生大额增加的次数分组_U卡
     BBK_NM, --15.  管理分行名称
     CUST_CNT, --16.  十二个月前or三月前客户数量
     PD_CUST_CNT, --17.  十二个月后or三月后违约客户数量
     PD_INF, --18.  违约概率
     GROUP_NM, --19.  所属分组
     ISDEL, --20.  是否删除
     SRC_COMPANY_CD, --21.  源企业代码
     SRC_CD, --22.  源系统
     UPDT_BY, --23.  更新人
     UPDT_DT, --24.  更新时间
     RECORD_SID, --25.  流水号
     LOADLOG_SID, --26.  日志号
     RNK, --27.  记录序列
     overdue_12m   -- A1. 过去一年有无逾期记
     )
    SELECT SEQ_COMPY_OPERATIONCLEAR_CMB.NEXTVAL AS COMPY_OPERATIONCLEAR_SID, --1. 经营指标及结算汇总编号
           T1.COMPANY_ID AS COMPANY_ID, --2. 企业标识符
           --TO_DATE(T.DATA_DT, 'YYYY-MM-DD') AS RPT_DT, --3. 日期
           F_STR_TO_DATE(T.DATA_DT) AS RPT_DT, --3. 日期
           T.CURRENCY AS CURRENCY, --4. 币种代码
           T.ALL_AMT_IN AS ALL_AMT_IN, --5. 合计资金转入
           T.ALL_AMT_OUT AS ALL_AMT_OUT, --6. 合计资金转出
           T.AVG_BALANCE_CURY AS AVG_BALANCE_CURY, --7. 本年存款日均余额
           T.AVG_GRTBALANCE_CURY AS AVG_GRTBALANCE_CURY, --8. 本年保证金日均余额
           T.AVG_LOANBALANCE_CURY AS AVG_LOANBALANCE_CURY, --9. 本年贷款日均余额
           T.LOAN_DEPOSIT_RATIO AS LOAN_DEPOSIT_RATIO, --10.  存贷比
           T.GUR_GROUP AS GUR_GROUP, --11.  担保圈
           T.BALANCE_SIXMON AS BALANCE_SIXMON, --12.  结算账户近6个月月均余额
           T.BAL_1Y_UPTIMES AS BAL_1Y_UPTIMES, --13.  客户过去一年月末存款余额发生大额增加的次数_U卡
           T.BAL_1Y_UPTIMES_GROUP AS BAL_1Y_UPTIMES_GROUP, --14.  客户过去一年月末存款余额发生大额增加的次数分组_U卡
           T.BBK_NM AS BBK_NM, --15.  管理分行名称
           T.CUST_CNT AS CUST_CNT, --16.  十二个月前or三月前客户数量
           T.PD_CUST_CNT AS PD_CUST_CNT, --17.  十二个月后or三月后违约客户数量
           T.PD_INF AS PD_INF, --18.  违约概率
           T.GROUP_NM AS GROUP_NM, --19.  所属分组
           V_ISDEL AS ISDEL, --20.  是否删除
           T.CUST_NO AS SRC_COMPANY_CD, --21.  源企业代码
           V_SRC_CD AS SRC_CD, --22.  源系统
           V_UPDT_BY AS UPDT_BY, --23.  更新人
           SYSTIMESTAMP AS UPDT_DT, --24.  更新时间
           T.RECORD_SID AS RECORD_SID, --25.  流水号
           T.LOADLOG_SID AS LOADLOG_SID, --26.  日志号
           ROW_NUMBER()OVER(PARTITION BY T.DATA_DT, T.CUST_NO ORDER BY T.UPDT_DT DESC, T.RECORD_SID DESC) AS RNK, --27.  记录序列
           T.OVERDUE_12M AS OVERDUE_12M   -- A1. 过去一年有无逾期记
      FROM CMAP_SYNC.STG_CMB_COMPY_OPERATIONCLEAR T
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
    FROM TEMP_COMPY_OPERATIONCLEAR_CMB;

  --删除已经存在的增量数据
  V_EXEC_STEP := 'STEP4 删除已经存在的增量数据';

  DELETE FROM COMPY_OPERATIONCLEAR_CMB T
   WHERE EXISTS (SELECT *
            FROM TEMP_COMPY_OPERATIONCLEAR_CMB A
           WHERE T.COMPANY_ID = A.COMPANY_ID
             AND T.RPT_DT = A.RPT_DT);

  V_EXEC_STEP := 'STEP5 加载数据到目标表';
  INSERT INTO COMPY_OPERATIONCLEAR_CMB
    (COMPY_OPERATIONCLEAR_SID, --1. 经营指标及结算汇总编号
     COMPANY_ID, --2. 企业标识符
     RPT_DT, --3. 日期
     CURRENCY, --4. 币种代码
     ALL_AMT_IN, --5. 合计资金转入
     ALL_AMT_OUT, --6. 合计资金转出
     AVG_BALANCE_CURY, --7. 本年存款日均余额
     AVG_GRTBALANCE_CURY, --8. 本年保证金日均余额
     AVG_LOANBALANCE_CURY, --9. 本年贷款日均余额
     LOAN_DEPOSIT_RATIO, --10.  存贷比
     GUR_GROUP, --11.  担保圈
     BALANCE_SIXMON, --12.  结算账户近6个月月均余额
     BAL_1Y_UPTIMES, --13.  客户过去一年月末存款余额发生大额增加的次数_U卡
     BAL_1Y_UPTIMES_GROUP, --14.  客户过去一年月末存款余额发生大额增加的次数分组_U卡
     BBK_NM, --15.  管理分行名称
     CUST_CNT, --16.  十二个月前or三月前客户数量
     PD_CUST_CNT, --17.  十二个月后or三月后违约客户数量
     PD_INF, --18.  违约概率
     GROUP_NM, --19.  所属分组
     ISDEL, --20.  是否删除
     SRC_COMPANY_CD, --21.  源企业代码
     SRC_CD, --22.  源系统
     UPDT_BY, --23.  更新人
     UPDT_DT, --24.  更新时间
     OVERDUE_12M  -- A1. 过去一年有无逾期记
     )
    SELECT COMPY_OPERATIONCLEAR_SID, --1. 经营指标及结算汇总编号
           COMPANY_ID, --2. 企业标识符
           RPT_DT, --3. 日期
           CASE WHEN NVL(CURRENCY,'10') = '10' THEN 'CNY' ELSE CURRENCY END AS CURRENCY, --4. 币种代码
           ALL_AMT_IN, --5. 合计资金转入
           ALL_AMT_OUT, --6. 合计资金转出
           AVG_BALANCE_CURY, --7. 本年存款日均余额
           AVG_GRTBALANCE_CURY, --8. 本年保证金日均余额
           AVG_LOANBALANCE_CURY, --9. 本年贷款日均余额
           LOAN_DEPOSIT_RATIO, --10.  存贷比
           GUR_GROUP, --11.  担保圈
           BALANCE_SIXMON, --12.  结算账户近6个月月均余额
           BAL_1Y_UPTIMES, --13.  客户过去一年月末存款余额发生大额增加的次数_U卡
           BAL_1Y_UPTIMES_GROUP, --14.  客户过去一年月末存款余额发生大额增加的次数分组_U卡
           BBK_NM, --15.  管理分行名称
           CUST_CNT, --16.  十二个月前or三月前客户数量
           PD_CUST_CNT, --17.  十二个月后or三月后违约客户数量
           PD_INF, --18.  违约概率
           GROUP_NM, --19.  所属分组
           ISDEL, --20.  是否删除
           SRC_COMPANY_CD, --21.  源企业代码
           SRC_CD, --22.  源系统
           UPDT_BY, --23.  更新人
           UPDT_DT, --24.  更新时间
           OVERDUE_12M -- A1. 过去一年有无逾期记
      FROM TEMP_COMPY_OPERATIONCLEAR_CMB T
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
     NVL(V_UPDT_COUNT, 0),
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

END SP_COMPY_OPERATIONCLEAR_CMB;
/
