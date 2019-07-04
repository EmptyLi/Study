create table if not exists hist_bond_pledge
(
	record_sid bigint,
	bond_pledge_sid bigint,
	secinner_id bigint,
	rpt_dt date,
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

commit;
