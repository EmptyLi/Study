
股权结构：COMPY_BONDISSUER.ORG_NATURE_ID

信用环境：COMPY_BONDISSUER.REGION

企业性质：COMPY_BASICINFO.ORG_FORM_ID

注册地址（省份）：COMPY_BASICINFO.REGION
-------------------------------------------------------------------------------------------------
数据库修改：
1. tgt层：COMPY_BONDISSUER增加updt_by字段

2. stg层：stg/hist_compy_bondissuer增加updt_by字段

3. MDS：修改推数视图及subscribe table表。注：不能影响其他客户，比如招商
