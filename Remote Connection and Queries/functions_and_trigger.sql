/* Remote connection and disconnection functions */
CREATE OR REPLACE FUNCTION conectar() 
RETURNS bool 
AS $$
BEGIN
	PERFORM dblink_connect('dblink_fdw','foreigndb');
	return True;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION desconectar()
RETURNS bool 
AS $$
BEGIN
	PERFORM dblink_disconnect('dblink_fdw');
	return True;
END;
$$ LANGUAGE plpgsql;

/* Trigger function operating remotely and trigger */
CREATE OR REPLACE FUNCTION trigger_function_remote()
RETURNS trigger 
AS $$
DECLARE
	cons text := 'insert into tab(id) values(' || (NEW.id)||')';
BEGIN
	PERFORM dblink('dblink_fdw',cons);
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER remote_trigger AFTER INSERT ON TAB
	FOR EACH ROW
		EXECUTE PROCEDURE trigger_function_remote()