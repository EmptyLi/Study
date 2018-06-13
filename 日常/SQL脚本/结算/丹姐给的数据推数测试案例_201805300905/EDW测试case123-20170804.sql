--CASE1：
	--需要把企业放入默认组合 --云南白药集团股份有限公司
    --第一步：清除已有2016年财务和评级数据，删除2015年经营数据，和2015年入模财务指标数据（从而只会产生参考评级）
	
	    delete from compy_finance
		where company_id=61029 and to_char(rpt_dt,'yyyy-mm-dd') in ('2016-12-31');

        delete from compy_finance_last_y
		where company_id_last_y=61029 and to_char(rpt_dt_last_y,'yyyy-mm-dd') in ('2016-12-31');

        delete from compy_finance_bf_last_y
		where company_id_bf_last_y=61029 and to_char(rpt_dt_bf_last_y,'yyyy-mm-dd') in ('2016-12-31');

		delete from compy_factor_finance where company_id=61029 and to_char(rpt_dt,'yyyy-mm-dd') in ('2016-12-31');
		delete from compy_factor_finance where company_id=61029 and to_char(rpt_dt,'yyyy-mm-dd')='2015-12-31' and factor_cd='Size2';		
		delete from compy_factor_operation where company_id=61029 and to_char(rpt_dt,'yyyy-mm-dd')='2015-12-31';
		delete from bond_pledge where secinner_id=21544766;	 

		delete from rating_detail where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2016-12-31') ;
		delete from rating_display where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2016-12-31') ;
		delete from rating_factor where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2016-12-31') ;
		delete from rating_approv where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2016-12-31') ;
		delete from rating_adjustment_reason where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2016-12-31') ;
		delete from rating_record_log where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2016-12-31') ;
		delete from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2016-12-31';
		
		delete from rating_detail where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2015-12-31' and rating_type<>0) ;
		delete from rating_display where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2015-12-31' and rating_type<>0) ;
		delete from rating_factor where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2015-12-31' and rating_type<>0) ;
		delete from rating_approv where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2015-12-31'  and rating_type<>0) ;
		delete from rating_adjustment_reason where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2015-12-31' and rating_type<>0) ;
		delete from rating_record_log where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2015-12-31' and rating_type<>0) ;
		delete from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2015-12-31'  and rating_type<>0;	

		delete from bond_rating_detail where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where to_char(factor_dt,'yyyy-mm-dd')='2016-12-31' and secinner_id in 
					(select secinner_id from compy_security_xw where company_id=61029));
		delete from bond_rating_factor where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where to_char(factor_dt,'yyyy-mm-dd')='2016-12-31' and secinner_id in 
					(select secinner_id from compy_security_xw where company_id=61029));
		delete from bond_rating_xw where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where to_char(factor_dt,'yyyy-mm-dd')='2016-12-31' and secinner_id in 
					(select secinner_id from compy_security_xw  where company_id=61029));
		delete from bond_rating_approv where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where to_char(factor_dt,'yyyy-mm-dd')='2016-12-31' and secinner_id in 
					(select secinner_id from compy_security_xw where company_id=61029));
		delete from bond_rating_display where bond_rating_record_id in (select bond_rating_record_sid from bond_rating_record where to_char(factor_dt,'yyyy-mm-dd')='2016-12-31' and secinner_id in 
					(select secinner_id from compy_security_xw where company_id=61029));
		delete from bond_rating_record where to_char(factor_dt,'yyyy-mm-dd')='2016-12-31' and secinner_id in 
					(select secinner_id from compy_security_xw where company_id=61029);
					
		delete from bond_rating_detail where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where rating_type<>0 and to_char(factor_dt,'yyyy-mm-dd')='2015-12-31' and secinner_id in 
					(select secinner_id from compy_security_xw where company_id=61029));
		delete from bond_rating_factor where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where rating_type<>0 and to_char(factor_dt,'yyyy-mm-dd')='2015-12-31' and secinner_id in 
					(select secinner_id from compy_security_xw where company_id=61029));
		delete from bond_rating_xw where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where rating_type<>0 and to_char(factor_dt,'yyyy-mm-dd')='2015-12-31' and secinner_id in 
					(select secinner_id from compy_security_xw  where company_id=61029));
		delete from bond_rating_approv where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where rating_type<>0 and to_char(factor_dt,'yyyy-mm-dd')='2015-12-31' and secinner_id in 
					(select secinner_id from compy_security_xw where company_id=61029));
		delete from bond_rating_display where bond_rating_record_id in (select bond_rating_record_sid from bond_rating_record where rating_type<>0 and to_char(factor_dt,'yyyy-mm-dd')='2015-12-31' and secinner_id in 
					(select secinner_id from compy_security_xw where company_id=61029));
		delete from bond_rating_record where  rating_type<>0 and to_char(factor_dt,'yyyy-mm-dd')='2015-12-31' and secinner_id in 
					(select secinner_id from compy_security_xw where company_id=61029);
	
	
    --第二步：触发生成2015年参考评级, 保证 企业1 有2015年12月31日的参考评级
		--触发生成2015年参考评级	
		
		update rany_compy_factor_finance_0727
		set updt_dt=now()
		where company_id=61029 and to_char(rpt_dt,'yyyy-mm-dd')='2015-12-31' and factor_cd='Size2';
		
		
		insert into compy_factor_finance 
		select * from rany_compy_factor_finance_0727
		where company_id=61029 and to_char(rpt_dt,'yyyy-mm-dd')='2015-12-31' and factor_cd='Size2';
		
		--执行完后五分钟，可查看2015年参考评级

	--第三步：用2015年财务数据作为2016年财务数据推送
		select fn_drop_if_exist('case2016_compy_factor_finance_0728');	

		delete from compy_factor_finance where company_id=61029 and to_char(rpt_dt,'yyyy-mm-dd') in ('20161231') ;

		create table rany_compy_factor_finance_0728 as select * from  rany_compy_factor_finance_0727 where  company_id=61029 and to_char(rpt_dt,'yyyy-mm-dd')='2015-12-31' and factor_cd='Size2';

		update rany_compy_factor_finance_0728 
		set compy_factor_finance_sid=8000000000000+compy_factor_finance_sid,
			rpt_dt=to_date('2016-12-31','yyyy-mm-dd'),
			updt_dt=now();
			

		insert into compy_finance
		select * from rany_compy_finance_0801;

		insert into compy_finance_last_y
		select * from rany_compy_finance_last_y_0801;

		insert into compy_finance_bf_last_y
		select * from rany_compy_finance_bf_last_y_0801;
		
		insert into compy_factor_finance select * from rany_compy_factor_finance_0801 where to_char(rpt_dt,'yyyy-mm-dd')='2016-12-31' ;
		insert into compy_factor_finance select * from rany_compy_factor_finance_0728;

	--第四步：可在页面上查看评级结果，并且无预警
		--会触发企业2016年参考评级，因为两次参考评级无变动，所以应该无 主体参考评级变动提醒
		--会触发企业发行的所有债券2016年参考评级，因为两次参考评级无变动，所以应该无 债券参考评级变动提醒

	
