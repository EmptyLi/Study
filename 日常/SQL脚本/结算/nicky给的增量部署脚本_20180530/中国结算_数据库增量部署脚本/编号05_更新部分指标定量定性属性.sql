--根据收数团队的反馈，中国结算有五个指标定量需改为定性
--执行数据库：cs_master_tgt

--备份指标表
create table factor_fix_05 as select * from factor;

--更新指标的定量定性属性
update factor set factor_category_cd=1 where  factor_cd in ('factor_019','factor_021','factor_052','factor_005','factor_008');

--备份企业定量指标表
create table compy_factor_finance_fix_05 as select * from compy_factor_finance;

--从企业定量指标表中删除涉及的数据，这部分数据将通过数据同步迁移到compy_factor_operation表中
delete from compy_factor_finance where  factor_cd in ('factor_019','factor_021','factor_052','factor_005','factor_008');

--QC检查

--检查5个指标是否已更改为定性(factor_category_cd为1)
select count(*) from factor where factor_cd in ('factor_019','factor_021','factor_052','factor_005','factor_008') and factor_category_cd=1;--应该返回6条

--检查企业定量指标表中是否已删除以上五个指标的数据
select count(*) from compy_factor_finance where  factor_cd in ('factor_019','factor_021','factor_052','factor_005','factor_008');--应该返回0条

--检查通过后，清除备份表
drop table factor_fix_05;

drop table compy_factor_finance_fix_05;

--中证将通过推数通道重新推送该5个指标数据
