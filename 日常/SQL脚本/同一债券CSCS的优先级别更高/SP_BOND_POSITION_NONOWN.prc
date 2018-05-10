CREATE OR REPLACE PROCEDURE SP_BOND_POSITION_NONOWN IS
  /*
  �洢���̣�SP_BOND_POSITION_NONOWN
  ��    �ܣ�����-�������ֲ�-������STG->TEMP->TGT��
  �� �� �ˣ�RayLee
  ����ʱ�䣺2018-01-24 18:07:26.952000
  Դ    ��CMAP_SYNC.STG_CMB_BOND_STRUCTURED
  �� �� ��TEMP_BOND_POSITION_STRUCTURED
  Ŀ �� ��BOND_POSITION_STRUCTURED
  --------------------------------------------------------------------
  �޸ļ�¼�������޷���������˾ծȯ�Ĵ���ҲҪȫ��չʾ raylee 2018-01-30
            �޸���ϳֲֵ�����ΪTSID+END_DT;END_DT��Դ��ΪDATA_DT zhangcong 2018-03-14
  -------------------------------------------------------
  �� �� �ˣ�RayLee
  �޸�ʱ�䣺2018-04-13 10:20:11.877052
  �޸����ݣ������ֶ����f_str_to_date���ӽ�׳��
  
  �� �� �ˣ�RayLee
  �޸�ʱ�䣺2018-04-23 11:26:53.541000
  �޸����ݣ����ͬһծ����֤��ծȯ�������ֹ�¼���ծȯ
  */

  V_ERROR_CD          VARCHAR2(100);
  V_ERROR_MESSAGE     VARCHAR2(1000);
  V_TASK_NAME         ETL_TGT_LOADLOG.PROCESS_NM%TYPE; --��������
  V_UPDT_DT           ETL_TGT_LOADLOG.END_DT%TYPE; --�ϴ�ͬ������ʱ��
  V_START_DT          ETL_TGT_LOADLOG.START_DT%TYPE; --��ʼʱ��
  V_END_DT            ETL_TGT_LOADLOG.END_DT%TYPE; --����ʱ��
  V_START_ROWID       ETL_TGT_LOADLOG.START_ROWID%TYPE; --��ʼ�к�
  V_END_ROWID         ETL_TGT_LOADLOG.END_ROWID%TYPE; --��ֹ�к�
  V_INSERT_COUNT      ETL_TGT_LOADLOG.INSERT_COUNT%TYPE; --�����¼��
  V_UPDT_COUNT        ETL_TGT_LOADLOG.UPDT_COUNT%TYPE; --���¼�¼��
  V_ORIG_RECORD_COUNT NUMBER(16); --ԭʼ�ļ�¼��
  V_DUP_RECORD_COUNT  NUMBER(16); --�ظ��ļ�¼��

  --
  --V_SRC_CD  TEMP_BOND_POSITION_STRUCTURED.SRC_CD%TYPE := UPPER(TRIM('CMB'));
  V_UPDT_BY   TEMP_BOND_POSITION_NONOWN.UPDT_BY%TYPE := 0;
  V_ISDEL     TEMP_BOND_POSITION_NONOWN.ISDEL%TYPE := 0;
  V_EXEC_STEP VARCHAR2(100);

