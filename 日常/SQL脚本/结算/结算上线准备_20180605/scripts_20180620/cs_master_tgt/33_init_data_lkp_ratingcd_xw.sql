delete from lkp_ratingcd_xw where model_id =1 and constant_type = 5;
commit;

INSERT INTO public.lkp_ratingcd_xw (model_id, constant_nm, ratingcd_nm, constant_type, updt_by, updt_dt) VALUES (1, '6354', '1类行业', 5, 1, '2018-04-25 12:35:53.549000');
INSERT INTO public.lkp_ratingcd_xw (model_id, constant_nm, ratingcd_nm, constant_type, updt_by, updt_dt) VALUES (1, '6369', '1类行业', 5, 1, '2018-04-25 12:35:53.549000');
INSERT INTO public.lkp_ratingcd_xw (model_id, constant_nm, ratingcd_nm, constant_type, updt_by, updt_dt) VALUES (1, '6375', '2类行业', 5, 1, '2018-04-25 12:35:53.549000');
INSERT INTO public.lkp_ratingcd_xw (model_id, constant_nm, ratingcd_nm, constant_type, updt_by, updt_dt) VALUES (1, '6344', '2类行业', 5, 1, '2018-04-25 12:35:53.549000');
INSERT INTO public.lkp_ratingcd_xw (model_id, constant_nm, ratingcd_nm, constant_type, updt_by, updt_dt) VALUES (1, '6355', '2类行业', 5, 1, '2018-04-25 12:35:53.550000');
INSERT INTO public.lkp_ratingcd_xw (model_id, constant_nm, ratingcd_nm, constant_type, updt_by, updt_dt) VALUES (1, '6381', '3类行业', 5, 1, '2018-04-25 12:35:53.550000');
INSERT INTO public.lkp_ratingcd_xw (model_id, constant_nm, ratingcd_nm, constant_type, updt_by, updt_dt) VALUES (1, '6360', '3类行业', 5, 1, '2018-04-25 12:35:53.550000');
INSERT INTO public.lkp_ratingcd_xw (model_id, constant_nm, ratingcd_nm, constant_type, updt_by, updt_dt) VALUES (1, '6368', '3类行业', 5, 1, '2018-04-25 12:35:53.550000');
INSERT INTO public.lkp_ratingcd_xw (model_id, constant_nm, ratingcd_nm, constant_type, updt_by, updt_dt) VALUES (1, '6379', '3类行业', 5, 1, '2018-04-25 12:35:53.550000');
INSERT INTO public.lkp_ratingcd_xw (model_id, constant_nm, ratingcd_nm, constant_type, updt_by, updt_dt) VALUES (1, '6359', '3类行业', 5, 1, '2018-04-25 12:35:53.549000');
INSERT INTO public.lkp_ratingcd_xw (model_id, constant_nm, ratingcd_nm, constant_type, updt_by, updt_dt) VALUES (1, '6377', '3类行业', 5, 1, '2018-04-25 12:35:53.549000');
INSERT INTO public.lkp_ratingcd_xw (model_id, constant_nm, ratingcd_nm, constant_type, updt_by, updt_dt) VALUES (1, '6376', '3类行业', 5, 1, '2018-04-25 12:35:53.549000');
INSERT INTO public.lkp_ratingcd_xw (model_id, constant_nm, ratingcd_nm, constant_type, updt_by, updt_dt) VALUES (1, '6370', '2类行业', 5, 1, '2018-04-25 12:35:53.549000');
INSERT INTO public.lkp_ratingcd_xw (model_id, constant_nm, ratingcd_nm, constant_type, updt_by, updt_dt) VALUES (1, '6378', '3类行业', 5, 1, '2018-04-25 12:35:53.550000');
INSERT INTO public.lkp_ratingcd_xw (model_id, constant_nm, ratingcd_nm, constant_type, updt_by, updt_dt) VALUES (1, '6380', '2类行业', 5, 1, '2018-04-25 12:35:53.548000');
INSERT INTO public.lkp_ratingcd_xw (model_id, constant_nm, ratingcd_nm, constant_type, updt_by, updt_dt) VALUES (1, '6373', '1类行业', 5, 1, '2018-04-25 12:35:53.548000');
INSERT INTO public.lkp_ratingcd_xw (model_id, constant_nm, ratingcd_nm, constant_type, updt_by, updt_dt) VALUES (1, '6374', '1类行业', 5, 1, '2018-04-25 12:35:53.548000');
INSERT INTO public.lkp_ratingcd_xw (model_id, constant_nm, ratingcd_nm, constant_type, updt_by, updt_dt) VALUES (1, '6372', '2类行业', 5, 1, '2018-04-25 12:35:53.548000');
commit;


-- 提升台湾为一级地区，增加其他地区
delete from lkp_ratingcd_xw where constant_type=6 and updt_by=1 and constant_nm='台湾省';
delete from lkp_ratingcd_xw where constant_type=6 and updt_by=1 and constant_nm='澳门特别行政区';
delete from lkp_ratingcd_xw where constant_type=6 and updt_by=1 and constant_nm='其他';
insert into lkp_ratingcd_xw select 1,'台湾省','1类地区',6,1,now() ;
insert into lkp_ratingcd_xw select 1,'澳门特别行政区','1类地区',6,1,now() ;
insert into lkp_ratingcd_xw select 1,'其他','3类地区',6,1,now() ;

--更改新疆维吾尔族自治区 为 新疆维吾尔自治区
update lkp_ratingcd_xw
set constant_nm='新疆维吾尔自治区'
where constant_type=6 and updt_by=1 and constant_nm='新疆维吾尔族自治区';
