del *.sql
del *.proc
del .\rollback\*.sql
del .\rollback\*.proc
######################################## 表类测试：1、不添加任何的约束 ##############################################
echo CREATE OR REPLACE PROCEDURE SP_DROP_OBJECT(P_OWNER      IN VARCHAR2,                                      >> 00_rollback_procedure.proc
echo                                     P_OBJECTNAME IN VARCHAR2,                                             >> 00_rollback_procedure.proc
echo                                     P_OBJECTTYPE IN VARCHAR2) AS                                          >> 00_rollback_procedure.proc
echo   V_STMT_STR VARCHAR(4000);                                                                               >> 00_rollback_procedure.proc
echo BEGIN                                                                                                     >> 00_rollback_procedure.proc
echo   BEGIN                                                                                                   >> 00_rollback_procedure.proc
echo     SELECT  'DROP '^|^| OBJECT_TYPE ^|^| ' ' ^|^| OWNER ^|^| '.' ^|^| OBJECT_NAME ^|^| ''                 >> 00_rollback_procedure.proc
echo              INTO V_STMT_STR                                                                              >> 00_rollback_procedure.proc
echo              FROM ALL_OBJECTS                                                                             >> 00_rollback_procedure.proc
echo             WHERE OBJECT_NAME = UPPER(TRIM(P_OBJECTNAME))                                                 >> 00_rollback_procedure.proc
echo               AND OWNER = UPPER(TRIM(P_OWNER))                                                            >> 00_rollback_procedure.proc
echo               AND OBJECT_TYPE = UPPER(TRIM(P_OBJECTTYPE));                                                >> 00_rollback_procedure.proc
echo   EXCEPTION                                                                                               >> 00_rollback_procedure.proc
echo     WHEN NO_DATA_FOUND THEN                                                                               >> 00_rollback_procedure.proc
echo       V_STMT_STR := 'SELECT SYSTIMESTAMP FROM DUAL';                                                      >> 00_rollback_procedure.proc
echo   END;                                                                                                    >> 00_rollback_procedure.proc
echo   EXECUTE IMMEDIATE V_STMT_STR;                                                                           >> 00_rollback_procedure.proc
echo EXCEPTION                                                                                                 >> 00_rollback_procedure.proc
echo   WHEN OTHERS THEN                                                                                        >> 00_rollback_procedure.proc
echo     DBMS_OUTPUT.PUT_LINE(V_STMT_STR);                                                                     >> 00_rollback_procedure.proc
echo     DBMS_OUTPUT.put_line(SQLCODE ^|^| SQLERRM);                                                           >> 00_rollback_procedure.proc
echo END;                                                                                                      >> 00_rollback_procedure.proc

