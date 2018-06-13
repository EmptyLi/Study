delete from lkp_ratingcd_xw where model_id = 1 and constant_type <> 5;
commit;
insert into lkp_ratingcd_xw
(
	model_id,
	constant_nm,
	ratingcd_nm,
	constant_type,
	updt_by,
	updt_dt
)
select 1 as model_id,
	constant_nm,
	ratingcd_nm,
	constant_type,
	1 as updt_by,
	updt_dt
from ray_lkp_ratingcd_xw
where constant_type <> 5
;
commit;