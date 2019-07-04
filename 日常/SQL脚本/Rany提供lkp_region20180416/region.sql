select a.company_nm, COUNTRY,REGION,CITY, lkp1.region_nm, lkp2.region_nm, 
       (select lkp3.region_nm from c##cscredit.lkp_region lkp3  
               where (a.company_nm like '%' ||replace(lkp3.region_nm, '市','') || '%' 
                     and (lkp3.region_type = 2 or trim(translate(lkp3.region_nm, '市县',' ')) <> lkp3.region_nm)
                     and substr(lkp3.region_cd,1,3) = substr(a.region,1,3)
                     or substr(a.company_nm,1,2) = substr(lkp3.region_nm,1,2)
                     and trim(translate(lkp3.region_nm, '市县',' ')) <> lkp3.region_nm
                     and (substr(lkp3.region_cd,1,3) = substr(a.region,1,3) and a.region <> '' or nvl(a.region,' ') = ' ')
                     ) 
                     and rownum <=1)                  
from stg_dfcf_compy_basicinfo a
left join c##cscredit.lkp_region lkp1
on a.region = lkp1.region_cd and lkp1.region_type = 1
left join c##cscredit.lkp_region lkp2
on a.CITY = lkp2.region_cd and lkp2.region_type = 2



delete from c##cscredit.lkp_region where region_type = 2

insert into c##cscredit.lkp_region
select a.region_cd, a.region_nm, b.region_cd, 2 as region_type, systimestamp
from (select paramorder as region_cd, paramchname as region_nm from choice.cfp_pvalue@dfcf.dblink.oracle 
     where NIPMID=138000000539415596 and eisdel =0) a
inner join c##cscredit.lkp_region b
on substr(a.region_cd, 1,2) = substr(b.region_cd,1,2)
and region_type = 1 
--and substr(b.region_cd,1,3) is null
and a.region_cd not in (select region_cd from c##cscredit.lkp_region)


   	CITY
1	522200 ##
2	542300
3	522400
4	341400
5	522401
6	232702 ##
7	370205
8	371421

   	REGION_CD	REGION_NM
1	341400	巢湖市
2	542300	日喀则地区
3	522400	毕节地区
4	522401	毕节市
5	371421	陵县
6	370205	四方区

