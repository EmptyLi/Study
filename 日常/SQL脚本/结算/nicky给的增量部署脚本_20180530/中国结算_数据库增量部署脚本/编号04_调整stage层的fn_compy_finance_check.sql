CREATE OR REPLACE FUNCTION "public"."fn_compy_finance_check"()
  RETURNS "pg_catalog"."int4" AS $BODY$
  /*
-------------------------------------------------------------------------------------------------
Stored Procedure Name:    fn_compy_finance_check
Parameter:
Example:                  select fn_compy_finance_check()
Author:                   Nicky Shang
Created Date:             2017-04-13
Description:              财务数据勾稽校对(Master Staging层)
Output:                   
Modification:
-------------------------------------------------------------------------------------------------
*/
DECLARE
vSTART_DT TIMESTAMP;
vEND_DT TIMESTAMP;
vSQL VARCHAR(32000);
vSQL1 VARCHAR(32700);
vSQL2 VARCHAR(32000);
vSQL_temp VARCHAR(32000);
vin_updcount integer;
vin_updcount_temp integer;
L record;
I record;

BEGIN

--为变量赋值
vSTART_DT := clock_timestamp();


PERFORM fn_drop_if_exist('wrk_compy_balancesheet');
CREATE TABLE wrk_compy_balancesheet
AS
select
record_sid,
compy_balancesheet_sid,
fst_notice_dt,
latest_notice_dt,
company_id,
rpt_dt,
start_dt,
end_dt,
rpt_timetype_cd,
combine_type_cd,
rpt_srctype_id,
data_ajust_type,
data_type,
is_public_rpt,
company_type,
currency,
coalesce(monetary_fund,0)AS    monetary_fund,
coalesce(tradef_asset,0)AS    tradef_asset,
coalesce(bill_rec,0)AS    bill_rec,
coalesce(account_rec,0)AS    account_rec,
coalesce(other_rec,0)AS    other_rec,
coalesce(advance_pay,0)AS    advance_pay,
coalesce(dividend_rec,0)AS    dividend_rec,
coalesce(interest_rec,0)AS    interest_rec,
coalesce(inventory,0)AS    inventory,
coalesce(nonl_asset_oneyear,0)AS    nonl_asset_oneyear,
coalesce(defer_expense,0)AS    defer_expense,
coalesce(other_lasset,0)AS    other_lasset,
coalesce(lasset_other,0)AS    lasset_other,
coalesce(lasset_balance,0)AS    lasset_balance,
coalesce(sum_lasset,0)AS    sum_lasset,
coalesce(saleable_fasset,0)AS    saleable_fasset,
coalesce(held_maturity_inv,0)AS    held_maturity_inv,
coalesce(estate_invest,0)AS    estate_invest,
coalesce(lte_quity_inv,0)AS    lte_quity_inv,
coalesce(ltrec,0)AS    ltrec,
coalesce(fixed_asset,0)AS    fixed_asset,
coalesce(construction_material,0)AS    construction_material,
coalesce(construction_progress,0)AS    construction_progress,
coalesce(liquidate_fixed_asset,0)AS    liquidate_fixed_asset,
coalesce(product_biology_asset,0)AS    product_biology_asset,
coalesce(oilgas_asset,0)AS    oilgas_asset,
coalesce(intangible_asset,0)AS    intangible_asset,
coalesce(develop_exp,0)AS    develop_exp,
coalesce(good_will,0)AS    good_will,
coalesce(ltdefer_asset,0)AS    ltdefer_asset,
coalesce(defer_incometax_asset,0)AS    defer_incometax_asset,
coalesce(other_nonl_asset,0)AS    other_nonl_asset,
coalesce(nonlasset_other,0)AS    nonlasset_other,
coalesce(nonlasset_balance,0)AS    nonlasset_balance,
coalesce(sum_nonl_asset,0)AS    sum_nonl_asset,
coalesce(cash_and_depositcbank,0)AS    cash_and_depositcbank,
coalesce(deposit_infi,0)AS    deposit_infi,
coalesce(fi_deposit,0)AS    fi_deposit,
coalesce(precious_metal,0)AS    precious_metal,
coalesce(lend_fund,0)AS    lend_fund,
coalesce(derive_fasset,0)AS    derive_fasset,
coalesce(buy_sellback_fasset,0)AS    buy_sellback_fasset,
coalesce(loan_advances,0)AS    loan_advances,
coalesce(agency_assets,0)AS    agency_assets,
coalesce(premium_rec,0)AS    premium_rec,
coalesce(subrogation_rec,0)AS    subrogation_rec,
coalesce(ri_rec,0)AS    ri_rec,
coalesce(undue_rireserve_rec,0)AS    undue_rireserve_rec,
coalesce(claim_rireserve_rec,0)AS    claim_rireserve_rec,
coalesce(life_rireserve_rec,0)AS    life_rireserve_rec,
coalesce(lthealth_rireserve_rec,0)AS    lthealth_rireserve_rec,
coalesce(gdeposit_pay,0)AS    gdeposit_pay,
coalesce(insured_pledge_loan,0)AS    insured_pledge_loan,
coalesce(capitalg_deposit_pay,0)AS    capitalg_deposit_pay,
coalesce(independent_asset,0)AS    independent_asset,
coalesce(client_fund,0)AS    client_fund,
coalesce(settlement_provision,0)AS    settlement_provision,
coalesce(client_provision,0)AS    client_provision,
coalesce(seat_fee,0)AS    seat_fee,
coalesce(other_asset,0)AS    other_asset,
coalesce(asset_other,0)AS    asset_other,
coalesce(asset_balance,0)AS    asset_balance,
coalesce(sum_asset,0)AS    sum_asset,
coalesce(st_borrow,0)AS    st_borrow,
coalesce(trade_fliab,0)AS    trade_fliab,
coalesce(bill_pay,0)AS    bill_pay,
coalesce(account_pay,0)AS    account_pay,
coalesce(advance_receive,0)AS    advance_receive,
coalesce(salary_pay,0)AS    salary_pay,
coalesce(tax_pay,0)AS    tax_pay,
coalesce(interest_pay,0)AS    interest_pay,
coalesce(dividend_pay,0)AS    dividend_pay,
coalesce(other_pay,0)AS    other_pay,
coalesce(accrue_expense,0)AS    accrue_expense,
coalesce(anticipate_liab,0)AS    anticipate_liab,
coalesce(defer_income,0)AS    defer_income,
coalesce(nonl_liab_oneyear,0)AS    nonl_liab_oneyear,
coalesce(other_lliab,0)AS    other_lliab,
coalesce(lliab_other,0)AS    lliab_other,
coalesce(lliab_balance,0)AS    lliab_balance,
coalesce(sum_lliab,0)AS    sum_lliab,
coalesce(lt_borrow,0)AS    lt_borrow,
coalesce(bond_pay,0)AS    bond_pay,
coalesce(lt_account_pay,0)AS    lt_account_pay,
coalesce(special_pay,0)AS    special_pay,
coalesce(defer_incometax_liab,0)AS    defer_incometax_liab,
coalesce(other_nonl_liab,0)AS    other_nonl_liab,
coalesce(nonl_liab_other,0)AS    nonl_liab_other,
coalesce(nonl_liab_balance,0)AS    nonl_liab_balance,
coalesce(sum_nonl_liab,0)AS    sum_nonl_liab,
coalesce(borrow_from_cbank,0)AS    borrow_from_cbank,
coalesce(borrow_fund,0)AS    borrow_fund,
coalesce(derive_financedebt,0)AS    derive_financedebt,
coalesce(sell_buyback_fasset,0)AS    sell_buyback_fasset,
coalesce(accept_deposit,0)AS    accept_deposit,
coalesce(agency_liab,0)AS    agency_liab,
coalesce(other_liab,0)AS    other_liab,
coalesce(premium_advance,0)AS    premium_advance,
coalesce(comm_pay,0)AS    comm_pay,
coalesce(ri_pay,0)AS    ri_pay,
coalesce(gdeposit_rec,0)AS    gdeposit_rec,
coalesce(insured_deposit_inv,0)AS    insured_deposit_inv,
coalesce(undue_reserve,0)AS    undue_reserve,
coalesce(claim_reserve,0)AS    claim_reserve,
coalesce(life_reserve,0)AS    life_reserve,
coalesce(lt_health_reserve,0)AS    lt_health_reserve,
coalesce(independent_liab,0)AS    independent_liab,
coalesce(pledge_borrow,0)AS    pledge_borrow,
coalesce(agent_trade_security,0)AS    agent_trade_security,
coalesce(agent_uw_security,0)AS    agent_uw_security,
coalesce(liab_other,0)AS    liab_other,
coalesce(liab_balance,0)AS    liab_balance,
coalesce(sum_liab,0)AS    sum_liab,
coalesce(share_capital,0)AS    share_capital,
coalesce(capital_reserve,0)AS    capital_reserve,
coalesce(surplus_reserve,0)AS    surplus_reserve,
coalesce(retained_earning,0)AS    retained_earning,
coalesce(inventory_share,0)AS    inventory_share,
coalesce(general_risk_prepare,0)AS    general_risk_prepare,
coalesce(diff_conversion_fc,0)AS    diff_conversion_fc,
coalesce(minority_equity,0)AS    minority_equity,
coalesce(sh_equity_other,0)AS    sh_equity_other,
coalesce(sh_equity_balance,0)AS    sh_equity_balance,
coalesce(sum_parent_equity,0)AS    sum_parent_equity,
coalesce(sum_sh_equity,0)AS    sum_sh_equity,
coalesce(liabsh_equity_other,0)AS    liabsh_equity_other,
coalesce(liabsh_equity_balance,0)AS    liabsh_equity_balance,
coalesce(sum_liabsh_equity,0)AS    sum_liabsh_equity,
coalesce(td_eposit,0)AS    td_eposit,
coalesce(st_bond_rec,0)AS    st_bond_rec,
coalesce(claim_pay,0)AS    claim_pay,
coalesce(policy_divi_pay,0)AS    policy_divi_pay,
coalesce(unconfirm_inv_loss,0)AS    unconfirm_inv_loss,
coalesce(ricontact_reserve_rec,0)AS    ricontact_reserve_rec,
coalesce(deposit,0)AS    deposit,
coalesce(contact_reserve,0)AS    contact_reserve,
coalesce(invest_rec,0)AS    invest_rec,
coalesce(specia_lreserve,0)AS    specia_lreserve,
coalesce(subsidy_rec,0)AS    subsidy_rec,
coalesce(marginout_fund,0)AS    marginout_fund,
coalesce(export_rebate_rec,0)AS    export_rebate_rec,
coalesce(defer_income_oneyear,0)AS    defer_income_oneyear,
coalesce(lt_salary_pay,0)AS    lt_salary_pay,
--coalesce(fvalue_fasset,0)AS    fvalue_fasset,
CASE WHEN coalesce(fvalue_fasset,0)<>0 then fvalue_fasset else coalesce(tradef_asset,0) END AS fvalue_fasset,
coalesce(define_fvalue_fasset,0)AS    define_fvalue_fasset,
coalesce(internal_rec,0)AS    internal_rec,
coalesce(clheld_sale_ass,0)AS    clheld_sale_ass,
--coalesce(fvalue_fliab,0)AS    fvalue_fliab,
CASE WHEN coalesce(fvalue_fliab,0)<>0 then fvalue_fliab else coalesce(trade_fliab,0) END AS fvalue_fliab,
coalesce(define_fvalue_fliab,0)AS    define_fvalue_fliab,
coalesce(internal_pay,0)AS    internal_pay,
coalesce(clheld_sale_liab,0)AS    clheld_sale_liab,
coalesce(anticipate_lliab,0)AS    anticipate_lliab,
coalesce(other_equity,0)AS    other_equity,
coalesce(other_cincome,0)AS    other_cincome,
coalesce(plan_cash_divi,0)AS    plan_cash_divi,
coalesce(parent_equity_other,0)AS    parent_equity_other,
coalesce(parent_equity_balance,0)AS    parent_equity_balance,
coalesce(preferred_stock,0)AS    preferred_stock,
coalesce(prefer_stoc_bond,0)AS    prefer_stoc_bond,
coalesce(cons_biolo_asset,0)AS    cons_biolo_asset,
coalesce(stock_num_end,0)AS    stock_num_end,
coalesce(net_mas_set,0)AS    net_mas_set,
coalesce(outward_remittance,0)AS    outward_remittance,
coalesce(cdandbill_rec,0)AS    cdandbill_rec,
coalesce(hedge_reserve,0)AS    hedge_reserve,
coalesce(suggest_assign_divi,0)AS    suggest_assign_divi,
coalesce(marginout_security,0)AS    marginout_security,
coalesce(cagent_trade_security,0)AS    cagent_trade_security,
coalesce(trade_risk_prepare,0)AS    trade_risk_prepare,
coalesce(creditor_planinv,0)AS    creditor_planinv,
coalesce(short_financing,0)AS    short_financing,
coalesce(receivables,0)AS    receivables,
chk_status
from stg_compy_balancesheet;

