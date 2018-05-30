CREATE OR REPLACE PROCEDURE sp_compy_creditrating_cmb IS
  /************************************************
  �洢���̣�sp_compy_creditrating_cmb
  ����ʱ�䣺2017/11/10
  �� �� �ˣ�ZhangCong
  Դ    ��stg_cmb_compy_creditrating(��������)
  �� �� ��temp_compy_creditrating_cmb
  Ŀ �� ��compy_creditrating_cmb(��������)
  ��    �ܣ�����ͬ��stg�µ������������ݵ�tgt��
  �޸ļ�¼��2017/12/25 zhangcong ������SP�������²����߼�
  -------------------------------------------------------
  �� �� �ˣ�RayLee
  �޸�ʱ�䣺2018-04-13 10:20:11.877052
  �޸����ݣ������ֶ����f_str_to_date���ӽ�׳��

  *************************************************/

  --------------------------------������־����-----------------------------
  v_error_cd          VARCHAR2(100);
  v_error_message     VARCHAR2(1000);
  v_task_name         etl_tgt_loadlog.process_nm%TYPE; --��������
  v_updt_dt           etl_tgt_loadlog.end_dt%TYPE; --�ϴ�ͬ������ʱ��
  v_start_dt          etl_tgt_loadlog.start_dt%TYPE; --��ʼʱ��
  v_end_dt            etl_tgt_loadlog.end_dt%TYPE; --����ʱ��
  v_start_rowid       etl_tgt_loadlog.start_rowid%TYPE; --��ʼ�к�
  v_end_rowid         etl_tgt_loadlog.end_rowid%TYPE; --��ֹ�к�
  v_insert_count      etl_tgt_loadlog.insert_count%TYPE; --�����¼��
  v_updt_count        etl_tgt_loadlog.updt_count%TYPE; --���¼�¼��
  v_orig_record_count etl_tgt_loadlog.orig_record_count%TYPE; --ԭʼ�ļ�¼��
  v_dup_record_count  etl_tgt_loadlog.dup_record_count%TYPE; --�ظ��ļ�¼��
  v_batch_sid         etl_tgt_loadlog.batch_sid%TYPE := 0; --���κ�

  --------------------------------����ҵ�����------------------------------
  v_updt_by compy_creditapply_cmb.updt_by%TYPE := 0; --������
  v_isdel   compy_creditapply_cmb.isdel%TYPE := 0; --�Ƿ�ɾ��
  v_src_cd  compy_creditapply_cmb.src_cd%TYPE := 'CMB'; --Դϵͳ

