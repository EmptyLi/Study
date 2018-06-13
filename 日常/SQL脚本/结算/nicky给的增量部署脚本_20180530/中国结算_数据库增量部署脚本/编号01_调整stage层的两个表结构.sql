--执行数据库：cs_master_stg
/*
----------------------------
对表hist_compy_incomestate 新增两个字段
----------------------------
*/

--备份源表
create table hist_compy_incomestate_bkp as select * from hist_compy_incomestate;

--删除旧表 hist_compy_incomestate
drop table hist_compy_incomestate;

--创建新表 hist_compy_incomestate
CREATE TABLE
    hist_compy_incomestate
    (
        record_sid BIGINT,
        compy_incomestate_sid BIGINT,
        first_notice_dt TIMESTAMP(6) WITHOUT TIME ZONE,
        latest_notice_dt TIMESTAMP(6) WITHOUT TIME ZONE,
        company_id BIGINT,
        rpt_dt BIGINT,
        start_dt BIGINT,
        end_dt BIGINT,
        rpt_timetype_cd BIGINT,
        combine_type_cd BIGINT,
        rpt_srctype_id BIGINT,
        data_ajust_type BIGINT,
        data_type BIGINT,
        is_public_rpt BIGINT,
        company_type BIGINT,
        currency CHARACTER VARYING(6),
        operate_reve NUMERIC(24,4),
        operate_exp NUMERIC(24,4),
        operate_tax NUMERIC(24,4),
        sale_exp NUMERIC(24,4),
        manage_exp NUMERIC(24,4),
        finance_exp NUMERIC(24,4),
        asset_devalue_loss NUMERIC(24,4),
        fvalue_income NUMERIC(24,4),
        invest_income NUMERIC(24,4),
        intn_reve NUMERIC(24,4),
        int_reve NUMERIC(24,4),
        int_exp NUMERIC(24,4),
        commn_reve NUMERIC(24,4),
        comm_reve NUMERIC(24,4),
        comm_exp NUMERIC(24,4),
        exchange_income NUMERIC(24,4),
        premium_earned NUMERIC(24,4),
        premium_income NUMERIC(24,4),
        ripremium NUMERIC(24,4),
        undue_reserve NUMERIC(24,4),
        premium_exp NUMERIC(24,4),
        indemnity_exp NUMERIC(24,4),
        amortise_indemnity_exp NUMERIC(24,4),
        duty_reserve NUMERIC(24,4),
        amortise_duty_reserve NUMERIC(24,4),
        rireve NUMERIC(24,4),
        riexp NUMERIC(24,4),
        surrender_premium NUMERIC(24,4),
        policy_divi_exp NUMERIC(24,4),
        amortise_riexp NUMERIC(24,4),
        agent_trade_security NUMERIC(24,4),
        security_uw NUMERIC(24,4),
        client_asset_manage NUMERIC(24,4),
        operate_profit_other NUMERIC(24,4),
        operate_profit_balance NUMERIC(24,4),
        operate_profit NUMERIC(24,4),
        nonoperate_reve NUMERIC(24,4),
        nonoperate_exp NUMERIC(24,4),
        nonlasset_net_loss NUMERIC(24,4),
        sum_profit_other NUMERIC(24,4),
        sum_profit_balance NUMERIC(24,4),
        sum_profit NUMERIC(24,4),
        income_tax NUMERIC(24,4),
        net_profit_other2 NUMERIC(24,4),
        net_profit_balance1 NUMERIC(24,4),
        net_profit_balance2 NUMERIC(24,4),
        net_profit NUMERIC(24,4),
        parent_net_profit NUMERIC(24,4),
        minority_income NUMERIC(24,4),
        undistribute_profit NUMERIC(24,4),
        basic_eps NUMERIC(24,4),
        diluted_eps NUMERIC(24,4),
        invest_joint_income NUMERIC(24,4),
        total_operate_reve NUMERIC(24,4),
        total_operate_exp NUMERIC(24,4),
        other_reve NUMERIC(24,4),
        other_exp NUMERIC(24,4),
        unconfirm_invloss NUMERIC(24,4),
        other_cincome NUMERIC(24,4),
        sum_cincome NUMERIC(24,4),
        parent_cincome NUMERIC(24,4),
        minority_cincome NUMERIC(24,4),
        net_contact_reserve NUMERIC(24,4),
        rdexp NUMERIC(24,4),
        operate_manage_exp NUMERIC(24,4),
        insur_reve NUMERIC(24,4),
        nonlasset_reve NUMERIC(24,4),
        total_operatereve_other NUMERIC(24,4),
        net_indemnity_exp NUMERIC(24,4),
        total_operateexp_other NUMERIC(24,4),
        net_profit_other1 NUMERIC(24,4),
        cincome_balance1 NUMERIC(24,4),
        cincome_balance2 NUMERIC(24,4),
        other_net_income NUMERIC(24,4),
        reve_other NUMERIC(24,4),
        reve_balance NUMERIC(24,4),
        operate_exp_other NUMERIC(24,4),
        operate_exp_balance NUMERIC(24,4),
        bank_intnreve NUMERIC(24,4),
        bank_intreve NUMERIC(24,4),
        ninsur_commn_reve NUMERIC(24,4),
        ninsur_comm_reve NUMERIC(24,4),
        ninsur_comm_exp NUMERIC(24,4),
        adisposal_income  NUMERIC(24,4),--增加科目
        other_miincome   NUMERIC(24,4),--增加科目
        remark CHARACTER VARYING(1000),
        chk_status CHARACTER VARYING(200),
        isdel BIGINT,
        src_company_cd CHARACTER VARYING(60),
        srcid CHARACTER VARYING(100),
        src_cd CHARACTER VARYING(10),
        updt_by BIGINT,
        updt_dt TIMESTAMP(6) WITHOUT TIME ZONE,
        loadlog_sid BIGINT
    );

