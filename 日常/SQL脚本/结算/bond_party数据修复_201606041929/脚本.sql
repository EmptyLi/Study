-- select current_user, current_schema, current_database();
select isdel,count(*) from bond_party
group by isdel;

create table ray_bond_party as select * from bond_party;
create table ttt_bond_party
(
  bond_party_sid varchar(100),
  secinner_id    varchar(100),
  notice_dt      varchar(100),
  party_id       varchar(100),
  party_nm       varchar(300),
  party_type_id  varchar(100),
  start_dt       varchar(100),
  end_dt         varchar(100),
  isdel          varchar(100),
  srcid          varchar(100),
  src_cd         varchar(100),
  updt_by        varchar(100),
  updt_dt        varchar(100)
);

select * from ttt_bond_party;

delete from bond_party;
commit;

update ttt_bond_party t
  set end_dt = null
where end_dt = '';
commit;


  insert into bond_party
  (bond_party_sid
,secinner_id
,notice_dt
,party_id
,party_nm
,party_type_id
,start_dt
,end_dt
,isdel
,srcid
,src_cd
,updt_by
,updt_dt )
select
bond_party_sid
,secinner_id
,notice_dt
,party_id
,party_nm
,party_type_id
,start_dt::date
,trim(end_dt)::date
,isdel
,srcid
,src_cd
,0 as updt_by
,updt_by::timestamp as updt_dt
from ttt_bond_party;

commit;

select isdel,count(*) from bond_party
group by isdel;