######################################## 表类测试：1、不添加任何的约束 ##############################################
# 表创建
echo create table ray_1_tab_A(id int, name varchar2(20));                                                      >> 01_tab_create_table.sql
echo create table ray_1_tab_B(id int, name varchar2(20));                                                      >> 01_tab_create_table.sql
echo create table ray_1_tab_C(id int, name varchar2(20));                                                      >> 01_tab_create_table.sql
echo create table ray_1_tab_D(id int, name varchar2(20));                                                      >> 01_tab_create_table.sql
echo create table ray_1_tab_E(id int, name varchar2(20));                                                      >> 01_tab_create_table.sql
echo commit;                                                                                                   >> 01_tab_create_table.sql
# 表删除
echo rename ray_1_tab_A to ray_1_tab_A_bak;                                                                    >> 02_tab_drop_table.sql
echo commit;                                                                                                   >> 02_tab_drop_table.sql
# 表结构修改(增减字段）
# 表结构增加字段
echo rename ray_1_tab_B to ray_1_tab_B_bak;                                                                        >> 03_tab_add_column.sql
echo create table ray_1_tab_B(id int, add_column1 varchar2(30), name varchar2(20));                            >> 03_tab_add_column.sql
echo commit;                                                                                                   >> 03_tab_add_column.sql
# 表结构删除字段
echo create table ray_1_tab_C_bak as select * from ray_1_tab_C;                                                >> 04_tab_drop_column.sql
echo alter table ray_1_tab_C drop column name;                                                                 >> 04_tab_drop_column.sql
echo commit;                                                                                                   >> 04_tab_drop_column.sql
# 表结构修改(修改字段类型）
echo create table ray_1_tab_D_bak as select * from ray_1_tab_D;                                                >> 05_tab_modify_column.sql
echo truncate table ray_1_tab_D;                                                                               >> 05_tab_modify_column.sql
echo alter table ray_1_tab_D modify id varchar2(100);                                                          >> 05_tab_modify_column.sql
echo insert into ray_1_tab_D select * from ray_1_tab_D_bak;                                                    >> 05_tab_modify_column.sql
echo commit;                                                                                                   >> 05_tab_modify_column.sql
######################################## 视图测试：2、不添加任何的约束 ##############################################
# 视图创建
echo create or replace view ray_2_vw_A as select * from ray_1_tab_B;                                           >> 06_vw_create_view.sql
echo create or replace view ray_2_vw_B as select * from ray_1_tab_B;                                           >> 06_vw_create_view.sql
echo create or replace view ray_2_vw_C as select * from ray_1_tab_B;                                           >> 06_vw_create_view.sql
echo commit;                                                                                                   >> 06_vw_create_view.sql
# 视图删除
echo rename ray_2_vw_B to ray_2_vw_B_bak;                                                                      >> 07_vw_drop_view.sql
echo commit;                                                                                                   >> 07_vw_drop_view.sql
# 视图表更
echo rename ray_2_vw_C to ray_2_vw_C_bak;                                                                      >> 08_vw_modify_view.sql
echo create or replace view ray_2_vw_C as  select id, name from ray_1_tab_B;                                   >> 08_vw_modify_view.sql
echo commit;                                                                                                   >> 08_vw_modify_view.sql
######################################## 物化视图测试：3、不添加任何的约束 #########################################
# 物化视图创建
echo ALTER TABLE RAY_1_TAB_E ADD CONSTRAINT RAY_1_TAB_E_ID_pk PRIMARY KEY (ID);                                >> 09_mv_create_mv.sql
echo ALTER TABLE RAY_1_TAB_B ADD CONSTRAINT RAY_1_TAB_B_ID_pk PRIMARY KEY (ID);                                >> 09_mv_create_mv.sql
echo ALTER TABLE RAY_1_TAB_C ADD CONSTRAINT RAY_1_TAB_C_ID_pk PRIMARY KEY (ID);                                >> 09_mv_create_mv.sql
echo create materialized view log on ray_1_tab_E;                                                              >> 09_mv_create_mv.sql
echo create materialized view ray_3_mv_C refresh fast on commit as select * from ray_1_tab_E;                  >> 09_mv_create_mv.sql
echo create materialized view log on ray_1_tab_B;                                                              >> 09_mv_create_mv.sql
echo create materialized view ray_3_mv_A refresh fast on commit as select * from ray_1_tab_B;                  >> 09_mv_create_mv.sql
echo create materialized view log on ray_1_tab_C;                                                              >> 09_mv_create_mv.sql
echo create materialized view ray_3_mv_B refresh fast on commit as select * from ray_1_tab_C;                  >> 09_mv_create_mv.sql
echo commit;                                                                                                   >> 09_mv_create_mv.sql
# 物化视图删除
# echo rename ray_3_mv_C to ray_3_mv_C_bak;                                                                      >> 10_mv_drop_mv.sql
# echo commit;                                                                                                   >> 10_mv_drop_mv.sql
# 视图表更
# echo alter table ray_3_mv_B rename ray_3_mv_B_bak PRESERVE TABLE;                                              >> 11_mv_modify_mv.sql
# echo create materialized view ray_3_mv_B refresh fast on commit as select * from ray_1_tab_C;                  >> 11_mv_modify_mv.sql
# echo commit;                                                                                                   >> 11_mv_modify_mv.sql
######################################## 存储过程测试：4、不添加任何的约束 #########################################
# 存储过程创建
echo CREATE OR REPLACE PROCEDURE ray_sp_drop1(p_table in varchar2)                                             >> 12_proc_create_procedure1.proc
echo AS                                                                                                        >> 12_proc_create_procedure1.proc
echo   v_count number(10);                                                                                     >> 12_proc_create_procedure1.proc
echo BEGIN                                                                                                     >> 12_proc_create_procedure1.proc
echo   SELECT COUNT(*)                                                                                         >> 12_proc_create_procedure1.proc
echo     INTO V_COUNT                                                                                          >> 12_proc_create_procedure1.proc
echo     FROM USER_TABLES                                                                                      >> 12_proc_create_procedure1.proc
echo    WHERE TABLE_NAME = UPPER(p_table);                                                                     >> 12_proc_create_procedure1.proc
echo   IF V_COUNT ^> 0 THEN                                                                                    >> 12_proc_create_procedure1.proc
echo     EXECUTE IMMEDIATE 'drop table ' ^|^| p_table ^|^| ' purge';                                           >> 12_proc_create_procedure1.proc
echo   END IF;                                                                                                 >> 12_proc_create_procedure1.proc
echo END;                                                                                                      >> 12_proc_create_procedure1.proc

