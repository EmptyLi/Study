场景一：单发行人单抵质押品单担保人
当前发行人：四川川投能源股份有限公司
当前债券：13川投01
要求：需添加一个抵质押,一个担保人
-- 13川投01
select * from bond_basicinfo where security_snm = '13川投01';
-- 17387806
select * from bond_pledge where secinner_id = 17387806;
select * from bond_pledge where isdel = 0 limit 1;

INSERT INTO public.bond_pledge (bond_pledge_sid,
                                secinner_id,
                                rpt_dt,
                                notice_dt,
                                pledge_nm,
                                pledge_type_id,
                                pledge_desc,
                                pledge_owner_id,
                                pledge_owner,
                                pledge_value,
                                priority_value,
                                pledge_depend_id,
                                pledge_control_id,
                                region,
                                mitigation_value,
                                isdel,
                                srcid,
                                src_cd,
                                updt_by,
                                updt_dt)
VALUES
  (88810000000000404,
    17387806,
    '2016-12-31', '2017-06-28', '营口市人民政府58.79 亿元的应收账款', 6829, null, null, null, 40.7900, 0.0000, 6584, 6581, 210000,
   10.8501, 0, '105435', 'EXPERT', 0, '2017-08-25 20:05:32.000000');
select * from vw_bond_rating_cacul_pledge where secinner_id = '17387806';

select * from bond_warrantor where isdel = 0 limit 1;

INSERT INTO public.bond_warrantor
(bond_warrantor_sid, secinner_id, rpt_dt, notice_dt, warranty_rate, guarantee_type_id, warranty_period,
 warrantor_id, warrantor_nm, warrantor_type_id, start_dt, end_dt, warranty_amt, warrantor_resume, warranty_contract,
 warranty_benef, warranty_content, warranty_type_id, warranty_claim, warranty_strength_id, pay_step, warranty_fee,
 exempt_set, warranty_obj, isser_credit, src_updt_dt, mitigation_value, isdel, srcid, src_cd, updt_by, updt_dt)
VALUES (80010000000011120, 17387806, '2016-12-31', null, null, 8111, null, 128160, '河北建设投资集团有限责任公司', 8104, null, null, 4.499980000, null, null, null, null, -1, null, 6597, null, null, null, null, null, null, 3.6000, 0, '108668', 'EXPERT', 0, '2017-08-25 20:14:46.000000');

select * from vw_bond_rating_cacul_warrantor where secinner_id = '17387806'

commit;

场景二：单发行人多抵质押多担保人
当前发行人：浏阳市城市建设集团有限公司
当前债券：16浏城建
要求：需要添加两个抵质押品

-- 16浏城建
select * from bond_basicinfo where security_snm = '16浏城建';
-- 17450879
select * from bond_pledge where secinner_id = 17387806;
select * from bond_pledge where isdel = 0 and bond_pledge_sid <> '10000000000404' limit 1;
delete from bond_pledge where bond_pledge_sid = '88710000000000404';
INSERT INTO public.bond_pledge (bond_pledge_sid,
                                secinner_id,
                                rpt_dt,
                                notice_dt,
                                pledge_nm,
                                pledge_type_id,
                                pledge_desc,
                                pledge_owner_id,
                                pledge_owner,
                                pledge_value,
                                priority_value,
                                pledge_depend_id,
                                pledge_control_id,
                                region,
                                mitigation_value,
                                isdel,
                                srcid,
                                src_cd,
                                updt_by,
                                updt_dt)
VALUES
  (88710000000000404,
    17450879,
    '2016-12-31', '2017-06-28', '营口市人民政府58.79 亿元的应收账款', 6829, null, null, null, 40.7900, 0.0000, 6584, 6581, 210000,
   10.8501, 0, '105435', 'EXPERT', 0, '2017-08-25 20:05:32.000000');

INSERT INTO public.bond_pledge (bond_pledge_sid, secinner_id, rpt_dt, notice_dt, pledge_nm, pledge_type_id,
                                pledge_desc, pledge_owner_id, pledge_owner, pledge_value, priority_value,
                                pledge_depend_id, pledge_control_id, region, mitigation_value, isdel,
                                srcid, src_cd, updt_by, updt_dt) VALUES (88610000000000380, 17450879, '2016-12-31', '2017-06-28', '“12 衡阳城投债/PR 衡城投”以衡阳市区 三宗商业、住宅土地使用权作为抵押担保，土 地面积合计 930004.65 平方米。', 6797, null, null, null, 35.3500, 0.0000, 6584, 6580, 430000, 15.1121, 0, '105254', 'EXPERT', 0, '2017-08-25 20:05:32.000000');

