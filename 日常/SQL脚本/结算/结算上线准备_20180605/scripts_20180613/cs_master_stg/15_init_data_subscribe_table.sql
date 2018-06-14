delete from subscribe_table where 1 = 1;
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (110, 2, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (111, 3, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (128, 5, 1, null, 'and constant_id not in (select constant_id from lkp_charcode where constant_type=201 and constant_nm in
   (''国债'',
   ''地方政府债'',
   ''央行票据'',
   ''政府支持债'',
   ''中小企业集合债券'',
   ''政策性银行债'',
   ''政策性银行次级债'',
   ''特种金融债'',
   ''中小企业集合票据''))', 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (129, 8, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (124, 101, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (122, 105, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (109, 106, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (103, 107, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (99, 108, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (106, 109, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (125, 110, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (121, 111, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (119, 114, 1, null, 'and trade_markect_nm in (''深圳证券交易所'',''上海证券交易所'') and security_type not in (''国债'',
   ''地方政府债'',
   ''央行票据'',
   ''政府支持债'',
   ''中小企业集合债券'',
   ''政策性银行债'',
   ''政策性银行次级债'',
   ''特种金融债'',
   ''中小企业集合票据'') and issue_type_cd<>2', 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (98, 117, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (108, 118, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (107, 119, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (117, 120, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (112, 121, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (118, 122, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (114, 123, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (116, 124, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (113, 126, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (104, 134, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (138, 146, 1, 1, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (141, 149, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (115, 102, 1, null, 'and rpt_dt < 20170101', 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (105, 125, 1, null, 'and rpt_dt < to_date(''20170101'',''yyyymmdd'')', 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (101, 112, 1, 1, null, 1, 333, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (130, 136, 1, 1, null, 1, 333, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (126, 135, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (133, 137, 1, 1, null, 1, 333, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (97, 152, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (4810, 74423, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (501, 6216, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (139, 74421, 1, null, 'and rpt_dt < to_date(''20170101'',''yyyymmdd'')', 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (140, 74422, 1, null, 'and rpt_dt < to_date(''20170101'',''yyyymmdd'')', 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (3337, 144, 1, 1, 'and client_id = ai_client_id and rpt_dt >= to_date(''20151231'',''yyyymmdd'')', 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (336, 143, 1, 1, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (132, 113, 1, 1, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (137, 145, 1, 1, 'and rpt_dt < to_date(''20170101'',''yyyymmdd'')', 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (123, 132, 1, 1, 'and rpt_dt < to_date(''20170101'',''yyyymmdd'')', 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (100, 104, 1, null, 'and rpt_dt < 20170101', 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (570, 9028, 1, 1, 'and client_id = ai_client_id and rpt_dt < to_date(''20170101'',''yyyymmdd'')', 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (136, 138, 1, 1, null, 1, 333, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (135, 139, 1, 1, null, 1, 333, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (134, 140, 1, 1, null, 1, 333, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (627, 4, 1, null, null, 1, 0, '2018-04-11 15:52:40.208432');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (120, 153, 1, null, null, 1, 0, '2017-09-06 20:15:40.000000');
   INSERT INTO public.subscribe_table (subscribe_table_sid, subscribe_table_id, subscribe_id, client_id, subscribe_filter, if_prior, isdel, updt_dt) VALUES (102, 103, 1, null, 'and rpt_dt < 20170101', 1, 0, '2017-09-06 20:15:40.000000');
