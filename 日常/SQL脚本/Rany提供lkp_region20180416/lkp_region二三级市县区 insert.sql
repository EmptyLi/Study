insert into c##cscredit.lkp_region
select a.region_cd, a.region_nm, b.region_cd, 2 as region_type, systimestamp
from (select distinct paramorder as region_cd, paramchname as region_nm from choice.cfp_pvalue@dfcf.dblink.oracle 
     where NIPMID in(138000000539415596,127000000001707319 ) and eisdel =0) a
inner join c##cscredit.lkp_region b
on substr(a.region_cd, 1,2) = substr(b.region_cd,1,2)
and region_type = 1 and substr(a.region_cd,5,6)='00' --and substr(a.region_cd,3,6)<>'0000' 
and a.region_cd not in (select region_cd from c##cscredit.lkp_region)


insert into c##cscredit.lkp_region
select a.region_cd, a.region_nm, b.region_cd, 3 as region_type, systimestamp
from (select distinct paramorder as region_cd, paramchname as region_nm from choice.cfp_pvalue@dfcf.dblink.oracle 
     where NIPMID in(138000000539415596,127000000001707319 ) and eisdel =0) a
inner join c##cscredit.lkp_region b
on substr(a.region_cd, 1,4) = substr(b.region_cd,1,4)
and region_type = 2 and substr(a.region_cd,5,6)<>'00'
and a.region_cd not in (select region_cd from c##cscredit.lkp_region)