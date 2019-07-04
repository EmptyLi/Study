create table  if not exists rating_factor
(
  rating_factor_id          bigint default nextval('seq_rating_hist_factor_score' :: regclass) not null
    constraint rating_hist_factor_score_pkey
    primary key,
  rating_record_id          bigint                                                             not null,
  rm_factor_id              bigint                                                             not null,
  -- factor_dt                 date                                                               not null,
  factor_val_revised        numeric(32, 16),
  score                     numeric(20, 16),
  creation_time             timestamp(6),
  factor_val                numeric(32, 16),
  factor_exception_val      numeric(32, 16),
  factor_exception_rule_sid bigint,
  factor_missing_cd         bigint,
  adjustment_comment        varchar(2000)
);

delete from rating_factor where 1 = 1;
insert into rating_factor
(	rating_factor_id
,	rating_record_id
,	rm_factor_id
,	factor_val_revised
,	score
,	creation_time
,	factor_val
,	factor_exception_val
,	factor_exception_rule_sid
,	factor_missing_cd
,	adjustment_comment
)
select 	rating_factor_id
,	rating_record_id
,	rm_factor_id
,	factor_val_revised
,	score
,	creation_time
,	factor_val
,	factor_exception_val
,	factor_exception_rule_sid
,	factor_missing_cd
,	adjustment_comment
 from ray_rating_factor;

-- alter table ray_rating_factor rename to rating_factor;
commit;
