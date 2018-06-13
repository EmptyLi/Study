--准备工作
	--配置敞口负责人
	--确保敞口负责人没有相关企业的任务，如果有先处理掉
	--有效日期设置，设置成以后的日期
	--第一步 删除2016 2015年评级记录
	select * from bond_position;
	delete from bond_position where secinner_id=21514088;

	delete from compy_finance where company_id=314772 and rpt_dt >= '20161231' ;
	delete from compy_finance_last_y where company_id_last_y=314772 and rpt_dt_last_y >= '20161231';
	delete from compy_finance_bf_last_y where company_id_bf_last_y=314772 and rpt_dt_bf_last_y >= '20161231';
	delete from bond_position where secinner_id=21514088;
	delete from compy_factor_finance where company_id=314772 and rpt_dt='2016-12-31';
	delete from compy_factor_operation where company_id=314772 and rpt_dt='2016-12-31';
	delete from task where workflow_sid in (select workflow_sid from  workflow where tgt_nm='安徽省投资集团控股有限公司');
	delete from workflow where tgt_nm='安徽省投资集团控股有限公司';

	delete from rating_detail where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2016-12-31') ;
	delete from rating_display where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2016-12-31') ;
	delete from rating_factor where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2016-12-31') ;
	delete from rating_approv where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2016-12-31') ;
	delete from rating_adjustment_reason where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2016-12-31') ;
	delete from rating_record_log where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2016-12-31') ;
	delete from rating_record where company_id=314772 and factor_dt='2016-12-31';

	delete from rating_detail where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2015-12-31') ;
	delete from rating_display where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2015-12-31') ;
	delete from rating_factor where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2015-12-31') ;
	delete from rating_approv where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2015-12-31') ;
	delete from rating_adjustment_reason where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2015-12-31') ;
	delete from rating_record_log where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2015-12-31') ;
	delete from rating_record where company_id=314772 and factor_dt='2015-12-31';

	delete from bond_rating_detail where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where secinner_id in
			(select secinner_id from compy_security_xw where company_id=314772));
	delete from bond_rating_factor where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where secinner_id in
			(select secinner_id from compy_security_xw where company_id=314772));
	delete from bond_rating_xw where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where secinner_id in
			(select secinner_id from compy_security_xw  where company_id=314772));
	delete from bond_rating_approv where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where secinner_id in
			(select secinner_id from compy_security_xw where company_id=314772));
	delete from bond_rating_display where bond_rating_record_id in (select bond_rating_record_sid from bond_rating_record where secinner_id in
			(select secinner_id from compy_security_xw where company_id=314772));
	delete from bond_rating_record where secinner_id in
			(select secinner_id from compy_security_xw where company_id=314772);

	--测试检查：“安徽省投资集团控股有限公司”所有主体评级/债券评级已清除
	--第二步：手动认定“安徽省投资集团控股有限公司”企业和债券2015年财报的认定评级，生成主体2015年基础和认定评级， 债券2015年基础和认定评级
	--第三步：清除“16皖投02”

	delete from bond_rating_detail where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where secinner_id=21514088);
	delete from bond_rating_factor where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where secinner_id=21514088);
	delete from bond_rating_xw where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where secinner_id=21514088);
	delete from bond_rating_approv where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where secinner_id=21514088);
	delete from bond_rating_display where bond_rating_record_id in (select bond_rating_record_sid from bond_rating_record where secinner_id=21514088);
	delete from bond_rating_record where secinner_id=21514088;

	--删除16皖投02, 跑完这个语句后债券列表查询不到这只债
       update bond_basicinfo
       set isdel=1
       where secinner_id=21514088 and security_snm='16皖投02';

       --重新插回16皖投02, 跑完这个语句后债券列表可以查询这只债，并且能触发这只债产生基础评级（需要等5分钟左右）
      update bond_basicinfo
      set isdel=0,
      updt_dt=clock_timestamp()
      where secinner_id=21514088 and security_snm='16皖投02';

--4.1 都是执行以下： 将该只债券X放入EDW清单中，由数据组同事进行数据推送
    delete from bond_position where secinner_id=21514088;
	insert into bond_position select '136639', '2875', '16皖投02', '21514088', '0', '0', '0', 'BB', 'BB', '2016-12-16', '2016-12-15', '0', 'CSDC', now();
	--等5-10分钟，触发评级认定任务