--CASE2

	--第一步：清除已有2016年财务和评级数据
	delete from compy_factor_finance where company_id=61029 and to_char(rpt_dt,'yyyy-mm-dd')='2016-12-31' ;

	delete from rating_detail where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2016-12-31') ;
	delete from rating_display where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2016-12-31') ;
	delete from rating_factor where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2016-12-31') ;
	delete from rating_approv where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2016-12-31') ;
	delete from rating_adjustment_reason where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2016-12-31') ;
	delete from rating_record_log where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2016-12-31') ;
	delete from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2016-12-31';
	
	delete from bond_rating_detail where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where to_char(factor_dt,'yyyy-mm-dd')='2016-12-31' and secinner_id in 
                (select secinner_id from compy_security_xw where company_id=61029));
	delete from bond_rating_factor where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where to_char(factor_dt,'yyyy-mm-dd')='2016-12-31' and secinner_id in 
                (select secinner_id from compy_security_xw where company_id=61029));
	delete from bond_rating_xw where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where to_char(factor_dt,'yyyy-mm-dd')='2016-12-31' and secinner_id in 
                (select secinner_id from compy_security_xw  where company_id=61029));
	delete from bond_rating_approv where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where to_char(factor_dt,'yyyy-mm-dd')='2016-12-31' and secinner_id in 
                (select secinner_id from compy_security_xw where company_id=61029));
	delete from bond_rating_display where bond_rating_record_id in (select bond_rating_record_sid from bond_rating_record where to_char(factor_dt,'yyyy-mm-dd')='2016-12-31' and secinner_id in 
                (select secinner_id from compy_security_xw where company_id=61029));
    delete from bond_rating_record where to_char(factor_dt,'yyyy-mm-dd')='2016-12-31' and secinner_id in 
                (select secinner_id from compy_security_xw where company_id=61029);
	
	--第二步：查看页面上只有2015年12月31日的参考评级
	--第三步：2016年财务数据推送

	select fn_drop_if_exist('rany_compy_factor_finance_0728');

    create table rany_compy_factor_finance_0728 as select * from  rany_compy_factor_finance_0727 where  company_id=61029 and to_char(rpt_dt,'yyyy-mm-dd')='2016-12-31' and factor_cd='Size2';

	update rany_compy_factor_finance_0728 
	set compy_factor_finance_sid=8000000000000+compy_factor_finance_sid,
		updt_dt=now();
    
	insert into compy_factor_finance select * from rany_compy_factor_finance_0801  where to_char(rpt_dt,'yyyy-mm-dd')='2016-12-31' ;
	insert into compy_factor_finance select * from rany_compy_factor_finance_0728;
		
	  
     
	--第四步：过5-10分钟，页面上能看到2016参考评级，因为两次参考评级有变动，所以应该产生 主体参考评级变动提醒
	--更新该企业发行的所有债券参考评级，因为两次参考评级有变动，所以应该产生 债券参考评级变动提醒
    --五条预警记录，4条债券，1条企业
	

