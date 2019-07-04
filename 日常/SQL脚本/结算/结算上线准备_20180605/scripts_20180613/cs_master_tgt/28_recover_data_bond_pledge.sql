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