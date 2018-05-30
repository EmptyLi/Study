-- 修改 lkp_model_bond_type
update lkp_model_bond_type  set
   bond_type_flag = 0
where type_id in (2898, 2853, 2842, 3146, 3145, 3073, 2901, 3147, 2900, 3386, 3148, 2854, 3206, 2899, 060006);
commit;

update bond_rating_model
   set model_nm ='LGD专家模型';
commit;
