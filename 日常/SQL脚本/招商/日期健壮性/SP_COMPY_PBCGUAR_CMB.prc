CREATE OR REPLACE PROCEDURE SP_COMPY_PBCGUAR_CMB IS
  /*
  �洢���̣�SP_COMPY_PBCGUAR_CMB
  ��    �ܣ�����-������Ϣ-������STG->TEMP->TGT��
  �� �� �ˣ�RayLee
  ����ʱ�䣺2017/11/8 19:16:19
  Դ    ��CMAP_SYNC.STG_COMPY_PBCGUAR_CMB
  �� �� ��TEMP_COMPY_PBCGUAR_CMB
  Ŀ �� ��COMPY_PBCGUAR_CMB
  --------------------------------------------------------------------
  �� �� �ˣ�RayLee
  �޸�ʱ�䣺2017-12-28 14:30:40
  �޸����ݣ���ͬҵ��������ȡupdt_dt�ϴ󣬶���ͬһ���Σ�updt_dt��ͬ����ȡrecord_sid����ļ�¼
  �� �� �ˣ�RayLee
  �޸�ʱ�䣺2018-01-08 16:14:35
  �޸����ݣ��������˺��Ŀͻ���   �����ͻ���ȡcompany_id
            �������˺��Ŀͻ���   �����ͻ���ȡcompany_nm
  �� �� �ˣ�RayLee
  �޸�ʱ�䣺2018-03-20 18:09:00.064000
  �޸����ݣ��޸�seq
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
  V_SRC_CD  TEMP_COMPY_PBCGUAR_CMB.SRC_CD%TYPE := UPPER(TRIM('CMB'));
  V_UPDT_BY TEMP_COMPY_PBCGUAR_CMB.UPDT_BY%TYPE := 0;
  V_ISDEL TEMP_COMPY_PBCGUAR_CMB.ISDEL%TYPE := 0;

  V_EXEC_STEP VARCHAR2(100);

BEGIN

  --��������
  V_TASK_NAME := 'SP_COMPY_PBCGUAR_CMB';

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
  INSERT INTO TEMP_COMPY_PBCGUAR_CMB
    (COMPY_PBCGUAR_SID, --1. ����ҵ����
     MSG_ID, --2. ���ı�ʶ��
     GRTSER_ID, --3. ������ͬ��ˮ��
     GRTBUSSER_ID, --4. ������ҵ����ˮ��
     COMPANY_ID, --5. ��ҵ��ʶ��
     RPT_DT, --6. ��������
     WARRANTEE_ID, --7. �������˺��Ŀͻ���
     WARRANTEE_NM, --8. ������������
     CURRENCY, --9. ��������
     GUAR_AMT, --10.  �������
     GUAR_TYPE_CD, --11.  ������ʽ
     BALANCE, --12.  ������ҵ�����
     END_DT, --13.  ������ҵ����壨���ڣ�����
     FIVE_CLASS_CD, --14.  ������ҵ���弶����
     WARRANTEE_CURRENCY, --15.  ������ҵ�����
     ISDEL, --16.  �Ƿ�ɾ��
     SRC_COMPANY_CD, --17.  Դ��ҵ����
     SRC_CD, --18.  Դϵͳ
     UPDT_BY, --19.  ������
     UPDT_DT, --20.  ����ʱ��
     RNK ,--13.  ��¼����
     RECORD_SID,  --14.��ˮ��
     LOADLOG_SID  --15.��־��

     )
    SELECT SEQ_COMPY_PBCGUAR_CMB.NEXTVAL AS COMPY_PBCGUAR_SID, --1. ����ҵ����
           T.MSG_ID AS MSG_ID, --2. ���ı�ʶ��
           T.GRTSER_ID AS GRTSER_ID, --3. ������ͬ��ˮ��
           T.GRTBUSSER_ID AS GRTBUSSER_ID, --4. ������ҵ����ˮ��
           T.CUST_NO AS COMPANY_ID, --5. ��ҵ��ʶ��
           --TO_DATE(T.RPT_DT, 'YYYY-MM-DD') AS RPT_DT, --6. ��������
           F_STR_TO_DATE(T.RPT_DT) AS RPT_DT, --6. ��������
           --T.WARRANTEE_CUST_NO AS WARRANTEE_ID, --7. �������˺��Ŀͻ���
           T2.COMPANY_ID AS WARRANTEE_ID, --7. �������˺��Ŀͻ���
           --T.WARRANTEE_CUST_NO AS WARRANTEE_NM, --8. ������������
           T2.CUSTOMER_NM AS WARRANTEE_NM, --8. ������������
           T.CURRENCY AS CURRENCY, --9. ��������
           T.GUAR_AMT AS GUAR_AMT, --10.  �������
           T.GUAR_TYPE AS GUAR_TYPE_CD, --11.  ������ʽ
           T.BALANCE AS BALANCE, --12.  ������ҵ�����
           --TO_DATE(T.END_DT, 'YYYY-MM-DD') AS END_DT, --13.  ������ҵ����壨���ڣ�����
           F_STR_TO_DATE(T.END_DT) AS END_DT, --13.  ������ҵ����壨���ڣ�����
           T.FIVE_CLASS AS FIVE_CLASS_CD, --14.  ������ҵ���弶����
           T.WARRANTEE_CURRENCY AS WARRANTEE_CURRENCY, --15.  ������ҵ�����
           V_ISDEL AS ISDEL, --16.  �Ƿ�ɾ��
           T.CUST_NO AS SRC_COMPANY_CD, --17.  Դ��ҵ����
           V_SRC_CD AS SRC_CD, --18.  Դϵͳ
           V_UPDT_BY AS UPDT_BY, --19.  ������
           SYSTIMESTAMP AS UPDT_DT, --20.  ����ʱ��
           ROW_NUMBER() OVER(PARTITION BY T.MSG_ID, T.GRTSER_ID, T.GRTBUSSER_ID ORDER BY T.UPDT_DT DESC,T.RECORD_SID DESC) AS RNK, --13.  ��¼����
           T.RECORD_SID AS RECORD_SID,  --14.��ˮ��
           T.LOADLOG_SID AS LOADLOG_SID  --15.��־��
      FROM CMAP_SYNC.STG_CMB_COMPY_PBCGUAR T
      LEFT JOIN CUSTOMER_CMB T1
        ON T1.CUST_NO = T.CUST_NO
      LEFT JOIN CUSTOMER_CMB T2
        ON T2.CUST_NO = T.WARRANTEE_CUST_NO
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
    FROM TEMP_COMPY_PBCGUAR_CMB;

  --ɾ���Ѿ����ڵ���������
  V_EXEC_STEP := 'STEP4 ɾ���Ѿ����ڵ���������';

  DELETE FROM COMPY_PBCGUAR_CMB A
   WHERE EXISTS (SELECT 1
            FROM TEMP_COMPY_PBCGUAR_CMB B
           WHERE A.MSG_ID = B.MSG_ID
             AND A.GRTSER_ID = B.GRTSER_ID
             AND A.GRTBUSSER_ID = B.GRTBUSSER_ID);

  V_EXEC_STEP := 'STEP5 �������ݵ�Ŀ���';
  INSERT INTO COMPY_PBCGUAR_CMB
    (COMPY_PBCGUAR_SID, --1. ����ҵ����
     MSG_ID, --2. ���ı�ʶ��
     GRTSER_ID, --3. ������ͬ��ˮ��
     GRTBUSSER_ID, --4. ������ҵ����ˮ��
     COMPANY_ID, --5. ��ҵ��ʶ��
     RPT_DT, --6. ��������
     WARRANTEE_ID, --7. �������˺��Ŀͻ���
     WARRANTEE_NM, --8. ������������
     CURRENCY, --9. ��������
     GUAR_AMT, --10.  �������
     GUAR_TYPE_CD, --11.  ������ʽ
     BALANCE, --12.  ������ҵ�����
     END_DT, --13.  ������ҵ����壨���ڣ�����
     FIVE_CLASS_CD, --14.  ������ҵ���弶����
     WARRANTEE_CURRENCY, --15.  ������ҵ�����
     ISDEL, --16.  �Ƿ�ɾ��
     SRC_COMPANY_CD, --17.  Դ��ҵ����
     SRC_CD, --18.  Դϵͳ
     UPDT_BY, --19.  ������
     UPDT_DT --20.  ����ʱ��

     )
    SELECT COMPY_PBCGUAR_SID, --1. ����ҵ����
           MSG_ID, --2. ���ı�ʶ��
           GRTSER_ID, --3. ������ͬ��ˮ��
           GRTBUSSER_ID, --4. ������ҵ����ˮ��
           COMPANY_ID, --5. ��ҵ��ʶ��
           RPT_DT, --6. ��������
           WARRANTEE_ID, --7. �������˺��Ŀͻ���
           WARRANTEE_NM, --8. ������������
           CURRENCY, --9. ��������
           GUAR_AMT, --10.  �������
           GUAR_TYPE_CD, --11.  ������ʽ
           BALANCE, --12.  ������ҵ�����
           END_DT, --13.  ������ҵ����壨���ڣ�����
           FIVE_CLASS_CD, --14.  ������ҵ���弶����
           WARRANTEE_CURRENCY, --15.  ������ҵ�����
           ISDEL, --16.  �Ƿ�ɾ��
           SRC_COMPANY_CD, --17.  Դ��ҵ����
           SRC_CD, --18.  Դϵͳ
           UPDT_BY, --19.  ������
           UPDT_DT --20.  ����ʱ��
      FROM TEMP_COMPY_PBCGUAR_CMB T
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
     NVL(V_UPDT_COUNT,0),
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

END SP_COMPY_PBCGUAR_CMB;
/