BEGIN

  --��������
  V_TASK_NAME := 'SP_BOND_POSITION_NONOWN';

  --��ʼʱ��
  V_START_DT := SYSTIMESTAMP;

  --��ȡ�ϴ�ͬ�����ݵ�ʱ��,����ǵ�һ������û�м�¼�ᷢ��NO_DATA_FOUND�쳣
  V_EXEC_STEP := 'STEP1 ��ȡ�ϴ�ͬ��ʱ��';
  BEGIN
    SELECT NVL(MAX(END_DT), TO_DATE('1900-1-1', 'yyyy-mm-dd'))
      INTO V_UPDT_DT
      FROM ETL_TGT_LOADLOG
     WHERE PROCESS_NM = V_TASK_NAME;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      V_UPDT_DT := TO_DATE('1900-1-1', 'yyyy-mm-dd');
  END;

  --��ȡ�����������ݲ��뵽��ʱ��
  V_EXEC_STEP := 'STEP2 ��ȡ�����������ݲ��뵽��ʱ��';
  INSERT INTO TEMP_BOND_POSITION_NONOWN
    (BOND_POSITION_NONOWN_SID, --1. �������ֲ���ˮ��
     SECINNER_ID, --2. ծȯ��ʶ��
     SECURITY_CD, --3. ծȯ����
     TRADE_MARKET_ID, --4. �����г�
     TRUSTEE_NM, --5. ί���������
     PORTFOLIO_CD, --6. ��ϴ���
     PORTFOLIO_NM, --7. �������
     END_DT, --8. �ֲ�����
     CURRENCY, --9. ����
     AMT_COST, --10.  �ֲ����-�ɱ���
     AMT_MARKETVALUE, --11.  �ֲ����-��ֵ��
     POSITION_NUM, --12.  �ֲ�����
     POSITION_CATEGORY, --13.  �ֲ�ҵ�����
     STRATEGY_L1, --14.  ����1������
     STRATEGY_L2, --15.  ����2������
     STRATEGY_L3, --16.  ����3������
     IS_VALID, --17.  �Ƿ���Ч
     TSID, --18.  Ψһ��ʶ
     SRC_UPDT_DT, --19.  Դ����ʱ��
     ISDEL, --20.  �Ƿ�ɾ��
     UPDT_BY, --21.  ������
     UPDT_DT, --22.  ����ʱ��
     RECORD_SID, --23.
     LOADLOG_SID, --24.
     RNK --25.
)
    SELECT SEQ_BOND_POSITION_NONOWN.NEXTVAL AS BOND_POSITION_NONOWN_SID, --1. �������ֲ���ˮ��
           T1.SECINNER_ID AS SECINNER_ID, --2. ծȯ��ʶ��
           T.SECURITY_CD AS SECURITY_CD, --3. ծȯ����
           TRADE_MARKET_ID, --4. �����г�
           TRUSTEE_NM, --5. ί���������
           PORTFOLIO_CD, --6. ��ϴ���
           PORTFOLIO_NM, --7. �������
           --TO_DATE(T.POSITION_DT, 'YYYY-MM-DD') AS END_DT, --8. �ֲ�����
           --TO_DATE(T.DATA_DT, 'YYYY-MM-DD') AS END_DT, --8. �ֲ�����
           F_STR_TO_DATE(T.DATA_DT) AS END_DT, --8. �ֲ�����
           CURRENCY, --9. ����
           AMT_COST, --10.  �ֲ����-�ɱ���
           AMT_MARKETVALUE, --11.  �ֲ����-��ֵ��
           POSITION_NUM, --12.  �ֲ�����
           POSITION_CATEGORY, --13.  �ֲ�ҵ�����
           T.CLS_01 AS STRATEGY_L1, --14.  ����1������
           T.CLS_02 AS STRATEGY_L2, --15.  ����2������
           T.CLS_03 AS STRATEGY_L3, --16.  ����3������
           IS_VALID, --17.  �Ƿ���Ч
           TSID, --18.  Ψһ��ʶ
           --TO_TIMESTAMP(SRC_UPDT_DT,'YYYY-MM-DD HH24:MI:SS') AS SRC_UPDT_DT, --19.  Դ����ʱ��
           TO_TIMESTAMP(POSITION_DT,'YYYY-MM-DD hh24:mi:ssxff6') AS SRC_UPDT_DT, --19.  Դ�ֲ�ʱ��
           V_ISDEL AS ISDEL, --20.  �Ƿ�ɾ��
           V_UPDT_BY AS UPDT_BY, --21.  ������
           SYSTIMESTAMP AS UPDT_DT, --22.  ����ʱ��
           RECORD_SID, --23.
           LOADLOG_SID, --24.
           --ROW_NUMBER() OVER(PARTITION BY T.SECURITY_CD, T.PORFOLIO_CD, T.DATA_DT ORDER BY T.UPDT_DT DESC,T.RECORD_SID DESC) AS RNK --16.
           --ROW_NUMBER() OVER(PARTITION BY T.DATA_DT,T.TSID ORDER BY T.UPDT_DT DESC, T.RECORD_SID DESC) AS RNK
           ROW_NUMBER() OVER(PARTITION BY T.DATA_DT,T.TSID ORDER BY T.UPDT_DT DESC, T.RECORD_SID DESC, CASE WHEN T1.SRC_CD = 'CSCS' THEN 1 ELSE 0 END DESC) AS RNK
      FROM CMAP_SYNC.STG_CMB_BOND_NONOWN T
     LEFT JOIN (SELECT A.SECINNER_ID,
                        A.TRADE_MARKET_ID,
                        A.SECURITY_NM,
                        SUBSTR(C.MARKET_ABBR || A.SECURITY_CD, 2) AS SECURITY_CD,
                        A.SRC_CD AS SRC_CD   -- ADD BY RAYLEE
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
                        'BK' || A.SECURITY_CD AS SECURITY_CD,
                        A.SRC_CD AS SRC_CD   -- ADD BY RAYLEE
                   FROM BOND_BASICINFO A
                   LEFT JOIN LKP_CHARCODE B
                     ON A.TRADE_MARKET_ID = B.CONSTANT_ID
                    AND B.CONSTANT_TYPE = 206
                   LEFT JOIN LKP_MARKET_ABBR C
                     ON C.MARKET_CD = B.CONSTANT_CD
                  WHERE C.MARKET_ABBR = '.IB') T1
        ON T1.SECURITY_CD = T.SECURITY_CD
     WHERE T.IS_VALID = '1'
       AND T.UPDT_DT > V_UPDT_DT;

  --����ʱ��
  V_END_DT := SYSTIMESTAMP;

  --��ȡ��־����
  V_EXEC_STEP := 'STEP3 ��ȡ��־����';
  SELECT COUNT(1) AS ORIG_RECORD_COUNT, --ԭʼ�ļ�¼��
         NVL(SUM(CASE
                   WHEN RNK > 1 THEN
                    1
                   ELSE
                    0
                 END),
             0) AS DUP_RECORD_COUNT, --�ظ��ļ�¼��
         MIN(RECORD_SID) AS START_ROWID, --��ʼ�к�
         MAX(RECORD_SID) AS END_ROWID --��ֹ�к�
    INTO V_ORIG_RECORD_COUNT,
         V_DUP_RECORD_COUNT,
         V_START_ROWID,
         V_END_ROWID
    FROM TEMP_BOND_POSITION_NONOWN;

  --ɾ���Ѿ����ڵ���������
  V_EXEC_STEP := 'STEP4 ɾ���Ѿ����ڵ���������';

  DELETE FROM BOND_POSITION_NONOWN T
   WHERE EXISTS
   (SELECT * FROM TEMP_BOND_POSITION_NONOWN A WHERE T.TSID = A.TSID AND T.END_DT = A.END_DT);

  V_EXEC_STEP := 'STEP5 �������ݵ�Ŀ���';
  INSERT INTO BOND_POSITION_NONOWN
    (BOND_POSITION_NONOWN_SID, --1. �������ֲ���ˮ��
     SECINNER_ID, --2. ծȯ��ʶ��
     SECURITY_CD, --3. ծȯ����
     TRADE_MARKET_ID, --4. �����г�
     TRUSTEE_NM, --5. ί���������
     PORTFOLIO_CD, --6. ��ϴ���
     PORTFOLIO_NM, --7. �������
     END_DT, --8. �ֲ�����
     CURRENCY, --9. ����
     AMT_COST, --10.  �ֲ����-�ɱ���
     AMT_MARKETVALUE, --11.  �ֲ����-��ֵ��
     POSITION_NUM, --12.  �ֲ�����
     POSITION_CATEGORY, --13.  �ֲ�ҵ�����
     STRATEGY_L1, --14.  ����1������
     STRATEGY_L2, --15.  ����2������
     STRATEGY_L3, --16.  ����3������
     IS_VALID, --17.  �Ƿ���Ч
     TSID, --18.  Ψһ��ʶ
     SRC_UPDT_DT, --19.  Դ����ʱ��
     ISDEL, --20.  �Ƿ�ɾ��
     UPDT_BY, --21.  ������
     UPDT_DT --22.  ����ʱ��

     )
    SELECT BOND_POSITION_NONOWN_SID, --1. �������ֲ���ˮ��
           SECINNER_ID, --2. ծȯ��ʶ��
           SECURITY_CD, --3. ծȯ����
           TRADE_MARKET_ID, --4. �����г�
           TRUSTEE_NM, --5. ί���������
           PORTFOLIO_CD, --6. ��ϴ���
           PORTFOLIO_NM, --7. �������
           END_DT, --8. �ֲ�����
           CURRENCY, --9. ����
           AMT_COST, --10.  �ֲ����-�ɱ���
           AMT_MARKETVALUE, --11.  �ֲ����-��ֵ��
           POSITION_NUM, --12.  �ֲ�����
           T.POSITION_CATEGORY AS POSITION_CATEGORY, --13.  �ֲ�ҵ�����
           STRATEGY_L1, --14.  ����1������
           STRATEGY_L2, --15.  ����2������
           STRATEGY_L3, --16.  ����3������
           IS_VALID, --17.  �Ƿ���Ч
           TSID, --18.  Ψһ��ʶ
           SRC_UPDT_DT, --19.  Դ����ʱ��
           ISDEL, --20.  �Ƿ�ɾ��
           UPDT_BY, --21.  ������
           UPDT_DT --22.  ����ʱ��
      FROM TEMP_BOND_POSITION_NONOWN T
     WHERE RNK = '1';

  V_INSERT_COUNT := SQL%ROWCOUNT;
  COMMIT;

  --�������ݵ�LOG����
  V_EXEC_STEP := 'STEP6 �������ݵ�LOG����';
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

  --������
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

END SP_BOND_POSITION_NONOWN;
/