BEGIN

  --��������
  v_task_name := 'SP_COMPY_CREDITRATING_CMB';

  --��ȡ�ϴ�ͬ�����ݵ�ʱ��
  SELECT nvl(MAX(end_dt), to_date('1900-1-1', 'yyyy-mm-dd'))
    INTO v_updt_dt
    FROM etl_tgt_loadlog
   WHERE process_nm = v_task_name;

  --��ʼʱ��
  v_start_dt := SYSTIMESTAMP;

  --��ȡ�����������ݲ��뵽��ʱ��
  INSERT INTO temp_compy_creditrating_cmb
    (rating_no,
     company_id,
     auto_rating,
     final_rating,
     rating_period,
     rating_start_dt,
     effect_end_dt,
     autorating_avgpd,
     finalrating_avgpd,
     adjust_reasontype_cd,
     adjust_reason,
     isdel,
     src_company_cd,
     src_cd,
     updt_by,
     updt_dt,
     rnk,
     record_sid,
     loadlog_sid)
    SELECT substr(a.rating_no, 1, 30) AS rating_no,
           b.company_id,
           a.auto_rating,
           a.final_rating,
           --to_date(a.rating_period, 'yyyy/mm') AS rating_period,
           F_STR_TO_DATE(a.rating_period) AS rating_period,
           --to_timestamp(a.rating_start_dt, 'yyyy-mm-dd hh24:mi:ss.FF6') AS rating_start_dt,
           F_STR_TO_DATE(a.rating_start_dt) AS rating_start_dt,
           --to_timestamp(a.effect_end_dt, 'yyyy-mm-dd hh24:mi:ss.FF6') AS rating_start_dt,
           F_STR_TO_DATE(a.effect_end_dt) AS effect_end_dt,
           CAST(a.autorating_avgpd AS NUMBER(24, 4)) AS autorating_avgpd,
           CAST(a.finalrating_avgpd AS NUMBER(24, 4)) AS finalrating_avgpd,
           a.adjust_reasontype_cd,
           a.adjust_reason,
           v_isdel AS isdel,
           a.cust_no AS src_company_cd,
           v_src_cd AS src_cd,
           v_updt_by AS updt_by,
           systimestamp AS updt_dt,
           row_number() over(PARTITION BY a.rating_no ORDER BY a.updt_dt DESC,a.record_sid DESC) rnk, --ȥ��
           a.record_sid,
           a.loadlog_sid
      FROM cmap_sync.stg_cmb_compy_creditrating a
      JOIN customer_cmb b
        ON (a.cust_no = b.cust_no AND b.company_id IS NOT NULL)
     WHERE a.updt_dt > v_updt_dt;

  --����ʱ��
  v_end_dt := SYSTIMESTAMP;

  --��ȡ��־����
  SELECT COUNT(1) AS orig_record_count, --ԭʼ�ļ�¼��
         nvl(SUM(CASE
                   WHEN rnk > 1 THEN
                    1
                   ELSE
                    0
                 END),
             0) AS dup_record_count, --�ظ��ļ�¼��
         MIN(record_sid) AS start_rowid, --��ʼ�к�
         MAX(record_sid) AS end_rowid --��ֹ�к�
    INTO v_orig_record_count, v_dup_record_count, v_start_rowid, v_end_rowid
    FROM temp_compy_creditrating_cmb;

  --ɾ�������µ�����
  DELETE FROM compy_creditrating_cmb a
   WHERE EXISTS
   (SELECT 1 FROM temp_compy_creditrating_cmb cdm WHERE a.rating_no = cdm.rating_no);

  v_updt_count := SQL%ROWCOUNT;

  --������������
  INSERT INTO compy_creditrating_cmb
    (rating_no,
     company_id,
     auto_rating,
     final_rating,
     rating_period,
     rating_start_dt,
     effect_end_dt,
     autorating_avgpd,
     finalrating_avgpd,
     adjust_reasontype_cd,
     adjust_reason,
     isdel,
     src_company_cd,
     src_cd,
     updt_by,
     updt_dt)
    SELECT a.rating_no,
           a.company_id,
           a.auto_rating,
           a.final_rating,
           a.rating_period,
           a.rating_start_dt,
           a.effect_end_dt,
           a.autorating_avgpd,
           a.finalrating_avgpd,
           a.adjust_reasontype_cd,
           a.adjust_reason,
           a.isdel,
           a.src_company_cd,
           a.src_cd,
           a.updt_by,
           a.updt_dt
      FROM temp_compy_creditrating_cmb a
     WHERE a.company_id IS NOT NULL
       AND a.rnk = 1;

  v_insert_count := SQL%ROWCOUNT - v_updt_count;

  COMMIT;

  --�������ݵ�LOG����

  INSERT INTO etl_tgt_loadlog
    (loadlog_sid,
     batch_sid,
     process_nm,
     orig_record_count,
     dup_record_count,
     insert_count,
     updt_count,
     start_dt,
     end_dt,
     start_rowid,
     end_rowid)
    SELECT seq_etl_tgt_loadlog.nextval,
           v_batch_sid,
           v_task_name,
           v_orig_record_count,
           v_dup_record_count,
           v_insert_count,
           v_updt_count,
           v_start_dt,
           v_end_dt,
           v_start_rowid,
           v_end_rowid
      FROM dual;

  COMMIT;

  --������
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    v_error_cd      := SQLCODE;
    v_error_message := substr(SQLERRM, 1, 1000);
    dbms_output.put_line('failed! ERROR:' || v_error_cd || ' ,' || v_error_message);
    raise_application_error(-20021, v_error_message);
    RETURN;

    COMMIT;

END sp_compy_creditrating_cmb;
/
