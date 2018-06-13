--执行数据库：cs_master_tgt
/*
----------------------------
对表compy_incomestate 新增两个字段
----------------------------
*/
--备份源表
create table compy_incomestate_bkp as select * from compy_incomestate;

--由于有三张视图使用到了compy_incomestate，需要先把这三张视图进行删除，备份DDL
/*
view vw_finance_subject  
materialized view vw_compy_finanalarm
view vw_expired_rating 
*/
drop materialized view vw_compy_finanalarm;
drop view vw_finance_subject; 
drop view vw_expired_rating; 


--删除旧表 compy_incomestate
drop table compy_incomestate;

--创建新表 compy_incomestate
CREATE TABLE
    compy_incomestate
    (
        compy_incomestate_sid BIGINT DEFAULT nextval('seq_compy_incomestate'::regclass) NOT NULL,
        first_notice_dt TIMESTAMP(6) WITHOUT TIME ZONE,
        latest_notice_dt TIMESTAMP(6) WITHOUT TIME ZONE,
        company_id BIGINT NOT NULL,
        rpt_dt BIGINT NOT NULL,
        start_dt BIGINT,
        end_dt BIGINT,
        rpt_timetype_cd BIGINT,
        combine_type_cd BIGINT NOT NULL,
        rpt_srctype_id BIGINT,
        data_ajust_type BIGINT NOT NULL,
        data_type BIGINT,
        is_public_rpt BIGINT,
        company_type BIGINT NOT NULL,
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
        isdel BIGINT NOT NULL,
        src_company_cd CHARACTER VARYING(60),
        srcid CHARACTER VARYING(100),
        src_cd CHARACTER VARYING(10) NOT NULL,
        updt_by BIGINT DEFAULT 0 NOT NULL,
        updt_dt TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL,
        CONSTRAINT pk_compy_incomestate PRIMARY KEY (compy_incomestate_sid)
    );
	
ALTER TABLE compy_incomestate OWNER TO CS_MASTER_TGT;
    
--恢复原始数据
INSERT INTO compy_incomestate (compy_incomestate_sid, first_notice_dt, latest_notice_dt, company_id, rpt_dt, start_dt, end_dt, rpt_timetype_cd, combine_type_cd, rpt_srctype_id, data_ajust_type, data_type, is_public_rpt, company_type, currency, operate_reve, operate_exp, operate_tax, sale_exp, manage_exp, finance_exp, asset_devalue_loss, fvalue_income, invest_income, intn_reve, int_reve, int_exp, commn_reve, comm_reve, comm_exp, exchange_income, premium_earned, premium_income, ripremium, undue_reserve, premium_exp, indemnity_exp, amortise_indemnity_exp, duty_reserve, amortise_duty_reserve, rireve, riexp, surrender_premium, policy_divi_exp, amortise_riexp, agent_trade_security, security_uw, client_asset_manage, operate_profit_other, operate_profit_balance, operate_profit, nonoperate_reve, nonoperate_exp, nonlasset_net_loss, sum_profit_other, sum_profit_balance, sum_profit, income_tax, net_profit_other2, net_profit_balance1, net_profit_balance2, net_profit, parent_net_profit, minority_income, undistribute_profit, basic_eps, diluted_eps, invest_joint_income, total_operate_reve, total_operate_exp, other_reve, other_exp, unconfirm_invloss, other_cincome, sum_cincome, parent_cincome, minority_cincome, net_contact_reserve, rdexp, operate_manage_exp, insur_reve, nonlasset_reve, total_operatereve_other, net_indemnity_exp, total_operateexp_other, net_profit_other1, cincome_balance1, cincome_balance2, other_net_income, reve_other, reve_balance, operate_exp_other, operate_exp_balance, bank_intnreve, bank_intreve, ninsur_commn_reve, ninsur_comm_reve, ninsur_comm_exp, adisposal_income, other_miincome, remark, chk_status, isdel, src_company_cd, srcid, src_cd, updt_by, updt_dt) 
SELECT compy_incomestate_sid, first_notice_dt, latest_notice_dt, company_id, rpt_dt, start_dt, end_dt, rpt_timetype_cd, combine_type_cd, rpt_srctype_id, data_ajust_type, data_type, is_public_rpt, company_type, currency, operate_reve, operate_exp, operate_tax, sale_exp, manage_exp, finance_exp, asset_devalue_loss, fvalue_income, invest_income, intn_reve, int_reve, int_exp, commn_reve, comm_reve, comm_exp, exchange_income, premium_earned, premium_income, ripremium, undue_reserve, premium_exp, indemnity_exp, amortise_indemnity_exp, duty_reserve, amortise_duty_reserve, rireve, riexp, surrender_premium, policy_divi_exp, amortise_riexp, agent_trade_security, security_uw, client_asset_manage, operate_profit_other, operate_profit_balance, operate_profit, nonoperate_reve, nonoperate_exp, nonlasset_net_loss, sum_profit_other, sum_profit_balance, sum_profit, income_tax, net_profit_other2, net_profit_balance1, net_profit_balance2, net_profit, parent_net_profit, minority_income, undistribute_profit, basic_eps, diluted_eps, invest_joint_income, total_operate_reve, total_operate_exp, other_reve, other_exp, unconfirm_invloss, other_cincome, sum_cincome, parent_cincome, minority_cincome, net_contact_reserve, rdexp, operate_manage_exp, insur_reve, nonlasset_reve, total_operatereve_other, net_indemnity_exp, total_operateexp_other, net_profit_other1, cincome_balance1, cincome_balance2, other_net_income, reve_other, reve_balance, operate_exp_other, operate_exp_balance, bank_intnreve, bank_intreve, ninsur_commn_reve, ninsur_comm_reve, ninsur_comm_exp, null as adisposal_income, null as other_miincome, remark, chk_status, isdel, src_company_cd, srcid, src_cd, updt_by, updt_dt
FROM compy_incomestate_bkp;