ALTER TABLE hist_compy_incomestate OWNER TO CS_MASTER_STG;

--恢复原始数据
INSERT INTO hist_compy_incomestate (record_sid, compy_incomestate_sid, first_notice_dt, latest_notice_dt, company_id, rpt_dt, start_dt, end_dt, rpt_timetype_cd, combine_type_cd, rpt_srctype_id, data_ajust_type, data_type, is_public_rpt, company_type, currency, operate_reve, operate_exp, operate_tax, sale_exp, manage_exp, finance_exp, asset_devalue_loss, fvalue_income, invest_income, intn_reve, int_reve, int_exp, commn_reve, comm_reve, comm_exp, exchange_income, premium_earned, premium_income, ripremium, undue_reserve, premium_exp, indemnity_exp, amortise_indemnity_exp, duty_reserve, amortise_duty_reserve, rireve, riexp, surrender_premium, policy_divi_exp, amortise_riexp, agent_trade_security, security_uw, client_asset_manage, operate_profit_other, operate_profit_balance, operate_profit, nonoperate_reve, nonoperate_exp, nonlasset_net_loss, sum_profit_other, sum_profit_balance, sum_profit, income_tax, net_profit_other2, net_profit_balance1, net_profit_balance2, net_profit, parent_net_profit, minority_income, undistribute_profit, basic_eps, diluted_eps, invest_joint_income, total_operate_reve, total_operate_exp, other_reve, other_exp, unconfirm_invloss, other_cincome, sum_cincome, parent_cincome, minority_cincome, net_contact_reserve, rdexp, operate_manage_exp, insur_reve, nonlasset_reve, total_operatereve_other, net_indemnity_exp, total_operateexp_other, net_profit_other1, cincome_balance1, cincome_balance2, other_net_income, reve_other, reve_balance, operate_exp_other, operate_exp_balance, bank_intnreve, bank_intreve, ninsur_commn_reve, ninsur_comm_reve, ninsur_comm_exp, adisposal_income, other_miincome, remark, chk_status, isdel, src_company_cd, srcid, src_cd, updt_by, updt_dt, loadlog_sid) 
select record_sid, compy_incomestate_sid, first_notice_dt, latest_notice_dt, company_id, rpt_dt, start_dt, end_dt, rpt_timetype_cd, combine_type_cd, rpt_srctype_id, data_ajust_type, data_type, is_public_rpt, company_type, currency, operate_reve, operate_exp, operate_tax, sale_exp, manage_exp, finance_exp, asset_devalue_loss, fvalue_income, invest_income, intn_reve, int_reve, int_exp, commn_reve, comm_reve, comm_exp, exchange_income, premium_earned, premium_income, ripremium, undue_reserve, premium_exp, indemnity_exp, amortise_indemnity_exp, duty_reserve, amortise_duty_reserve, rireve, riexp, surrender_premium, policy_divi_exp, amortise_riexp, agent_trade_security, security_uw, client_asset_manage, operate_profit_other, operate_profit_balance, operate_profit, nonoperate_reve, nonoperate_exp, nonlasset_net_loss, sum_profit_other, sum_profit_balance, sum_profit, income_tax, net_profit_other2, net_profit_balance1, net_profit_balance2, net_profit, parent_net_profit, minority_income, undistribute_profit, basic_eps, diluted_eps, invest_joint_income, total_operate_reve, total_operate_exp, other_reve, other_exp, unconfirm_invloss, other_cincome, sum_cincome, parent_cincome, minority_cincome, net_contact_reserve, rdexp, operate_manage_exp, insur_reve, nonlasset_reve, total_operatereve_other, net_indemnity_exp, total_operateexp_other, net_profit_other1, cincome_balance1, cincome_balance2, other_net_income, reve_other, reve_balance, operate_exp_other, operate_exp_balance, bank_intnreve, bank_intreve, ninsur_commn_reve, ninsur_comm_reve, ninsur_comm_exp, null as adisposal_income, null as other_miincome, remark, chk_status, isdel, src_company_cd, srcid, src_cd, updt_by, updt_dt, loadlog_sid
from hist_compy_incomestate_bkp;

