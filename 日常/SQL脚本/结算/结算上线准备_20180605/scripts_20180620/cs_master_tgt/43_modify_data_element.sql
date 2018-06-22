update element
   set data_type=1,
       unit=null,
       format=null
where element_cd in ('element_0097','element_0101','element_0115','element_0153','element_0180','element_0216');
commit;
