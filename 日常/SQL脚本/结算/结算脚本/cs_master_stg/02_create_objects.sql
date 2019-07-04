CREATE TABLE  if not exists hist_bond_pledge
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
commit;

CREATE TABLE  if not exists stg_bond_pledge
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
commit;
