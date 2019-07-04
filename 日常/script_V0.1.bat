del *.sql 
del *.proc
del *.func

######################################## 表类测试：1、不添加任何的约束 ##############################################
# 表创建
echo create table ray_1_tab_A(id int, name varchar2(20)); >> 11_tab_create_table.sql
echo create table ray_1_tab_B(id int, name varchar2(20)); >> 11_tab_create_table.sql
echo create table ray_1_tab_C(id int, name varchar2(20)); >> 1_tab_create_table.sql
echo create table ray_1_tab_D(id int, name varchar2(20)); >> 1_tab_create_table.sql
echo create table ray_1_tab_E(id int, name varchar2(20)); >> 1_tab_create_table.sql
echo commit >> 1_tab_create_table.sql
# 表删除
echo rename ray_1_tab_A to ray_1_tab_A_bak; >> 2_tab_drop_table.sql 
echo commit >> 2_tab_drop_table.sql
# 表结构修改(增减字段）
# 表结构增加字段
echo rename ray_1_tab_B to ray_1_B_bak; >> 3_tab_add_column.sql
echo create table ray_1_tab_B(id int, add_column1 varchar2(30), name varchar2(20)); >> 3_tab_add_column.sql
echo commit >> 3_tab_add_column.sql
# 表结构删除字段
echo create table ray_1_tab_C_bak as select * from ray_1_tab_C; >> 4_tab_drop_column.sql
echo alter table ray_1_tab_C drop column name >> 4_tab_drop_column.sql
echo commit >> 4_tab_drop_column.sql
# 表结构修改(修改字段类型）
echo create table ray_1_tab_D_bak as select * from ray_1_tab_D; >> 5_tab_modify_column.sql 
echo truncate table ray_1_tab_D; >> 5_tab_modify_column.sql 
echo alter table ray_1_tab_D modify id varchar2(100); >> 5_tab_modify_column.sql 
echo insert into ray_1_tab_D select * from ray_1_tab_D_bak; >> 5_tab_modify_column.sql
echo commit >> 5_tab_modify_column.sql
######################################## 视图测试：2、不添加任何的约束 ##############################################
# 视图创建
echo create or replace view ray_2_vw_A as select * from ray_1_tab_B; >> 6_vw_create_view.sql
echo create or replace view ray_2_vw_B as select * from ray_1_tab_B; >> 6_vw_create_view.sql
echo create or replace view ray_2_vw_C as select * from ray_1_tab_B; >> 6_vw_create_view.sql
echo commit >> 6_vw_create_view.sql
# 视图删除
echo rename ray_2_vw_B to ray_2_vw_B_bak; >> 7_vw_drop_view.sql
echo commit >> 7_vw_drop_view.sql
# 视图表更
echo rename ray_2_vw_C to ray_2_vw_C_bak; >> 8_vw_modify_view.sql
echo create or replace view ray_2_vw_C select id, name from ray_1_tab_B; >> 8_vw_modify_view.sql
echo commit >> 8_vw_modify_view.sql
######################################## 物化视图测试：3、不添加任何的约束 #########################################
# 物化视图创建
echo create materialized view log on ray_1_tab_E; >> 9_mv_create_mv.sql
echo create materialized view ray_3_mv_C refresh fast on commit as select * from ray_1_tab_E; >> 9_mv_create_mv.sql
echo create materialized view log on ray_1_tab_B; >> 9_mv_create_mv.sql
echo create materialized view ray_3_mv_A refresh fast on commit as select * from ray_1_tab_B; >> 9_mv_create_mv.sql
echo create materialized view log on ray_1_tab_C; >> 9_mv_create_mv.sql
echo create materialized view ray_3_mv_B refresh fast on commit as select * from ray_1_tab_C; >> 9_mv_create_mv.sql
echo commit >> 9_mv_create_mv.sql
# 物化视图删除
echo alter table ray_3_mv_C rename ray_3_mv_C_bak PRESERVE TABLE; >> 10_mv_drop_mv.sql
echo commit >> 10_mv_drop_mv.sql
# 视图表更
echo alter table ray_3_mv_B rename ray_3_mv_B_bak PRESERVE TABLE; >> 11_mv_modify_mv.sql
echo create materialized view ray_3_mv_B refresh fast on commit as select * from ray_1_tab_C; >> 11_mv_modify_mv.sql
echo commit >> 11_mv_modify_mv.sql
######################################## 存储过程测试：4、不添加任何的约束 #########################################
# 存储过程创建
echo CREATE OR REPLACE PROCEDURE ray_sp_drop1(p_table in varchar2)            >> 12_proc_create_procedure.proc
echo AS                                                                       >> 12_proc_create_procedure.proc
echo   v_count number(10);                                                    >> 12_proc_create_procedure.proc
echo BEGIN                                                                    >> 12_proc_create_procedure.proc
echo   SELECT COUNT(*)                                                        >> 12_proc_create_procedure.proc
echo     INTO V_COUNT                                                         >> 12_proc_create_procedure.proc
echo     FROM USER_TABLES                                                     >> 12_proc_create_procedure.proc
echo    WHERE TABLE_NAME = UPPER(p_table);                                    >> 12_proc_create_procedure.proc
echo                                                                          >> 12_proc_create_procedure.proc
echo   IF V_COUNT > 0 THEN                                                    >> 12_proc_create_procedure.proc
echo     EXECUTE IMMEDIATE 'drop table ' || p_table || ' purge';              >> 12_proc_create_procedure.proc
echo   END IF;                                                                >> 12_proc_create_procedure.proc
echo END;                                                                     >> 12_proc_create_procedure.proc
echo /                                                                        >> 12_proc_create_procedure.proc

