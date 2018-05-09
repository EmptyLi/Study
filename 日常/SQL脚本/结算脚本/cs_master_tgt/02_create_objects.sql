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

alter table bond_rating_record drop constraint pk_bond_rating_record;
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

alter table ray_bond_rating_factor drop constraint pk_bond_rating_factor;
create table  if not exists bond_rating_factor
(
  bond_rating_factor_sid bigint default nextval('seq_bond_rating_factor' :: regclass) not null
    constraint pk_bond_rating_factor
    primary key,
  bond_rating_record_sid bigint                                                       not null,
  orig_record_sid        bigint,
  factor_cd              varchar(30)                                                  not null,
  factor_nm              varchar(200)                                                 not null,
  factor_type            varchar(60)                                                  not null,
  factor_value           varchar(600)                                                 not null,
  option_num             integer,
  ratio                  numeric(10, 4),
  factor_val_revised   varchar(600),
  option_num_revised     integer,
  ratio_revised          numeric(10, 4),
  adjustment_comment     varchar(600),
  client_id              bigint                                                       not null,
  updt_by                bigint                                                       not null,
  updt_dt                timestamp                                                    not null
);
commit;

alter table ray_rating_factor drop constraint rating_hist_factor_score_pkey;
create table  if not exists rating_factor
(
  rating_factor_id          bigint default nextval('seq_rating_hist_factor_score' :: regclass) not null
    constraint rating_hist_factor_score_pkey
    primary key,
  rating_record_id          bigint                                                             not null,
  rm_factor_id              bigint                                                             not null,
  factor_dt                 date                                                               not null,
  factor_val_revised        numeric(32, 16),
  score                     numeric(20, 16),
  creation_time             timestamp(6),
  factor_val                numeric(32, 16),
  factor_exception_val      numeric(32, 16),
  factor_exception_rule_sid bigint,
  factor_missing_cd         bigint,
  adjustment_comment        varchar(2000)
);
commit;

alter table ray_bond_factor_option drop constraint pk_bond_factor_option;
create table  if not exists bond_factor_option
(
  bond_factor_option_sid bigint default nextval('seq_bond_factor_option' :: regclass) not null
    constraint pk_bond_factor_option
    primary key,
  factor_cd              varchar(30)                                                  not null,
  model_id               bigint                                                       not null,
  option_type            varchar(300),
  option                 varchar(300),
  option_num             integer                                                      not null,
  ratio                  numeric(10, 4)                                               not null,
  low_bound              numeric(10, 4),
  remark                 varchar(1000),
  isdel                  integer,
  client_id              bigint                                                       not null,
  updt_by                bigint                                                       not null,
  updt_dt                timestamp(6)                                                 not null
);
commit;

alter table ray_bond_pledge drop constraint pk_bond_pledge;
create table  if not exists bond_pledge
(
  bond_pledge_sid   bigint default nextval('seq_bond_pledge' :: regclass) not null
    constraint pk_bond_pledge
    primary key,
  secinner_id       bigint                                                not null,
  rpt_dt            date,
  notice_dt         date,
  pledge_nm         varchar(300)                                          not null,
  pledge_type_id    bigint,
  pledge_desc       varchar(2000),
  pledge_owner_id   bigint,
  pledge_owner      varchar(300),
  pledge_value      numeric(20, 4),
  priority_value    numeric(20, 4),
  pledge_depend_id  bigint,
  pledge_control_id bigint,
  region            integer,
  mitigation_value  numeric(20, 4),
  isdel             integer                                               not null,
  srcid             varchar(100),
  src_cd            varchar(10)                                           not null,
  updt_by           bigint default 0                                      not null,
  updt_dt           timestamp                                             not null
);
commit;

alter table ray_bond_rating_model drop constraint pk_bond_rating_model;
CREATE TABLE  if not exists bond_rating_model
(
  model_id   BIGINT DEFAULT nextval('seq_bond_rating_model' :: REGCLASS) NOT NULL
    CONSTRAINT pk_bond_rating_model
    PRIMARY KEY,
  model_cd   VARCHAR(30)                                                 NOT NULL,
  model_nm   VARCHAR(100)                                                NOT NULL,
  model_desc VARCHAR(1000),
  formula_ch VARCHAR(2000),
  formula_en VARCHAR(2000),
  version    NUMERIC(10, 4),
  IS_ACTIVE  INTEGER,
  isdel      INTEGER,
  client_id  BIGINT                                                      NOT NULL,
  updt_by    BIGINT                                                      NOT NULL,
  updt_dt    TIMESTAMP                                                   NOT NULL
);
commit;

