CREATE TABLE if not exists
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