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