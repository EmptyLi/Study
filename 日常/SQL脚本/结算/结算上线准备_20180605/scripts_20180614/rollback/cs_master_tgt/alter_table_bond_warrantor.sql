create table bond_warrantor
(
	bond_warrantor_sid bigint default nextval('seq_bond_warrantor'::regclass) not null
		constraint pk_bond_warrantor
			primary key,
	secinner_id bigint not null,
	-- rpt_dt date not null,
	notice_dt date,
	warranty_rate numeric(10,4),
	guarantee_type_id bigint,
	warranty_period varchar(60),
	warrantor_id bigint,
	warrantor_nm varchar(300) not null,
	warrantor_type_id bigint,
	start_dt date,
	end_dt date,
	warranty_amt numeric(24,9),
	warrantor_resume text,
	warranty_contract text,
	warranty_benef varchar(300),
	warranty_content text,
	warranty_type_id bigint not null,
	warranty_claim varchar(200),
	warranty_strength_id bigint,
	pay_step text,
	warranty_fee numeric(24,8),
	exempt_set text,
	warranty_obj varchar(1000),
	isser_credit text,
	src_updt_dt date,
	mitigation_value numeric(20,4),
	isdel integer not null,
	srcid varchar(100),
	src_cd varchar(10) not null,
	updt_by bigint default 0 not null,
	updt_dt timestamp not null
)
;

delete from bond_warrantor where 1 = 1;
insert into bond_warrantor
(	bond_warrantor_sid
,	secinner_id
,	notice_dt
,	warranty_rate
,	guarantee_type_id
,	warranty_period
,	warrantor_id
,	warrantor_nm
,	warrantor_type_id
,	start_dt
,	end_dt
,	warranty_amt
,	warrantor_resume
,	warranty_contract
,	warranty_benef
,	warranty_content
,	warranty_type_id
,	warranty_claim
,	warranty_strength_id
,	pay_step
,	warranty_fee
,	exempt_set
,	warranty_obj
,	isser_credit
,	src_updt_dt
,	mitigation_value
,	isdel
,	srcid
,	src_cd
,	updt_by
,	updt_dt
)
select 	bond_warrantor_sid
,	secinner_id
,	notice_dt
,	warranty_rate
,	guarantee_type_id
,	warranty_period
,	warrantor_id
,	warrantor_nm
,	warrantor_type_id
,	start_dt
,	end_dt
,	warranty_amt
,	warrantor_resume
,	warranty_contract
,	warranty_benef
,	warranty_content
,	warranty_type_id
,	warranty_claim
,	warranty_strength_id
,	pay_step
,	warranty_fee
,	exempt_set
,	warranty_obj
,	isser_credit
,	src_updt_dt
,	mitigation_value
,	isdel
,	srcid
,	src_cd
,	updt_by
,	updt_dt
 from ray_bond_warrantor;

-- alter table ray_bond_warrantor rename to bond_warrantor;
commit;