alter table ray_lkp_ratingcd_xw drop constraint pk_lkp_ratingcd_xw;
CREATE TABLE if not exists lkp_ratingcd_xw
(
  model_id      BIGINT       NOT NULL,
  constant_nm   VARCHAR(200) NOT NULL,
  ratingcd_nm   VARCHAR(200) NOT NULL,
  constant_type INTEGER      NOT NULL,
  updt_by       BIGINT       DEFAULT 0                                   NOT NULL,
  updt_dt       TIMESTAMP    NOT NULL,
  CONSTRAINT pk_lkp_ratingcd_xw
  PRIMARY KEY (model_id, constant_nm, ratingcd_nm, constant_type)
);
commit;

CREATE VIEW vw_bond_rating_cacul AS WITH client AS (
         SELECT DISTINCT client_basicinfo.client_id
           FROM client_basicinfo
        ), tmp_lkp_ratingcd_xw AS (
         SELECT a_1.model_id,
            a_1.constant_nm,
            a_1.ratingcd_nm,
            a_1.constant_type,
            a_1.updt_by,
            a_1.updt_dt
           FROM ((lkp_ratingcd_xw a_1
             JOIN bond_rating_model b ON ((((b.model_id = a_1.model_id) AND (b.isdel = 0)) AND (b.is_active = 1))))
             JOIN client_basicinfo c ON ((c.client_id = b.client_id)))
        ), rating_cd2 AS (
         SELECT a_1.constant_id,
            a_1.constant_nm,
            b.ratingcd_nm,
            a_1.constant_type,
            b.model_id
           FROM (lkp_charcode a_1
             JOIN tmp_lkp_ratingcd_xw b ON (((a_1.constant_nm)::text = (b.constant_nm)::text)))
          WHERE ((a_1.constant_type = ANY (ARRAY[(201)::bigint, (207)::bigint])) AND (a_1.isdel = 0))
        ), rating_cd_region AS (
         SELECT a_1.region_cd,
            a_1.region_nm,
            b.ratingcd_nm,
            b.model_id
           FROM (lkp_region a_1
             JOIN tmp_lkp_ratingcd_xw b ON ((((substr((a_1.region_nm)::text, 1, 2) = substr((b.constant_nm)::text, 1, 2)) AND (a_1.parent_cd IS NULL)) AND (b.constant_type = 6))))
        ), rating_cd_industry AS (
         SELECT a_1.exposure_sid,
            a_1.exposure,
            b.ratingcd_nm,
            b.model_id
           FROM (exposure a_1
             JOIN tmp_lkp_ratingcd_xw b ON ((((a_1.exposure)::text = (b.constant_nm)::text) AND (b.constant_type = 5))))
          WHERE (a_1.isdel = 0)
        )
 SELECT row_number() OVER (ORDER BY NULL::text) AS bond_rating_cacul_sid,
    a.model_id,
    a.secinner_id,
    a.security_cd,
    a.security_nm,
    a.company_id,
    a.company_nm,
    a.bond_type,
    a.remain_vol,
    a.corp_nature,
    a.credit_region,
    a.industry,
    a.exposure,
    a.client_id
   FROM ( SELECT DISTINCT COALESCE(e.model_id, r2.model_id, l.model_id) AS model_id,
            a_1.secinner_id,
            a_1.security_cd,
            a_1.security_nm,
            d.issuer_id AS company_id,
            m.company_nm,
            e.ratingcd_nm AS bond_type,
            COALESCE((chg.remain_vol / (10000)::numeric), a_1.issue_vol) AS remain_vol,
            lkporgnature.constant_nm AS corp_nature,
            r2.ratingcd_nm AS credit_region,
            l.ratingcd_nm AS industry,
            l.exposure,
            t.client_id
           FROM (((((((((bond_basicinfo a_1
             JOIN client t ON ((1 = 1)))
             LEFT JOIN ( SELECT a_2.secinner_id,
                    a_2.remain_vol,
                    row_number() OVER (PARTITION BY a_2.secinner_id ORDER BY a_2.change_dt DESC) AS rnk
                   FROM (bond_opvolchg a_2
                     JOIN lkp_charcode b ON ((((a_2.chg_type_id = b.constant_id) AND (b.constant_type = 45)) AND ((b.constant_nm)::text = ANY ((ARRAY['债券偿付本金'::character varying, '回售'::character varying, '到期'::character varying, '赎回'::character varying])::text[])))))
                  WHERE ((((a_2.change_dt IS NOT NULL) AND (a_2.change_dt <= now())) AND (a_2.isdel = 0)) AND (b.isdel = 0))) chg ON (((a_1.secinner_id = chg.secinner_id) AND (chg.rnk = 1))))
             LEFT JOIN vw_bond_issuer d ON ((a_1.secinner_id = d.secinner_id)))
             LEFT JOIN compy_basicinfo m ON (((d.issuer_id = m.company_id) AND (m.is_del = 0))))
             LEFT JOIN rating_cd2 e ON ((a_1.security_type_id = e.constant_id)))
             LEFT JOIN compy_bondissuer bdissuer ON (((d.issuer_id = bdissuer.company_id) AND (bdissuer.isdel = 0))))
             LEFT JOIN lkp_charcode lkporgnature ON ((((bdissuer.org_nature_id = lkporgnature.constant_id) AND (lkporgnature.constant_type = 46)) AND (lkporgnature.isdel = 0))))
             LEFT JOIN rating_cd_region r2 ON ((bdissuer.region = r2.region_cd)))
             LEFT JOIN ( SELECT a_2.company_id,
                    a_2.client_id,
                    b.ratingcd_nm,
                    b.exposure,
                    b.model_id
                   FROM (compy_exposure a_2
                     JOIN rating_cd_industry b ON ((a_2.exposure_sid = b.exposure_sid)))
                  WHERE ((a_2.isdel = 0) AND (a_2.is_new = 1))) l ON (((COALESCE(d.issuer_id, bdissuer.company_id) = l.company_id) AND (l.client_id = t.client_id))))
          WHERE (a_1.isdel = 0)) a;
