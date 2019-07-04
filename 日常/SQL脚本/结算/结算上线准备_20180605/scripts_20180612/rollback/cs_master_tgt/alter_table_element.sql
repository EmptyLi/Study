delete from element where element_cd in ('element_0097','element_0101','element_0115','element_0153','element_0180','element_0216');
insert into element
select * from ray_element
where element_cd in ('element_0097','element_0101','element_0115','element_0153','element_0180','element_0216');
commit;