echo CREATE OR REPLACE PROCEDURE ray_sp_drop2(p_table in varchar2)            >> 12_proc_create_procedure.proc
echo AS                                                                       >> 12_proc_create_procedure.proc
echo   v_count number(10);                                                    >> 12_proc_create_procedure.proc
echo BEGIN                                                                    >> 12_proc_create_procedure.proc
echo   SELECT COUNT(*)                                                        >> 12_proc_create_procedure.proc
echo     INTO V_COUNT                                                         >> 12_proc_create_procedure.proc
echo     FROM USER_TABLES                                                     >> 12_proc_create_procedure.proc
echo    WHERE TABLE_NAME = UPPER(p_table);                                    >> 12_proc_create_procedure.proc
echo                                                                          >> 12_proc_create_procedure.proc
echo   IF V_COUNT > 0 THEN                                                    >> 12_proc_create_procedure.proc
echo     EXECUTE IMMEDIATE 'drop table ' || p_table || ' purge';              >> 12_proc_create_procedure.proc
echo   END IF;                                                                >> 12_proc_create_procedure.proc
echo END;                                                                     >> 12_proc_create_procedure.proc
echo /                                                                        >> 12_proc_create_procedure.proc

echo CREATE OR REPLACE PROCEDURE ray_sp_drop3(p_table in varchar2)            >> 12_proc_create_procedure.proc
echo AS                                                                       >> 12_proc_create_procedure.proc
echo   v_count number(10);                                                    >> 12_proc_create_procedure.proc
echo BEGIN                                                                    >> 12_proc_create_procedure.proc
echo   SELECT COUNT(*)                                                        >> 12_proc_create_procedure.proc
echo     INTO V_COUNT                                                         >> 12_proc_create_procedure.proc
echo     FROM USER_TABLES                                                     >> 12_proc_create_procedure.proc
echo    WHERE TABLE_NAME = UPPER(p_table);                                    >> 12_proc_create_procedure.proc
echo                                                                          >> 12_proc_create_procedure.proc
echo   IF V_COUNT > 0 THEN                                                    >> 12_proc_create_procedure.proc
echo     EXECUTE IMMEDIATE 'drop table ' || p_table || ' purge';              >> 12_proc_create_procedure.proc
echo   END IF;                                                                >> 12_proc_create_procedure.proc
echo END;                                                                     >> 12_proc_create_procedure.proc
echo /                                                                        >> 12_proc_create_procedure.proc
# 存储过程删除
echo drop procedure ray_sp_drop2; >> 12_proc_drop_proc.sql 

