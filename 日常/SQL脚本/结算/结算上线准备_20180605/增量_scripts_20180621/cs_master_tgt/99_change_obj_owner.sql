DO language plpgsql $$
DECLARE
	owner VARCHAR(20):='cs_master_tgt';
	i RECORD;
BEGIN
	FOR I IN (select relname from pg_class a inner join pg_namespace b on a.relnamespace=b.oid where nspname='public' and upper(relname) not like 'PK%' and relname not like 'dblink%' order by 1)
	LOOP
		EXECUTE 'ALTER TABLE '||I.relname||' OWNER TO '||owner;
	END LOOP;
	FOR I IN (SELECT VIEWNAME FROM PG_VIEWS where SCHEMANAME='public' order by 1)
	LOOP
		EXECUTE 'ALTER VIEW '||I.VIEWNAME||' OWNER TO '||owner;
	END LOOP;
	FOR I IN (select relname from pg_class where relname like 'seq\_%' order by 1)
	LOOP
		EXECUTE 'ALTER SEQUENCE '||I.relname||' owned by none';
		EXECUTE 'ALTER SEQUENCE '||I.relname||' owner TO '||owner;
	END LOOP;
	FOR I IN (SELECT matviewname FROM pg_matviews)
	LOOP
		EXECUTE 'alter MATERIALIZED view '||I.matviewname||' owner TO '||OWNER;
	END LOOP;
END;
$$;