--删除备份表
drop table compy_incomestate_bkp;

--创建视图 vw_finance_subject
CREATE VIEW
    vw_finance_subject
    (
        company_id,
        rpt_dt,
        end_dt,
        combine_type_cd,
        sum_liab,
        sum_asset,
        sum_sh_equity,
        sum_lasset,
        sum_lliab,
        sum_profit,
        finance_exp,
        rpt_quarter,
        row_num
    ) AS
SELECT
    a_1.company_id,
    a_1.rpt_dt,
    a_1.end_dt,
    a_1.combine_type_cd,
    a_1.sum_liab,
    a_1.sum_asset,
    a_1.sum_sh_equity,
    a_1.sum_lasset,
    a_1.sum_lliab,
    b_1.sum_profit,
    b_1.finance_exp,
    ((("substring"(((a_1.rpt_dt)::CHARACTER(20))::text, 1, 4))::NUMERIC * (4)::NUMERIC) + (
    ("substring"(((a_1.rpt_dt)::CHARACTER(20))::text, 5, 2))::NUMERIC / (3)::NUMERIC)) AS
    rpt_quarter,
    row_number() OVER (PARTITION BY a_1.company_id, a_1.rpt_dt ORDER BY
    CASE
        WHEN (a_1.data_ajust_type = 2)
        THEN 0
        ELSE 1
    END, a_1.end_dt DESC, a_1.data_type) AS row_num
FROM
    (compy_balancesheet a_1
JOIN
    compy_incomestate b_1
ON
    (((((((
                                a_1.company_id = b_1.company_id)
                        AND (
                                a_1.combine_type_cd = b_1.combine_type_cd))
                    AND (
                            a_1.rpt_dt = b_1.rpt_dt))
                AND (
                        a_1.end_dt = b_1.end_dt))
            AND (
                    a_1.data_type = b_1.data_type))
        AND (
                a_1.combine_type_cd = 1))));

ALTER VIEW vw_finance_subject OWNER TO CS_MASTER_TGT;
     
--创建视图 vw_expired_rating           
CREATE VIEW
    vw_expired_rating
    (
        company_id,
        company_nm,
        rating,
        rating_dt,
        expired_reason,
        client_id
    ) AS
WITH
    balancesheet_latest AS
    (
        SELECT
            compy_balancesheet.company_id,
            compy_balancesheet.rpt_dt,
            compy_balancesheet.updt_dt,
            row_number() OVER (PARTITION BY compy_balancesheet.company_id ORDER BY
            CASE
                WHEN (compy_balancesheet.data_ajust_type = 2)
                THEN 0
                ELSE 1
            END, compy_balancesheet.compy_balancesheet_sid DESC) AS row_num
        FROM
            compy_balancesheet
        WHERE
            (((
                        compy_balancesheet.isdel = 0)
                AND (
                        compy_balancesheet.rpt_timetype_cd = 1))
            AND (
                    compy_balancesheet.combine_type_cd = 1))
    )
    ,
    incomestate_latest AS
    (
        SELECT
            compy_incomestate.company_id,
            compy_incomestate.rpt_dt,
            compy_incomestate.updt_dt,
            row_number() OVER (PARTITION BY compy_incomestate.company_id ORDER BY
            CASE
                WHEN (compy_incomestate.data_ajust_type = 2)
                THEN 0
                ELSE 1
            END, compy_incomestate.compy_incomestate_sid DESC) AS row_num
        FROM
            compy_incomestate
        WHERE
            (((
                        compy_incomestate.isdel = 0)
                AND (
                        compy_incomestate.rpt_timetype_cd = 1))
            AND (
                    compy_incomestate.combine_type_cd = 1))
    )
    ,
    rating_hist_latest AS
    (
        SELECT
            rating_record.company_id,
            rating_record.client_id,
            rating_record.final_rating,
            rating_record.rating_start_dt AS creation_time,
            row_number() OVER (PARTITION BY rating_record.company_id, rating_record.client_id
            ORDER BY rating_record.rating_start_dt DESC) AS row_num
        FROM
            rating_record
    )