# 存储过程修改
echo drop procedure ray_sp_drop3; >> 13_proc_drop_proc.sql 
echo CREATE OR REPLACE PROCEDURE ray_sp_drop3(p_table in varchar2)            >> 14_proc_create_procedure.proc
echo AS                                                                       >> 14_proc_create_procedure.proc
echo   v_count number(10);                                                    >> 14_proc_create_procedure.proc
echo BEGIN                                                                    >> 14_proc_create_procedure.proc
echo   SELECT COUNT(*) INTO V_COUNT FROM USER_TABLES WHERE TABLE_NAME = UPPER(p_table); >> 14_proc_create_procedure.proc
echo                                                                          >> 14_proc_create_procedure.proc
echo   IF V_COUNT > 0 THEN                                                    >> 14_proc_create_procedure.proc
echo     EXECUTE IMMEDIATE 'drop table ' || p_table || ' purge';              >> 14_proc_create_procedure.proc
echo   END IF;                                                                >> 14_proc_create_procedure.proc
echo END;                                                                     >> 14_proc_create_procedure.proc
echo /  

######################################## 函数测试：5、不添加任何的约束 #############################################
# 函数创建
echo create or replace function ray_get_seq_next1(seq_name in varchar2) return number is   >> 15_func_create_functions.func
echo   seq_val number;                                                                     >> 15_func_create_functions.func
echo begin                                                                                 >> 15_func_create_functions.func
echo   execute immediate 'select ' || seq_name || '.nextval from dual'                     >> 15_func_create_functions.func
echo     into seq_val;                                                                     >> 15_func_create_functions.func
echo   return seq_val;                                                                     >> 15_func_create_functions.func
echo end get_seq_next;                                                                     >> 15_func_create_functions.func
echo /                                                                                     >> 15_func_create_functions.func
echo                                                                                       >> 15_func_create_functions.func
echo create or replace function ray_get_seq_next2(seq_name in varchar2) return number is   >> 15_func_create_functions.func
echo   seq_val number;                                                                     >> 15_func_create_functions.func
echo begin                                                                                 >> 15_func_create_functions.func
echo   execute immediate 'select ' || seq_name || '.nextval from dual'                     >> 15_func_create_functions.func
echo     into seq_val;                                                                     >> 15_func_create_functions.func
echo   return seq_val;                                                                     >> 15_func_create_functions.func
echo end get_seq_next;                                                                     >> 15_func_create_functions.func
echo /                                                                                     >> 15_func_create_functions.func
echo                                                                                       >> 15_func_create_functions.func
echo create or replace function ray_get_seq_next3(seq_name in varchar2) return number is   >> 15_func_create_functions.func
echo   seq_val number;                                                                     >> 15_func_create_functions.func
echo begin                                                                                 >> 15_func_create_functions.func
echo   execute immediate 'select ' || seq_name || '.nextval from dual'                     >> 15_func_create_functions.func
echo     into seq_val;                                                                     >> 15_func_create_functions.func
echo   return seq_val;                                                                     >> 15_func_create_functions.func
echo end get_seq_next;                                                                     >> 15_func_create_functions.func
echo /                                                                                     >> 15_func_create_functions.func

