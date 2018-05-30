CREATE OR REPLACE PROCEDURE SP_COMPY_OPERATIONCLEAR_CMB IS
  /*
  �洢���̣�SP_COMPY_OPERATIONCLEAR_CMB
  ��    �ܣ�����-��Ӫָ�꼰������ܱ�-������STG->TEMP->TGT��
            ��������ˮ��
            (�ͻ�+��Դ+�ͻ�����+�Ƿ���Ч)
  �� �� �ˣ�RayLee
  ����ʱ�䣺2017/11/9 10:25:27
  Դ    ��CMAP_SYNC.STG_CMB_COMPY_OPERATIONCLEAR
  �� �� ��TEMP_COMPY_OPERATIONCLEAR_CMB
  Ŀ �� ��COMPY_OPERATIONCLEAR_CMB
  --------------------------------------------------------------------
  �� �� �ˣ�RayLee
  �޸�ʱ�䣺2017-12-19 09:51
  �޸����ݣ�ת�����ִ���
  �� �� �ˣ�RayLee
  �޸�ʱ�䣺2017-12-28 14:22:54
  �޸����ݣ���ͬҵ��������ȡupdt_dt�ϴ󣬶���ͬһ���Σ�updt_dt��ͬ����ȡrecord_sid����ļ�¼
  �� �� �ˣ�RayLee
  �޸�ʱ�䣺2018-01-11 20:53:00.018000
  �޸����ݣ�����ֶΣ���ȥһ���������ڼ�
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
  V_SRC_CD  TEMP_COMPY_OPERATIONCLEAR_CMB.SRC_CD%TYPE := UPPER(TRIM('CMB'));
  V_UPDT_BY TEMP_COMPY_OPERATIONCLEAR_CMB.UPDT_BY%TYPE := 0;
  V_ISDEL   TEMP_COMPY_OPERATIONCLEAR_CMB.ISDEL%TYPE := 0;

  V_EXEC_STEP VARCHAR2(100);

BEGIN

  --��������
  V_TASK_NAME := 'SP_COMPY_OPERATIONCLEAR_CMB';

  --��ʼʱ��
  V_START_DT := SYSTIMESTAMP;

  --��ȡ�ϴ�ͬ�����ݵ�ʱ��,����ǵ�һ������û�м�¼�ᷢ��NO_DATA_FOUND�쳣
  V_EXEC_STEP := 'STEP1 ��ȡ�ϴ�ͬ��ʱ��';
  BEGIN
    SELECT NVL(MAX(END_DT),TO_DATE('1900-1-1', 'yyyy-mm-dd'))
      INTO V_UPDT_DT
      FROM ETL_TGT_LOADLOG
     WHERE PROCESS_NM = V_TASK_NAME;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      V_UPDT_DT := TO_DATE('1900-1-1', 'yyyy-mm-dd');
  END;

  --��ȡ�����������ݲ��뵽��ʱ��
  V_EXEC_STEP := 'STEP2 ��ȡ�����������ݲ��뵽��ʱ��';
  INSERT INTO TEMP_COMPY_OPERATIONCLEAR_CMB
    (COMPY_OPERATIONCLEAR_SID, --1. ��Ӫָ�꼰������ܱ��
     COMPANY_ID, --2. ��ҵ��ʶ��
     RPT_DT, --3. ����
     CURRENCY, --4. ���ִ���
     ALL_AMT_IN, --5. �ϼ��ʽ�ת��
     ALL_AMT_OUT, --6. �ϼ��ʽ�ת��
     AVG_BALANCE_CURY, --7. �������վ����
     AVG_GRTBALANCE_CURY, --8. ���걣֤���վ����
     AVG_LOANBALANCE_CURY, --9. ��������վ����
     LOAN_DEPOSIT_RATIO, --10.  �����
     GUR_GROUP, --11.  ����Ȧ
     BALANCE_SIXMON, --12.  �����˻���6�����¾����
     BAL_1Y_UPTIMES, --13.  �ͻ���ȥһ����ĩ�������������ӵĴ���_U��
     BAL_1Y_UPTIMES_GROUP, --14.  �ͻ���ȥһ����ĩ�������������ӵĴ�������_U��
     BBK_NM, --15.  �����������
     CUST_CNT, --16.  ʮ������ǰor����ǰ�ͻ�����
     PD_CUST_CNT, --17.  ʮ�����º�or���º�ΥԼ�ͻ�����
     PD_INF, --18.  ΥԼ����
     GROUP_NM, --19.  ��������
     ISDEL, --20.  �Ƿ�ɾ��
     SRC_COMPANY_CD, --21.  Դ��ҵ����
     SRC_CD, --22.  Դϵͳ
     UPDT_BY, --23.  ������
     UPDT_DT, --24.  ����ʱ��
     RECORD_SID, --25.  ��ˮ��
     LOADLOG_SID, --26.  ��־��
     RNK, --27.  ��¼����
     overdue_12m   -- A1. ��ȥһ���������ڼ�
     )
    SELECT SEQ_COMPY_OPERATIONCLEAR_CMB.NEXTVAL AS COMPY_OPERATIONCLEAR_SID, --1. ��Ӫָ�꼰������ܱ��
           T1.COMPANY_ID AS COMPANY_ID, --2. ��ҵ��ʶ��
           --TO_DATE(T.DATA_DT, 'YYYY-MM-DD') AS RPT_DT, --3. ����
           F_STR_TO_DATE(T.DATA_DT) AS RPT_DT, --3. ����
           T.CURRENCY AS CURRENCY, --4. ���ִ���
           T.ALL_AMT_IN AS ALL_AMT_IN, --5. �ϼ��ʽ�ת��
           T.ALL_AMT_OUT AS ALL_AMT_OUT, --6. �ϼ��ʽ�ת��
           T.AVG_BALANCE_CURY AS AVG_BALANCE_CURY, --7. �������վ����
           T.AVG_GRTBALANCE_CURY AS AVG_GRTBALANCE_CURY, --8. ���걣֤���վ����
           T.AVG_LOANBALANCE_CURY AS AVG_LOANBALANCE_CURY, --9. ��������վ����
           T.LOAN_DEPOSIT_RATIO AS LOAN_DEPOSIT_RATIO, --10.  �����
           T.GUR_GROUP AS GUR_GROUP, --11.  ����Ȧ
           T.BALANCE_SIXMON AS BALANCE_SIXMON, --12.  �����˻���6�����¾����
           T.BAL_1Y_UPTIMES AS BAL_1Y_UPTIMES, --13.  �ͻ���ȥһ����ĩ�������������ӵĴ���_U��
           T.BAL_1Y_UPTIMES_GROUP AS BAL_1Y_UPTIMES_GROUP, --14.  �ͻ���ȥһ����ĩ�������������ӵĴ�������_U��
           T.BBK_NM AS BBK_NM, --15.  �����������
           T.CUST_CNT AS CUST_CNT, --16.  ʮ������ǰor����ǰ�ͻ�����
           T.PD_CUST_CNT AS PD_CUST_CNT, --17.  ʮ�����º�or���º�ΥԼ�ͻ�����
           T.PD_INF AS PD_INF, --18.  ΥԼ����
           T.GROUP_NM AS GROUP_NM, --19.  ��������
           V_ISDEL AS ISDEL, --20.  �Ƿ�ɾ��
           T.CUST_NO AS SRC_COMPANY_CD, --21.  Դ��ҵ����
           V_SRC_CD AS SRC_CD, --22.  Դϵͳ
           V_UPDT_BY AS UPDT_BY, --23.  ������
           SYSTIMESTAMP AS UPDT_DT, --24.  ����ʱ��
           T.RECORD_SID AS RECORD_SID, --25.  ��ˮ��
           T.LOADLOG_SID AS LOADLOG_SID, --26.  ��־��
           ROW_NUMBER()OVER(PARTITION BY T.DATA_DT, T.CUST_NO ORDER BY T.UPDT_DT DESC, T.RECORD_SID DESC) AS RNK, --27.  ��¼����
           T.OVERDUE_12M AS OVERDUE_12M   -- A1. ��ȥһ���������ڼ�
      FROM CMAP_SYNC.STG_CMB_COMPY_OPERATIONCLEAR T
      LEFT JOIN CUSTOMER_CMB T1
        ON T1.CUST_NO = T.CUST_NO
     WHERE T.UPDT_DT > V_UPDT_DT
       AND T1.COMPANY_ID IS NOT NULL;

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
    FROM TEMP_COMPY_OPERATIONCLEAR_CMB;

  --ɾ���Ѿ����ڵ���������
  V_EXEC_STEP := 'STEP4 ɾ���Ѿ����ڵ���������';

  DELETE FROM COMPY_OPERATIONCLEAR_CMB T
   WHERE EXISTS (SELECT *
            FROM TEMP_COMPY_OPERATIONCLEAR_CMB A
           WHERE T.COMPANY_ID = A.COMPANY_ID
             AND T.RPT_DT = A.RPT_DT);

  V_EXEC_STEP := 'STEP5 �������ݵ�Ŀ���';
  INSERT INTO COMPY_OPERATIONCLEAR_CMB
    (COMPY_OPERATIONCLEAR_SID, --1. ��Ӫָ�꼰������ܱ��
     COMPANY_ID, --2. ��ҵ��ʶ��
     RPT_DT, --3. ����
     CURRENCY, --4. ���ִ���
     ALL_AMT_IN, --5. �ϼ��ʽ�ת��
     ALL_AMT_OUT, --6. �ϼ��ʽ�ת��
     AVG_BALANCE_CURY, --7. �������վ����
     AVG_GRTBALANCE_CURY, --8. ���걣֤���վ����
     AVG_LOANBALANCE_CURY, --9. ��������վ����
     LOAN_DEPOSIT_RATIO, --10.  �����
     GUR_GROUP, --11.  ����Ȧ
     BALANCE_SIXMON, --12.  �����˻���6�����¾����
     BAL_1Y_UPTIMES, --13.  �ͻ���ȥһ����ĩ�������������ӵĴ���_U��
     BAL_1Y_UPTIMES_GROUP, --14.  �ͻ���ȥһ����ĩ�������������ӵĴ�������_U��
     BBK_NM, --15.  �����������
     CUST_CNT, --16.  ʮ������ǰor����ǰ�ͻ�����
     PD_CUST_CNT, --17.  ʮ�����º�or���º�ΥԼ�ͻ�����
     PD_INF, --18.  ΥԼ����
     GROUP_NM, --19.  ��������
     ISDEL, --20.  �Ƿ�ɾ��
     SRC_COMPANY_CD, --21.  Դ��ҵ����
     SRC_CD, --22.  Դϵͳ
     UPDT_BY, --23.  ������
     UPDT_DT, --24.  ����ʱ��
     OVERDUE_12M  -- A1. ��ȥһ���������ڼ�
     )
    SELECT COMPY_OPERATIONCLEAR_SID, --1. ��Ӫָ�꼰������ܱ��
           COMPANY_ID, --2. ��ҵ��ʶ��
           RPT_DT, --3. ����
           CASE WHEN NVL(CURRENCY,'10') = '10' THEN 'CNY' ELSE CURRENCY END AS CURRENCY, --4. ���ִ���
           ALL_AMT_IN, --5. �ϼ��ʽ�ת��
           ALL_AMT_OUT, --6. �ϼ��ʽ�ת��
           AVG_BALANCE_CURY, --7. �������վ����
           AVG_GRTBALANCE_CURY, --8. ���걣֤���վ����
           AVG_LOANBALANCE_CURY, --9. ��������վ����
           LOAN_DEPOSIT_RATIO, --10.  �����
           GUR_GROUP, --11.  ����Ȧ
           BALANCE_SIXMON, --12.  �����˻���6�����¾����
           BAL_1Y_UPTIMES, --13.  �ͻ���ȥһ����ĩ�������������ӵĴ���_U��
           BAL_1Y_UPTIMES_GROUP, --14.  �ͻ���ȥһ����ĩ�������������ӵĴ�������_U��
           BBK_NM, --15.  �����������
           CUST_CNT, --16.  ʮ������ǰor����ǰ�ͻ�����
           PD_CUST_CNT, --17.  ʮ�����º�or���º�ΥԼ�ͻ�����
           PD_INF, --18.  ΥԼ����
           GROUP_NM, --19.  ��������
           ISDEL, --20.  �Ƿ�ɾ��
           SRC_COMPANY_CD, --21.  Դ��ҵ����
           SRC_CD, --22.  Դϵͳ
           UPDT_BY, --23.  ������
           UPDT_DT, --24.  ����ʱ��
           OVERDUE_12M -- A1. ��ȥһ���������ڼ�
      FROM TEMP_COMPY_OPERATIONCLEAR_CMB T
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

END SP_COMPY_OPERATIONCLEAR_CMB;
/