PERFORM fn_drop_if_exist('wrk_compy_incomestate');
CREATE TABLE wrk_compy_incomestate
AS
select
record_sid,
    compy_incomestate_sid,
    first_notice_dt,
    latest_notice_dt,
    company_id,
    rpt_dt,
    start_dt,
    end_dt,
    rpt_timetype_cd,
    combine_type_cd,
    rpt_srctype_id,
    data_ajust_type,
    data_type,
    is_public_rpt,
    company_type,
    currency,
    coalesce(operate_reve,0) AS            operate_reve,
    coalesce(operate_exp,0) AS             operate_exp,
    coalesce(operate_tax,0) AS             operate_tax,
    coalesce(sale_exp,0) AS                sale_exp,
    coalesce(manage_exp,0) AS              manage_exp,
    coalesce(finance_exp,0) AS             finance_exp,
    coalesce(asset_devalue_loss,0) AS      asset_devalue_loss,
    coalesce(fvalue_income,0) AS           fvalue_income,
    coalesce(invest_income,0) AS           invest_income,
    coalesce(intn_reve,0) AS               intn_reve,
    coalesce(int_reve,0) AS                int_reve,
    coalesce(int_exp,0) AS                 int_exp,
    coalesce(commn_reve,0) AS              commn_reve,
    coalesce(comm_reve,0) AS               comm_reve,
    coalesce(comm_exp,0) AS                comm_exp,
    coalesce(exchange_income,0) AS         exchange_income,
    coalesce(premium_earned,0) AS          premium_earned,
    coalesce(premium_income,0) AS          premium_income,
    coalesce(ripremium,0) AS               ripremium,
    coalesce(undue_reserve,0) AS           undue_reserve,
    coalesce(premium_exp,0) AS             premium_exp,
    coalesce(indemnity_exp,0) AS           indemnity_exp,
    coalesce(amortise_indemnity_exp,0) AS  amortise_indemnity_exp,
    coalesce(duty_reserve,0) AS            duty_reserve,
    coalesce(amortise_duty_reserve,0) AS   amortise_duty_reserve,
    coalesce(rireve,0) AS                  rireve,
    coalesce(riexp,0) AS                   riexp,
    coalesce(surrender_premium,0) AS       surrender_premium,
    coalesce(policy_divi_exp,0) AS         policy_divi_exp,
    coalesce(amortise_riexp,0) AS          amortise_riexp,
    coalesce(agent_trade_security,0) AS    agent_trade_security,
    coalesce(security_uw,0) AS             security_uw,
    coalesce(client_asset_manage,0) AS     client_asset_manage,
    coalesce(operate_profit_other,0) AS    operate_profit_other,
    coalesce(operate_profit_balance,0) AS  operate_profit_balance,
    coalesce(operate_profit,0) AS          operate_profit,
    coalesce(nonoperate_reve,0) AS         nonoperate_reve,
    coalesce(nonoperate_exp,0) AS          nonoperate_exp,
    coalesce(nonlasset_net_loss,0) AS      nonlasset_net_loss,
    coalesce(sum_profit_other,0) AS        sum_profit_other,
    coalesce(sum_profit_balance,0) AS      sum_profit_balance,
    coalesce(sum_profit,0) AS              sum_profit,
    coalesce(income_tax,0) AS              income_tax,
    coalesce(net_profit_other2,0) AS       net_profit_other2,
    coalesce(net_profit_balance1,0) AS     net_profit_balance1,
    coalesce(net_profit_balance2,0) AS     net_profit_balance2,
    coalesce(net_profit,0) AS              net_profit,
    coalesce(parent_net_profit,0) AS       parent_net_profit,
    coalesce(minority_income,0) AS         minority_income,
    coalesce(undistribute_profit,0) AS     undistribute_profit,
    coalesce(basic_eps,0) AS               basic_eps,
    coalesce(diluted_eps,0) AS             diluted_eps,
    coalesce(invest_joint_income,0) AS     invest_joint_income,
    coalesce(total_operate_reve,0) AS      total_operate_reve,
    coalesce(total_operate_exp,0) AS       total_operate_exp,
    coalesce(other_reve,0) AS              other_reve,
    coalesce(other_exp,0) AS               other_exp,
    coalesce(unconfirm_invloss,0) AS       unconfirm_invloss,
    coalesce(other_cincome,0) AS           other_cincome,
    coalesce(sum_cincome,0) AS             sum_cincome,
    coalesce(parent_cincome,0) AS          parent_cincome,
    coalesce(minority_cincome,0) AS        minority_cincome,
    coalesce(net_contact_reserve,0) AS     net_contact_reserve,
    coalesce(rdexp,0) AS                   rdexp,
    coalesce(operate_manage_exp,0) AS      operate_manage_exp,
    coalesce(insur_reve,0) AS              insur_reve,
    coalesce(nonlasset_reve,0) AS          nonlasset_reve,
    coalesce(total_operatereve_other,0) AS total_operatereve_other,
    coalesce(net_indemnity_exp,0) AS       net_indemnity_exp,
    coalesce(total_operateexp_other,0) AS  total_operateexp_other,
    coalesce(net_profit_other1,0) AS       net_profit_other1,
    coalesce(cincome_balance1,0) AS        cincome_balance1,
    coalesce(cincome_balance2,0) AS        cincome_balance2,
    coalesce(other_net_income,0) AS        other_net_income,
    coalesce(reve_other,0) AS              reve_other,
    coalesce(reve_balance,0) AS            reve_balance,
    coalesce(operate_exp_other,0) AS       operate_exp_other,
    coalesce(operate_exp_balance,0) AS     operate_exp_balance,
    coalesce(bank_intnreve,0) AS           bank_intnreve,
    coalesce(bank_intreve,0) AS            bank_intreve,
    coalesce(ninsur_commn_reve,0) AS       ninsur_commn_reve,
    coalesce(ninsur_comm_reve,0) AS        ninsur_comm_reve,
    coalesce(ninsur_comm_exp,0) AS         ninsur_comm_exp,
    coalesce(adisposal_income,0) AS        adisposal_income,
    coalesce(other_miincome,0) AS          other_miincome,
    chk_status
