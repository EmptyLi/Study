WITH TEMP AS
(SELECT
   105217 AS BOND_PLEDGE_SID,
   'Y'    AS FLAG
 UNION ALL
 SELECT
   106169 AS BOND_PLEDGE_SID,
   'N'    AS FLAG
 UNION ALL
 SELECT
   105554 AS BOND_PLEDGE_SID,
   'N'    AS FLAG
 UNION ALL
 SELECT
   105249 AS BOND_PLEDGE_SID,
   'Y'    AS FLAG
 UNION ALL
 SELECT
   106449 AS BOND_PLEDGE_SID,
   'N'    AS FLAG
 UNION ALL
 SELECT
   105327 AS BOND_PLEDGE_SID,
   'Y'    AS FLAG
 UNION ALL
 SELECT
   105346 AS BOND_PLEDGE_SID,
   'Y'    AS FLAG
 UNION ALL
 SELECT
   106508 AS BOND_PLEDGE_SID,
   'N'    AS FLAG
 UNION ALL
 SELECT
   106049 AS BOND_PLEDGE_SID,
   'N'    AS FLAG
 UNION ALL
 SELECT
   105426 AS BOND_PLEDGE_SID,
   'Y'    AS FLAG
 UNION ALL
 SELECT
   106050 AS BOND_PLEDGE_SID,
   'Y'    AS FLAG
)
select
  a.*,
  b.flag
from bond_pledge a
  left join TEMP b
    on a.bond_pledge_sid = b.BOND_PLEDGE_SID
where a.bond_pledge_sid in (105217
  , 106169
  , 105554
  , 105249
  , 106449
  , 105327
  , 105346
  , 106508
  , 106049
  , 105426
  , 106050
);

update bond_pledge
set isdel = 1, updt_dt = now()
where bond_pledge_sid in (
  105217
  , 105327
  , 105346
  , 105249
  , 105426
  , 106050
);

update bond_pledge
set isdel = 0, updt_dt = now()
where isdel = 1
      and bond_pledge_sid in (
  106169
  , 106449
  , 106508
  , 105554
  , 106049
);

delete from bond_pledge
where bond_pledge_sid in (105217
  , 106169
  , 105554
  , 105249
  , 106449
  , 105327
  , 105346
  , 106508
  , 106049
  , 105426
  , 106050);

insert into bond_pledge
  select *
  from ray_bond_pledge_0517
  where bond_pledge_sid in (105217
    , 106169
    , 105554
    , 105249
    , 106449
    , 105327
    , 105346
    , 106508
    , 106049
    , 105426
    , 106050);

COMMIT;