场景三：多发行人单抵质押无担保人
当前发行人：永州市零陵城建投资有限公司
当前债券： PR永城建
要求：需要再添加一个发行人
-- PR永城建
select * from bond_basicinfo where security_snm = 'PR永城建';

17254628

select * from vw_bond_issuer where secinner_id = '17254628'

INSERT INTO public.bond_party
(bond_party_sid,
 secinner_id,
 notice_dt,
 party_id,
 party_nm,
 party_type_id,
 start_dt,
 end_dt,
 isdel,
 srcid,
 src_cd,
 updt_by,
 updt_dt)
VALUES (80099999999999999,
 17254628,
 '2018-01-20',
 514582,
 '海通证券股份有限公司',
 6502,
 '2018-01-20',
 null,
 0,
 '7116236',
 'CSCS',
        0,
        now());
commit;


场景四：多发行人无抵质押单担保人
当前发行人：永兴银都投资建设发展(集团)有限公司
当前债券：16永银都
要求：需要再添加两个发行人

-- select * from bond_basicinfo where security_snm = '16永银都';
17356032
select * from vw_bond_issuer where secinner_id = '17356032'

INSERT INTO public.bond_party
(bond_party_sid,
 secinner_id,
 notice_dt,
 party_id,
 party_nm,
 party_type_id,
 start_dt,
 end_dt,
 isdel,
 srcid,
 src_cd,
 updt_by,
 updt_dt)
VALUES (80199999999999999,
 17356032,
 '2018-01-20',
 514582,
 '海通证券股份有限公司',
 6502,
 '2018-01-20',
 null,
 0,
 '7116236',
 'CSCS',
        0,
        now());
commit;

INSERT INTO public.bond_party
(bond_party_sid,
 secinner_id,
 notice_dt,
 party_id,
 party_nm,
 party_type_id,
 start_dt,
 end_dt,
 isdel,
 srcid,
 src_cd,
 updt_by,
 updt_dt)
VALUES (80299999999999998,
 17356032,
 '2018-03-07',
 190801,
 '绿城房地产集团有限公司',
 6502,
 '2018-03-07',
 null,
 0,
 '7155887',
 'CSCS',
 0,
 now());
commit;

场景五：多发行人单抵质押单担保人
当前发行人：天津广成投资集团有限公司
债券：16津广成
要求：需要添加发行人1个，一个抵质押，一个担保人

select * from bond_basicinfo where security_snm = '16津广成';
17122311

delete from bond_party where bond_party_sid = 80399999999999998;
INSERT INTO public.bond_party
(bond_party_sid,
 secinner_id,
 notice_dt,
 party_id,
 party_nm,
 party_type_id,
 start_dt,
 end_dt,
 isdel,
 srcid,
 src_cd,
 updt_by,
 updt_dt)
VALUES (80399999999999998,
 17122311,
 '2018-03-07',
 190801,
 '绿城房地产集团有限公司',
 6502,
 '2018-03-07',
 null,
 0,
 '7155887',
 'CSCS',
 0,
 now());
commit;
delete from bond_pledge where bond_pledge_sid = 88510000000000380;
INSERT INTO public.bond_pledge (bond_pledge_sid, secinner_id, rpt_dt, notice_dt, pledge_nm, pledge_type_id,
                                pledge_desc, pledge_owner_id, pledge_owner, pledge_value, priority_value,
                                pledge_depend_id, pledge_control_id, region, mitigation_value, isdel,
                                srcid, src_cd, updt_by, updt_dt) VALUES (88510000000000380, 17122311, '2016-12-31', '2017-06-28', '“12 衡阳城投债/PR 衡城投”以衡阳市区 三宗商业、住宅土地使用权作为抵押担保，土 地面积合计 930004.65 平方米。', 6797, null, null, null, 35.3500, 0.0000, 6584, 6580, 430000, 15.1121, 0, '105254', 'EXPERT', 0, '2017-08-25 20:05:32.000000');
commit;

delete from bond_warrantor where bond_warrantor_sid = 88810000000011120;
INSERT INTO public.bond_warrantor
(bond_warrantor_sid, secinner_id, rpt_dt, notice_dt, warranty_rate, guarantee_type_id, warranty_period,
 warrantor_id, warrantor_nm, warrantor_type_id, start_dt, end_dt, warranty_amt, warrantor_resume, warranty_contract,
 warranty_benef, warranty_content, warranty_type_id, warranty_claim, warranty_strength_id, pay_step, warranty_fee,
 exempt_set, warranty_obj, isser_credit, src_updt_dt, mitigation_value, isdel, srcid, src_cd, updt_by, updt_dt)
VALUES (88810000000011120, 17122311, '2016-12-31', null, null, 8111, null, 128160, '河北建设投资集团有限责任公司', 8104, null, null, 4.499980000, null, null, null, null, -1, null, 6597, null, null, null, null, null, null, 3.6000, 0, '108668', 'EXPERT', 0, '2017-08-25 20:14:46.000000');


