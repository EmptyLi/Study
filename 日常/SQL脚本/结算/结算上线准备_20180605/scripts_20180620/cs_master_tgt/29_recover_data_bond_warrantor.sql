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

select setval('seq_bond_warrantor',case when max(bond_warrantor_sid :: bigint) > nextval('seq_bond_warrantor')
  then max(bond_warrantor_sid :: bigint)
       else nextval('seq_bond_warrantor') end)
from ray_bond_warrantor;

-- select setval('seq_bond_warrantor',case when max(bond_warrantor_sid :: bigint) > max(start_value :: bigint)
--   then max(bond_warrantor_sid :: bigint)
--        else max(start_value :: bigint) end)
-- from ray_bond_warrantor
--   inner join information_schema.sequences on sequence_schema = 'public' and sequence_name = 'seq_bond_warrantor';
