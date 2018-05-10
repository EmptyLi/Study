CREATE PROCEDURE                  "SP_TGT_BOND_PLEDGE"
IS
  v_count pls_integer;
  v_upd_count  pls_integer;
   v_load_count  pls_integer;
      v_todo_load_count  pls_integer;
   exists_completed_process exception;
  v_etl_process_log_rec etl_process_log%rowtype;
  v_error_cd varchar2(100);
  v_error_message varchar2(1000);
 v1_sql varchar2(2000);
  v2_sql varchar2(2000);
    v3_sql varchar2(2000);
begin

DBMS_OUTPUT.ENABLE(buffer_size => null);
  --记录开始时间
  v_etl_process_log_rec.start_dt := sysdate;
    --查出当前运行的batch_sid
  select nvl(max(batch_sid), -1) into v_etl_process_log_rec.batch_sid from etl_dm_job_batch where batch_status = 0;
  --如果当前batch已经存在运行过的本sp，则抛出错误，停止本sp
/*   select count(*) into v_count from etl_process_log where process_nm='SP_TGT_BOND_PLEDGE' and batch_sid = v_etl_process_log_rec.batch_sid;
   if (v_count > 0)
   then
    raise exists_completed_process;
   end if;*/

---删除已经存在的记录
v1_sql:='delete from bond_pledge a where exists (select 1 from stg_bond_pledge t  join
   (select a.secinner_id, a.security_cd||c.market_abbr as security_cd from  (select distinct secinner_id,SECURITY_CD,trade_market_id from bond_basicinfo) a join LKP_CHARCODE b on a.trade_market_id=b.constant_id and b.constant_type=206
       join LKP_MARKET_ABBR c on b.constant_cd=c.market_cd) bb on upper(bb.security_cd)=upper(t.security_cd)
where  bb.SECINNER_ID=a.SECINNER_ID and a.isdel=0)';
execute IMMEDIATE v1_sql ;
v_upd_count := sql%rowcount;
  dbms_output.put_line('bond_pledge删除且需要更新的数据量：'||v_upd_count);

  --匹配通过的记录插入到tgt表中
 v2_sql:='insert into bond_pledge
  (
        bond_pledge_sid ,
        secinner_id ,
        notice_dt ,
        pledge_nm ,
        pledge_type_id ,
        pledge_desc ,
        pledge_owner_id ,
        pledge_owner ,
        pledge_value ,
        priority_value ,
        pledge_depend_id ,
        pledge_control_id ,
        region ,
        mitigation_value ,
        isdel ,
        srcid ,
        src_cd ,
        updt_by ,
        updt_dt
        )
  select seq_bond_pledge.nextval,
b.secinner_id,
case when a.notice_dt is not null then to_date(to_char(to_number(a.notice_dt)),''yyyymmdd'') else null end as notice_dt ,
a.pledge_nm,
c.constant_id as  pledge_type_id,
null as pledge_desc,
null as pledge_owner_id,
null as pledge_owner,
a.pledge_value,
a.priority_value,
d.constant_id as pledge_depend_id,
e.constant_id as pledge_control_id,
bb.region_cd as region,
null as mitigation_value,
  0 as isdel,
  999999 as srcid,
   ''EXPERT'' as src_cd,
   0 as updt_by,
   systimestamp as updt_dt
  from stg_bond_pledge a
 left  join  lkp_charcode c on  replace(replace( c.constant_nm,''国内'',''''),''主板'','''') =trim(replace(replace(a.pledge_type,''国内'',''''),''主板'','''')) and  c.constant_type = 211
        join  lkp_charcode d on d.constant_nm= trim(a.pledge_depend) and d.constant_type = 213
        join  lkp_charcode e on e.constant_nm=trim(a.pledge_control)  and  e.constant_type = 212
   join  lkp_region bb on bb.region_nm=a.region
   join (select a.secinner_id, a.security_cd||c.market_abbr as security_cd from  (select distinct secinner_id,security_cd,trade_market_id from bond_basicinfo) a join LKP_CHARCODE b on a.trade_market_id=b.constant_id and b.constant_type=206
       join LKP_MARKET_ABBR c on b.constant_cd=c.market_cd
       union all select secinner_id, security_cd from bond_pledge_todo where secinner_id is not null
       )b on upper(b.security_cd)=upper(a.security_cd)
 where a.pledge_nm is not null and trim(translate(a.notice_dt, ''E1234567890.'',''            '')) is null';
execute IMMEDIATE v2_sql ;
 v_load_count := sql%rowcount;
  dbms_output.put_line('bond_pledge表导入数量：'||v_load_count);

--如果债券名称匹配不上的情况，需手工处理重新跑
v3_sql:='insert into  bond_pledge_todo
 (secinner_id ,
security_cd,
notice_dt,
pledge_nm,
pledge_type,
pledge_value,
pledge_depend,
pledge_control,
region,
priority_value,
data_src
 )
  select null as secinner_id ,a.*
  from stg_bond_pledge a
  left join (select a.secinner_id, a.security_cd||c.market_abbr as security_cd from  (select distinct secinner_id,security_cd,trade_market_id from bond_basicinfo) a join LKP_CHARCODE b on a.trade_market_id=b.constant_id and b.constant_type=206
          join LKP_MARKET_ABBR c on b.constant_cd=c.market_cd) bb on upper(bb.security_cd)=upper(a.security_cd)
 where a.pledge_nm is not null and bb.security_cd is null ';
execute IMMEDIATE v3_sql ;
v_todo_load_count  := sql%rowcount;
 dbms_output.put_line('bond_pledge_todo表插入数量：'||v_todo_load_count);

  dbms_output.put_line('开始插入log表!');
  --记录数据加载日志
  v_etl_process_log_rec.log_sid := seq_etl_process_log.nextval;
  v_etl_process_log_rec.batch_sid := v_etl_process_log_rec.batch_sid;
  v_etl_process_log_rec.process_nm := 'SP_TGT_BOND_PLEDGE';
  v_etl_process_log_rec.orig_record_count := 0;
  v_etl_process_log_rec.dup_record_count := 0;
  v_etl_process_log_rec.insert_count := 0;
  v_etl_process_log_rec.updt_count := 0;
  v_etl_process_log_rec.delete_count := 0;
  v_etl_process_log_rec.start_dt := v_etl_process_log_rec.start_dt;
  v_etl_process_log_rec.end_dt := sysdate;
insert into etl_process_log values v_etl_process_log_rec;

exception
  when exists_completed_process then
    rollback;
    v_error_message := 'error: 当前batch已经存在运行过的本sp！';
    raise_application_error(-20010, v_error_message);
    return;
  when others then
    rollback;
    v_error_cd := sqlcode;
    v_error_message := sqlerrm;
    dbms_output.put_line('failed! error:'||v_error_cd||' ,'||v_error_message);
    raise_application_error(-20021,v_error_message);
    return;
end ;

/