select * from vw_bond_issuer where secinner_id = 17122311;
select * from vw_bond_rating_cacul_warrantor where secinner_id = 17122311;
select * from vw_bond_rating_cacul_pledge where secinner_id = 17122311;


场景六：多发行人多抵质押无担保人
当前发行人：白山市城市建设投资开发有限公司
当前债券：PR白山债
要求:需添再加一个发行人
select * from bond_basicinfo where security_snm = 'PR白山债';
17117857

delete from bond_party where bond_party_sid = 80499999999999998;
INSERT INTO public.bond_party
(bond_party_sid,
 secinner_id,
 notice_dt,
 party_id,
 party_nm,
 party_type_id,
 start_dt,
 end_dt,
 isdel,
 srcid,
 src_cd,
 updt_by,
 updt_dt)
VALUES (80499999999999998,
 17117857,
 '2018-03-07',
 190801,
 '绿城房地产集团有限公司',
 6502,
 '2018-03-07',
 null,
 0,
 '7155887',
 'CSCS',
 0,
 now());
commit;


场景七：多发行人无抵质押多担保人
当前发行人：武汉钢铁有限公司
当前债券： 14武钢债
要求：需要再添加两个发行人
INSERT INTO public.bond_party
(bond_party_sid,
 secinner_id,
 notice_dt,
 party_id,
 party_nm,
 party_type_id,
 start_dt,
 end_dt,
 isdel,
 srcid,
 src_cd,
 updt_by,
 updt_dt)
VALUES (99999999999999,
 17441071,
 '2018-01-20',
 514582,
 '海通证券股份有限公司',
 6502,
 '2018-01-20',
 null,
 0,
 '7116236',
 'CSCS',
        0,
        now());
commit;
INSERT INTO public.bond_party
(bond_party_sid,
 secinner_id,
 notice_dt,
 party_id,
 party_nm,
 party_type_id,
 start_dt,
 end_dt,
 isdel,
 srcid,
 src_cd,
 updt_by,
 updt_dt)
VALUES (99999999999998,
 17441071,
 '2018-03-07',
 190801,
 '绿城房地产集团有限公司',
 6502,
 '2018-03-07',
 null,
 0,
 '7155887',
 'CSCS',
 0,
 now());
commit;

场景八：多发行人多抵制押多担保人
当前发行人：青岛莱西市资产运营有限公司
当前债券：PR青莱西
要求：需要再加一个发行人，再添加两个抵质押

INSERT INTO public.bond_party
(bond_party_sid,
 secinner_id,
 notice_dt,
 party_id,
 party_nm,
 party_type_id,
 start_dt,
 end_dt,
 isdel,
 srcid,
 src_cd,
 updt_by,
 updt_dt)
VALUES (99999999999992,
 17457627,
 '2018-01-20',
 514582,
 '海通证券股份有限公司',
 6502,
 '2018-01-20',
 null,
 0,
 '7116236',
 'CSCS',
        0,
        now());
commit;


INSERT INTO public.bond_pledge (bond_pledge_sid,
                                secinner_id,
                                rpt_dt,
                                notice_dt,
                                pledge_nm,
                                pledge_type_id,
                                pledge_desc,
                                pledge_owner_id,
                                pledge_owner,
                                pledge_value,
                                priority_value,
                                pledge_depend_id,
                                pledge_control_id,
                                region,
                                mitigation_value,
                                isdel,
                                srcid,
                                src_cd,
                                updt_by,
                                updt_dt)
VALUES
  (82710000000000404,
    17457627,
    '2016-12-31', '2017-06-28', '营口市人民政府58.79 亿元的应收账款', 6829, null, null, null, 40.7900, 0.0000, 6584, 6581, 210000,
   10.8501, 0, '105435', 'EXPERT', 0, '2017-08-25 20:05:32.000000');

INSERT INTO public.bond_pledge (bond_pledge_sid, secinner_id, rpt_dt, notice_dt, pledge_nm, pledge_type_id,
                                pledge_desc, pledge_owner_id, pledge_owner, pledge_value, priority_value,
                                pledge_depend_id, pledge_control_id, region, mitigation_value, isdel,
                                srcid, src_cd, updt_by, updt_dt) VALUES (81610000000000380, 17457627, '2016-12-31', '2017-06-28', '“12 衡阳城投债/PR 衡城投”以衡阳市区 三宗商业、住宅土地使用权作为抵押担保，土 地面积合计 930004.65 平方米。', 6797, null, null, null, 35.3500, 0.0000, 6584, 6580, 430000, 15.1121, 0, '105254', 'EXPERT', 0, '2017-08-25 20:05:32.000000');
