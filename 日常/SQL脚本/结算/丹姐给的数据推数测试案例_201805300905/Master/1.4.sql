-- 1.4  2016年财务数据包括需要特殊处理的（入模指标缺失率小于40%）+2016年缺失的经营数据（入模指标）需触发参考评级自动计算
-- 保证 企业4有2015年12月31日的参考评级，推送该企业 2016年12月31日缺失的财务数据（缺失率小于40%）+2016年缺失的经营数据（入模指标）并推送：
-- 模型：消费品制造
-- 财务指标：
-- 有息债务/EBITDA --- Leverage18 分子=0， 分母>0, 需正常计算
-- 资产总额 --- Size1
-- 有息债务/(有息债务+所有者权益) ---Structure2
-- 营业毛利率 --- Profitability6 --- 缺失
-- 保守速动比率 --- Leverage3 --- 缺失
-- 营业周期 --- Operation1
--
-- 非财务分析：
-- 股权结构--- factor_001  ---- 2016年缺失，2015年有值
-- 融资渠道多样性 --- factor_004
-- 受限货币资金占比 --- factor_012 --- 数据库中历年无值
-- 市场地位 --- factor_071



truncate table ray_factor_list;
insert into ray_factor_list
    SELECT ft_code
  FROM (SELECT bfo.company_id,
               bfo.company_nm,
               ep.exposure_sid,
               ep.exposure,
               rms.name AS sub_model_nm,
               rmf.ft_code,
               f.factor_category_cd,
               f.factor_nm,
               fo.option_num,
               f.formula_en
          FROM rating_model_factor rmf
          JOIN rating_model_sub_model rms
            ON (rmf.sub_model_id = rms.id)
          JOIN rating_model rm
            ON (rms.parent_rm_id = rm.id AND rm.is_active = 1 AND rm.isdel = 0)
          JOIN rating_model_exposure_xw rmxw
            ON (rm.id = rmxw.model_id)
          JOIN exposure ep
            ON (rmxw.exposure_sid = ep.exposure_sid AND ep.isdel = 0)
          JOIN compy_exposure cse
            ON (ep.exposure_sid = cse.exposure_sid)
          JOIN compy_basicinfo bfo
            ON (cse.company_id = bfo.company_id AND
               bfo.company_nm = '际华集团股份有限公司')
          LEFT JOIN exposure_factor_xw efx
            ON (ep.exposure_sid = efx.exposure_sid AND
               rmf.ft_code = efx.factor_cd AND efx.isdel = 0)
          LEFT JOIN factor f
            ON (rmf.ft_code = f.factor_cd AND f.isdel = 0)
          LEFT JOIN (SELECT *
                      FROM (SELECT exposure_sid,
                                   factor_cd,
                                   option_num,
                                   formula_ch,
                                   row_number() over(PARTITION BY exposure_sid, factor_cd ORDER BY option_num DESC) AS rn
                              FROM factor_option
                             WHERE isdel = 0) as ret
                     WHERE rn = 1) fo
            ON (efx.exposure_sid = fo.exposure_sid AND
               efx.factor_cd = fo.factor_cd)
         ORDER BY ep.exposure, rm.name, rms.name, rmf.ft_code, fo.option_num) as ret;


delete from compy_finance
where company_id in (select company_id
                     from compy_basicinfo
                     where company_nm = '际华集团股份有限公司' and is_del = 0)
      and rpt_dt = date '2017-12-31';
delete from compy_finance_last_y
where company_id in (select company_id
                     from compy_basicinfo
                     where company_nm = '际华集团股份有限公司' and is_del = 0)
      and rpt_dt = date '2017-12-31';
delete from compy_finance_bf_last_y
where company_id in (select company_id
                     from compy_basicinfo
                     where company_nm = '际华集团股份有限公司' and is_del = 0)
      and rpt_dt = date '2017-12-31';
delete from compy_factor_finance
where company_id in (select company_id
                     from compy_basicinfo
                     where company_nm = '际华集团股份有限公司' and is_del = 0)
      and rpt_dt = date '2017-12-31' and factor_cd in (select ray_factor_list.factor_cd
                                                       from ray_factor_list);
delete from compy_factor_operation
where company_id in (select company_id
                     from compy_basicinfo
                     where company_nm = '际华集团股份有限公司' and is_del = 0)
      and rpt_dt = date '2017-12-31' and factor_cd in (select ray_factor_list.factor_cd
                                                       from ray_factor_list);

delete from rating_detail
where rating_record_id in (select rating_record_id
                           from rating_record
                           where company_id in (select company_id
                                                from compy_basicinfo
                                                where company_nm = '际华集团股份有限公司' and is_del = 0) and
                                 to_char(factor_dt, 'yyyy-mm-dd') = '2017-12-31');

delete from rating_display
where rating_record_id in (select rating_record_id
                           from rating_record
                           where company_id in (select company_id
                                                from compy_basicinfo
                                                where company_nm = '际华集团股份有限公司' and is_del = 0) and
                                 to_char(factor_dt, 'yyyy-mm-dd') = '2017-12-31');

