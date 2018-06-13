/*
问题：指标的经济含义有误
*/
--以下为修复方案，中证模拟环境已验证通过

--执行数据库：cs_master_tgt

--更新指标：总资产收益率的描述内容
update factor set description='总资产收益率是指净利润与资产总计的比率，它反映每1元总资产创造的净利润，值越大，盈利能力越强' where factor_cd='factor_123';
--更新指标：应收账款占比的描述内容
update factor set description='城投企业在参与政府建设过程中的建设款是计入应收账款。应收账款越高表明地方政府对平台的资金占用程度越高，企业的资产质量越差，信用风险越高。' where factor_cd='factor_513';
