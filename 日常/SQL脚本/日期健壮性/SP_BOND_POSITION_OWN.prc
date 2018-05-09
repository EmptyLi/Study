CREATE OR REPLACE PROCEDURE SP_BOND_POSITION_OWN IS
  /*
  存储过程：SP_BOND_POSITION_OWN
  功    能：加载-自主持仓-增量（STG->TEMP->TGT）
            主键：流水号
            (客户+来源+客户类型+是否生效)
  创 建 人：RayLee
  创建时间：2017/11/9 10:25:27
  源    表：CMAP_SYNC.STG_CMB_BOND_POSITIONOWN
  中 间 表：TEMP_BOND_POSITION_OWN
  目 标 表：BOND_POSITION_OWN
  --------------------------------------------------------------------
  修 改 人：RayLee
  修改时间：2017-12-28 14:27:05
  修改内容：相同业务主键，取updt_dt较大，对于同一批次（updt_dt相同），取record_sid更大的记录
  修 改 人：RayLee
  修改时间：2018-01-30 13:31:42
  修改内容：对于无法关联到我司债券的代码也要全部展示
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
  --V_SRC_CD  TEMP_BOND_POSITION_OWN.SRC_CD%TYPE := UPPER(TRIM('CMB'));
  V_UPDT_BY TEMP_BOND_POSITION_OWN.UPDT_BY%TYPE := 0;
  V_ISDEL   TEMP_BOND_POSITION_OWN.ISDEL%TYPE := 0;

  V_EXEC_STEP VARCHAR2(100);

BEGIN

  --流程名称
  V_TASK_NAME := 'SP_BOND_POSITION_OWN';

  --开始时间
  V_START_DT := SYSTIMESTAMP;

  --获取上次同步数据的时间,如果是第一次运行没有记录会发生NO_DATA_FOUND异常
  V_EXEC_STEP := 'STEP1 获取上次同步时间';
  BEGIN
    SELECT NVL(MAX(END_DT), TO_DATE('1900-1-1', 'yyyy-mm-dd'))
      INTO V_UPDT_DT
      FROM ETL_TGT_LOADLOG
     WHERE PROCESS_NM = V_TASK_NAME;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      V_UPDT_DT := TO_DATE('1900-1-1', 'yyyy-mm-dd');
  END;

  --获取本次增量数据插入到临时表
  V_EXEC_STEP := 'STEP2 获取本次增量数据插入到临时表';
  INSERT INTO TEMP_BOND_POSITION_OWN
    (BOND_POSITION_OWN_SID, --1. 自主持仓流水号
     SECINNER_ID, --2. 债券标识符
     SECURITY_CD, --债券代码
     SECURITY_NM, --债券全称
     TRADE_MARKET_ID, --交易市场
     SECURITY_SNM, --债券简称
     PORTFOLIO_CD, --3. 组合代码
     PORTFOLIO_NM, --4. 组合名称
     END_DT, --5. 持仓日期
     CURRENCY, --6. 币种
     AMT_COST, --7. 持仓余额-成本法
     AMT_MARKETVALUE, --8. 持仓余额-市值法
     POSITION_NUM, --9. 持仓数量
     SRC_UPDT_DT, --10.  源更新时间
     ISDEL, --11.  是否删除
     UPDT_BY, --12.  更新人
     RECORD_SID, --13.  流水号
     LOADLOG_SID, --14.  日志号
     UPDT_DT, --15.  更新时间
     RNK --16.  记录序列
     )
    SELECT SEQ_BOND_POSITION_OWN.NEXTVAL AS BOND_POSITION_OWN_SID, --1. 自主持仓流水号
           T1.SECINNER_ID AS SECINNER_ID, --2. 债券标识符
           T.SECURITY_CD,--债券代码
           T.SECURITY_NM,--债券全称
           T1.TRADE_MARKET_ID,--交易市场
           T.SECURITY_SNM,--债券简称
           T.PORTFOLIO_CD AS PORTFOLIO_CD, --3. 组合代码
           T.PORTFOLIO_NM AS PORTFOLIO_NM, --4. 组合名称
           --TO_DATE(T.DATA_DT, 'YYYY-MM-DD') AS END_DT, --5. 持仓日期
           f_str_to_date(T.DATA_DT) AS END_DT, --5. 持仓日期
           T.CURRENCY AS CURRENCY, --6. 币种
           T.AMT_COST AS AMT_COST, --7. 持仓余额-成本法
           T.AMT_MARKETVALUE AS AMT_MARKETVALUE, --8. 持仓余额-市值法
           T.POSITION_NUM AS POSITION_NUM, --9. 持仓数量
           TO_TIMESTAMP(T.SRC_UPDT_DT,'YYYY-MM-DD hh24:mi:ssxff6') AS SRC_UPDT_DT, --10.  源更新时间
           V_ISDEL AS ISDEL, --11.  是否删除
           V_UPDT_BY AS UPDT_BY, --12.  更新人
           T.RECORD_SID AS RECORD_SID, --13.  流水号
           T.LOADLOG_SID AS LOADLOG_SID, --14.  日志号
           SYSTIMESTAMP AS UPDT_DT, --15.  更新时间
           ROW_NUMBER() OVER(PARTITION BY T.SECURITY_CD, T.DATA_DT, T.PORTFOLIO_CD ORDER BY T.UPDT_DT DESC,T.RECORD_SID DESC) AS RNK --16.  记录序列
      FROM CMAP_SYNC.STG_CMB_BOND_POSITIONOWN T
      LEFT JOIN (SELECT A.SECINNER_ID,
                        A.TRADE_MARKET_ID,
                        A.SECURITY_NM,
                        SUBSTR(C.MARKET_ABBR || A.SECURITY_CD, 2) AS SECURITY_CD
                   FROM BOND_BASICINFO A
                   LEFT JOIN LKP_CHARCODE B
                     ON A.TRADE_MARKET_ID = B.CONSTANT_ID
                    AND B.CONSTANT_TYPE = 206
                   LEFT JOIN LKP_MARKET_ABBR C
                     ON C.MARKET_CD = B.CONSTANT_CD
                 UNION ALL
                 SELECT A.SECINNER_ID,
                        A.TRADE_MARKET_ID,
                        A.SECURITY_NM,
                        'BK' || A.SECURITY_CD AS SECURITY_CD
                   FROM BOND_BASICINFO A
                   LEFT JOIN LKP_CHARCODE B
                     ON A.TRADE_MARKET_ID = B.CONSTANT_ID
                    AND B.CONSTANT_TYPE = 206
                   LEFT JOIN LKP_MARKET_ABBR C
                     ON C.MARKET_CD = B.CONSTANT_CD
                  WHERE C.MARKET_ABBR = '.IB') T1
        ON T1.SECURITY_CD = T.SECURITY_CD
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
    FROM TEMP_BOND_POSITION_OWN T;

  --删除已经存在的增量数据
  V_EXEC_STEP := 'STEP4 删除已经存在的增量数据';

  DELETE FROM BOND_POSITION_OWN T
   WHERE EXISTS (SELECT *
            FROM TEMP_BOND_POSITION_OWN A
           WHERE A.SECINNER_ID = T.SECINNER_ID
             AND A.END_DT = T.END_DT);

  V_EXEC_STEP := 'STEP5 加载数据到目标表';
  INSERT INTO BOND_POSITION_OWN
    (BOND_POSITION_OWN_SID, --1. 自主持仓流水号
     SECINNER_ID, --2. 债券标识符
     SECURITY_CD, --债券代码
     SECURITY_NM, --债券全称
     TRADE_MARKET_ID, --交易市场
     SECURITY_SNM, --债券简称
     PORTFOLIO_CD, --3. 组合代码
     PORTFOLIO_NM, --4. 组合名称
     END_DT, --5. 持仓日期
     CURRENCY, --6. 币种
     AMT_COST, --7. 持仓余额-成本法
     AMT_MARKETVALUE, --8. 持仓余额-市值法
     POSITION_NUM, --9. 持仓数量
     SRC_UPDT_DT, --10.  源更新时间
     ISDEL, --11.  是否删除
     UPDT_BY, --12.  更新人
     UPDT_DT --13.  更新时间

     )
    SELECT BOND_POSITION_OWN_SID, --1. 自主持仓流水号
           SECINNER_ID, --2. 债券标识符
           SECURITY_CD, --债券代码
           SECURITY_NM, --债券全称
           TRADE_MARKET_ID, --交易市场
           SECURITY_SNM, --债券简称
           PORTFOLIO_CD, --3. 组合代码
           PORTFOLIO_NM, --4. 组合名称
           END_DT, --5. 持仓日期
           CURRENCY, --6. 币种
           AMT_COST, --7. 持仓余额-成本法
           AMT_MARKETVALUE, --8. 持仓余额-市值法
           POSITION_NUM, --9. 持仓数量
           SRC_UPDT_DT, --10.  源更新时间
           ISDEL, --11.  是否删除
           UPDT_BY, --12.  更新人
           UPDT_DT --13.  更新时间
      FROM TEMP_BOND_POSITION_OWN T
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

END SP_BOND_POSITION_OWN;
/
