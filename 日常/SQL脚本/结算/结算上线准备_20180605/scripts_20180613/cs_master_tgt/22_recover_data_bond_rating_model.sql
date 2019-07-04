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