# 函数删除
echo drop function ray_get_seq_next2; >> 16_func_drop_func.sql 
# 函数修改
echo drop function ray_get_seq_next3; >> 17_func_drop_func.sql
echo create or replace function ray_get_seq_next3(seq_name in varchar2) return number is   >> 17_func_create_functions.func
echo   seq_val number;                                                                     >> 17_func_create_functions.func
echo begin                                                                                 >> 17_func_create_functions.func
echo   execute immediate 'select ' || seq_name || '.nextval from dual' into seq_val;       >> 17_func_create_functions.func                                                             >> 17_func_create_func.func
echo   return seq_val;                                                                     >> 17_func_create_functions.func
echo end get_seq_next;                                                                     >> 17_func_create_functions.func
echo /                                                                                     >> 17_func_create_functions.func
######################################## 序列测试：6、不添加任何的约束 #############################################
# 序列创建
echo create sequence ray_6_seq_A; >> 18_seq_create_sequence.sql
echo create sequence ray_6_seq_B START WITH 10000000000481; >> 18_seq_create_sequence.sql
echo create sequence ray_6_seq_C; >> 18_seq_create_sequence.sql
# 序列删除
echo drop sequence ray_6_seq_B; >> 19_seq_drop_sequence.sql
# 序列值重置
echo drop sequence ray_6_seq_C; >> 20_seq_modify_sequence.sql
echo create sequence ray_6_seq_B START WITH 810000000000481; >> 20_seq_modify_sequence.sql
######################################## 索引测试：7、不添加任何的约束 #############################################
# 索引创建
echo create index ray_1_tab_A_idx on ray_1_tab_A(id); >> 21_idx_create_index.sql
echo create index ray_1_tab_B_idx on ray_1_tab_A(name); >> 21_idx_create_index.sql
echo create index ray_1_tab_C_idx on ray_1_tab_A(id, name); >> 21_idx_create_index.sql

# 索引删除
echo drop index ray_1_tab_B_idx; >> 21_idx_drop_index.sql
# 索引重建
echo drop index ray_1_tab_C_idx; >> 22_idx_rebuild_index.sql
echo create index ray_1_tab_D_idx on ray_1_tab_A(name); >> 23_idx_create_index.sql

######################################## 检查对象：8、不添加任何的约束 #############################################
# 新建表
# 新建视图
# 新建物化视图
# 新建存储过程
# 新建函数
# 新建序列
# 新建索引
# 删除表
# 删除视图
# 删除物化视图
# 删除存储过程
# 删除函数
# 删除序列
# 删除索引
# 修改表
# 修改视图
# 修改序列
# 修改索引
######################################## 编译失效对象：9、不添加任何的约束 #############################################
# 编译失效视图
echo alter view ray_2_vw_A compile; >> 24_vw_recompile_view.sql 
echo alter view ray_2_vw_C compile; >> 24_vw_recompile_view.sql 
# 编译失效物化视图
echo ALTER MATERIALIZED VIEW ray_3_mv_A compile; >> 25_mv_recompile_view.sql
echo ALTER MATERIALIZED VIEW ray_3_mv_C compile; >> 25_mv_recompile_view.sql
# 编译失效存储过程
echo ALTER PROCEDURE ray_sp_drop3 compile; >> 26_proc_recompile_procedure.sql
echo ALTER PROCEDURE ray_sp_drop1 compile; >> 26_proc_recompile_procedure.sql
# 编译失效函数
echo ALTER function ray_get_seq_next1 compile; >> 27_func_recompile_functions.sql
echo ALTER function ray_get_seq_next3 compile; >> 27_func_recompile_functions.sql
# 编译失效索引
echo alter index ray_1_tab_A_idx rebuild; >> 28_idx_recompile_index.sql
echo ALTER index ray_1_tab_C_idx rebuild; >> 28_idx_recompile_index.sql
######################################## 清理对象：10、不添加任何的约束 ################################################
# 清理表
echo drop table ray_1_tab_A_bak; >> 29_tab_clean_table.sql 
echo drop table ray_1_tab_B_bak; >> 29_tab_clean_table.sql 
echo drop table ray_1_tab_C_bak; >> 29_tab_clean_table.sql 
# 清理视图
echo drop view ray_2_vw_B_bak; >> 29_idx_clean_index.sql
echo drop view ray_2_vw_C_bak; >> 29_idx_clean_index.sql  
# 清理物化视图
echo DROP MATERIALIZED VIEW ray_3_mv_A; >> 30_mv_clean_view.sql
echo DROP MATERIALIZED VIEW LOG ON ray_1_tab_B; >> 30_mv_clean_view.sql
######################################## 回滚对象：11、不添加任何的约束 ################################################
# 回滚表
# 回滚视图
# 回滚物化视图
# 回滚存储过程
# 回滚函数
# 回滚序列
# 回滚索引

















