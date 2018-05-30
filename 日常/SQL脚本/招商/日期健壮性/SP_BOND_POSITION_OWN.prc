CREATE OR REPLACE PROCEDURE SP_BOND_POSITION_OWN IS
  /*
  �洢���̣�SP_BOND_POSITION_OWN
  ��    �ܣ�����-�����ֲ�-������STG->TEMP->TGT��
            ��������ˮ��
            (�ͻ�+��Դ+�ͻ�����+�Ƿ���Ч)
  �� �� �ˣ�RayLee
  ����ʱ�䣺2017/11/9 10:25:27
  Դ    ��CMAP_SYNC.STG_CMB_BOND_POSITIONOWN
  �� �� ��TEMP_BOND_POSITION_OWN
  Ŀ �� ��BOND_POSITION_OWN
  --------------------------------------------------------------------
  �� �� �ˣ�RayLee
  �޸�ʱ�䣺2017-12-28 14:27:05
  �޸����ݣ���ͬҵ��������ȡupdt_dt�ϴ󣬶���ͬһ���Σ�updt_dt��ͬ����ȡrecord_sid����ļ�¼
  �� �� �ˣ�RayLee
  �޸�ʱ�䣺2018-01-30 13:31:42
  �޸����ݣ������޷���������˾ծȯ�Ĵ���ҲҪȫ��չʾ
  -------------------------------------------------------
  �� �� �ˣ�RayLee
  �޸�ʱ�䣺2018-04-13 10:20:11.877052
  �޸����ݣ������ֶ����f_str_to_date���ӽ�׳��
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
  --V_SRC_CD  TEMP_BOND_POSITION_OWN.SRC_CD%TYPE := UPPER(TRIM('CMB'));
  V_UPDT_BY TEMP_BOND_POSITION_OWN.UPDT_BY%TYPE := 0;
  V_ISDEL   TEMP_BOND_POSITION_OWN.ISDEL%TYPE := 0;

  V_EXEC_STEP VARCHAR2(100);

BEGIN

  --��������
  V_TASK_NAME := 'SP_BOND_POSITION_OWN';

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
  INSERT INTO TEMP_BOND_POSITION_OWN
    (BOND_POSITION_OWN_SID, --1. �����ֲ���ˮ��
     SECINNER_ID, --2. ծȯ��ʶ��
     SECURITY_CD, --ծȯ����
     SECURITY_NM, --ծȯȫ��
     TRADE_MARKET_ID, --�����г�
     SECURITY_SNM, --ծȯ���
     PORTFOLIO_CD, --3. ��ϴ���
     PORTFOLIO_NM, --4. �������
     END_DT, --5. �ֲ�����
     CURRENCY, --6. ����
     AMT_COST, --7. �ֲ����-�ɱ���
     AMT_MARKETVALUE, --8. �ֲ����-��ֵ��
     POSITION_NUM, --9. �ֲ�����
     SRC_UPDT_DT, --10.  Դ����ʱ��
     ISDEL, --11.  �Ƿ�ɾ��
     UPDT_BY, --12.  ������
     RECORD_SID, --13.  ��ˮ��
     LOADLOG_SID, --14.  ��־��
     UPDT_DT, --15.  ����ʱ��
     RNK --16.  ��¼����
     )
    SELECT SEQ_BOND_POSITION_OWN.NEXTVAL AS BOND_POSITION_OWN_SID, --1. �����ֲ���ˮ��
           T1.SECINNER_ID AS SECINNER_ID, --2. ծȯ��ʶ��
           T.SECURITY_CD,--ծȯ����
           T.SECURITY_NM,--ծȯȫ��
           T1.TRADE_MARKET_ID,--�����г�
           T.SECURITY_SNM,--ծȯ���
           T.PORTFOLIO_CD AS PORTFOLIO_CD, --3. ��ϴ���
           T.PORTFOLIO_NM AS PORTFOLIO_NM, --4. �������
           --TO_DATE(T.DATA_DT, 'YYYY-MM-DD') AS END_DT, --5. �ֲ�����
           f_str_to_date(T.DATA_DT) AS END_DT, --5. �ֲ�����
           T.CURRENCY AS CURRENCY, --6. ����
           T.AMT_COST AS AMT_COST, --7. �ֲ����-�ɱ���
           T.AMT_MARKETVALUE AS AMT_MARKETVALUE, --8. �ֲ����-��ֵ��
           T.POSITION_NUM AS POSITION_NUM, --9. �ֲ�����
           TO_TIMESTAMP(T.SRC_UPDT_DT,'YYYY-MM-DD hh24:mi:ssxff6') AS SRC_UPDT_DT, --10.  Դ����ʱ��
           V_ISDEL AS ISDEL, --11.  �Ƿ�ɾ��
           V_UPDT_BY AS UPDT_BY, --12.  ������
           T.RECORD_SID AS RECORD_SID, --13.  ��ˮ��
           T.LOADLOG_SID AS LOADLOG_SID, --14.  ��־��
           SYSTIMESTAMP AS UPDT_DT, --15.  ����ʱ��
           ROW_NUMBER() OVER(PARTITION BY T.SECURITY_CD, T.DATA_DT, T.PORTFOLIO_CD ORDER BY T.UPDT_DT DESC,T.RECORD_SID DESC) AS RNK --16.  ��¼����
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
    FROM TEMP_BOND_POSITION_OWN T;

  --ɾ���Ѿ����ڵ���������
  V_EXEC_STEP := 'STEP4 ɾ���Ѿ����ڵ���������';

  DELETE FROM BOND_POSITION_OWN T
   WHERE EXISTS (SELECT *
            FROM TEMP_BOND_POSITION_OWN A
           WHERE A.SECINNER_ID = T.SECINNER_ID
             AND A.END_DT = T.END_DT);

  V_EXEC_STEP := 'STEP5 �������ݵ�Ŀ���';
  INSERT INTO BOND_POSITION_OWN
    (BOND_POSITION_OWN_SID, --1. �����ֲ���ˮ��
     SECINNER_ID, --2. ծȯ��ʶ��
     SECURITY_CD, --ծȯ����
     SECURITY_NM, --ծȯȫ��
     TRADE_MARKET_ID, --�����г�
     SECURITY_SNM, --ծȯ���
     PORTFOLIO_CD, --3. ��ϴ���
     PORTFOLIO_NM, --4. �������
     END_DT, --5. �ֲ�����
     CURRENCY, --6. ����
     AMT_COST, --7. �ֲ����-�ɱ���
     AMT_MARKETVALUE, --8. �ֲ����-��ֵ��
     POSITION_NUM, --9. �ֲ�����
     SRC_UPDT_DT, --10.  Դ����ʱ��
     ISDEL, --11.  �Ƿ�ɾ��
     UPDT_BY, --12.  ������
     UPDT_DT --13.  ����ʱ��

     )
    SELECT BOND_POSITION_OWN_SID, --1. �����ֲ���ˮ��
           SECINNER_ID, --2. ծȯ��ʶ��
           SECURITY_CD, --ծȯ����
           SECURITY_NM, --ծȯȫ��
           TRADE_MARKET_ID, --�����г�
           SECURITY_SNM, --ծȯ���
           PORTFOLIO_CD, --3. ��ϴ���
           PORTFOLIO_NM, --4. �������
           END_DT, --5. �ֲ�����
           CURRENCY, --6. ����
           AMT_COST, --7. �ֲ����-�ɱ���
           AMT_MARKETVALUE, --8. �ֲ����-��ֵ��
           POSITION_NUM, --9. �ֲ�����
           SRC_UPDT_DT, --10.  Դ����ʱ��
           ISDEL, --11.  �Ƿ�ɾ��
           UPDT_BY, --12.  ������
           UPDT_DT --13.  ����ʱ��
      FROM TEMP_BOND_POSITION_OWN T
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

END SP_BOND_POSITION_OWN;
/