commit;

CREATE VIEW vw_bond_rating_cacul_pledge AS WITH tmp_lkp_ratingcd_xw AS (
         SELECT a_1.model_id,
            a_1.constant_nm,
            a_1.ratingcd_nm,
            a_1.constant_type,
            a_1.updt_by,
            a_1.updt_dt,
            b_1.model_id,
            b_1.model_cd,
            b_1.model_nm,
            b_1.model_desc,
            b_1.formula_ch,
            b_1.formula_en,
            b_1.version,
            b_1.is_active,
            b_1.isdel,
            b_1.client_id,
            b_1.updt_by,
            b_1.updt_dt,
            c.client_id,
            c.client_nm,
            c.client_snm,
            c.client_addr,
            c.contact,
            c.phone,
            c.email,
            c.purchase_dt,
            c.updt_dt
           FROM ((lkp_ratingcd_xw a_1
             JOIN bond_rating_model b_1 ON ((((b_1.model_id = a_1.model_id) AND (b_1.isdel = 0)) AND (b_1.is_active = 1))))
             JOIN client_basicinfo c ON ((c.client_id = b_1.client_id)))
        ), rating_cd_region AS (
         SELECT a_1.region_cd,
            a_1.region_nm,
            b_1.ratingcd_nm,
            b_1.model_id
           FROM (lkp_region a_1
             JOIN tmp_lkp_ratingcd_xw b_1(model_id, constant_nm, ratingcd_nm, constant_type, updt_by, updt_dt, model_id_1, model_cd, model_nm, model_desc, formula_ch, formula_en, version, is_active, isdel, client_id, updt_by_1, updt_dt_1, client_id_1, client_nm, client_snm, client_addr, contact, phone, email, purchase_dt, updt_dt_2) ON ((((substr((a_1.region_nm)::text, 1, 2) = substr((b_1.constant_nm)::text, 1, 2)) AND (a_1.parent_cd IS NULL)) AND (b_1.constant_type = 6))))
        ), rating_cd1 AS (
         SELECT a_1.constant_id,
            a_1.constant_nm AS ratingcd_nm,
            a_1.constant_type
           FROM lkp_charcode a_1
          WHERE ((a_1.constant_type = ANY (ARRAY[(211)::bigint, (212)::bigint, (213)::bigint, (214)::bigint, (215)::bigint])) AND (a_1.isdel = 0))
        ), client AS (
         SELECT DISTINCT client_basicinfo.client_id
           FROM client_basicinfo
        )
 SELECT r1.model_id,
    a.secinner_id,
    b.rpt_dt,
    b.bond_pledge_sid,
    b.pledge_nm,
    h.ratingcd_nm AS pledge_type,
    i.ratingcd_nm AS pledge_control,
    j.ratingcd_nm AS pledge_depend,
    b.pledge_value,
    b.priority_value,
    r1.ratingcd_nm AS pledge_region,
    t.client_id
   FROM ((((((bond_basicinfo a
     JOIN client t ON ((1 = 1)))
     JOIN bond_pledge b ON (((a.secinner_id = b.secinner_id) AND (b.isdel = 0))))
     LEFT JOIN rating_cd1 h ON ((b.pledge_type_id = h.constant_id)))
     LEFT JOIN rating_cd1 i ON ((b.pledge_control_id = i.constant_id)))
     LEFT JOIN rating_cd1 j ON ((b.pledge_depend_id = j.constant_id)))
     LEFT JOIN rating_cd_region r1 ON ((b.region = r1.region_cd)))
  WHERE (a.isdel = 0);
