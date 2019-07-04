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