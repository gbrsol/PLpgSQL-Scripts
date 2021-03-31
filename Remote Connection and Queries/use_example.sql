/* Example when using the stored functions and triggers created inside this directory */
select connect();
SELECT * FROM TAB;
SELECT * from dblink('dblink_fdw','select * from tab') as x(Code int);
insert into tab(id) values(6);
select disconnect();