delete from rating_factor
where rating_record_id in (select rating_record_id
                           from rating_record
                           where company_id in (select company_id
                                                from compy_basicinfo
                                                where company_nm = '际华集团股份有限公司' and is_del = 0) and
                                 to_char(factor_dt, 'yyyy-mm-dd') = '2017-12-31');

delete from rating_approv
where rating_record_id in (select rating_record_id
                           from rating_record
                           where company_id in (select company_id
                                                from compy_basicinfo
                                                where company_nm = '际华集团股份有限公司' and is_del = 0) and
                                 to_char(factor_dt, 'yyyy-mm-dd') = '2017-12-31');

delete from rating_adjustment_reason
where rating_record_id in (select rating_record_id
                           from rating_record
                           where company_id in (select company_id
                                                from compy_basicinfo
                                                where company_nm = '际华集团股份有限公司' and is_del = 0) and
                                 to_char(factor_dt, 'yyyy-mm-dd') = '2017-12-31');

delete from rating_record_log
where rating_record_id in (select rating_record_id
                           from rating_record
                           where company_id in (select company_id
                                                from compy_basicinfo
                                                where company_nm = '际华集团股份有限公司' and is_del = 0) and
                                 to_char(factor_dt, 'yyyy-mm-dd') = '2017-12-31');
delete from rating_record
where company_id in (select rating_record_id
                     from rating_record
                     where company_id in (select company_id
                                          from compy_basicinfo
                                          where company_nm = '际华集团股份有限公司' and is_del = 0)) and
      to_char(factor_dt, 'yyyy-mm-dd') = '2017-12-31';

delete from bond_warrantor
where secinner_id in (select secinner_id
                      from compy_security_xw
                      where company_id in (select company_id
                                           from compy_basicinfo
                                           where company_nm = '际华集团股份有限公司' and is_del = 0));

delete from bond_pledge
where secinner_id in (select secinner_id
                      from compy_security_xw
                      where company_id in (select company_id
                                           from compy_basicinfo
                                           where company_nm = '际华集团股份有限公司' and is_del = 0));


delete from bond_rating_detail
where bond_rating_record_sid in (select bond_rating_record_sid
                                 from bond_rating_record
                                 where to_char(factor_dt, 'yyyy-mm-dd') = '2017-12-31' and secinner_id in
                                                                                           (select secinner_id
                                                                                            from compy_security_xw
                                                                                            where company_id in
                                                                                                  (select company_id
                                                                                                   from compy_basicinfo
                                                                                                   where company_nm =
                                                                                                         '际华集团股份有限公司'
                                                                                                         and
                                                                                                         is_del = 0)));
delete from bond_rating_factor
where bond_rating_record_sid in (select bond_rating_record_sid
                                 from bond_rating_record
                                 where to_char(factor_dt, 'yyyy-mm-dd') = '2017-12-31' and secinner_id in
                                                                                           (select secinner_id
                                                                                            from compy_security_xw
                                                                                            where company_id in
                                                                                                  (select company_id
                                                                                                   from compy_basicinfo
                                                                                                   where company_nm =
                                                                                                         '际华集团股份有限公司'
                                                                                                         and
                                                                                                         is_del = 0)));
delete from bond_rating_xw
where bond_rating_record_sid in (select bond_rating_record_sid
                                 from bond_rating_record
                                 where to_char(factor_dt, 'yyyy-mm-dd') = '2017-12-31' and secinner_id in
                                                                                           (select secinner_id
                                                                                            from compy_security_xw
                                                                                            where company_id in
                                                                                                  (select company_id
                                                                                                   from compy_basicinfo
                                                                                                   where company_nm =
                                                                                                         '际华集团股份有限公司'
                                                                                                         and
                                                                                                         is_del = 0)));
delete from bond_rating_approv
where bond_rating_record_sid in (select bond_rating_record_sid
                                 from bond_rating_record
                                 where to_char(factor_dt, 'yyyy-mm-dd') = '2017-12-31' and secinner_id in
                                                                                           (select secinner_id
                                                                                            from compy_security_xw
                                                                                            where company_id in
                                                                                                  (select company_id
                                                                                                   from compy_basicinfo
                                                                                                   where company_nm =
                                                                                                         '际华集团股份有限公司'
                                                                                                         and
                                                                                                         is_del = 0)));
delete from bond_rating_display
where bond_rating_record_id in (select bond_rating_record_sid
                                from bond_rating_record
                                where to_char(factor_dt, 'yyyy-mm-dd') = '2017-12-31' and secinner_id in
                                                                                          (select secinner_id
                                                                                           from compy_security_xw
                                                                                           where company_id in
                                                                                                 (select company_id
                                                                                                  from compy_basicinfo
                                                                                                  where company_nm =
                                                                                                        '际华集团股份有限公司'
                                                                                                        and
                                                                                                        is_del = 0)));
delete from bond_rating_record
where to_char(factor_dt, 'yyyy-mm-dd') = '2017-12-31' and secinner_id in
                                                          (select secinner_id
                                                           from compy_security_xw
                                                           where company_id in (select company_id
                                                                                from compy_basicinfo
                                                                                where company_nm = '际华集团股份有限公司' and
                                                                                      is_del = 0));
commit;