echo CREATE OR REPLACE PROCEDURE ray_sp_drop2(p_table in varchar2)                                             >> 12_proc_create_procedure2.proc
echo AS                                                                                                        >> 12_proc_create_procedure2.proc
echo   v_count number(10);                                                                                     >> 12_proc_create_procedure2.proc
echo BEGIN                                                                                                     >> 12_proc_create_procedure2.proc
echo   SELECT COUNT(*)                                                                                         >> 12_proc_create_procedure2.proc
echo     INTO V_COUNT                                                                                          >> 12_proc_create_procedure2.proc
echo     FROM USER_TABLES                                                                                      >> 12_proc_create_procedure2.proc
echo    WHERE TABLE_NAME = UPPER(p_table);                                                                     >> 12_proc_create_procedure2.proc
echo   IF V_COUNT ^> 0 THEN                                                                                    >> 12_proc_create_procedure2.proc
echo     EXECUTE IMMEDIATE 'drop table ' ^|^| p_table ^|^| ' purge';                                           >> 12_proc_create_procedure2.proc
echo   END IF;                                                                                                 >> 12_proc_create_procedure2.proc
echo END;                                                                                                      >> 12_proc_create_procedure2.proc

echo CREATE OR REPLACE PROCEDURE ray_sp_drop3(p_table in varchar2)                                             >> 12_proc_create_procedure3.proc
echo AS                                                                                                        >> 12_proc_create_procedure3.proc
echo   v_count number(10);                                                                                     >> 12_proc_create_procedure3.proc
echo BEGIN                                                                                                     >> 12_proc_create_procedure3.proc
echo   SELECT COUNT(*)                                                                                         >> 12_proc_create_procedure3.proc
echo     INTO V_COUNT                                                                                          >> 12_proc_create_procedure3.proc
echo     FROM USER_TABLES                                                                                      >> 12_proc_create_procedure3.proc
echo    WHERE TABLE_NAME = UPPER(p_table);                                                                     >> 12_proc_create_procedure3.proc
echo   IF V_COUNT ^> 0 THEN                                                                                    >> 12_proc_create_procedure3.proc
echo     EXECUTE IMMEDIATE 'drop table ' ^|^| p_table ^|^| ' purge';                                           >> 12_proc_create_procedure3.proc
echo   END IF;                                                                                                 >> 12_proc_create_procedure3.proc
echo END;                                                                                                      >> 12_proc_create_procedure3.proc

# 存储过程删除
echo drop procedure ray_sp_drop2;                                                                              >> 12_proc_drop_proc.sql

