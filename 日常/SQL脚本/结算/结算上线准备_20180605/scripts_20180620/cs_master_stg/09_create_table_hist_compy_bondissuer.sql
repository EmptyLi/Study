create table if not exists hist_compy_bondissuer
(
  record_sid            bigint,
  company_id            bigint,
  region                integer,
  org_nature_id         bigint,
  actctrl_sharehd_ratio numeric(20, 4),
  org_nature_orig       varchar(4000),
  data_src              varchar(1000),
  isdel                 integer,
  srcid                 varchar(100),
  src_cd                varchar(10),
  updt_by               integer,
  updt_dt               timestamp(6),
  loadlog_sid           bigint
);
commit;
