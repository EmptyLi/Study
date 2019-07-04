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

-- select setval('seq_bond_rating_model', max(model_id)) from ray_bond_rating_model;
