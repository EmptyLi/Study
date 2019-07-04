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