--长城LGD得分
select a.security_snm,security_nm,security_cd,b.raw_lgd_score,b.raw_lgd_grade,a.secinner_id

 from 
 (select security_snm,security_nm,security_cd,secinner_id  ,row_number()over(partition by security_snm order by secinner_id desc) as row_num from bond_basicinfo) a
join 
        (
        select secinner_id,raw_lgd_score,raw_lgd_grade,
        
        row_number()over(partition by secinner_id order by updt_dt desc,BOND_RATING_RECORD_SID desc) as row_num
         from BOND_RATING_RECORD
         where factor_dt=date'2016-12-31'
         and rating_type=0
         )b  ON a.secinner_id=b.secinner_id
 where b.row_num=1
 and a.row_num=1;