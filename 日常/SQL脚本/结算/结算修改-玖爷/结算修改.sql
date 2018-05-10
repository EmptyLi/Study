--添加lkp_model_bond_type表
CREATE TABLE
    lkp_model_bond_type
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
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (6990, '定向工具', 1, 0, 1, 1, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (2841, '国际机构债券', 1, 0, 1, 1, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (2842, '信贷资产证券化', 1, 0, 0, 0, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (2853, '政策性银行债', 1, 0, 0, 0, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (2854, '政策性银行次级债', 1, 0, 0, 0, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (2855, '特种金融债', 1, 0, 0, 0, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (2856, '商业银行普通债', 1, 0, 1, 1, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (2857, '商业银行次级债', 1, 0, 1, 1, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (2863, '混合资本债', 1, 0, 0, 0, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (2864, '证券公司债', 1, 0, 1, 1, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (2865, '证券公司短期融资券', 1, 0, 1, 1, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (2866, '证券公司次级债', 1, 0, 1, 1, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (2867, '保险公司债', 1, 0, 1, 1, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (2868, '财务公司债', 1, 0, 1, 1, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (2871, '中小企业集合票据', 1, 0, 0, 0, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (2872, '公司债', 1, 0, 1, 1, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (2873, '可转换债券', 1, 0, 1, 1, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (2874, '可分离交易可转债', 1, 0, 1, 1, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (2898, '住房抵押贷款证券化', 1, 0, 0, 0, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (2899, '汽车抵押贷款证券化', 1, 0, 0, 0, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (2900, '券商专项资产管理', 1, 0, 0, 0, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (2901, '资产支持票据', 1, 0, 0, 0, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (3073, '同业存单', 1, 0, 1, 1, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (3145, '国债', 1, 0, 0, 0, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (3146, '地方政府债', 1, 0, 0, 0, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (3147, '央行票据', 1, 0, 0, 0, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (3148, '政府支持机构债', 1, 0, 0, 0, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (3149, '政府支持债', 1, 0, 0, 0, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (3150, '金融租赁公司债', 1, 0, 1, 1, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (3151, '汽车金融公司债', 1, 0, 1, 1, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (3152, '其它金融债', 1, 0, 1, 1, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (3153, '企业债', 1, 0, 1, 1, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (3154, '中期票据', 1, 0, 1, 1, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (3155, '短期融资券', 1, 0, 1, 1, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (3156, '超短期融资券', 1, 0, 1, 1, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (3157, '中小企业集合债券', 1, 0, 0, 0, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (3177, '可交换债券', 1, 0, 1, 1, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (3184, '保险公司金融债', 1, 0, 1, 1, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (3206, '不动产投资信托(REITs)', 1, 0, 0, 0, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (3224, '项目收益债券', 1, 0, 0, 0, 0, '2018-02-05 10:02:23');
INSERT INTO lkp_model_bond_type (type_id, bond_type, bond_type_flag, issue_type, rulerating_flag, warning_flag, isdel, updt_dt) VALUES (3386, '未知', 1, 0, 0, 0, 0, '2018-02-05 10:02:23');


--bond_rating_record表添加effect_start_dt，effect_end_dt
create table bond_rating_record_bak as select * from bond_rating_record;
drop table bond_rating_record;
CREATE TABLE bond_rating_record
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
INSERT INTO bond_rating_record (bond_rating_record_sid, secinner_id, model_id, factor_dt, rating_dt, rating_type, raw_lgd_score, raw_lgd_grade, adjust_lgd_score, adjust_lgd_grade, adjust_lgd_reason, raw_rating, adjust_rating, adjust_rating_reason, rating_st, updt_by, updt_dt)
select * from bond_rating_record_bak;
