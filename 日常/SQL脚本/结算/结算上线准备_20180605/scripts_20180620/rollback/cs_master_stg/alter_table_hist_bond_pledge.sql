create table if not exists hist_bond_pledge
(
	record_sid bigint,
	bond_pledge_sid bigint,
	secinner_id bigint,
	-- rpt_dt date,
	notice_dt date,
	pledge_nm varchar(300),
	pledge_type_id bigint,
	pledge_desc varchar(2000),
	pledge_owner_id bigint,
	pledge_owner varchar(300),
	pledge_value numeric(20,4),
	priority_value numeric(20,4),
	pledge_depend_id bigint,
	pledge_control_id bigint,
	region integer,
	mitigation_value numeric(20,4),
	isdel integer,
	srcid varchar(100),
	src_cd varchar(10),
	updt_by bigint,
	updt_dt timestamp,
	loadlog_sid bigint
)
;
delete from hist_bond_pledge where 1 = 1;
insert into hist_bond_pledge
(	record_sid
,	bond_pledge_sid
,	secinner_id
,	notice_dt
,	pledge_nm
,	pledge_type_id
,	pledge_desc
,	pledge_owner_id
,	pledge_owner
,	pledge_value
,	priority_value
,	pledge_depend_id
,	pledge_control_id
,	region
,	mitigation_value
,	isdel
,	srcid
,	src_cd
,	updt_by
,	updt_dt
,	loadlog_sid
)
select
record_sid
,	bond_pledge_sid
,	secinner_id
,	notice_dt
,	pledge_nm
,	pledge_type_id
,	pledge_desc
,	pledge_owner_id
,	pledge_owner
,	pledge_value
,	priority_value
,	pledge_depend_id
,	pledge_control_id
,	region
,	mitigation_value
,	isdel
,	srcid
,	src_cd
,	updt_by
,	updt_dt
,	loadlog_sid
from ray_hist_bond_pledge;

-- alter table ray_hist_bond_pledge rename to hist_bond_pledge;
commit;
