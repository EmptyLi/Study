select *
from bond_pledge;
create table ray_bond_pledge as
  select *
  from bond_pledge;
select *
from ray_bond_pledge;
drop table bond_pledge cascade;
create table bond_pledge
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

create view vw_bond_rating_cacul_pledge as with rating_cd_region as (
    select
      a_1.region_cd,
      a_1.region_nm,
      b_1.ratingcd_nm
    from (lkp_region a_1
      join lkp_ratingcd_xw b_1 on ((
        ((substr((a_1.region_nm) :: text, 1, 2) = substr((b_1.constant_nm) :: text, 1, 2)) and (a_1.parent_cd is null))
        and (b_1.constant_type = 6))))
), rating_cd1 as (
    select
      a_1.constant_id,
      a_1.constant_nm as ratingcd_nm,
      a_1.constant_type
    from lkp_charcode a_1
    where ((a_1.constant_type = any
            (array [(211) :: bigint, (212) :: bigint, (213) :: bigint, (214) :: bigint, (215) :: bigint])) and
           (a_1.isdel = 0))
), client as (
    select distinct client_basicinfo.client_id
    from client_basicinfo
)
select
  a.secinner_id,
  b.rpt_dt,
  b.bond_pledge_sid,
  b.pledge_nm,
  h.ratingcd_nm  as pledge_type,
  i.ratingcd_nm  as pledge_control,
  j.ratingcd_nm  as pledge_depend,
  b.pledge_value,
  b.priority_value,
  r1.ratingcd_nm as pledge_region,
  t.client_id
from ((((((bond_basicinfo a
  join client t on ((1 = 1)))
  join bond_pledge b on (((a.secinner_id = b.secinner_id) and (b.isdel = 0))))
  left join rating_cd1 h on ((b.pledge_type_id = h.constant_id)))
  left join rating_cd1 i on ((b.pledge_control_id = i.constant_id)))
  left join rating_cd1 j on ((b.pledge_depend_id = j.constant_id)))
  left join rating_cd_region r1 on ((b.region = r1.region_cd)))
where (a.isdel = 0);

insert into bond_pledge
  select
    bond_pledge_sid,
    secinner_id,
    '2016-12-31' :: date as rpt_dt,
    notice_dt,
    pledge_nm,
    pledge_type_id,
    pledge_desc,
    pledge_owner_id,
    pledge_owner,
    pledge_value,
    priority_value,
    pledge_depend_id,
    pledge_control_id,
    region,
    mitigation_value,
    isdel,
    srcid,
    src_cd,
    updt_by,
    updt_dt
  from ray_bond_pledge;

commit;