# 存储过程修改
echo drop procedure ray_sp_drop3;                                                                              >> 13_proc_drop_proc.sql
echo CREATE OR REPLACE PROCEDURE ray_sp_drop3(p_table in varchar2)                                             >> 14_proc_create_procedure.proc
echo AS                                                                                                        >> 14_proc_create_procedure.proc
echo   v_count number(10);                                                                                     >> 14_proc_create_procedure.proc
echo BEGIN                                                                                                     >> 14_proc_create_procedure.proc
echo   SELECT COUNT(*) INTO V_COUNT FROM USER_TABLES WHERE TABLE_NAME = UPPER(p_table);                        >> 14_proc_create_procedure.proc
echo   IF V_COUNT ^> 0 THEN                                                                                    >> 14_proc_create_procedure.proc
echo     EXECUTE IMMEDIATE 'drop table ' ^|^| p_table ^|^| ' purge';                                           >> 14_proc_create_procedure.proc
echo   END IF;                                                                                                 >> 14_proc_create_procedure.proc
echo END;                                                                                                      >> 14_proc_create_procedure.proc


######################################## 函数测试：5、不添加任何的约束 #############################################
# 函数创建
echo create or replace function ray_get_seq_next1(seq_name in varchar2) return number is                       >> 15_func_create_functions1.proc
echo   seq_val number;                                                                                         >> 15_func_create_functions1.proc
echo begin                                                                                                     >> 15_func_create_functions1.proc
echo   execute immediate 'select ' ^|^| seq_name ^|^| '.nextval from dual'                                     >> 15_func_create_functions1.proc
echo     into seq_val;                                                                                         >> 15_func_create_functions1.proc
echo   return seq_val;                                                                                         >> 15_func_create_functions1.proc
echo end ray_get_seq_next1;                                                                                         >> 15_func_create_functions1.proc

echo create or replace function ray_get_seq_next2(seq_name in varchar2) return number is                       >> 15_func_create_functions2.proc
echo   seq_val number;                                                                                         >> 15_func_create_functions2.proc
echo begin                                                                                                     >> 15_func_create_functions2.proc
echo   execute immediate 'select ' ^|^| seq_name ^|^| '.nextval from dual'                                     >> 15_func_create_functions2.proc
echo     into seq_val;                                                                                         >> 15_func_create_functions2.proc
echo   return seq_val;                                                                                         >> 15_func_create_functions2.proc
echo end ray_get_seq_next2;                                                                                         >> 15_func_create_functions2.proc

echo create or replace function ray_get_seq_next3(seq_name in varchar2) return number is                       >> 15_func_create_functions3.proc
echo   seq_val number;                                                                                         >> 15_func_create_functions3.proc
echo begin                                                                                                     >> 15_func_create_functions3.proc
echo   execute immediate 'select ' ^|^| seq_name ^|^| '.nextval from dual'                                     >> 15_func_create_functions3.proc
echo     into seq_val;                                                                                         >> 15_func_create_functions3.proc
echo   return seq_val;                                                                                         >> 15_func_create_functions3.proc
echo end ray_get_seq_next3;                                                                                         >> 15_func_create_functions3.proc


# 函数删除
echo drop function ray_get_seq_next2;                                                                          >> 16_func_drop_func.sql
# 函数修改
echo drop function ray_get_seq_next3;                                                                          >> 16_func_drop_func1.sql
echo create or replace function ray_get_seq_next3(seq_name in varchar2) return number is                       >> 17_func_create_functions.proc
echo   seq_val number;                                                                                         >> 17_func_create_functions.proc
echo begin                                                                                                     >> 17_func_create_functions.proc
echo   execute immediate 'select ' ^|^| seq_name ^|^| '.nextval from dual' into seq_val;                       >> 17_func_create_functions.proc
echo   return seq_val;                                                                                         >> 17_func_create_functions.proc
echo end ray_get_seq_next3;                                                                                         >> 17_func_create_functions.proc
######################################## 序列测试：6、不添加任何的约束 #############################################
# 序列创建
echo create sequence ray_6_seq_A;                                                                              >> 18_seq_create_sequence.sql
echo create sequence ray_6_seq_B START WITH 10000000000481;                                                    >> 18_seq_create_sequence.sql
echo create sequence ray_6_seq_C;                                                                              >> 18_seq_create_sequence.sql
# 序列删除
echo drop sequence ray_6_seq_B;                                                                                >> 19_seq_drop_sequence.sql
# 序列值重置
echo drop sequence ray_6_seq_C;                                                                                >> 20_seq_modify_sequence.sql
echo create sequence ray_6_seq_B START WITH 810000000000481;                                                   >> 20_seq_modify_sequence.sql
######################################## 索引测试：7、不添加任何的约束 #############################################
# 索引创建
echo create index ray_1_tab_D_idx on ray_1_tab_D(id);                                                          >> 21_idx_create_index.sql
echo create index ray_1_tab_B_idx on ray_1_tab_E(name);                                                        >> 21_idx_create_index.sql
echo create index ray_1_tab_C_idx on ray_1_tab_E(id, name);                                                    >> 21_idx_create_index.sql

