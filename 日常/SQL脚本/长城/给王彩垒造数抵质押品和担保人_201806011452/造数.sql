
-- 场景十三：多发行人无抵质押多担保人
--  a) 武汉钢铁有限公司  14武钢债
select * from bond_party where SECINNER_ID = '17441071' and BOND_PARTY_SID = '99999999999999'

delete from BOND_PARTY where BOND_PARTY_SID = '99999999999999';
commit;


INSERT INTO bond_party
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
 date'2018-01-20',
 514582,
 '海通证券股份有限公司',
 6502,
 date'2018-01-20',
 null,
 0,
 '7116236',
 'CSCS',
        0,
        systimestamp);
commit;
INSERT INTO bond_party
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
 date'2018-03-07',
 190801,
 '绿城房地产集团有限公司',
 6502,
 date'2018-03-07',
 null,
 0,
 '7155887',
 'CSCS',
 0,
 systimestamp);
commit;


-- 场景十二：多发行人多抵质押无担保人
-- a) 宁夏晟晏实业集团有限公司   14晟晏债
-- 17633981
INSERT INTO bond_party
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
VALUES (99999999999997,
 17633981,
 date'2018-03-07',
 190801,
 '绿城房地产集团有限公司',
 6502,
 date'2018-03-07',
 null,
 0,
 '7155887',
 'CSCS',
 0,
 systimestamp);
commit;


-- 场景十：多发行人无抵质押单担保人
-- a)	中国石油化工股份有限公司  12石化02
-- 17349859
delete from bond_party where bond_party_sid = '99999999999995';
commit;

INSERT INTO bond_party
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
VALUES (99999999999996,
 17349859,
 date'2018-03-07',
 190801,
 '绿城房地产集团有限公司',
 6502,
 date'2018-03-07',
 null,
 0,
 '7155887',
 'CSCS',
 0,
 systimestamp);
commit;
INSERT INTO bond_party
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
VALUES (99999999999995,
 17349859,
 date'2018-01-20',
 514582,
 '海通证券股份有限公司',
 6502,
 date'2018-01-20',
 null,
 0,
 '7116236',
 'CSCS',
        0,
        systimestamp);
commit;



-- 场景九：多发行人单抵质押无担保人
-- a)	白山市城市建设投资开发有限公司  PR白山债
-- 17117857

INSERT INTO bond_party
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
VALUES (99999999999994,
 17117857,
 date'2018-01-20',
 514582,
 '海通证券股份有限公司',
 6502,
 date'2018-01-20',
 null,
 0,
 '7116236',
 'CSCS',
        0,
        systimestamp);
commit;


-- 场景八：多发行人无抵质押无担保人
-- a)	中国大唐集团有限公司    16大唐02
-- 21540728

INSERT INTO bond_party
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
VALUES (99999999999993,
 21540728,
 date'2018-01-20',
 514582,
 '海通证券股份有限公司',
 6502,
 date'2018-01-20',
 null,
 0,
 '7116236',
 'CSCS',
        0,
        systimestamp);
commit;


-- 场景十一：多发行人单抵质押单担保人
-- 17457627

INSERT INTO bond_party
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
 date'2018-01-20',
 514582,
 '海通证券股份有限公司',
 6502,
 date'2018-01-20',
 null,
 0,
 '7116236',
 'CSCS',
        0,
        systimestamp);
commit;

update bond_pledge t
 set isdel = 1
 where bond_pledge_sid = '10000000001890';
commit;


场景十四：多发行人多抵制押多担保人
17318624
select * from vw_bond_issuer where secinner_id = '17318624';
select * from vw_bond_rating_cacul_pledge where secinner_id = '17318624';
select * from vw_bond_rating_cacul_warrantor where secinner_id = '17318624';


INSERT INTO bond_party
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
VALUES (99999999999991,
 17318624,
 date'2018-03-07',
 190801,
 '绿城房地产集团有限公司',
 6502,
 date'2018-03-07',
 null,
 0,
 '7155887',
 'CSCS',
 0,
 systimestamp);
commit;
INSERT INTO bond_party
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
VALUES (99999999999990,
 17318624,
 date'2018-01-20',
 514582,
 '海通证券股份有限公司',
 6502,
 date'2018-01-20',
 null,
 0,
 '7116236',
 'CSCS',
        0,
        systimestamp);
commit;


