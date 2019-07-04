-- 1. 用户基本权限
grant connect, resource to cmap_deploy;
grant unlimited tablespace to cmap_deploy;
-- 2. 表权限
grant alter any table to cmap_deploy;
grant create any table to cmap_deploy;
grant drop any table to cmap_deploy;
grant comment any table to cmap_deploy;
-- 3. 视图权限
grant create any view to cmap_deploy;
grant drop any view to cmap_deploy;
-- 4. 序列权限
grant create any sequence to cmap_deploy;
grant drop any sequence to cmap_deploy;
-- 5. 存储过程及函数权限
grant create any procedure to cmap_deploy;
grant drop any procedure to cmap_deploy;
grant alter any procedure to cmap_deploy;
grant execute any procedure to cmap_deploy;
-- 6. 索引权限
grant create any index to cmap_deploy;
grant alter any index to cmap_deploy;
grant drop any index to cmap_deploy;
-- 7. 物化视图权限
grant create any materialized view to cmap_deploy;
grant drop any materialized view to cmap_deploy;

-- 8. 数据操作权限
grant select any table to cmap_deploy;
grant update any table to cmap_deploy;
grant insert any table to cmap_deploy;
grant delete any table to cmap_deploy;
