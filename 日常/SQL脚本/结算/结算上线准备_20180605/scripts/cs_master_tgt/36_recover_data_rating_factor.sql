delete from rating_factor where 1= 1;
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