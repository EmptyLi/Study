create table ray_bond_pledge as select * from bond_pledge;
drop view vw_bond_pledge;
drop table bond_pledge;
CREATE TABLE bond_pledge
(
  bond_pledge_sid   BIGINT DEFAULT nextval('seq_bond_pledge' :: REGCLASS) NOT NULL
    CONSTRAINT pk_bond_pledge
    PRIMARY KEY,
  secinner_id       BIGINT                                                NOT NULL,
  rpt_dt            date                                                  not null,
  notice_dt         DATE,
  pledge_nm         VARCHAR(300)                                          NOT NULL,
  pledge_type_id    BIGINT,
  pledge_desc       VARCHAR(2000),
  pledge_owner_id   BIGINT,
  pledge_owner      VARCHAR(300),
  pledge_value      NUMERIC(20, 4),
  priority_value    NUMERIC(20, 4),
  pledge_depend_id  BIGINT,
  pledge_control_id BIGINT,
  region            INTEGER,
  mitigation_value  NUMERIC(20, 4),
  isdel             INTEGER                                               NOT NULL,
  srcid             VARCHAR(100),
  src_cd            VARCHAR(10)                                           NOT NULL,
  updt_by           BIGINT DEFAULT 0                                      NOT NULL,
  updt_dt           TIMESTAMP                                             NOT NULL
);

CREATE VIEW vw_bond_pledge AS SELECT bond_pledge.bond_pledge_sid,
    bond_pledge.secinner_id,
    bond_pledge.notice_dt,
    bond_pledge.pledge_nm,
    bond_pledge.pledge_type_id,
    bond_pledge.pledge_desc,
    bond_pledge.pledge_owner_id,
    bond_pledge.pledge_owner,
    bond_pledge.pledge_value,
    bond_pledge.priority_value,
    bond_pledge.pledge_depend_id,
    bond_pledge.pledge_control_id,
    bond_pledge.region,
    bond_pledge.mitigation_value,
    bond_pledge.isdel,
    bond_pledge.srcid,
    bond_pledge.src_cd,
    0 AS updt_by,
    bond_pledge.updt_dt
   FROM bond_pledge;

CREATE VIEW vw_bond_pledge_01 AS SELECT bond_pledge.bond_pledge_sid,
    bond_pledge.secinner_id,
    bond_pledge.rpt_dt,
    bond_pledge.notice_dt,
    bond_pledge.pledge_nm,
    bond_pledge.pledge_type_id,
    bond_pledge.pledge_desc,
    bond_pledge.pledge_owner_id,
    bond_pledge.pledge_owner,
    bond_pledge.pledge_value,
    bond_pledge.priority_value,
    bond_pledge.pledge_depend_id,
    bond_pledge.pledge_control_id,
    bond_pledge.region,
    bond_pledge.mitigation_value,
    bond_pledge.isdel,
    bond_pledge.srcid,
    bond_pledge.src_cd,
    0 AS updt_by,
    bond_pledge.updt_dt
   FROM bond_pledge;

insert into bond_pledge
select bond_pledge_sid
,secinner_id
,'2016-12-31'::date as rpt_dt
,notice_dt
,pledge_nm
,pledge_type_id
,pledge_desc
,pledge_owner_id
,pledge_owner
,pledge_value
,priority_value
,pledge_depend_id
,pledge_control_id
,region
,mitigation_value
,isdel
,srcid
,src_cd
,updt_by
,updt_dt
from ray_bond_pledge;
commit;
