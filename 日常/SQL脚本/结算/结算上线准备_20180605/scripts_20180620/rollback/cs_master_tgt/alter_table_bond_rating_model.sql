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
  -- IS_ACTIVE  INTEGER,
  isdel      INTEGER,
  client_id  BIGINT                                                      NOT NULL,
  updt_by    BIGINT                                                      NOT NULL,
  updt_dt    TIMESTAMP                                                   NOT NULL
);

delete from bond_rating_model where 1 = 1;

insert into bond_rating_model
   (	model_id
,	model_cd
,	model_nm
,	model_desc
,	formula_ch
,	formula_en
,	version
,	isdel
,	client_id
,	updt_by
,	updt_dt
)
select
model_id
,	model_cd
,	model_nm
,	model_desc
,	formula_ch
,	formula_en
,	version
,	isdel
,	client_id
,	updt_by
,	updt_dt
from ray_bond_rating_model;

-- 需要恢复数据
-- alter table ray_bond_rating_model rename to bond_rating_model;
commit;
