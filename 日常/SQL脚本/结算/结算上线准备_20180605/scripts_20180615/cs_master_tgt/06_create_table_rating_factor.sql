create table  if not exists rating_factor
(
  rating_factor_id          bigint default nextval('seq_rating_hist_factor_score' :: regclass) not null
    constraint rating_hist_factor_score_pkey
    primary key,
  rating_record_id          bigint                                                             not null,
  rm_factor_id              bigint                                                             not null,
  factor_dt                 date                                                               not null,
  factor_val_revised        numeric(32, 16),
  score                     numeric(20, 16),
  creation_time             timestamp(6),
  factor_val                numeric(32, 16),
  factor_exception_val      numeric(32, 16),
  factor_exception_rule_sid bigint,
  factor_missing_cd         bigint,
  adjustment_comment        varchar(2000)
);
commit;
-- select setval('seq_rating_hist_factor_score', max(rating_factor_id)) from ray_rating_factor;
