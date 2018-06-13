select * from compy_element a
  left join element b
  on b.src_cd = 'CSDC'
  and a.element_cd = b.element_cd
where a.company_id = '310968' and a.element_src = 'CISP'
  and a.rpt_dt = date'2016-12-31'
and  a.element_cd = 'JZC';

-- 46266220459.8300
set time zone 'PRC';
update compy_element
set
--   element_value = 0
  updt_dt = now()
where company_id = '310968' and element_src = 'CISP'
  and rpt_dt = date'2016-12-31';
--   and element_cd = 'JZC';


create table ray_compy_element_0607 as select * from compy_element;