--4.2 都是执行以下： 将该只债券X放入EDW清单中，由数据组同事进行数据推送
	--不用操作，等5分钟即可
    --等5-10分钟，不会触发新任务，完成认定2015年财报，“16皖投02”有2015年认定评级

--4.3 都是执行以下： 将该只债券X放入EDW清单中，由数据组同事进行数据推送
	--不用操作，等5分钟即可
    --等5-10分钟，没有任务产生

--4.4 由数据组同事模拟数据（将企业X的2015年财报当做2016年的），进行数据推送，确保评级结果不会发生变化。
	select fn_drop_if_exist('case2016_compy_finance_0518');
	select fn_drop_if_exist('case2016_compy_finance_last_y_0518');
	select fn_drop_if_exist('case2016_compy_finance_bf_last_y_0518');
	select fn_drop_if_exist('case2016_compy_factor_finance_0518');

	delete from rating_detail where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2016-12-31') ;
	delete from rating_display where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2016-12-31') ;
	delete from rating_factor where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2016-12-31') ;
	delete from rating_approv where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2016-12-31') ;
	delete from rating_adjustment_reason where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2016-12-31') ;
	delete from rating_record_log where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2016-12-31') ;
	delete from rating_record where company_id=314772 and factor_dt='2016-12-31';


	delete from bond_rating_detail where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where factor_dt='2016-12-31' and secinner_id in
                (select secinner_id from compy_security_xw where company_id=314772));
	delete from bond_rating_factor where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where factor_dt='2016-12-31' and secinner_id in
                (select secinner_id from compy_security_xw where company_id=314772));
	delete from bond_rating_xw where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where factor_dt='2016-12-31' and secinner_id in
                (select secinner_id from compy_security_xw  where company_id=314772));
	delete from bond_rating_approv where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where factor_dt='2016-12-31' and secinner_id in
                (select secinner_id from compy_security_xw where company_id=314772));
	delete from bond_rating_display where bond_rating_record_id in (select bond_rating_record_sid from bond_rating_record where factor_dt='2016-12-31' and secinner_id in
                (select secinner_id from compy_security_xw where company_id=314772));
	delete from bond_rating_record where factor_dt='2016-12-31' and secinner_id in
                (select secinner_id from compy_security_xw where company_id=314772);

   delete from compy_factor_finance where company_id=314772 and rpt_dt='2016-12-31';
	delete from compy_factor_operation where company_id=314772 and rpt_dt='2016-12-31';

	delete from compy_finance where company_id=314772 and rpt_dt in ('20161231') ;
	delete from compy_finance_last_y where company_id_last_y=314772 and rpt_dt_last_y in ('20161231');
	delete from compy_finance_bf_last_y where company_id_bf_last_y=314772 and rpt_dt_bf_last_y in ('20161231');

	create table case2016_compy_finance_0518 as select* from case_compy_finance_0518 where company_id=314772 and rpt_dt in ('20151231');
	create table case2016_compy_finance_last_y_0518 as select* from case_compy_finance_last_y_0518 where company_id_last_y=314772 and rpt_dt_last_y in ('20151231');
	create table case2016_compy_finance_bf_last_y_0518 as select* from case_compy_finance_bf_last_y_0518 where company_id_bf_last_y=314772 and rpt_dt_bf_last_y in ('20151231');
	create table case2016_compy_factor_finance_0518 as select * from  case_compy_factor_finance_0518 where  company_id=314772 and rpt_dt='2015-12-31' and factor_cd='LGFV_ReceivableRatio';

    update case2016_compy_finance_0518
	set
		fst_notice_dt='2017-05-22',
		latest_notice_dt='2017-05-22',
		rpt_dt='2016-12-31',
		start_dt=20160101,
		end_dt=20161231,
		updt_by=0,
		updt_dt=now();

	update case2016_compy_finance_last_y_0518
	set rpt_dt_last_y='2016-12-31',
		updt_by_last_y=0,
		updt_dt_last_y=now();


	update case2016_compy_finance_bf_last_y_0518
	set rpt_dt_bf_last_y='2016-12-31',
		updt_by_bf_last_y=0,
		updt_dt_bf_last_y=now();

	update case2016_compy_factor_finance_0518
	set compy_factor_finance_sid=8000000000000+compy_factor_finance_sid,
	    rpt_dt='2016-12-31',
		updt_dt=now();

	begin transaction;
	  insert into compy_finance select * from case2016_compy_finance_0518;
	  insert into compy_finance_last_y select * from case2016_compy_finance_last_y_0518;
	  insert into compy_finance_bf_last_y select * from case2016_compy_finance_bf_last_y_0518;
	  insert into compy_factor_operation select * from compy_factor_operation_0518;
	  insert into compy_factor_finance select * from case2016_compy_factor_finance_0518;
	commit;

	--10分钟后可以看到主体2016年基础评级和一条机器评级且是系统自动认定, 没有任务


