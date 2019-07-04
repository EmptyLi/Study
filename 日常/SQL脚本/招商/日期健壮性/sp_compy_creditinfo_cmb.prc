CREATE OR REPLACE PROCEDURE sp_compy_creditinfo_cmb IS
  /************************************************
  存储过程：sp_compy_creditinfo_cmb
  创建时间：2017/11/10
  创 建 人：ZhangCong
  源    表：stg_cmb_compy_creditinfo(授信情况)
  中 间 表：temp_compy_creditinfo_cmb
  目 标 表：compy_creditinfo_cmb(授信情况)
  功    能：增量同步stg下的授信情况数据到tgt表
  修改记录：2017/12/25 zhangcong ：调整SP增量更新插入逻辑
  -----------------------------------------------------------
  修 改 人：RayLee
  修改时间：2018-04-13 10:20:11.877052
  修改内容：日期字段添加f_str_to_date增加健壮性
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
  v_task_name := 'SP_COMPY_CREDITINFO_CMB';

  --获取上次同步数据的时间
  SELECT nvl(MAX(end_dt), to_date('1900-1-1', 'yyyy-mm-dd'))
    INTO v_updt_dt
    FROM etl_tgt_loadlog
   WHERE process_nm = v_task_name;

  --开始时间
  v_start_dt := SYSTIMESTAMP;

  --获取本次增量数据插入到临时表
  INSERT INTO temp_compy_creditinfo_cmb
    (creditinfo_id,
     company_id,
     exposure_amt,
     nominal_amt,
     exposure_balance,
     exposure_remain,
     start_dt,
     end_dt,
     is_cmbrelatecust,
     creditline_type_cd,
     is_lowrisk,
     use_org_id,
     use_org_nm,
     loan_mode_cd,
     credit_status_cd,
     is_exposure,
     currency,
     total_loan_amt,
     business_balance,
     term_month,
     guaranty_type_cd,
     isdel,
     src_company_cd,
     src_cd,
     updt_by,
     updt_dt,
     rnk,
     record_sid,
     loadlog_sid)
    SELECT a.creditinfo_id,
           b.company_id,
           CAST(a.exposure_amt AS NUMBER(24, 4)) AS exposure_amt,
           CAST(a.nominal_amt AS NUMBER(24, 4)) AS nominal_amt,
           CAST(a.exposure_balance AS NUMBER(24, 4)) AS exposure_balance,
           CAST(a.exposure_remain AS NUMBER(24, 4)) AS exposure_remain,
           --to_date(a.start_dt, 'yyyy-mm-dd hh24:mi;ss') AS start_dt,
           --to_date(a.end_dt, 'yyyy-mm-dd hh24:mi;ss') AS end_dt,
           f_str_to_date(a.start_dt) as start_dt,
           f_str_to_date(a.end_dt) as end_dt,
           to_number(a.is_cmbrelatecust) AS is_cmbrelatecust,
           a.creditline_type_cd,
           to_number(a.is_lowrisk) AS is_lowrisk,
           to_number(a.use_org_id) AS use_org_id,
           a.use_org_nm,
           a.loan_mode_cd,
           a.credit_status_cd,
           to_number(a.is_exposure) AS is_exposure,
           a.currency,
           CAST(a.total_loan_amt AS NUMBER(24, 4)) AS total_loan_amt,
           CAST(a.business_balance AS NUMBER(24, 4)) AS business_balance,
           to_number(a.term_month) AS term_month,
           a.guaranty_type_cd,
           v_isdel AS isdel,
           a.cust_no AS src_company_cd,
           v_src_cd AS src_cd,
           v_updt_by AS updt_by,
           systimestamp AS updt_dt,
           row_number() over(PARTITION BY a.creditinfo_id ORDER BY a.updt_dt DESC, a.record_sid DESC) rnk, --去重
           a.record_sid,
           a.loadlog_sid
      FROM cmap_sync.stg_cmb_compy_creditinfo a
      JOIN customer_cmb b
        ON (a.cust_no = b.cust_no AND b.company_id IS NOT NULL)
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
    FROM temp_compy_creditinfo_cmb;

  --删除待更新的数据
  DELETE FROM compy_creditinfo_cmb a
   WHERE EXISTS (SELECT 1
            FROM temp_compy_creditinfo_cmb cdm
           WHERE a.creditinfo_id = cdm.creditinfo_id);

  v_updt_count := SQL%ROWCOUNT;

  --插入增量数据
  INSERT INTO compy_creditinfo_cmb
    (creditinfo_id,
     company_id,
     exposure_amt,
     nominal_amt,
     exposure_balance,
     exposure_remain,
     start_dt,
     end_dt,
     is_cmbrelatecust,
     creditline_type_cd,
     is_lowrisk,
     use_org_id,
     use_org_nm,
     loan_mode_cd,
     credit_status_cd,
     is_exposure,
     currency,
     total_loan_amt,
     business_balance,
     term_month,
     guaranty_type_cd,
     isdel,
     src_company_cd,
     src_cd,
     updt_by,
     updt_dt)
    SELECT a.creditinfo_id,
           a.company_id,
           a.exposure_amt,
           a.nominal_amt,
           a.exposure_balance,
           a.exposure_remain,
           a.start_dt,
           a.end_dt,
           a.is_cmbrelatecust,
           a.creditline_type_cd,
           a.is_lowrisk,
           a.use_org_id,
           a.use_org_nm,
           a.loan_mode_cd,
           a.credit_status_cd,
           a.is_exposure,
           a.currency,
           a.total_loan_amt,
           a.business_balance,
           a.term_month,
           a.guaranty_type_cd,
           a.isdel,
           a.src_company_cd,
           a.src_cd,
           a.updt_by,
           a.updt_dt
      FROM temp_compy_creditinfo_cmb a
     WHERE a.company_id IS NOT NULL
       AND a.rnk = 1;

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

END sp_compy_creditinfo_cmb;
/
