CREATE TABLE if not exists lkp_model_bond_type
(
        type_id NUMERIC(16,0) NOT NULL,
        bond_type CHARACTER VARYING(100) NOT NULL,
        bond_type_flag INTEGER NOT NULL,
        issue_type INTEGER,
        rulerating_flag INTEGER,
        warning_flag INTEGER,
        isdel INTEGER NOT NULL,
        updt_dt TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL
);
commit;