# 索引删除
echo drop index ray_1_tab_B_idx;                                                                               >> 22_idx_drop_index.sql
# 索引重建
echo drop index ray_1_tab_C_idx;                                                                               >> 23_idx_rebuild_index.sql
echo create index ray_1_tab_E_idx on ray_1_tab_E(name);                                                        >> 23_idx_rebuild_index.sql

######################################## 检查对象：8、不添加任何的约束 #############################################
######################################## 编译失效对象：9、不添加任何的约束 #############################################
# 编译失效视图
echo alter view ray_2_vw_A compile;                                                                            >> 24_vw_recompile_view.sql
echo alter view ray_2_vw_C compile;                                                                            >> 24_vw_recompile_view.sql
# 编译失效物化视图
echo ALTER MATERIALIZED VIEW ray_3_mv_A compile;                                                               >> 25_mv_recompile_view.sql
echo ALTER MATERIALIZED VIEW ray_3_mv_C compile;                                                               >> 25_mv_recompile_view.sql
# 编译失效存储过程
echo ALTER PROCEDURE ray_sp_drop3 compile;                                                                     >> 26_proc_recompile_procedure.sql
echo ALTER PROCEDURE ray_sp_drop1 compile;                                                                     >> 26_proc_recompile_procedure.sql
# 编译失效函数
echo ALTER function ray_get_seq_next1 compile;                                                                 >> 27_func_recompile_functions.sql
echo ALTER function ray_get_seq_next3 compile;                                                                 >> 27_func_recompile_functions.sql
# 编译失效索引
echo alter index RAY_1_TAB_E_ID_PK rebuild;                                                                    >> 28_idx_recompile_index.sql
echo ALTER index RAY_1_TAB_E_IDX rebuild;                                                                      >> 28_idx_recompile_index.sql
######################################## 清理对象：10、不添加任何的约束 ################################################
# 清理表
echo drop TABLE RAY_1_B_BAK;                                                                                   >> 29_tab_clean_table.sql
echo drop TABLE RAY_1_TAB_C_BAK;                                                                               >> 29_tab_clean_table.sql
echo drop TABLE RAY_1_TAB_D_BAK;                                                                               >> 29_tab_clean_table.sql
echo drop table RAY_1_TAB_A_BAK;                                                                               >> 29_tab_clean_table.sql
# 清理视图
echo drop view ray_2_vw_B_bak;                                                                                 >> 29_vw_clean_index.sql
echo drop view ray_2_vw_C_bak;                                                                                 >> 29_vw_clean_index.sql
# 清理物化视图
echo DROP MATERIALIZED VIEW ray_3_mv_A;                                                                        >> 30_mv_clean_view.sql
echo DROP MATERIALIZED VIEW LOG ON ray_1_tab_B;                                                                >> 30_mv_clean_view.sql
######################################## 回滚对象：11、不添加任何的约束 ################################################
# 回滚表
echo call sp_drop_object('cs_master_tgt', 'ray_1_tab_A', 'TABLE'); >> .\rollback\01_drop_table.sql
echo call sp_drop_object('cs_master_tgt', 'ray_1_tab_E', 'TABLE'); >> .\rollback\01_drop_table.sql
echo call sp_drop_object('cs_master_tgt', 'ray_1_tab_B', 'TABLE'); >> .\rollback\01_drop_table.sql
echo call sp_drop_object('cs_master_tgt', 'ray_1_tab_C', 'TABLE'); >> .\rollback\01_drop_table.sql
echo call sp_drop_object('cs_master_tgt', 'ray_1_tab_D', 'TABLE'); >> .\rollback\01_drop_table.sql