from stg_compy_incomestate;

PERFORM fn_drop_if_exist('wrk_compy_cashflow');
CREATE TABLE wrk_compy_cashflow
AS
select
record_sid,
    compy_cashflow_sid,
    first_notice_dt,
    latest_notice_dt,
    company_id,
    rpt_dt,
    start_dt,
    end_dt,
    rpt_timetype_cd,
    combine_type_cd,
    rpt_srctype_id,
    data_ajust_type,
    data_type,
    is_public_rpt,
    company_type,
    currency,
    coalesce(salegoods_service_rec,0)AS    salegoods_service_rec,
    coalesce(tax_return_rec,0)AS    tax_return_rec,
    coalesce(other_operate_rec,0)AS    other_operate_rec,
    coalesce(ni_deposit,0)AS    ni_deposit,
    coalesce(niborrow_from_cbank,0)AS    niborrow_from_cbank,
    coalesce(niborrow_from_fi,0)AS    niborrow_from_fi,
    coalesce(premium_rec,0)AS    premium_rec,
    coalesce(nidisp_trade_fasset,0)AS    nidisp_trade_fasset,
    coalesce(nidisp_saleable_fasset,0)AS    nidisp_saleable_fasset,
    coalesce(niborrow_fund,0)AS    niborrow_fund,
    coalesce(nibuyback_fund,0)AS    nibuyback_fund,
    coalesce(operate_flowin_other,0)AS    operate_flowin_other,
    coalesce(operate_flowin_balance,0)AS    operate_flowin_balance,
    coalesce(sum_operate_flowin,0)AS    sum_operate_flowin,
    coalesce(buygoods_service_pay,0)AS    buygoods_service_pay,
    coalesce(employee_pay,0)AS    employee_pay,
    coalesce(tax_pay,0)AS    tax_pay,
    coalesce(other_operat_epay,0)AS    other_operat_epay,
    coalesce(niloan_advances,0)AS    niloan_advances,
    coalesce(nideposit_incbankfi,0)AS    nideposit_incbankfi,
    coalesce(indemnity_pay,0)AS    indemnity_pay,
    coalesce(intandcomm_pay,0)AS    intandcomm_pay,
    coalesce(operate_flowout_other,0)AS    operate_flowout_other,
    coalesce(operate_flowout_balance,0)AS    operate_flowout_balance,
    coalesce(sum_operate_flowout,0)AS    sum_operate_flowout,
    coalesce(operate_flow_other,0)AS    operate_flow_other,
    coalesce(operate_flow_balance,0)AS    operate_flow_balance,
    coalesce(net_operate_cashflow,0)AS    net_operate_cashflow,
    coalesce(disposal_inv_rec,0)AS    disposal_inv_rec,
    coalesce(inv_income_rec,0)AS    inv_income_rec,
    coalesce(disp_filasset_rec,0)AS    disp_filasset_rec,
    coalesce(disp_subsidiary_rec,0)AS    disp_subsidiary_rec,
    coalesce(other_invrec,0)AS    other_invrec,
    coalesce(inv_flowin_other,0)AS    inv_flowin_other,
    coalesce(inv_flowin_balance,0)AS    inv_flowin_balance,
    coalesce(sum_inv_flowin,0)AS    sum_inv_flowin,
    coalesce(buy_filasset_pay,0)AS    buy_filasset_pay,
    coalesce(inv_pay,0)AS    inv_pay,
    coalesce(get_subsidiary_pay,0)AS    get_subsidiary_pay,
    coalesce(other_inv_pay,0)AS    other_inv_pay,
    coalesce(nipledge_loan,0)AS    nipledge_loan,
    coalesce(inv_flowout_other,0)AS    inv_flowout_other,
    coalesce(inv_flowout_balance,0)AS    inv_flowout_balance,
    coalesce(sum_inv_flowout,0)AS    sum_inv_flowout,
    coalesce(inv_flow_other,0)AS    inv_flow_other,
    coalesce(inv_cashflow_balance,0)AS    inv_cashflow_balance,
    coalesce(net_inv_cashflow,0)AS    net_inv_cashflow,
    coalesce(accept_inv_rec,0)AS    accept_inv_rec,
    coalesce(loan_rec,0)AS    loan_rec,
    coalesce(other_fina_rec,0)AS    other_fina_rec,
    coalesce(issue_bond_rec,0)AS    issue_bond_rec,
    coalesce(niinsured_deposit_inv,0)AS    niinsured_deposit_inv,
    coalesce(fina_flowin_other,0)AS    fina_flowin_other,
    coalesce(fina_flowin_balance,0)AS    fina_flowin_balance,
    coalesce(sum_fina_flowin,0)AS    sum_fina_flowin,
    coalesce(repay_debt_pay,0)AS    repay_debt_pay,
    coalesce(divi_profitorint_pay,0)AS    divi_profitorint_pay,
    coalesce(other_fina_pay,0)AS    other_fina_pay,
    coalesce(fina_flowout_other,0)AS    fina_flowout_other,
    coalesce(fina_flowout_balance,0)AS    fina_flowout_balance,
    coalesce(sum_fina_flowout,0)AS    sum_fina_flowout,
    coalesce(fina_flow_other,0)AS    fina_flow_other,
    coalesce(fina_flow_balance,0)AS    fina_flow_balance,
    coalesce(net_fina_cashflow,0)AS    net_fina_cashflow,
    coalesce(effect_exchange_rate,0)AS    effect_exchange_rate,
    coalesce(nicash_equi_other,0)AS    nicash_equi_other,
    coalesce(nicash_equi_balance,0)AS    nicash_equi_balance,
    coalesce(nicash_equi,0)AS    nicash_equi,
    coalesce(cash_equi_beginning,0)AS    cash_equi_beginning,
    coalesce(cash_equi_ending,0)AS    cash_equi_ending,
    coalesce(net_profit,0)AS    net_profit,
    coalesce(asset_devalue,0)AS    asset_devalue,
    coalesce(fixed_asset_etcdepr,0)AS    fixed_asset_etcdepr,
    coalesce(intangible_asset_amor,0)AS    intangible_asset_amor,
    coalesce(ltdefer_exp_amor,0)AS    ltdefer_exp_amor,
    coalesce(defer_exp_reduce,0)AS    defer_exp_reduce,
    coalesce(drawing_exp_add,0)AS    drawing_exp_add,
    coalesce(disp_filasset_loss,0)AS    disp_filasset_loss,
    coalesce(fixed_asset_loss,0)AS    fixed_asset_loss,
    coalesce(fvalue_loss,0)AS    fvalue_loss,
    coalesce(finance_exp,0)AS    finance_exp,
    coalesce(inv_loss,0)AS    inv_loss,
    coalesce(defer_taxasset_reduce,0)AS    defer_taxasset_reduce,
    coalesce(defer_taxliab_add,0)AS    defer_taxliab_add,
    coalesce(inventory_reduce,0)AS    inventory_reduce,
    coalesce(operate_rec_reduce,0)AS    operate_rec_reduce,
    coalesce(operate_pay_add,0)AS    operate_pay_add,
    coalesce(inoperate_flow_other,0)AS    inoperate_flow_other,
    coalesce(inoperate_flow_balance,0)AS    inoperate_flow_balance,
    coalesce(innet_operate_cashflow,0)AS    innet_operate_cashflow,
    coalesce(debt_to_capital,0)AS    debt_to_capital,
    coalesce(cb_oneyear,0)AS    cb_oneyear,
    coalesce(finalease_fixed_asset,0)AS    finalease_fixed_asset,
    coalesce(cash_end,0)AS    cash_end,
    coalesce(cash_begin,0)AS    cash_begin,
    coalesce(equi_end,0)AS    equi_end,
    coalesce(equi_begin,0)AS    equi_begin,
    coalesce(innicash_equi_other,0)AS    innicash_equi_other,
    coalesce(innicash_equi_balance,0)AS    innicash_equi_balance,
    coalesce(innicash_equi,0)AS    innicash_equi,
    coalesce(other,0)AS    other,
    coalesce(subsidiary_accept,0)AS    subsidiary_accept,
    coalesce(subsidiary_pay,0)AS    subsidiary_pay,
    coalesce(divi_pay,0)AS    divi_pay,
    coalesce(intandcomm_rec,0)AS    intandcomm_rec,
    coalesce(net_rirec,0)AS    net_rirec,
    coalesce(nilend_fund,0)AS    nilend_fund,
    coalesce(defer_tax,0)AS    defer_tax,
    coalesce(defer_income_amor,0)AS    defer_income_amor,
    coalesce(exchange_loss,0)AS    exchange_loss,
    coalesce(fixandestate_depr,0)AS    fixandestate_depr,
    coalesce(fixed_asset_depr,0)AS    fixed_asset_depr,
    coalesce(tradef_asset_reduce,0)AS    tradef_asset_reduce,
    coalesce(ndloan_advances,0)AS    ndloan_advances,
    coalesce(reduce_pledget_deposit,0)AS    reduce_pledget_deposit,
    coalesce(add_pledget_deposit,0)AS    add_pledget_deposit,
    coalesce(buy_subsidiary_pay,0)AS    buy_subsidiary_pay,
    coalesce(cash_equiending_other,0)AS    cash_equiending_other,
    coalesce(cash_equiending_balance,0)AS    cash_equiending_balance,
    coalesce(nd_depositinc_bankfi,0)AS    nd_depositinc_bankfi,
    coalesce(niborrow_sell_buyback,0)AS    niborrow_sell_buyback,
    coalesce(ndlend_buy_sellback,0)AS    ndlend_buy_sellback,
    coalesce(net_cd,0)AS    net_cd,
    coalesce(nitrade_fliab,0)AS    nitrade_fliab,
    coalesce(ndtrade_fasset,0)AS    ndtrade_fasset,
    coalesce(disp_masset_rec,0)AS    disp_masset_rec,
    coalesce(cancel_loan_rec,0)AS    cancel_loan_rec,
    coalesce(ndborrow_from_cbank,0)AS    ndborrow_from_cbank,
    coalesce(ndfide_posit,0)AS    ndfide_posit,
    coalesce(ndissue_cd,0)AS    ndissue_cd,
    coalesce(nilend_sell_buyback,0)AS    nilend_sell_buyback,
    coalesce(ndborrow_sell_buyback,0)AS    ndborrow_sell_buyback,
    coalesce(nitrade_fasset,0)AS    nitrade_fasset,
    coalesce(ndtrade_fliab,0)AS    ndtrade_fliab,
    coalesce(buy_finaleaseasset_pay,0)AS    buy_finaleaseasset_pay,
    coalesce(niaccount_rec,0)AS    niaccount_rec,
    coalesce(issue_cd,0)AS    issue_cd,
    coalesce(addshare_capital_rec,0)AS    addshare_capital_rec,
    coalesce(issue_share_rec,0)AS    issue_share_rec,
    coalesce(bond_intpay,0)AS    bond_intpay,
    coalesce(niother_finainstru,0)AS    niother_finainstru,
    coalesce(agent_trade_securityrec,0)AS    agent_trade_securityrec,
    coalesce(uwsecurity_rec,0)AS    uwsecurity_rec,
    coalesce(buysellback_fasset_rec,0)AS    buysellback_fasset_rec,
    coalesce(agent_uwsecurity_rec,0)AS    agent_uwsecurity_rec,
    coalesce(nidirect_inv,0)AS    nidirect_inv,
    coalesce(nitrade_settlement,0)AS    nitrade_settlement,
    coalesce(buysellback_fasset_pay,0)AS    buysellback_fasset_pay,
    coalesce(nddisp_trade_fasset,0)AS    nddisp_trade_fasset,
    coalesce(ndother_fina_instr,0)AS    ndother_fina_instr,
    coalesce(ndborrow_fund,0)AS    ndborrow_fund,
    coalesce(nddirect_inv,0)AS    nddirect_inv,
    coalesce(ndtrade_settlement,0)AS    ndtrade_settlement,
    coalesce(ndbuyback_fund,0)AS    ndbuyback_fund,
    coalesce(agenttrade_security_pay,0)AS    agenttrade_security_pay,
    coalesce(nddisp_saleable_fasset,0)AS    nddisp_saleable_fasset,
    coalesce(nisell_buyback,0)AS    nisell_buyback,
    coalesce(ndbuy_sellback,0)AS    ndbuy_sellback,
    coalesce(nettrade_fasset_rec,0)AS    nettrade_fasset_rec,
    coalesce(net_ripay,0)AS    net_ripay,
    coalesce(ndlend_fund,0)AS    ndlend_fund,
    coalesce(nibuy_sellback,0)AS    nibuy_sellback,
    coalesce(ndsell_buyback,0)AS    ndsell_buyback,
    coalesce(ndinsured_deposit_inv,0)AS    ndinsured_deposit_inv,
    coalesce(nettrade_fasset_pay,0)AS    nettrade_fasset_pay,
    coalesce(niinsured_pledge_loan,0)AS    niinsured_pledge_loan,
    coalesce(disp_subsidiary_pay,0)AS    disp_subsidiary_pay,
    coalesce(netsell_buyback_fassetrec,0)AS    netsell_buyback_fassetrec,
    coalesce(netsell_buyback_fassetpay,0)AS    netsell_buyback_fassetpay,
    chk_status
