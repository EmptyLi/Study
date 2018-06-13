update lkp_finance_check_rule 
set formula_ch = 'ABS(营业利润  - ( 营业总收入 - 营业总成本 + 加:公允价值变动收益 + 加:投资收益 + 加:汇兑收益 + 营业利润其他项目+其他收益 + 资产处置收益))<=110',
formula_en='ABS(operate_profit-(total_operate_reve-total_operate_exp+fvalue_income+invest_income+exchange_income+operate_profit_other+other_miincome+adisposal_income))<=110',
remark ='利润表新增两个财务科目：其他收益和资产处置收益',
updt_dt=sysdate
where check_cd='GIS01';