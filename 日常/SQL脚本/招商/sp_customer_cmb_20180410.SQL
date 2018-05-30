CREATE OR REPLACE PROCEDURE sp_customer_cmb IS
  /************************************************
  存储过程：sp_customer_cmb
  创建时间：2017/11/10
  创 建 人：ZhangCong
  源    表：stg_cmb_customer(客户基本资料)
  中 间 表：temp_customer_cmb
  目 标 表：customer_cmb(客户基本资料)
  功    能：增量同步stg下的客户基本资料数据到tgt表
  修改记录：2017/12/25 zhangcong ：调整SP增量更新插入逻辑
  -- modify by raylee  2018-04-10 10:35:19.897000
  -- 将company_id为0的数据处理成NULL

  *************************************************/

  --------------------------------设置日志变量-----------------------------
  v_error_cd          VARCHAR2(100);
  v_error_message     VARCHAR2(1000);
  v_task_name         etl_tgt_loadlog.process_nm%TYPE; --流程名称
  v_updt_dt           etl_tgt_loadlog.end_dt%TYPE; --上次同步数据时间
  v_start_dt          etl_tgt_loadlog.start_dt%TYPE; --开始时间
  v_end_dt            etl_tgt_loadlog.end_dt%TYPE; --结束时间
  v_start_rowid       etl_tgt_loadlog.start_rowid%TYPE; --起始行号
  v_end_rowid         etl_tgt_loadlog.end_rowid%TYPE; --截止行号
  v_insert_count      etl_tgt_loadlog.insert_count%TYPE; --插入记录数
  v_updt_count        etl_tgt_loadlog.updt_count%TYPE; --更新记录数
  v_orig_record_count etl_tgt_loadlog.orig_record_count%TYPE; --原始的记录数
  v_dup_record_count  etl_tgt_loadlog.dup_record_count%TYPE; --重复的记录数
  v_batch_sid         etl_tgt_loadlog.batch_sid%TYPE := 0; --批次号

  --------------------------------设置业务变量------------------------------
  v_updt_by compy_creditapply_cmb.updt_by%TYPE := 0; --更新人
  v_isdel   compy_creditapply_cmb.isdel%TYPE := 0; --是否删除
  v_src_cd  compy_creditapply_cmb.src_cd%TYPE := 'CMB'; --源系统

BEGIN

  --流程名称
  v_task_name := 'SP_CUSTOMER_CMB';

  --获取上次同步数据的时间
  SELECT nvl(MAX(end_dt), to_date('1900-1-1', 'yyyy-mm-dd'))
    INTO v_updt_dt
    FROM etl_tgt_loadlog
   WHERE process_nm = v_task_name;

  --开始时间
  v_start_dt := SYSTIMESTAMP;

  --获取本次增量数据插入到临时表
  INSERT INTO temp_customer_cmb
    (cust_no,
     company_id,
     customer_nm,
     org_num,
     bl_numb,
     risk_status_cd,
     class_grade_cd,
     is_yjhplatform,
     is_loan,
     is_cmbrelatecust,
     customer_grade_cd,
     is_high_risk,
     group_cust_no,
     group_nm,
     group_warnstatus_cd,
     is_guar,
     guargrp_risklevel_cd,
     rating_cd,
     ent_size_cd,
     isdel,
     src_company_cd,
     srcid,
     src_cd,
     updt_by,
     updt_dt,
     rnk,
     record_sid,
     loadlog_sid)
    SELECT a.cust_no,
           -- modify by raylee 2018-04-10 10:35:19.897000
           case when a.company_id = 0 then null else a.company_id end as company_id,
           a.customer_nm,
           a.org_num,
           a.bl_numb,
           a.risk_status_cd,
           a.class_grade_cd,
           to_number(a.is_yjhplatform) AS is_yjhplatform,
           to_number(a.is_loan) AS is_loan,
           to_number(a.is_cmbrelatecust) AS is_cmbrelatecust,
           a.customer_grade_cd,
           to_number(a.is_high_risk) AS is_high_risk,
           a.group_cust_no,
           a.group_nm,
           a.group_warnstatus_cd,
           to_number(a.is_guar) AS is_guar,
           a.guargrp_risklevel_cd,
           a.rating_cd,
           a.ent_size_cd,
           v_isdel AS isdel,
           a.cust_no AS src_company_cd,
           -1 AS srcid,
           v_src_cd AS src_cd,
           v_updt_by AS updt_by,
           systimestamp AS updt_dt,
           row_number() over(PARTITION BY a.cust_no ORDER BY a.updt_dt DESC, a.record_sid DESC) rnk, --去重
           a.record_sid,
           a.loadlog_sid
      FROM cmap_sync.stg_cmb_customer a
     WHERE a.updt_dt > v_updt_dt;

  --结束时间
  v_end_dt := SYSTIMESTAMP;

  --获取日志参数
  SELECT COUNT(1) AS orig_record_count, --原始的记录数
         nvl(SUM(CASE
                   WHEN rnk > 1 THEN
                    1
                   ELSE
                    0
                 END),
             0) AS dup_record_count, --重复的记录数
         MIN(record_sid) AS start_rowid, --起始行号
         MAX(record_sid) AS end_rowid --截止行号
    INTO v_orig_record_count, v_dup_record_count, v_start_rowid, v_end_rowid
    FROM temp_customer_cmb;

  --删除待更新的数据
  DELETE FROM customer_cmb a
   WHERE EXISTS (SELECT 1 FROM temp_customer_cmb cdm WHERE a.cust_no = cdm.cust_no);

  v_updt_count := SQL%ROWCOUNT;

  --插入增量数据
  INSERT INTO customer_cmb
    (cust_no,
     company_id,
     customer_nm,
     org_num,
     bl_numb,
     risk_status_cd,
     class_grade_cd,
     is_yjhplatform,
     is_loan,
     is_cmbrelatecust,
     customer_grade_cd,
     is_high_risk,
     group_cust_no,
     group_nm,
     group_warnstatus_cd,
     is_guar,
     guargrp_risklevel_cd,
     rating_cd,
     ent_size_cd,
     isdel,
     src_company_cd,
     srcid,
     src_cd,
     updt_by,
     updt_dt)
    SELECT cust_no,
           company_id,
           customer_nm,
           org_num,
           bl_numb,
           risk_status_cd,
           class_grade_cd,
           is_yjhplatform,
           is_loan,
           is_cmbrelatecust,
           customer_grade_cd,
           is_high_risk,
           group_cust_no,
           group_nm,
           group_warnstatus_cd,
           is_guar,
           guargrp_risklevel_cd,
           rating_cd,
           ent_size_cd,
           isdel,
           src_company_cd,
           srcid,
           src_cd,
           updt_by,
           updt_dt
      FROM temp_customer_cmb a
     WHERE a.rnk = 1;

  v_insert_count := SQL%ROWCOUNT - v_updt_count;

  COMMIT;

  --插入数据到LOG表中

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

  --报错处理
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    v_error_cd      := SQLCODE;
    v_error_message := substr(SQLERRM, 1, 1000);
    dbms_output.put_line('failed! ERROR:' || v_error_cd || ' ,' || v_error_message);
    raise_application_error(-20021, v_error_message);
    RETURN;

    COMMIT;

END sp_customer_cmb;
