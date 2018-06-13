create table if not exists bond_factor_option
(
  bond_factor_option_sid bigint default nextval('seq_bond_factor_option' :: regclass) not null
    constraint pk_bond_factor_option
    primary key,
  factor_cd              varchar(30)                                                  not null,
  model_id               bigint                                                       not null,
  option_type            varchar(300),
  option                 varchar(300),
  option_num             integer                                                      not null,
  ratio                  numeric(10, 4)                                               not null,
  low_bound              numeric(10, 4),
  remark                 varchar(1000),
  isdel                  integer,
  client_id              bigint                                                       not null,
  updt_by                bigint                                                       not null,
  updt_dt                timestamp(6)                                                 not null
);
commit;
