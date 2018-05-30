create view vw_bond_pledge as
select
    bond_pledge_sid,
    secinner_id,
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
    updt_dt
  from (
  SELECT bond_pledge.bond_pledge_sid,
    bond_pledge.secinner_id,
    bond_pledge.notice_dt,
    bond_pledge.pledge_nm,
    bond_pledge.pledge_type_id,
    bond_pledge.pledge_desc,
    bond_pledge.pledge_owner_id,
    bond_pledge.pledge_owner,
    bond_pledge.pledge_value,
    bond_pledge.priority_value,
    bond_pledge.pledge_depend_id,
    bond_pledge.pledge_control_id,
    bond_pledge.region,
    bond_pledge.mitigation_value,
    bond_pledge.isdel,
    bond_pledge.srcid,
    bond_pledge.src_cd,
    0 AS updt_by,
    bond_pledge.updt_dt,
    bond_pledge.rpt_dt,
    max(rpt_dt)over(partition by secinner_id) as max_rpt_dt,
    row_number()over(partition by secinner_id, pledge_nm, to_char(rpt_dt, 'yyyy') order by rpt_dt desc, updt_dt) as cnt
   FROM bond_pledge) as ret
where to_char(rpt_dt, 'yyyy') = to_char(max_rpt_dt, 'yyyy')
  and cnt = 1;


