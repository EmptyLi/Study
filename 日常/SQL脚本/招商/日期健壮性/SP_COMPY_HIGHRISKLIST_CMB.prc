CREATE OR REPLACE PROCEDURE SP_COMPY_HIGHRISKLIST_CMB IS
  /*
  �洢���̣�SP_COMPY_HIGHRISKLIST_CMB
  ��    �ܣ�����-�߷���������-������STG->TEMP->TGT��
            ��������ˮ��
            (�ͻ�+��Դ+�ͻ�����+�Ƿ���Ч)
  �� �� �ˣ�RayLee
  ����ʱ�䣺2017/11/9 10:25:27
  Դ    ��CMAP_SYNC.STG_CMB_COMPY_HIGHRISKLIST
  �� �� ��TEMP_CMB_COMPY_HIGHRISKLIST
  Ŀ �� ��COMPY_HIGHRISKLIST_CMB
  --------------------------------------------------------------------
  �� �� �ˣ�RayLee
  �޸�ʱ�䣺2017-12-28 14:28:06
  �޸����ݣ���ͬҵ��������ȡupdt_dt�ϴ󣬶���ͬһ���Σ�updt_dt��ͬ����ȡrecord_sid����ļ�¼
  �� �� �ˣ�RayLee
  �޸�ʱ�䣺2017-12-28 15:13:46
  �޸����ݣ��޸� ҵ������ȥ������blacklist_type_cd�ֶ�
  -------------------------------------------------------
  �� �� �ˣ�RayLee
  �޸�ʱ�䣺2018-04-13 10:20:11.877052
  �޸����ݣ������ֶ���� f_str_to_date ���ӽ�׳��
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
  V_SRC_CD  TEMP_COMPY_HIGHRISKLIST_CMB.SRC_CD%TYPE := UPPER(TRIM('CMB'));
  V_UPDT_BY TEMP_COMPY_HIGHRISKLIST_CMB.UPDT_BY%TYPE := 0;
  V_ISDEL TEMP_COMPY_HIGHRISKLIST_CMB.ISDEL%TYPE := 0;

  V_EXEC_STEP VARCHAR2(100);

BEGIN

  --��������
  V_TASK_NAME := 'SP_COMPY_HIGHRISKLIST_CMB';

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
  INSERT INTO TEMP_COMPY_HIGHRISKLIST_CMB
    (HISHGRISKLIST_ID, --1. ��ˮ��
     COMPANY_ID, --2. ��ҵ��ʶ��
     LIST_TYPE_CD, --3. ��������
     BLACKLIST_SRCCD, --4. ��������Դ
     BLACKLIST_TYPE_CD, --5. �������ͻ�����
     EFF_DT, --6. ��Ч����
     CONFIRM_REASON, --7. �϶�ԭ��
     CTL_MEASURE, --8. �ܿش�ʩ
     EFF_FLAG, --9. �Ƿ���Ч
     ISDEL, --10.  �Ƿ�ɾ��
     SRC_COMPANY_CD, --11.  Դ��ҵ����
     SRC_CD, --12.  Դϵͳ
     UPDT_BY, --13.  ������
     UPDT_DT, --14.  ����ʱ��
     RNK ,--15.  ��¼����
     RECORD_SID,  --16.��ˮ��
     LOADLOG_SID  --17.��־��

     )
    SELECT T.HISHGRISKLIST_ID AS HISHGRISKLIST_ID, --1. ��ˮ��
           T1.COMPANY_ID AS COMPANY_ID, --2. ��ҵ��ʶ��
           T.LIST_TYPE_CD AS LIST_TYPE_CD, --3. ��������
           T.BLACKLIST_SRCCD AS BLACKLIST_SRCCD, --4. ��������Դ
           T.BLACKLIST_TYPE_CD AS BLACKLIST_TYPE_CD, --5. �������ͻ�����
           --TO_DATE(T.EFF_DT, 'YYYY-MM-DD') AS EFF_DT, --6. ��Ч����
           f_str_to_date(T.EFF_DT) AS EFF_DT, --6. ��Ч����
           T.CONFIRM_REASON AS CONFIRM_REASON, --7. �϶�ԭ��
           T.CTL_MEASURE AS CTL_MEASURE, --8. �ܿش�ʩ
           T.EFF_FLAG AS EFF_FLAG, --9. �Ƿ���Ч
           V_ISDEL AS ISDEL, --10.  �Ƿ�ɾ��
           T.CUST_NO AS SRC_COMPANY_CD, --11.  Դ��ҵ����
           V_SRC_CD AS SRC_CD, --12.  Դϵͳ
           V_UPDT_BY AS UPDT_BY, --13.  ������
           SYSTIMESTAMP AS UPDT_DT, --14.  ����ʱ��
           ROW_NUMBER() OVER(PARTITION BY T.CUST_NO, T.BLACKLIST_SRCCD, T.EFF_FLAG, T.BLACKLIST_TYPE_CD ORDER BY T.UPDT_DT DESC, T.RECORD_SID DESC) RNK, --15.  ��¼����
           T.RECORD_SID AS RECORD_SID,  --16.��ˮ��
           T.LOADLOG_SID AS LOADLOG_SID  --17.��־��
      FROM CMAP_SYNC.STG_CMB_COMPY_HIGHRISKLIST T
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
    FROM TEMP_COMPY_HIGHRISKLIST_CMB;

  --ɾ���Ѿ����ڵ���������
  V_EXEC_STEP := 'STEP4 ɾ���Ѿ����ڵ���������';

  DELETE FROM COMPY_HIGHRISKLIST_CMB
   WHERE (COMPANY_ID, BLACKLIST_SRCCD, EFF_FLAG, BLACKLIST_TYPE_CD) IN
         (SELECT COMPANY_ID, BLACKLIST_SRCCD, EFF_FLAG, BLACKLIST_TYPE_CD
            FROM TEMP_COMPY_HIGHRISKLIST_CMB);

  V_EXEC_STEP := 'STEP5 �������ݵ�Ŀ���';
  INSERT INTO COMPY_HIGHRISKLIST_CMB
    (HISHGRISKLIST_ID, --1. ��ˮ��
     COMPANY_ID, --2. ��ҵ��ʶ��
     LIST_TYPE_CD, --3. ��������
     BLACKLIST_SRCCD, --4. ��������Դ
     BLACKLIST_TYPE_CD, --5. �������ͻ�����
     EFF_DT, --6. ��Ч����
     CONFIRM_REASON, --7. �϶�ԭ��
     CTL_MEASURE, --8. �ܿش�ʩ
     EFF_FLAG, --9. �Ƿ���Ч
     ISDEL, --10.  �Ƿ�ɾ��
     SRC_COMPANY_CD, --11.  Դ��ҵ����
     SRC_CD, --12.  Դϵͳ
     UPDT_BY, --13.  ������
     UPDT_DT --14.  ����ʱ��
     )
    SELECT HISHGRISKLIST_ID, --1. ��ˮ��
           COMPANY_ID, --2. ��ҵ��ʶ��
           LIST_TYPE_CD, --3. ��������
           BLACKLIST_SRCCD, --4. ��������Դ
           BLACKLIST_TYPE_CD, --5. �������ͻ�����
           EFF_DT, --6. ��Ч����
           CONFIRM_REASON, --7. �϶�ԭ��
           CTL_MEASURE, --8. �ܿش�ʩ
           EFF_FLAG, --9. �Ƿ���Ч
           ISDEL, --10.  �Ƿ�ɾ��
           SRC_COMPANY_CD, --11.  Դ��ҵ����
           SRC_CD, --12.  Դϵͳ
           UPDT_BY, --13.  ������
           UPDT_DT --14.  ����ʱ��
      FROM TEMP_COMPY_HIGHRISKLIST_CMB T
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

END SP_COMPY_HIGHRISKLIST_CMB;
/
