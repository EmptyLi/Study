CREATE TABLE if not exists bond_rating_record
    (
        bond_rating_record_sid BIGINT DEFAULT nextval('seq_bond_rating_record'::regclass) NOT NULL,
        secinner_id BIGINT NOT NULL,
        model_id BIGINT NOT NULL,
        factor_dt DATE,
        rating_dt DATE NOT NULL,
        rating_type INTEGER NOT NULL,
        raw_lgd_score NUMERIC(10,4),
        raw_lgd_grade CHARACTER VARYING(30),
        adjust_lgd_score NUMERIC(10,4),
        adjust_lgd_grade CHARACTER VARYING(30),
        adjust_lgd_reason CHARACTER VARYING(300),
        raw_rating CHARACTER VARYING(40),
        adjust_rating CHARACTER VARYING(40),
        adjust_rating_reason CHARACTER VARYING(300),
        rating_st INTEGER DEFAULT 0,
		  effect_start_dt TIMESTAMP,
        effect_end_dt TIMESTAMP,
        updt_by BIGINT NOT NULL,
        updt_dt TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL,
        CONSTRAINT pk_bond_rating_record PRIMARY KEY (bond_rating_record_sid)
    );
commit;
