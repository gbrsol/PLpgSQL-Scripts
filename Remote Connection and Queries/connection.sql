/* Create a local server using dblink data wrapper */
CREATE SERVER foreigndb FOREIGN DATA WRAPPER dblink_fdw OPTIONS (hostaddr '127.0.0.1', dbname 'test');

/* Create a new user, map and grant him previleges over the server(optional) */
CREATE USER usuario WITH PASSWORD 'pass';
CREATE USER MAPPING FOR usuario SERVER foreigndb OPTIONS (user 'usuario', password 'pass');
GRANT USAGE ON FOREIGN SERVER foreigndb TO usuario;

/* Mapping the default user for use */
CREATE USER MAPPING FOR postgres SERVER foreigndb OPTIONS (user 'postgres', password 'postgres123');
GRANT USAGE ON FOREIGN SERVER foreigndb TO postgres;

/* Connectint to the created data wrapper, using foreigndb as its database  */
SELECT dblink_connect('dblink_fdw','foreigndb');

/* Some examples of remote queries using the estabilished connection*/
SELECT * from dblink('dblink_fdw','select * from tab') as x(Code int);
SELECT dblink('dblink_fdw','insert into tab(id) values(4)');
SELECT DBLINK('dblink_fdw','delete from tab');

/* Disconnecting from the remote database */
SELECT dblink_disconnect('dblink_fdw');