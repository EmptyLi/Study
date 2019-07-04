create table if not exists bond_rating_record
(
	bond_rating_record_sid bigint default nextval('seq_bond_rating_record'::regclass) not null
		constraint pk_bond_rating_record
			primary key,
	secinner_id bigint not null,
	model_id bigint not null,
	factor_dt date,
	rating_dt date not null,
	rating_type integer not null,
	raw_lgd_score numeric(10,4),
	raw_lgd_grade varchar(30),
	adjust_lgd_score numeric(10,4),
	adjust_lgd_grade varchar(30),
	adjust_lgd_reason varchar(300),
	raw_rating varchar(40),
	adjust_rating varchar(40),
	adjust_rating_reason varchar(4000),
	rating_st integer default 0,
	effect_start_dt timestamp,
	effect_end_dt timestamp,
	updt_by bigint not null,
	updt_dt timestamp(6) not null
)
;
commit;
