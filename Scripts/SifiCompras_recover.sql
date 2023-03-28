



select t.*, t.rowid
from reqEmpresa t;


insert into reqMetaTabla 
select * from reqMetaTabla2;

insert into reqMeta_campo
select * from reqMeta_campo2;


insert into reqMenu
select * from reqMenu2;

select * from cat where table_name like '%2%';

select t.* , t.rowid from reqMenu t order by me_option_number;


insert into reqUsuario
(us_username, us_empresa, us_dependencia, us_password, us_status, us_inp_date, US_SU, us_last_login, us_last_ip)
select us_username, us_empresa, us_dependencia, us_password, us_status, us_inp_date, us_su, us_last_login, us_last_ip from reqUsuario2;

create table requsuario2 as select * from reqUsuario;

select t.*, t.rowid from requsuario t;


select t.*, t.rowid
from reqmenu t
order by me_option_number;


select * from reqMenu2;

select t.*, t.rowid from reqMetaTabla t;