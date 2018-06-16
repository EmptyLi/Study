delete from bond_rating_factor where 1 = 1;
   commit;
insert into bond_rating_factor
  ( bond_rating_factor_sid
,bond_rating_record_sid
,orig_record_sid
,factor_cd
,factor_nm
,factor_type
,factor_value
,option_num
,ratio
,factor_val_revised
,option_num_revised
,ratio_revised
,adjustment_comment
,client_id
,updt_by
,updt_dt   )
    select
bond_rating_factor_sid
      ,bond_rating_record_sid
,0 orig_record_sid
,factor_cd
,factor_nm
,factor_type
,factor_value
,option_num
,ratio
,null as factor_val_revised
,null as option_num_revised
,null as ratio_revised
,null as adjustment_comment
,client_id
,updt_by
,updt_dt
from ray_bond_rating_factor;
commit;

select setval('seq_bond_rating_factor',case when max(bond_rating_factor_sid :: bigint) > max(start_value :: bigint)
  then max(bond_rating_factor_sid :: bigint)
       else max(start_value :: bigint) end)
from ray_bond_rating_factor
  inner join information_schema.sequences on sequence_schema = 'public' and sequence_name = 'seq_bond_rating_factor';
