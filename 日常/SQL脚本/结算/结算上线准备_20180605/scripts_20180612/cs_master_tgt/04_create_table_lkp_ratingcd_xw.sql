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
