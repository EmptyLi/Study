CREATE OR REPLACE PROCEDURE sp_compy_limit_cmb IS
  /************************************************
  存储过程：sp_compy_limit_cmb
  创建时间：2017/11/10
  创 建 人：ZhangCong
  源    表：stg_cmb_compy_limit(总控限额)
  中 间 表：temp_compy_limit_cmb
  目 标 表：compy_limit_cmb(总控限额)
  功    能：增量同步stg下的总控限额数据到tgt表
  修改记录：2017/12/25 zhangcong ：调整SP增量更新插入逻辑
  -------------------------------------------------------
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
  v_task_name := 'SP_COMPY_LIMIT_CMB';

  --获取上次同步数据的时间
  SELECT nvl(MAX(end_dt), to_date('1900-1-1', 'yyyy-mm-dd'))
    INTO v_updt_dt
    FROM etl_tgt_loadlog
   WHERE process_nm = v_task_name;

  --开始时间
  v_start_dt := SYSTIMESTAMP;

  --获取本次增量数据插入到临时表
  INSERT INTO temp_compy_limit_cmb
    (company_id,
     limit_type_cd,
     limit_status_cd,
     is_frozen,
     org_id,
     org_nm,
     currency,
     apply_limit,
     apply_valid_months,
     apply_detail,
     cust_limit,
     limit_usageratio,
     limit_used,
     limit_notused,
     limit_tmpover_amt,
     limit_tmpover_dt,
     eff_dt,
     due_dt,
     isdel,
     src_company_cd,
     src_cd,
     updt_by,
     updt_dt,
     rnk,
     record_sid,
     loadlog_sid)
    SELECT b.company_id,
           a.limit_type_cd,
           a.limit_status_cd,
           to_number(a.is_frozen) AS is_frozen,
           to_number(a.org_id) AS org_id,
           a.org_nm,
           a.currency,
           CAST(a.apply_limit AS NUMBER(24, 4)) AS apply_limit,
           to_number(a.apply_valid_months) AS apply_valid_months,
           a.apply_detail,
           CAST(a.cust_limit AS NUMBER(24, 4)) AS cust_limit,
           CAST(a.limit_usageratio AS NUMBER(24, 4)) AS limit_usageratio,
           CAST(a.limit_used AS NUMBER(24, 4)) AS limit_used,
           CAST(a.limit_notused AS NUMBER(24, 4)) AS limit_notused,
           CAST(a.limit_tmpover_amt AS NUMBER(24, 4)) AS limit_tmpover_amt,
           to_date(a.limit_tmpover_dt, 'yyyy-mm-dd hh24:mi;ss') AS limit_tmpover_dt,
           --to_date(a.eff_dt, 'yyyy-mm-dd hh24:mi;ss') AS eff_dt,
           --to_date(a.due_dt, 'yyyy-mm-dd hh24:mi;ss') AS due_dt,
           f_str_to_date(a.eff_dt) AS eff_dt,
           f_str_to_date(a.due_dt) AS due_dt,
           v_isdel AS isdel,
           a.cust_no AS src_company_cd,
           v_src_cd AS src_cd,
           v_updt_by AS updt_by,
           systimestamp AS updt_dt,
           row_number() over(PARTITION BY a.cust_no, a.limit_type_cd ORDER BY a.updt_dt DESC, a.record_sid DESC) rnk, --去重
           a.record_sid,
           a.loadlog_sid
      FROM cmap_sync.stg_cmb_compy_limit a
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
    FROM temp_compy_limit_cmb;

  --删除待更新的数据
  DELETE FROM compy_limit_cmb a
   WHERE EXISTS (SELECT 1
            FROM temp_compy_limit_cmb cdm
           WHERE a.company_id = cdm.company_id
             AND a.limit_type_cd = cdm.limit_type_cd);

  v_updt_count := SQL%ROWCOUNT;

  --插入增量数据
  INSERT INTO compy_limit_cmb
    (compy_limit_sid,
     company_id,
     limit_type_cd,
     limit_status_cd,
     is_frozen,
     org_id,
     org_nm,
     currency,
     apply_limit,
     apply_valid_months,
     apply_detail,
     cust_limit,
     limit_usageratio,
     limit_used,
     limit_notused,
     limit_tmpover_amt,
     limit_tmpover_dt,
     eff_dt,
     due_dt,
     isdel,
     src_company_cd,
     src_cd,
     updt_by,
     updt_dt)
    SELECT seq_compy_limit_cmb.nextval,
           a.company_id,
           a.limit_type_cd,
           a.limit_status_cd,
           a.is_frozen,
           a.org_id,
           a.org_nm,
           a.currency,
           a.apply_limit,
           a.apply_valid_months,
           a.apply_detail,
           a.cust_limit,
           a.limit_usageratio,
           a.limit_used,
           a.limit_notused,
           a.limit_tmpover_amt,
           a.limit_tmpover_dt,
           a.eff_dt,
           a.due_dt,
           a.isdel,
           a.src_company_cd,
           a.src_cd,
           a.updt_by,
           a.updt_dt
      FROM temp_compy_limit_cmb a
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

END sp_compy_limit_cmb;
/
