delete from bond_rating_record where 1 =  1;
   commit;
insert into bond_rating_record
  ( bond_rating_record_sid
,secinner_id
,model_id
,factor_dt
,rating_dt
,rating_type
,raw_lgd_score
,raw_lgd_grade
,adjust_lgd_score
,adjust_lgd_grade
,adjust_lgd_reason
,raw_rating
,adjust_rating
,adjust_rating_reason
,rating_st
,effect_start_dt
,effect_end_dt
,updt_by
,updt_dt        )
    select
bond_rating_record_sid
,secinner_id
,model_id
,factor_dt
,rating_dt
,rating_type
,raw_lgd_score
,raw_lgd_grade
,adjust_lgd_score
,adjust_lgd_grade
,adjust_lgd_reason
,raw_rating
,adjust_rating
,adjust_rating_reason
,rating_st
,null as effect_start_dt
,null as effect_end_dt
,updt_by
,updt_dt
from ray_bond_rating_record;
commit;

select setval('seq_bond_rating_record',case when max(bond_rating_record_sid :: bigint) > nextval('seq_bond_rating_record')
  then max(bond_rating_record_sid :: bigint)
       else nextval('seq_bond_rating_record') end)
from ray_bond_rating_record;

-- select setval('seq_bond_rating_record',case when max(bond_rating_record_sid :: bigint) > max(start_value :: bigint)
--   then max(bond_rating_record_sid :: bigint)
--        else max(start_value :: bigint) end)
-- from ray_bond_rating_record
--   inner join information_schema.sequences on sequence_schema = 'public' and sequence_name = 'seq_bond_rating_record';