commit;

CREATE VIEW vw_bond_rating_cacul_warrantor AS WITH client AS (
         SELECT DISTINCT client_basicinfo.client_id
           FROM client_basicinfo
        ), tmp_lkp_ratingcd_xw AS (
         SELECT a_1.model_id,
            a_1.constant_nm,
            a_1.ratingcd_nm,
            a_1.constant_type,
            a_1.updt_by,
            a_1.updt_dt
           FROM ((lkp_ratingcd_xw a_1
             JOIN bond_rating_model b ON ((((b.model_id = a_1.model_id) AND (b.isdel = 0)) AND (b.is_active = 1))))
             JOIN client_basicinfo c_1 ON ((c_1.client_id = b.client_id)))
        ), rating_cd1 AS (
         SELECT a_1.constant_id,
            a_1.constant_nm AS ratingcd_nm,
            a_1.constant_type
           FROM lkp_charcode a_1
          WHERE ((a_1.constant_type = ANY (ARRAY[(211)::bigint, (212)::bigint, (213)::bigint, (214)::bigint, (215)::bigint])) AND (a_1.isdel = 0))
        ), rating_cd2 AS (
         SELECT a_1.constant_id,
            a_1.constant_nm,
            b.ratingcd_nm,
            a_1.constant_type,
            b.model_id
           FROM (lkp_charcode a_1
             JOIN tmp_lkp_ratingcd_xw b ON (((a_1.constant_nm)::text = (b.constant_nm)::text)))
          WHERE ((a_1.constant_type = ANY (ARRAY[(201)::bigint, (207)::bigint])) AND (a_1.isdel = 0))
        )
 SELECT f.model_id,
    a.secinner_id,
    p.factor_dt,
    c.bond_warrantor_sid,
    c.warrantor_nm,
    f.ratingcd_nm AS guarantee_type,
    n.ratingcd_nm AS warrantor_type,
    o.ratingcd_nm AS warranty_strength,
    p.final_rating AS warrantor_rating,
    c.warranty_amt AS warranty_value,
    t.client_id
   FROM ((((((bond_basicinfo a
     JOIN client t ON ((1 = 1)))
     JOIN ( SELECT bond_warrantor.bond_warrantor_sid,
            bond_warrantor.secinner_id,
            bond_warrantor.warrantor_id,
            bond_warrantor.warrantor_nm,
            bond_warrantor.warrantor_type_id,
            bond_warrantor.guarantee_type_id,
            bond_warrantor.warranty_strength_id,
            bond_warrantor.warranty_amt,
            row_number() OVER (PARTITION BY bond_warrantor.secinner_id, bond_warrantor.warrantor_nm ORDER BY bond_warrantor.src_updt_dt DESC NULLS LAST, bond_warrantor.notice_dt DESC NULLS LAST) AS row_num
           FROM bond_warrantor
          WHERE (bond_warrantor.isdel = 0)) c ON (((a.secinner_id = c.secinner_id) AND (c.row_num = 1))))
     LEFT JOIN rating_cd2 f ON ((c.guarantee_type_id = f.constant_id)))
     LEFT JOIN rating_cd1 n ON ((c.warrantor_type_id = n.constant_id)))
     LEFT JOIN rating_cd1 o ON ((c.warranty_strength_id = o.constant_id)))
     LEFT JOIN ( SELECT rating_record.company_id,
            rating_record.client_id,
            rating_record.factor_dt,
            rating_record.final_rating,
            row_number() OVER (PARTITION BY rating_record.company_id, rating_record.client_id ORDER BY rating_record.factor_dt DESC, rating_record.rating_start_dt DESC) AS row_num
           FROM rating_record
          WHERE ((rating_record.rating_type = 2) AND (rating_record.rating_st = 1))) p ON (((((c.warrantor_id)::numeric = p.company_id) AND (p.row_num = 1)) AND (p.client_id = t.client_id))))
  WHERE (a.isdel = 0);
commit;
