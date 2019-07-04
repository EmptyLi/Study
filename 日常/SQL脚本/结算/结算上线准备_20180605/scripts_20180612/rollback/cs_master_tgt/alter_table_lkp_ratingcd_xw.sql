CREATE TABLE if not exists lkp_ratingcd_xw
(
  -- model_id      BIGINT       NOT NULL,
  constant_nm   VARCHAR(200) NOT NULL,
  ratingcd_nm   VARCHAR(200) NOT NULL,
  constant_type INTEGER      NOT NULL,
  -- updt_by       BIGINT       DEFAULT 0                                   NOT NULL,
  updt_dt       TIMESTAMP    NOT NULL,
  CONSTRAINT pk_lkp_ratingcd_xw
  PRIMARY KEY (constant_nm, ratingcd_nm, constant_type)
);

delete from lkp_ratingcd_xw where 1 = 1;

insert into lkp_ratingcd_xw
(constant_nm
,ratingcd_nm
,constant_type
,updt_dt)
select constant_nm
,ratingcd_nm
,constant_type
,updt_dt
from ray_lkp_ratingcd_xw;

-- alter table ray_lkp_ratingcd_xw rename to lkp_ratingcd_xw;
commit;
