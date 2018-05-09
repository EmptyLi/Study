select * from pg_tables where tablename like '%bond_pledge%';
create table ray_hist_bond_pledge as select * from hist_bond_pledge;
create table ray_stg_bond_pledge as select * from stg_bond_pledge;

drop table stg_bond_pledge;
drop table hist_bond_pledge;

CREATE TABLE hist_bond_pledge
(
  record_sid        BIGINT,
  bond_pledge_sid   BIGINT,
  secinner_id       BIGINT,
  rpt_dt            date,
  notice_dt         DATE,
  pledge_nm         VARCHAR(300),
  pledge_type_id    BIGINT,
  pledge_desc       VARCHAR(2000),
  pledge_owner_id   BIGINT,
  pledge_owner      VARCHAR(300),
  pledge_value      NUMERIC(20, 4),
  priority_value    NUMERIC(20, 4),
  pledge_depend_id  BIGINT,
  pledge_control_id BIGINT,
  region            INTEGER,
  mitigation_value  NUMERIC(20, 4),
  isdel             INTEGER,
  srcid             VARCHAR(100),
  src_cd            VARCHAR(10),
  updt_by           BIGINT,
  updt_dt           TIMESTAMP,
  loadlog_sid       BIGINT
);


CREATE TABLE stg_bond_pledge
(
  record_sid        BIGINT DEFAULT nextval('seq_stg_bond_pledge' :: REGCLASS),
  bond_pledge_sid   BIGINT,
  secinner_id       BIGINT,
  rpt_dt            date,
  notice_dt         DATE,
  pledge_nm         VARCHAR(300),
  pledge_type_id    BIGINT,
  pledge_desc       VARCHAR(2000),
  pledge_owner_id   BIGINT,
  pledge_owner      VARCHAR(300),
  pledge_value      NUMERIC(20, 4),
  priority_value    NUMERIC(20, 4),
  pledge_depend_id  BIGINT,
  pledge_control_id BIGINT,
  region            INTEGER,
  mitigation_value  NUMERIC(20, 4),
  isdel             INTEGER,
  srcid             VARCHAR(100),
  src_cd            VARCHAR(10),
  updt_by           BIGINT,
  updt_dt           TIMESTAMP,
  loadlog_sid       BIGINT
);

insert into hist_bond_pledge
select
record_sid
,bond_pledge_sid
,secinner_id
,'2016-12-31'::date as rpt_dt
,notice_dt
,pledge_nm
,pledge_type_id
,pledge_desc
,pledge_owner_id
,pledge_owner
,pledge_value
,priority_value
,pledge_depend_id
,pledge_control_id
,region
,mitigation_value
,isdel
,srcid
,src_cd
,updt_by
,updt_dt
,loadlog_sid
from ray_hist_bond_pledge;

insert into stg_bond_pledge
  select
record_sid
,bond_pledge_sid
,secinner_id
,'2016-12-31'::date as rpt_dt
,notice_dt
,pledge_nm
,pledge_type_id
,pledge_desc
,pledge_owner_id
,pledge_owner
,pledge_value
,priority_value
,pledge_depend_id
,pledge_control_id
,region
,mitigation_value
,isdel
,srcid
,src_cd
,updt_by
,updt_dt
,loadlog_sid
from ray_stg_bond_pledge;
commit;

select * from stg_bond_pledge;
select * from ray_stg_bond_pledge;
select * from hist_bond_pledge;
select * from ray_hist_bond_pledge;
