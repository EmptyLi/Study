create table if not exists bond_pledge
(
  bond_pledge_sid   bigint default nextval('seq_bond_pledge' :: regclass) not null
    constraint pk_bond_pledge
    primary key,
  secinner_id       bigint                                                not null,
  rpt_dt            date                                                  not null,
  notice_dt         date,
  pledge_nm         varchar(300)                                          not null,
  pledge_type_id    bigint,
  pledge_desc       varchar(2000),
  pledge_owner_id   bigint,
  pledge_owner      varchar(300),
  pledge_value      numeric(20, 4),
  priority_value    numeric(20, 4),
  pledge_depend_id  bigint,
  pledge_control_id bigint,
  region            integer,
  mitigation_value  numeric(20, 4),
  isdel             integer                                               not null,
  srcid             varchar(100),
  src_cd            varchar(10)                                           not null,
  updt_by           bigint default 0                                      not null,
  updt_dt           timestamp                                             not null
);
commit;
select setval('seq_bond_pledge', max(bond_pledge_sid)) from bond_pledge;
