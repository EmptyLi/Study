--增加台湾省，澳门特别行政区
delete from lkp_ratingcd_xw where constant_type=6 and updt_by=1 and constant_nm='台湾省';
delete from lkp_ratingcd_xw where constant_type=6 and updt_by=1 and constant_nm='澳门特别行政区';
insert into lkp_ratingcd_xw select 1,'台湾省','1类地区',6,1,now() ;
insert into lkp_ratingcd_xw select 1,'澳门特别行政区','1类地区',6,1,now() ;

--更改新疆维吾尔族自治区 为 新疆维吾尔自治区
update lkp_ratingcd_xw
set constant_nm='新疆维吾尔自治区'
where constant_type=6 and updt_by=1 and constant_nm='新疆维吾尔族自治区';