--删除备份表
drop table hist_compy_incomestate_bkp;

/*
----------------------------
对表stg_compy_incomestate 新增两个字段
----------------------------
*/
--删除旧表 stg_compy_incomestate，因stg表为空表数据，故不需要进行数据备份
drop table stg_compy_incomestate;

--创建新表 stg_compy_incomestate
CREATE TABLE
    stg_compy_incomestate
    (
        record_sid BIGINT DEFAULT nextval('seq_stg_compy_incomestate'::regclass),
        compy_incomestate_sid BIGINT,
        first_notice_dt TIMESTAMP(6) WITHOUT TIME ZONE,
        latest_notice_dt TIMESTAMP(6) WITHOUT TIME ZONE,
        company_id BIGINT,
        rpt_dt BIGINT,
        start_dt BIGINT,
        end_dt BIGINT,
        rpt_timetype_cd BIGINT,
        combine_type_cd BIGINT,
        rpt_srctype_id BIGINT,
        data_ajust_type BIGINT,
        data_type BIGINT,
        is_public_rpt BIGINT,
        company_type BIGINT,
        currency CHARACTER VARYING(6),
        operate_reve NUMERIC(24,4),
        operate_exp NUMERIC(24,4),
        operate_tax NUMERIC(24,4),
        sale_exp NUMERIC(24,4),
        manage_exp NUMERIC(24,4),
        finance_exp NUMERIC(24,4),
        asset_devalue_loss NUMERIC(24,4),
        fvalue_income NUMERIC(24,4),
        invest_income NUMERIC(24,4),
        intn_reve NUMERIC(24,4),
        int_reve NUMERIC(24,4),
        int_exp NUMERIC(24,4),
        commn_reve NUMERIC(24,4),
        comm_reve NUMERIC(24,4),
        comm_exp NUMERIC(24,4),
        exchange_income NUMERIC(24,4),
        premium_earned NUMERIC(24,4),
        premium_income NUMERIC(24,4),
        ripremium NUMERIC(24,4),
        undue_reserve NUMERIC(24,4),
        premium_exp NUMERIC(24,4),
        indemnity_exp NUMERIC(24,4),
        amortise_indemnity_exp NUMERIC(24,4),
        duty_reserve NUMERIC(24,4),
        amortise_duty_reserve NUMERIC(24,4),
        rireve NUMERIC(24,4),
        riexp NUMERIC(24,4),
        surrender_premium NUMERIC(24,4),
        policy_divi_exp NUMERIC(24,4),
        amortise_riexp NUMERIC(24,4),
        agent_trade_security NUMERIC(24,4),
        security_uw NUMERIC(24,4),
        client_asset_manage NUMERIC(24,4),
        operate_profit_other NUMERIC(24,4),
        operate_profit_balance NUMERIC(24,4),
        operate_profit NUMERIC(24,4),
        nonoperate_reve NUMERIC(24,4),
        nonoperate_exp NUMERIC(24,4),
        nonlasset_net_loss NUMERIC(24,4),
        sum_profit_other NUMERIC(24,4),
        sum_profit_balance NUMERIC(24,4),
        sum_profit NUMERIC(24,4),
        income_tax NUMERIC(24,4),
        net_profit_other2 NUMERIC(24,4),
        net_profit_balance1 NUMERIC(24,4),
        net_profit_balance2 NUMERIC(24,4),
        net_profit NUMERIC(24,4),
        parent_net_profit NUMERIC(24,4),
        minority_income NUMERIC(24,4),
        undistribute_profit NUMERIC(24,4),
        basic_eps NUMERIC(24,4),
        diluted_eps NUMERIC(24,4),
        invest_joint_income NUMERIC(24,4),
        total_operate_reve NUMERIC(24,4),
        total_operate_exp NUMERIC(24,4),
        other_reve NUMERIC(24,4),
        other_exp NUMERIC(24,4),
        unconfirm_invloss NUMERIC(24,4),
        other_cincome NUMERIC(24,4),
        sum_cincome NUMERIC(24,4),
        parent_cincome NUMERIC(24,4),
        minority_cincome NUMERIC(24,4),
        net_contact_reserve NUMERIC(24,4),
        rdexp NUMERIC(24,4),
        operate_manage_exp NUMERIC(24,4),
        insur_reve NUMERIC(24,4),
        nonlasset_reve NUMERIC(24,4),
        total_operatereve_other NUMERIC(24,4),
        net_indemnity_exp NUMERIC(24,4),
        total_operateexp_other NUMERIC(24,4),
        net_profit_other1 NUMERIC(24,4),
        cincome_balance1 NUMERIC(24,4),
        cincome_balance2 NUMERIC(24,4),
        other_net_income NUMERIC(24,4),
        reve_other NUMERIC(24,4),
        reve_balance NUMERIC(24,4),
        operate_exp_other NUMERIC(24,4),
        operate_exp_balance NUMERIC(24,4),
        bank_intnreve NUMERIC(24,4),
        bank_intreve NUMERIC(24,4),
        ninsur_commn_reve NUMERIC(24,4),
        ninsur_comm_reve NUMERIC(24,4),
        ninsur_comm_exp NUMERIC(24,4),
        adisposal_income  NUMERIC(24,4),--增加科目
        other_miincome   NUMERIC(24,4),--增加科目
        remark CHARACTER VARYING(1000),
        chk_status CHARACTER VARYING(200),
        isdel BIGINT,
        src_company_cd CHARACTER VARYING(60),
        srcid CHARACTER VARYING(100),
        src_cd CHARACTER VARYING(10),
        updt_by BIGINT,
        updt_dt TIMESTAMP(6) WITHOUT TIME ZONE,
        loadlog_sid BIGINT
    );

ALTER TABLE stg_compy_incomestate OWNER TO CS_MASTER_STG;

--QC检查
select adisposal_income,other_miincome from stg_compy_incomestate limit 1; --无报错信息，表明字段增加成功
select adisposal_income,other_miincome from hist_compy_incomestate limit 1;--无报错信息，表明字段增加成功