SELECT
    a.company_id,
    b.company_nm,
    a.final_rating                    AS rating,
    a.creation_time                   AS rating_dt,
    '评级时间超过一年'::CHARACTER VARYING(40) AS expired_reason,
    a.client_id
FROM
    (rating_hist_latest a
JOIN
    compy_basicinfo b
ON
    ((
            a.company_id = (b.company_id)::NUMERIC)))
WHERE
    ((
            a.row_num = 1)
    AND (
            a.creation_time < (now() - '1 year'::interval)))
UNION ALL
SELECT
    a.company_id,
    b.company_nm,
    a.final_rating                         AS rating,
    a.creation_time                        AS rating_dt,
    '评级时间未超过一年，但已有最新年报'::CHARACTER VARYING AS expired_reason,
    a.client_id
FROM
    (((rating_hist_latest a
JOIN
    compy_basicinfo b
ON
    ((
            a.company_id = (b.company_id)::NUMERIC)))
JOIN
    balancesheet_latest c
ON
    ((
            a.company_id = (c.company_id)::NUMERIC)))
JOIN
    incomestate_latest d
ON
    ((
            a.company_id = (d.company_id)::NUMERIC)))
WHERE
    ((((((
                            a.row_num = 1)
                    AND (
                            c.row_num = 1))
                AND (
                        d.row_num = 1))
            AND (
                    c.updt_dt < (now() - '10 days'::interval)))
        AND (
                d.updt_dt < (now() - '10 days'::interval)))
    AND (
            a.creation_time >= (now() - '1 year'::interval)));

ALTER VIEW vw_expired_rating OWNER TO CS_MASTER_TGT;
            
--创建物化视图 vw_compy_finanalarm
CREATE Materialized View 
vw_compy_finanalarm
AS 
SELECT
    a.company_id,
    to_date(((a.rpt_dt)::CHARACTER(20))::text, 'yyyymmdd'::text) AS rpt_dt,
    to_date(((a.end_dt)::CHARACTER(20))::text, 'yyyymmdd'::text) AS end_dt,
    CASE
        WHEN (a.sum_asset = (0)::NUMERIC)
        THEN NULL::NUMERIC
        ELSE ((a.sum_liab / a.sum_asset) * (100)::NUMERIC)
    END AS leverage1,
    CASE
        WHEN (b.sum_asset = (0)::NUMERIC)
        THEN NULL::NUMERIC
        ELSE ((b.sum_liab / b.sum_asset) * (100)::NUMERIC)
    END AS leverage1_last_q,
    CASE
        WHEN (a.finance_exp = (0)::NUMERIC)
        THEN NULL::NUMERIC
        ELSE (((a.sum_profit + a.finance_exp) / a.finance_exp) * (100)::NUMERIC)
    END AS liquidity15,
    CASE
        WHEN (b.finance_exp = (0)::NUMERIC)
        THEN NULL::NUMERIC
        ELSE (((b.sum_profit + b.finance_exp) / b.finance_exp) * (100)::NUMERIC)
    END AS liquidity15_last_q,
    CASE
        WHEN (a.sum_lliab = (0)::NUMERIC)
        THEN NULL::NUMERIC
        ELSE ((a.sum_lasset / a.sum_lliab) * (100)::NUMERIC)
    END AS liquidity3,
    CASE
        WHEN (b.sum_lliab = (0)::NUMERIC)
        THEN NULL::NUMERIC
        ELSE ((b.sum_lasset / b.sum_lliab) * (100)::NUMERIC)
    END AS liquidity3_last_q,
    CASE
        WHEN ((a.sum_sh_equity + b.sum_sh_equity) = (0)::NUMERIC)
        THEN NULL::NUMERIC
        ELSE ((((2)::NUMERIC * (a.sum_profit + a.finance_exp)) / (a.sum_sh_equity + b.sum_sh_equity
            )) * (100)::NUMERIC)
    END AS profitability7,
    CASE
        WHEN ((b.sum_sh_equity + c.sum_sh_equity) = (0)::NUMERIC)
        THEN NULL::NUMERIC
        ELSE ((((2)::NUMERIC * (b.sum_profit + b.finance_exp)) / (b.sum_sh_equity + c.sum_sh_equity
            )) * (100)::NUMERIC)
    END AS profitability7_last_q
FROM
    ((vw_finance_subject a
JOIN
    vw_finance_subject b
ON
    (((((
                        a.company_id = b.company_id)
                AND ((
                            a.rpt_quarter - (1)::NUMERIC) = b.rpt_quarter))
            AND (
                    a.row_num = 1))
        AND (
                b.row_num = 1))))
JOIN
    vw_finance_subject c
ON
    (((((
                        a.company_id = c.company_id)
                AND ((
                            a.rpt_quarter - (2)::NUMERIC) = c.rpt_quarter))
            AND (
                    a.row_num = 1))
        AND (
                c.row_num = 1))));

ALTER TABLE vw_compy_finanalarm OWNER TO CS_MASTER_TGT;

--QC检查
select adisposal_income,other_miincome from compy_incomestate limit 1; --无报错信息，表明字段增加成功