--CASE3：

	--第一步：清除已有2016年财务和评级数据
	delete from compy_factor_finance where company_id=61029 and to_char(rpt_dt,'yyyy-mm-dd')='2016-12-31' ;
	delete from rating_change_warning;
	
	delete from rating_detail where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2016-12-31') ;
	delete from rating_display where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2016-12-31') ;
	delete from rating_factor where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2016-12-31') ;
	delete from rating_approv where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2016-12-31') ;
	delete from rating_adjustment_reason where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2016-12-31') ;
	delete from rating_record_log where rating_record_id in (select rating_record_id from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2016-12-31') ;
	delete from rating_record where company_id=61029 and to_char(factor_dt,'yyyy-mm-dd')='2016-12-31';

	
	delete from bond_rating_detail where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where to_char(factor_dt,'yyyy-mm-dd')='2016-12-31' and secinner_id in 
                (select secinner_id from compy_security_xw where company_id=61029));
	delete from bond_rating_factor where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where to_char(factor_dt,'yyyy-mm-dd')='2016-12-31' and secinner_id in 
                (select secinner_id from compy_security_xw where company_id=61029));
	delete from bond_rating_xw where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where to_char(factor_dt,'yyyy-mm-dd')='2016-12-31' and secinner_id in 
                (select secinner_id from compy_security_xw  where company_id=61029));
	delete from bond_rating_approv where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where to_char(factor_dt,'yyyy-mm-dd')='2016-12-31' and secinner_id in 
                (select secinner_id from compy_security_xw where company_id=61029));
	delete from bond_rating_display where bond_rating_record_id in (select bond_rating_record_sid from bond_rating_record where to_char(factor_dt,'yyyy-mm-dd')='2016-12-31' and secinner_id in 
                (select secinner_id from compy_security_xw where company_id=61029));
	delete from bond_rating_record where to_char(factor_dt,'yyyy-mm-dd')='2016-12-31' and secinner_id in 
                (select secinner_id from compy_security_xw where company_id=61029);
	--第二步：保证 企业1 有2015年12月31日的参考评级
	--第三步：用2015年数据作为2016年财务数据推送
	
    select fn_drop_if_exist('rany_compy_factor_finance_0728');
	
    create table rany_compy_factor_finance_0728 as select * from  rany_compy_factor_finance_0727 where  company_id=61029 and to_char(rpt_dt,'yyyy-mm-dd')='2015-12-31' and factor_cd='Size2';

	update rany_compy_factor_finance_0728 
	set compy_factor_finance_sid=8000000000000+compy_factor_finance_sid,
	    rpt_dt=to_date('2016-12-31','yyyy-mm-dd'),
		updt_dt=now();
    
	insert into compy_factor_finance select * from rany_compy_factor_finance_0801  where to_char(rpt_dt,'yyyy-mm-dd')='2016-12-31' ;
	insert into compy_factor_finance select * from rany_compy_factor_finance_0728;

	--第四步：5-10分钟，产生2016年参考评级，因为两次参考评级无变动，所以应该无预警
	--第五步：修改债券A的抵押品信息 --16云白01
	
	DELETE FROM bond_pledge WHERE SECINNER_ID=17149817;	 
	INSERT INTO "public"."bond_pledge" 
	select '1000800000099', '17149817', '2017-05-19', '上市公司流通A股股票', '6786', NULL, NULL, NULL, '10', NULL, '6583', '6580', '110000', null, '0', NULL, 'CSCS', '0', now();
 
	--第六步 5-10分钟确认因两次债券参考评级有变动，所以应该产生 债券参考评级变动提醒
	---1条预警
	