--4.5 由数据组同事清除[4.4]的操作数据，插入企业X真实的2016年财务数据并进行推送，使评级结果发生变化。

	--4.5.1 先删除已有的2016年财务数据和评级结果
	select fn_drop_if_exist('case2016_compy_finance_0518');
	select fn_drop_if_exist('case2016_compy_finance_last_y_0518');
	select fn_drop_if_exist('case2016_compy_finance_bf_last_y_0518');
	select fn_drop_if_exist('case2016_compy_factor_finance_0518');


	delete from rating_detail where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2016-12-31') ;
	delete from rating_display where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2016-12-31') ;
	delete from rating_factor where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2016-12-31') ;
	delete from rating_approv where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2016-12-31') ;
	delete from rating_adjustment_reason where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2016-12-31') ;
	delete from rating_record_log where rating_record_id in (select rating_record_id from rating_record where company_id=314772 and factor_dt='2016-12-31') ;
	delete from rating_record where company_id=314772 and factor_dt='2016-12-31';


	delete from bond_rating_detail where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where factor_dt='2016-12-31' and secinner_id in
                (select secinner_id from compy_security_xw where company_id=314772));
	delete from bond_rating_factor where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where factor_dt='2016-12-31' and secinner_id in
                (select secinner_id from compy_security_xw where company_id=314772));
	delete from bond_rating_xw where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where factor_dt='2016-12-31' and secinner_id in
                (select secinner_id from compy_security_xw  where company_id=314772));
	delete from bond_rating_approv where bond_rating_record_sid in (select bond_rating_record_sid from bond_rating_record where factor_dt='2016-12-31' and secinner_id in
                (select secinner_id from compy_security_xw where company_id=314772));
	delete from bond_rating_display where bond_rating_record_id in (select bond_rating_record_sid from bond_rating_record where factor_dt='2016-12-31' and secinner_id in
                (select secinner_id from compy_security_xw where company_id=314772));
	delete from bond_rating_record where factor_dt='2016-12-31' and secinner_id in
                (select secinner_id from compy_security_xw where company_id=314772);


    delete from compy_factor_finance where company_id=314772 and rpt_dt='2016-12-31';
	delete from compy_factor_operation where company_id=314772 and rpt_dt='2016-12-31';

	delete from compy_finance where company_id=314772 and rpt_dt in ('20161231') ;
	delete from compy_finance_last_y where company_id_last_y=314772 and rpt_dt_last_y in ('20161231');
	delete from compy_finance_bf_last_y where company_id_bf_last_y=314772 and rpt_dt_bf_last_y in ('20161231');

	--4.5.2 停顿5分钟，因为已有的2015年评级结果是失效的，所以会触发生成2015年的认定任务，然后处理掉

	--4.5.3 确认企业已有2015年认定评级之后，继续插入2016年财务数据
	create table case2016_compy_finance_0518 as select* from case_compy_finance_0518 where  company_id=314772 and  rpt_dt in ('20161231');
	create table case2016_compy_finance_last_y_0518 as select* from case_compy_finance_last_y_0518 where company_id_last_y=314772 and rpt_dt_last_y in ('20161231');
	create table case2016_compy_finance_bf_last_y_0518 as select* from case_compy_finance_bf_last_y_0518 where company_id_bf_last_y=314772 and rpt_dt_bf_last_y in ('20161231');
	create table case2016_compy_factor_finance_0518 as select * from  case_compy_factor_finance_0518 where  company_id=314772 and rpt_dt='2016-12-31' and factor_cd='LGFV_ReceivableRatio';

	update case2016_compy_finance_0518
	set updt_by=0,
		updt_dt=now();

	update case2016_compy_finance_last_y_0518
	set updt_by_last_y=0,
		updt_dt_last_y=now();

	update case2016_compy_finance_bf_last_y_0518
	set updt_by_bf_last_y=0,
		updt_dt_bf_last_y=now();

	update case2016_compy_factor_finance_0518
	set rpt_dt='2016-12-31',
		updt_dt=now();

	begin transaction;
	insert into compy_finance select * from case2016_compy_finance_0518;
	insert into compy_finance_last_y select * from case2016_compy_finance_last_y_0518;
	insert into compy_finance_bf_last_y select * from case2016_compy_finance_bf_last_y_0518;

	insert into compy_factor_operation select * from compy_factor_operation_0518;
	insert into compy_factor_finance select * from case2016_compy_factor_finance_0518;

	commit;
	--10分钟后可以看到2016年财报认定任务， 先不进行评级任务处理


