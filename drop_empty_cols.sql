CREATE OR REPLACE FUNCTION deleteEmptyCols() 
RETURNS VOID AS $$
DECLARE
	tabs CURSOR FOR SELECT tablename, attname 
		FROM pg_stats
		WHERE most_common_vals IS NULL
		AND schemaname = 'public'
		AND most_common_freqs IS NULL
		AND histogram_bounds IS NULL
		AND correlation IS NULL
		AND null_frac = 1;
BEGIN
	FOR reg IN tabs
	LOOP
		EXECUTE FORMAT('alter table %s drop column %s',reg.tablename,reg.attname);
	END LOOP;
	
END;
$$ LANGUAGE 'plpgsql';

SELECT deleteCols();