INSERT INTO bond_pledge (bond_pledge_sid, secinner_id, notice_dt, pledge_nm, pledge_type_id, pledge_desc, pledge_owner_id, pledge_owner, pledge_value, priority_value, pledge_depend_id, pledge_control_id, region, mitigation_value, isdel, srcid, src_cd, updt_by, updt_dt)
VALUES
 (99999999999996, 17318624,  date'2017-06-27', '子公司土地使用权', 6797, null, null, null, 1.9899, 0.0000, 6584, 6580,
  640000, 0.7562, 0, '999999', 'CSCS', 0, systimestamp);
commit;
INSERT INTO bond_pledge (bond_pledge_sid, secinner_id,  notice_dt, pledge_nm, pledge_type_id, pledge_desc, pledge_owner_id, pledge_owner, pledge_value, priority_value, pledge_depend_id, pledge_control_id, region, mitigation_value, isdel, srcid, src_cd, updt_by, updt_dt)
VALUES
 (99999999999995, 17318624, date'2017-07-21', '公司以其全资子公司欧亚集团沈阳联营有限公司合法拥有的房地产为本期债券提供抵押担保', 6799, null, null,
                  null, 10.2362, 0.0000, 6584, 6580, 220000, 3.1118, 0, '999999', 'CSCS', 0,
systimestamp);


-- select * from bond_warrantor where isdel = 0 and bond_warrantor_sid = '10000000014206';
INSERT INTO bond_warrantor (bond_warrantor_sid, secinner_id,  notice_dt, warranty_rate, guarantee_type_id, warranty_period, warrantor_id, warrantor_nm, warrantor_type_id, start_dt, end_dt, warranty_amt, warrantor_resume, warranty_contract, warranty_benef, warranty_content, warranty_type_id, warranty_claim, warranty_strength_id, pay_step, warranty_fee, exempt_set, warranty_obj, isser_credit, src_updt_dt, mitigation_value, isdel, srcid, src_cd, updt_by, updt_dt)
VALUES (99999999999996, 17318624,  null, null, 8111, null, 206352, '中债信用增进投资股份有限公司', 8106, null, null,
                                                                                                              15.000000000,
                                                                                                              null,
                                                                                                              null,
                                                                                                              null,
                                                                                                              null, -1,
                                                                                                              null,
                                                                                                              6603,
                                                                                                              null,
 null, null, null, null, null, null, 0, '999999', 'CSCS', 0, systimestamp);

INSERT INTO bond_warrantor (bond_warrantor_sid, secinner_id, notice_dt, warranty_rate, guarantee_type_id, warranty_period, warrantor_id, warrantor_nm, warrantor_type_id, start_dt, end_dt, warranty_amt, warrantor_resume, warranty_contract, warranty_benef, warranty_content, warranty_type_id, warranty_claim, warranty_strength_id, pay_step, warranty_fee, exempt_set, warranty_obj, isser_credit, src_updt_dt, mitigation_value, isdel, srcid, src_cd, updt_by, updt_dt)
VALUES (99999999999995, 17318624,  date'2017-12-15', null, 8111, null, 83463, '碧桂园控股有限公司', 6592, null, null,
                                                                                                                30.000000000,
                                                                                                                null,
                                                                                                                null,
                                                                                                                null,
                                                                                                                null,
                                                                                                                -1,
                                                                                                                null,
                                                                                                                6597,
                                                                                                                null,
 null, null, null, null, null, null, 0, '999999', 'CSCS', 0, systimestamp);
commit;


场景四：单发行人单抵质押品单担保人
30870245
select * from vw_bond_issuer where secinner_id = '30870245';
select * from vw_bond_rating_cacul_pledge where secinner_id = '30870245';
select * from vw_bond_rating_cacul_warrantor where secinner_id = '30870245';

select * from bond_pledge where isdel = 0 and bond_pledge_sid = '10000000001379'
INSERT INTO bond_pledge (bond_pledge_sid, secinner_id,  notice_dt, pledge_nm, pledge_type_id, pledge_desc, pledge_owner_id, pledge_owner, pledge_value, priority_value, pledge_depend_id, pledge_control_id, region, mitigation_value, isdel, srcid, src_cd, updt_by, updt_dt)
VALUES
 (99999999999997, 30870245,  date'2017-06-27', '子公司土地使用权', 6797, null, null, null, 1.9899, 0.0000, 6584, 6580,
  640000, 0.7562, 0, '999999', 'CSCS', 0, systimestamp);
commit;

