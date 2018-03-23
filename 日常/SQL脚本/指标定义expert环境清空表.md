```sql
truncate table tmp_factor;
truncate table TMP_FACTOR_ELEMENT;
truncate table TMP_FACTOR_OPTION;
truncate table TMP_ELEMENT;
call SP_FACTOR_ELEMENT_DEFINITION();
```

- 指标定义对应的表
```sql
select * from factor;
select * from client_factor;
select * from exposure_factor_xw;
select * from client_exposure_factor;
select * from element;
select * from client_element;
select * from factor_option;
select * from factor_element_xw;
select * from client_factor_element;
```