--4.6 重新插入2016年财务数据

	select fn_drop_if_exist('case2016_compy_finance_0518');
	select fn_drop_if_exist('case2016_compy_finance_last_y_0518');
	select fn_drop_if_exist('case2016_compy_finance_bf_last_y_0518');
	select fn_drop_if_exist('case2016_compy_factor_finance_0518');

    delete from compy_factor_finance where company_id=314772 and rpt_dt='2016-12-31';
	delete from compy_factor_operation where company_id=314772 and rpt_dt='2016-12-31';

	delete from compy_finance where company_id=314772 and rpt_dt in ('20161231') ;
	delete from compy_finance_last_y where company_id_last_y=314772 and rpt_dt_last_y in ('20161231');
	delete from compy_finance_bf_last_y where company_id_bf_last_y=314772 and rpt_dt_bf_last_y in ('20161231');

	create table case2016_compy_finance_0518 as select* from case_compy_finance_0518 where  company_id=314772 and  rpt_dt in ('20161231');
	create table case2016_compy_finance_last_y_0518 as select* from case_compy_finance_last_y_0518 where company_id_last_y=314772 and rpt_dt_last_y in ('20161231');
	create table case2016_compy_finance_bf_last_y_0518 as select* from case_compy_finance_bf_last_y_0518 where company_id_bf_last_y=314772 and rpt_dt_bf_last_y in ('20161231');
	create table case2016_compy_factor_finance_0518 as select * from  case_compy_factor_finance_0518 where  company_id=314772 and rpt_dt='2016-12-31' and factor_cd='LGFV_ReceivableRatio';

	update case2016_compy_finance_0518
	set updt_by=0,
		updt_dt=now();

	update case2016_compy_finance_last_y_0518
	set updt_by_last_y=0,
		updt_dt_last_y=now();

	update case2016_compy_finance_bf_last_y_0518
	set updt_by_bf_last_y=0,
		updt_dt_bf_last_y=now();

	update case2016_compy_factor_finance_0518
	set rpt_dt='2016-12-31',
		updt_dt=now();

	begin transaction;

	insert into compy_finance select * from case2016_compy_finance_0518;
	insert into compy_finance_last_y select * from case2016_compy_finance_last_y_0518;
	insert into compy_finance_bf_last_y select * from case2016_compy_finance_bf_last_y_0518;

	insert into compy_factor_operation select * from compy_factor_operation_0518;
	insert into compy_factor_finance select * from case2016_compy_factor_finance_0518;

	commit;
	--10分钟后没有新的任务, 完成认定任务

--Case5: 	到期日前5日触发EDW清单企业的评级任务

--在系统中配置到期日前 5 天触发评级认定任务
--并设置失效日期为测试日前五天
--失效日期：5月28日

--企业：富锦市锦程城市基础设施建设投资有限公司

insert into bond_position select '104918', '2875', '14黑重建', '17362557', '0', '0', '0', 'BB', 'BB', '2015-12-16', '2015-12-15', '0', 'CSDC', now();
select * from bond_position;

---5-10分钟后检查收到任务

--数据清理和复原以不影响下次测试
--失效日期恢复回原来的设定（测试日期之后）以免影响后续的测试
        delete from bond_position where secinner_id=17362557;
	delete from task where workflow_sid in (select workflow_sid from  workflow where tgt_nm='富锦市锦程城市基础设施建设投资有限公司');
	delete from workflow where tgt_nm='富锦市锦程城市基础设施建设投资有限公司';
