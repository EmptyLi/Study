delete from bond_factor_option where 1 = 1;
insert into  bond_factor_option
(bond_factor_option_sid
,  factor_cd
,model_id
,option_type
,option
,option_num
,ratio
,low_bound
,remark
,isdel
,client_id
,updt_by
,updt_dt
)
select bond_factor_option_sid
,  factor_cd
,1 as model_id
,option_type
,option
,option_num
,ratio
,low_bound
,remark
,isdel
,client_id
,updt_by
,updt_dt
  from ray_bond_factor_option;
  commit;
