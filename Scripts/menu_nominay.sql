


select t.*, t.rowid
from nmMenu t
order by me_id


select * from nmUsuario_opciones where uo_opcion = 7350



insert into nmMenu
(me_id, me_parent_id, me_institucion, me_url, me_desc, me_img, me_tooltip)
values (7450, 7000, 'GENERAL', 'administracion/cargaCambiosExcel.htm','Cambios masivos', null,null);


insert into nmUsuario_opciones
(uo_usuario, uo_opcion)
values ('sifi',7450);


select * from nmEmpleados
where em_company = 1 and em_email is not null and em_status = 'A'




select * from nmInasistencias_alta

select t.*, t.rowid from nmEmail t




select * from nmInasistencias  where in_empleado = 754


select t.*, t.rowid from nmEmpleados_alta t





insert into nmUsuario_opciones
(uo_usuario, uo_opcion)
values ('demo',7400);




select * from nmUsuario_opciones



insert into nmMenu
select 6005, 6000, me_institucion, me_url, 'Recibos', me_img, me_tooltip
from nmMenu
where me_id = 3400;

insert into nmMenu
select 6010, 6000, me_institucion, me_url, 'Firmas nómina', me_img, me_tooltip
from nmMenu
where me_id = 3350;

insert into nmMenu
select 6015, 6000, me_institucion, me_url, 'Detalle depto', me_img, me_tooltip
from nmMenu
where me_id = 6400;

insert into nmMenu
select 6020, 6000, me_institucion, me_url, 'Resumen nómina', me_img, me_tooltip
from nmMenu
where me_id = 6450;

insert into nmMenu
select 6380, 6000, me_institucion, me_url, 'Histórico conceptos', me_img, me_tooltip
from nmMenu
where me_id = 3750;


update nmUsuario_opciones
set uo_opcion = 6005
where uo_opcion = 3400;

update nmUsuario_opciones
set uo_opcion = 6010
where uo_opcion = 3350;

update nmUsuario_opciones
set uo_opcion = 6380
where uo_opcion = 3750;

update nmUsuario_opciones
set uo_opcion = 6015
where uo_opcion = 6400;

update nmUsuario_opciones
set uo_opcion = 6020
where uo_opcion = 6450;

delete from nmUsuario_opciones
where uo_opcion in (6150,6200,6250,7050,7100,7200);

delete from nmMenu 
where me_id in (3400,3350,3750,6400,6450,6150,6200,6250,7050,7100,7200);