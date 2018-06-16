delete from rating_factor where 1= 1;
   commit;
insert into rating_factor
(
rating_factor_id
,rating_record_id
,rm_factor_id
,factor_dt
,factor_val_revised
,score
,creation_time
,factor_val
,factor_exception_val
,factor_exception_rule_sid
,factor_missing_cd
,adjustment_comment
)
    select
a.rating_factor_id
,a.rating_record_id
,rm_factor_id
,b.factor_dt as  factor_dt
,factor_val_revised
,score
,creation_time
,factor_val
,factor_exception_val
,factor_exception_rule_sid
,factor_missing_cd
,a.adjustment_comment
from ray_rating_factor a
    inner join rating_record b
  on a.rating_record_id = b.rating_record_id;
commit;


select setval('seq_rating_hist_factor_score',case when max(rating_factor_id :: bigint) > max(start_value :: bigint)
  then max(rating_factor_id :: bigint)
       else max(start_value :: bigint) end)
from ray_rating_factor
  inner join information_schema.sequences on sequence_schema = 'public' and sequence_name = 'seq_rating_hist_factor_score';