echo rename ray_1_tab_A_bak to ray_1_tab_A;                        >> .\rollback\02_rename_table.sql
echo rename ray_1_tab_B_bak to ray_1_tab_B;                        >> .\rollback\02_rename_table.sql
echo rename ray_1_tab_C_bak to ray_1_tab_C;                        >> .\rollback\02_rename_table.sql
echo rename ray_1_tab_D_bak to ray_1_tab_D;                        >> .\rollback\02_rename_table.sql
# 回滚视图
echo call sp_drop_object('cs_master_tgt', 'RAY_2_VW_A', 'VIEW');   >> .\rollback\03_drop_view.sql
echo call sp_drop_object('cs_master_tgt', 'RAY_2_VW_C', 'VIEW');   >> .\rollback\03_drop_view.sql
echo rename RAY_2_VW_C_BAK to RAY_2_VW_C;                          >> .\rollback\04_rename_view.sql
echo rename RAY_2_VW_B_BAK to RAY_2_VW_B;                          >> .\rollback\04_rename_view.sql

# 回滚新创建的存储过程
echo call sp_drop_object('cs_master_tgt', 'RAY_SP_DROP1', 'procedure');   >> .\rollback\05_drop_proc.sql
echo call sp_drop_object('cs_master_tgt', 'RAY_SP_DROP2', 'procedure');   >> .\rollback\05_drop_proc.sql
echo call sp_drop_object('cs_master_tgt', 'RAY_SP_DROP3', 'procedure');   >> .\rollback\05_drop_proc.sql
# 回滚新创建的函数
echo call sp_drop_object('cs_master_tgt', 'ray_get_seq_next1', 'function');   >> .\rollback\06_drop_func.sql
echo call sp_drop_object('cs_master_tgt', 'ray_get_seq_next2', 'function');   >> .\rollback\06_drop_func.sql
echo call sp_drop_object('cs_master_tgt', 'ray_get_seq_next3', 'function');   >> .\rollback\06_drop_func.sql
# 回滚新创建的序列
echo call sp_drop_object('cs_master_tgt', 'ray_6_seq_A', 'SEQUENCE');   >> .\rollback\07_drop_seq.sql
echo call sp_drop_object('cs_master_tgt', 'ray_6_seq_B', 'SEQUENCE');   >> .\rollback\07_drop_seq.sql
echo call sp_drop_object('cs_master_tgt', 'ray_6_seq_C', 'SEQUENCE');   >> .\rollback\07_drop_seq.sql
# 回滚新创建的索引
echo call sp_drop_object('cs_master_tgt', 'ray_1_tab_b_idx', 'index');   >> .\rollback\08_drop_idx.sql
echo call sp_drop_object('cs_master_tgt', 'ray_1_tab_c_idx', 'index');   >> .\rollback\08_drop_idx.sql
echo call sp_drop_object('cs_master_tgt', 'ray_1_tab_D_idx', 'index');   >> .\rollback\08_drop_idx.sql
echo call sp_drop_object('cs_master_tgt', 'ray_1_tab_e_idx', 'index');   >> .\rollback\08_drop_idx.sql


--创建测试对象
create table zhc_tab_A(
id number,
name varchar2(200),
compy_nm varchar2(1000)
);
create unique index idx_zhc_tab_a on zhc_tab_a(compy_nm);


--用例：删除字段名称
alter table zhc_tab_A rename column compy_nm to compy_nm_bak;

--清理脚本
alter table zhc_tab_A drop column compy_nm_bak;

--回滚脚本
alter table zhc_tab_A rename column compy_nm_bak to compy_nm;
