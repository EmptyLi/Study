create table if not exists compy_bondissuer
(
  company_id            bigint       not null,
  region                integer      not null,
  org_nature_id         bigint,
  actctrl_sharehd_ratio numeric(20, 4),
  org_nature_orig       varchar(4000),
  data_src              varchar(1000),
  isdel                 integer      not null,
  srcid                 varchar(100) not null,
  src_cd                varchar(10)  not null,
  updt_by               integer      not null,
  updt_dt               timestamp    not null
);
commit;