FROM stg_compy_cashflow;

--一般工商企业的勾稽校对
--创建三大表勾稽校对表
PERFORM fn_drop_if_exist('wrk_compy_balancesheet_check');
PERFORM fn_drop_if_exist('wrk_compy_incomestate_check');
PERFORM fn_drop_if_exist('wrk_compy_cashflow_check');

CREATE TABLE wrk_compy_balancesheet_check(record_sid integer,check_status varchar(200));
CREATE TABLE wrk_compy_incomestate_check(record_sid integer,check_status varchar(200));
CREATE TABLE wrk_compy_cashflow_check(record_sid integer,check_status varchar(200));

--truncate table e_wrk_compy_balancesheet_check;
--truncate table e_wrk_compy_incomestate_check;
--truncate table e_wrk_compy_cashflow_check;

vSQL:='';
vSQL1:='';
vSQL2:='';

FOR L IN (SELECT DISTINCT temp_table_nm,check_table_nm,check_company_type,sequence_nm FROM stg_lkp_finance_check_rule WHERE isdel=0 ORDER BY check_table_nm,check_company_type)
 LOOP

FOR I IN (SELECT check_table_nm,check_cd,formula_en FROM  stg_lkp_finance_check_rule  WHERE check_table_nm=L.check_table_nm AND check_company_type=L.check_company_type AND isdel = 0 ORDER BY check_cd )
  LOOP
    vSQL := vSQL ||', CASE WHEN '||I.formula_en||' THEN ''PASS'' ELSE '''||I.check_cd||''' END AS '||I.check_cd||CHR(10);
    vSQL2:=vSQL2||'||'',''||'||I.check_cd;
  END LOOP;

vSQL2:=substr(vSQL2,8);

  vSQL1 :='insert into  '||L.temp_table_nm||'
  select '||L.SEQUENCE_NM||',
  replace(replace('||vSQL2||',''PASS,'',''''),'',PASS'','''') AS check_status
  from
    (
    SELECT '||
    L.SEQUENCE_NM||
    vSQL||
    ' FROM '||L.check_table_nm||
    ' a
    where company_type = '||L.check_company_type||
    ') a  ';
/*
vSQL_temp:='INSERT INTO  e_'||L.temp_table_nm||'
SELECT '||
L.SEQUENCE_NM||
vSQL||
' FROM '||L.check_table_nm||
' a
where company_type = '||L.check_company_type;
*/
  
EXECUTE vSQL1;
--EXECUTE vSQL_temp;
vSQL:='';
vSQL1:='';
vSQL2:='';
END LOOP;

--更新资产负债表的chk_status
UPDATE stg_compy_balancesheet  a
SET chk_status =b.check_status 
FROM wrk_compy_balancesheet_check b
WHERE a.record_sid = b.record_sid;

GET DIAGNOSTICS vIN_UPDCOUNT = ROW_COUNT;

--更新利润表的chk_status
UPDATE stg_compy_incomestate  a
SET chk_status =b.check_status 
FROM wrk_compy_incomestate_check b
WHERE a.record_sid = b.record_sid;

GET DIAGNOSTICS vIN_UPDCOUNT_temp = ROW_COUNT;
vIN_UPDCOUNT:=vIN_UPDCOUNT+vIN_UPDCOUNT_temp;

--更新现金流量表的chk_status
UPDATE stg_compy_cashflow  a
SET chk_status =b.check_status 
FROM wrk_compy_cashflow_check b
WHERE a.record_sid = b.record_sid;

GET DIAGNOSTICS vIN_UPDCOUNT_temp = ROW_COUNT;
vIN_UPDCOUNT:=vIN_UPDCOUNT+vIN_UPDCOUNT_temp;


PERFORM fn_drop_if_exist('compy_basicinfo_dedup');
CREATE TABLE compy_basicinfo_dedup 
AS
SELECT 
* 
FROM 
(
SELECT *,row_number() over(partition by company_id order by updt_dt desc) as row_num
FROM 
(select * from hist_compy_basicinfo 
union ALL
 SELECT * FROM stg_compy_basicinfo
) a
)x
WHERE x.row_num=1;
 

--生成勾稽校对检查结果模板
PERFORM fn_drop_if_exist('exp_compy_finance_check_report');
CREATE TABLE exp_compy_finance_check_report 
AS
SELECT 
'企业名称'::VARCHAR(200) AS company_nm,
'企业记录号'::VARCHAR(200) AS record_sid,
'企业代码'::VARCHAR(200) AS company_id,
'检查表名称'::VARCHAR(200) AS check_tbl_nm,
'报表合并类型'::VARCHAR(200) AS combine_type_cd,
'财报类型'::VARCHAR(200) AS rpt_timetype_cd,
'数据调整类型'::VARCHAR(200) AS data_ajust_type,
'财报时间'::VARCHAR(200) AS rpt_dt,
'检查状态(以下规则不通过)'::VARCHAR(200) AS chk_status,
'检查时间'::VARCHAR(200) AS check_dt
UNION ALL
SELECT 
x.company_nm,
a.record_sid ::VARCHAR(200),
a.company_id ::VARCHAR(200),
'资产负债表' AS check_tbl_nm,
c.constant_nm ::VARCHAR(200) as combine_type_cd,
b.constant_nm ::VARCHAR(200) as rpt_timetype_cd,
d.constant_nm ::VARCHAR(200) as data_ajust_type,
a.rpt_dt ::VARCHAR(200),
a.chk_status,
to_char(CURRENT_TIMESTAMP,'YYYYMMDD HH24:MI:SS') ::VARCHAR(200) as check_dt
FROM stg_compy_balancesheet a 
JOIN compy_basicinfo_dedup x ON a.company_id = x.company_id
JOIN stg_lkp_numbcode b ON a.rpt_timetype_cd = b.constant_cd AND b.constant_type=6--财报类型
JOIN stg_lkp_numbcode c ON a.combine_type_cd = c.constant_cd AND c.constant_type=7--报表合并类型
JOIN stg_lkp_numbcode d ON a.data_ajust_type = d.constant_cd AND d.constant_type=5--数据调整类型
WHERE coalesce(a.chk_status,'') <>'PASS'
;

INSERT INTO exp_compy_finance_check_report
SELECT 
'企业名称'::VARCHAR(200) AS company_nm,
'企业记录号'::VARCHAR(200) AS record_sid,
'企业代码'::VARCHAR(200) AS company_id,
'检查表名称'::VARCHAR(200) AS check_tbl_nm,
'报表合并类型'::VARCHAR(200) AS combine_type_cd,
'财报类型'::VARCHAR(200) AS rpt_timetype_cd,
'数据调整类型'::VARCHAR(200) AS data_ajust_type,
'财报时间'::VARCHAR(200) AS rpt_dt,
'检查状态(以下规则不通过)'::VARCHAR(200) AS chk_status,
'检查时间'::VARCHAR(200) AS check_dt
UNION ALL
SELECT 
x.company_nm,
a.record_sid ::VARCHAR(200),
a.company_id ::VARCHAR(200),
'利润表' AS check_tbl_nm,
c.constant_nm ::VARCHAR(200) as combine_type_cd,
b.constant_nm ::VARCHAR(200) as rpt_timetype_cd,
d.constant_nm ::VARCHAR(200) as data_ajust_type,
a.rpt_dt ::VARCHAR(200),
a.chk_status,
to_char(CURRENT_TIMESTAMP,'YYYYMMDD HH24:MI:SS') ::VARCHAR(200) as check_dt
FROM stg_compy_incomestate a 
JOIN compy_basicinfo_dedup x ON a.company_id = x.company_id
JOIN stg_lkp_numbcode b ON a.rpt_timetype_cd = b.constant_cd AND b.constant_type=6--财报类型
JOIN stg_lkp_numbcode c ON a.combine_type_cd = c.constant_cd AND c.constant_type=7--报表合并类型
JOIN stg_lkp_numbcode d ON a.data_ajust_type = d.constant_cd AND d.constant_type=5--数据调整类型
WHERE coalesce(a.chk_status,'') <>'PASS';

INSERT INTO exp_compy_finance_check_report
SELECT 
'企业名称'::VARCHAR(200) AS company_nm,
'企业记录号'::VARCHAR(200) AS record_sid,
'企业代码'::VARCHAR(200) AS company_id,
'检查表名称'::VARCHAR(200) AS check_tbl_nm,
'报表合并类型'::VARCHAR(200) AS combine_type_cd,
'财报类型'::VARCHAR(200) AS rpt_timetype_cd,
'数据调整类型'::VARCHAR(200) AS data_ajust_type,
'财报时间'::VARCHAR(200) AS rpt_dt,
'检查状态(以下规则不通过)'::VARCHAR(200) AS chk_status,
'检查时间'::VARCHAR(200) AS check_dt
UNION ALL
SELECT 
x.company_nm,
a.record_sid ::VARCHAR(200),
a.company_id ::VARCHAR(200),
'现金流量表' AS check_tbl_nm,
c.constant_nm ::VARCHAR(200) as combine_type_cd,
b.constant_nm ::VARCHAR(200) as rpt_timetype_cd,
d.constant_nm ::VARCHAR(200) as data_ajust_type,
a.rpt_dt ::VARCHAR(200),
a.chk_status,
to_char(CURRENT_TIMESTAMP,'YYYYMMDD HH24:MI:SS') ::VARCHAR(200) as check_dt
FROM stg_compy_cashflow a 
JOIN compy_basicinfo_dedup x ON a.company_id = x.company_id
JOIN stg_lkp_numbcode b ON a.rpt_timetype_cd = b.constant_cd AND b.constant_type=6--财报类型
JOIN stg_lkp_numbcode c ON a.combine_type_cd = c.constant_cd AND c.constant_type=7--报表合并类型
JOIN stg_lkp_numbcode d ON a.data_ajust_type = d.constant_cd AND d.constant_type=5--数据调整类型
WHERE coalesce(a.chk_status,'') <>'PASS';



--将不通过勾稽校对的数据挪至历史表中

INSERT INTO hist_compy_balancesheet SELECT * FROM stg_compy_balancesheet WHERE coalesce(chk_status,'') <>'PASS';
INSERT INTO hist_compy_incomestate SELECT * FROM stg_compy_incomestate WHERE coalesce(chk_status,'') <>'PASS';
INSERT INTO hist_compy_cashflow SELECT * FROM stg_compy_cashflow WHERE coalesce(chk_status,'') <>'PASS';


--删除不通过勾稽校对的数据
DELETE FROM stg_compy_balancesheet WHERE coalesce(chk_status,'') <>'PASS';
DELETE FROM stg_compy_incomestate WHERE coalesce(chk_status,'') <>'PASS';
DELETE FROM stg_compy_cashflow WHERE coalesce(chk_status,'') <>'PASS';


vEND_DT := clock_timestamp();

--clear temp tables
PERFORM fn_drop_if_exist('wrk_compy_balancesheet');
PERFORM fn_drop_if_exist('wrk_compy_incomestate');
PERFORM fn_drop_if_exist('wrk_compy_cashflow');
PERFORM fn_drop_if_exist('compy_basicinfo_dedup');
PERFORM fn_drop_if_exist('wrk_compy_balancesheet_check');
PERFORM fn_drop_if_exist('wrk_compy_incomestate_check');
PERFORM fn_drop_if_exist('wrk_compy_cashflow_check');

--记录日志

INSERT INTO etl_stg_loadlog
    SELECT nextval('seq_etl_stg_loadlog'),
        'FN_COMPY_FINANCE_CHECK',
        'FN_COMPY_FINANCE_CHECK' AS received_file,
        now() AS received_dt,
        vIN_UPDCOUNT AS orig_record_count,
        vIN_UPDCOUNT AS record_count,
        vSTART_DT AS start_dt,
        vEND_DT AS end_dt;

--出错处理

return 0;

exception when others then 

    raise notice 'Execute fn_compy_finance_check failed';
    raise exception '% %', SQLERRM, SQLSTATE;

END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

ALTER FUNCTION "public"."fn_compy_finance_check"() OWNER TO "cs_master_stg";