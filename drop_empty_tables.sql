CREATE OR REPLACE FUNCTION dropEmptyTables(name TEXT)
  RETURNS void AS
$BODY$
DECLARE statement TEXT;
BEGIN
statement := 'DROP TABLE ' || name;
EXECUTE statement;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;

SELECT dropEmptyTables(relname)
FROM pg_stat_user_tables
WHERE n_live_tup = 0;