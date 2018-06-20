create table  if not exists bond_rating_factor
(
  bond_rating_factor_sid bigint default nextval('seq_bond_rating_factor' :: regclass) not null
    constraint pk_bond_rating_factor
    primary key,
  bond_rating_record_sid bigint                                                       not null,
  orig_record_sid        bigint,
  factor_cd              varchar(30)                                                  not null,
  factor_nm              varchar(200)                                                 not null,
  factor_type            varchar(60)                                                  not null,
  factor_value           varchar(600)                                                 not null,
  option_num             integer,
  ratio                  numeric(10, 4),
  factor_val_revised   varchar(600),
  option_num_revised     integer,
  ratio_revised          numeric(10, 4),
  adjustment_comment     varchar(600),
  client_id              bigint                                                       not null,
  updt_by                bigint                                                       not null,
  updt_dt                timestamp                                                    not null
);
commit;
-- select setval('seq_bond_rating_factor', max(bond_rating_factor_sid)) from ray_bond_rating_factor;