select * from bond_warrantor where isdel = 0 and bond_warrantor_sid = '10000000014206';
INSERT INTO bond_warrantor (bond_warrantor_sid, secinner_id,  notice_dt, warranty_rate, guarantee_type_id, warranty_period, warrantor_id, warrantor_nm, warrantor_type_id, start_dt, end_dt, warranty_amt, warrantor_resume, warranty_contract, warranty_benef, warranty_content, warranty_type_id, warranty_claim, warranty_strength_id, pay_step, warranty_fee, exempt_set, warranty_obj, isser_credit, src_updt_dt, mitigation_value, isdel, srcid, src_cd, updt_by, updt_dt)
VALUES (99999999999997, 30870245, null, null, 8111, null, 206352, '中债信用增进投资股份有限公司', 8106, null, null,
                                                                                                              15.000000000,
                                                                                                              null,
                                                                                                              null,
                                                                                                              null,
                                                                                                              null, -1,
                                                                                                              null,
                                                                                                              6603,
                                                                                                              null,
 null, null, null, null, null, null, 0, '999999', 'CSCS', 0, systimestamp);

commit;


场景七：单发行人多抵质押多担保人
-- 17570799
select * from vw_bond_issuer where secinner_id = '17570799';
select * from vw_bond_rating_cacul_pledge where secinner_id = '17570799';
select * from vw_bond_rating_cacul_warrantor where secinner_id = '17570799';

select * from bond_pledge where isdel = 0 and bond_pledge_sid = '10000000001379'
INSERT INTO bond_pledge (bond_pledge_sid, secinner_id,  notice_dt, pledge_nm, pledge_type_id, pledge_desc, pledge_owner_id, pledge_owner, pledge_value, priority_value, pledge_depend_id, pledge_control_id, region, mitigation_value, isdel, srcid, src_cd, updt_by, updt_dt)
VALUES
 (99999999999999, 17570799,  date'2017-06-27', '子公司土地使用权', 6797, null, null, null, 1.9899, 0.0000, 6584, 6580,
  640000, 0.7562, 0, '999999', 'CSCS', 0, systimestamp);
commit;
INSERT INTO bond_pledge (bond_pledge_sid, secinner_id, notice_dt, pledge_nm, pledge_type_id, pledge_desc, pledge_owner_id, pledge_owner, pledge_value, priority_value, pledge_depend_id, pledge_control_id, region, mitigation_value, isdel, srcid, src_cd, updt_by, updt_dt)
VALUES
 (99999999999998, 17570799, date'2017-07-21', '公司以其全资子公司欧亚集团沈阳联营有限公司合法拥有的房地产为本期债券提供抵押担保', 6799, null, null,
                  null, 10.2362, 0.0000, 6584, 6580, 220000, 3.1118, 0, '999999', 'CSCS', 0,
systimestamp);


select * from bond_warrantor where isdel = 0 and bond_warrantor_sid = '10000000014206';
INSERT INTO bond_warrantor (bond_warrantor_sid, secinner_id,  notice_dt, warranty_rate, guarantee_type_id, warranty_period, warrantor_id, warrantor_nm, warrantor_type_id, start_dt, end_dt, warranty_amt, warrantor_resume, warranty_contract, warranty_benef, warranty_content, warranty_type_id, warranty_claim, warranty_strength_id, pay_step, warranty_fee, exempt_set, warranty_obj, isser_credit, src_updt_dt, mitigation_value, isdel, srcid, src_cd, updt_by, updt_dt)
VALUES (99999999999999, 17570799, null, null, 8111, null, 206352, '中债信用增进投资股份有限公司', 8106, null, null,
                                                                                                              15.000000000,
                                                                                                              null,
                                                                                                              null,
                                                                                                              null,
                                                                                                              null, -1,
                                                                                                              null,
                                                                                                              6603,
                                                                                                              null,
 null, null, null, null, null, null, 0, '999999', 'CSCS', 0, systimestamp);

INSERT INTO bond_warrantor (bond_warrantor_sid, secinner_id, notice_dt, warranty_rate, guarantee_type_id, warranty_period, warrantor_id, warrantor_nm, warrantor_type_id, start_dt, end_dt, warranty_amt, warrantor_resume, warranty_contract, warranty_benef, warranty_content, warranty_type_id, warranty_claim, warranty_strength_id, pay_step, warranty_fee, exempt_set, warranty_obj, isser_credit, src_updt_dt, mitigation_value, isdel, srcid, src_cd, updt_by, updt_dt)
VALUES (99999999999998, 17570799, date'2017-12-15', null, 8111, null, 83463, '碧桂园控股有限公司', 6592, null, null,
                                                                                                                30.000000000,
                                                                                                                null,
                                                                                                                null,
                                                                                                                null,
                                                                                                                null,
                                                                                                                -1,
                                                                                                                null,
                                                                                                                6597,
                                                                                                                null,
 null, null, null, null, null, null, 0, '999999', 'CSCS', 0, systimestamp);
commit;
