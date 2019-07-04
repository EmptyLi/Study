select a.security_type_id, b.constant_nm, a.issue_type_cd, l.constant_nm, count(*) from bond_basicinfo a
  inner join lkp_charcode b on a.security_type_id = b.constant_id
  inner join LKP_NUMBCODE l
    on l.isdel = 0
       and l.constant_type = 205
       and l.constant_cd = a.issue_type_cd
where a.issue_vol is null and a.isdel = 0 and a.mrty_dt > now()
group by a.security_type_id, b.constant_nm,l.constant_nm,a.issue_type_cd;
