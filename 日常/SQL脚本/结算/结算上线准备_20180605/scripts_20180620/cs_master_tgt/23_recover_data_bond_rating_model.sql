-- is_active 默认为1生效
delete from bond_rating_model where 1 = 1;
commit;
insert into bond_rating_model
(
	model_id,
	model_cd,
	model_nm,
	model_desc,
	formula_ch,
	formula_en,
	version,
	is_active,
	isdel,
	client_id,
	updt_by,
	updt_dt
)
select 	model_id,
	model_cd,
	model_nm,
	model_desc,
	formula_ch,
	formula_en,
	version,
	1 as is_active,
	isdel,
	client_id,
	updt_by,
	updt_dt
from ray_bond_rating_model
;
commit;

select setval('seq_bond_rating_model',case when max(model_id :: bigint) > nextval('seq_bond_rating_model')
  then max(model_id :: bigint)
       else nextval('seq_bond_rating_model') end)
from ray_bond_rating_model;

-- select setval('seq_bond_rating_model',case when max(model_id :: bigint) > max(start_value :: bigint)
--   then max(model_id :: bigint)
--        else max(start_value :: bigint) end)
-- from ray_bond_rating_model
--   inner join information_schema.sequences on sequence_schema = 'public' and sequence_name = 'seq_bond_rating_model';
