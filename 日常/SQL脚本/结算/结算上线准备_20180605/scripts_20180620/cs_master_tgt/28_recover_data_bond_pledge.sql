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

select setval('seq_bond_pledge',case when max(bond_pledge_sid :: bigint) > nextval('seq_bond_pledge')
  then max(bond_pledge_sid :: bigint)
       else nextval('seq_bond_pledge') end)
from ray_bond_pledge;

-- select setval('seq_bond_pledge',case when max(bond_pledge_sid :: bigint) > max(start_value :: bigint)
--   then max(bond_pledge_sid :: bigint)
--        else max(start_value :: bigint) end)
-- from ray_bond_pledge
--   inner join information_schema.sequences on sequence_schema = 'public' and sequence_name = 'seq_bond_pledge';
