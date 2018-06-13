delete from bond_warrantor where 1 = 1;
commit;
insert into bond_warrantor
(bond_warrantor_sid,
	secinner_id,
	rpt_dt,
	notice_dt,
	warranty_rate,
	guarantee_type_id,
	warranty_period,
	warrantor_id,
	warrantor_nm,
	warrantor_type_id,
	start_dt,
	end_dt,
	warranty_amt,
	warrantor_resume,
	warranty_contract,
	warranty_benef,
	warranty_content,
	warranty_type_id,
	warranty_claim,
	warranty_strength_id,
	pay_step,
	warranty_fee,
	exempt_set,
	warranty_obj,
	isser_credit,
	src_updt_dt,
	mitigation_value,
	isdel,
	srcid,
	src_cd,
	updt_by,
	updt_dt)
    select
bond_warrantor_sid,
	secinner_id,
	'2016-12-31'::date as rpt_dt,
	notice_dt,
	warranty_rate,
	guarantee_type_id,
	warranty_period,
	warrantor_id,
	warrantor_nm,
	warrantor_type_id,
	start_dt,
	end_dt,
	warranty_amt,
	warrantor_resume,
	warranty_contract,
	warranty_benef,
	warranty_content,
	warranty_type_id,
	warranty_claim,
	warranty_strength_id,
	pay_step,
	warranty_fee,
	exempt_set,
	warranty_obj,
	isser_credit,
	src_updt_dt,
	mitigation_value,
	isdel,
	srcid,
	src_cd,
	updt_by,
	updt_dt
from ray_bond_warrantor;
commit;

delete from bond_pledge where 1 = 1;
commit;
insert into bond_pledge
(
	bond_pledge_sid,
	secinner_id,
	rpt_dt,
	notice_dt,
	pledge_nm,
	pledge_type_id,
	pledge_desc,
	pledge_owner_id,
	pledge_owner,
	pledge_value ,
	priority_value,
	pledge_depend_id,
	pledge_control_id ,
	region,
	mitigation_value,
	isdel,
	srcid ,
	src_cd ,
	updt_by ,
	updt_dt
)
select
bond_pledge_sid,
	secinner_id,
	'2016-12-31'::date as rpt_dt,
	notice_dt,
	pledge_nm,
	pledge_type_id,
	pledge_desc,
	pledge_owner_id,
	pledge_owner,
	pledge_value ,
	priority_value,
	pledge_depend_id,
	pledge_control_id ,
	region,
	mitigation_value,
	isdel,
	srcid ,
	src_cd ,
	updt_by ,
	updt_dt
from ray_bond_pledge;
commit;

-- model_id 默认为1
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
	updt_by,
	updt_dt
from ray_lkp_ratingcd_xw
where model_id = 1 and constant_type <> 5
;

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
