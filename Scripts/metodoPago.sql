

alter table nmEmpleados modify em_forma_pago varchar2(2);

insert into nmMetaCampos
select co_id, 1,'01','Efectivo',null,null
from nmCompany
where exists ( select 1 from nmMetaTabla where mt_company = co_id and mt_tabla = 1);

insert into nmMetaCampos
select co_id, 1,'02','Cheque',null,null
from nmCompany
where exists ( select 1 from nmMetaTabla where mt_company = co_id and mt_tabla = 1);

insert into nmMetaCampos
select co_id, 1,'03','Transferencia',null,null
from nmCompany
where exists ( select 1 from nmMetaTabla where mt_company = co_id and mt_tabla = 1);

insert into nmMetaCampos
select co_id, 1,'04','Tarjetas de crédito',null,null
from nmCompany
where exists ( select 1 from nmMetaTabla where mt_company = co_id and mt_tabla = 1);

insert into nmMetaCampos
select co_id, 1,'05','Monederos electrónicos',null,null
from nmCompany
where exists ( select 1 from nmMetaTabla where mt_company = co_id and mt_tabla = 1);

insert into nmMetaCampos
select co_id, 1,'06','Dinero electrónico',null,null
from nmCompany
where exists ( select 1 from nmMetaTabla where mt_company = co_id and mt_tabla = 1);

insert into nmMetaCampos
select co_id, 1,'07','Tarjetas digitales',null,null
from nmCompany
where exists ( select 1 from nmMetaTabla where mt_company = co_id and mt_tabla = 1);

insert into nmMetaCampos
select co_id, 1,'08','Vales despensa',null,null
from nmCompany
where exists ( select 1 from nmMetaTabla where mt_company = co_id and mt_tabla = 1);

insert into nmMetaCampos
select co_id, 1,'09','Bienes',null,null
from nmCompany
where exists ( select 1 from nmMetaTabla where mt_company = co_id and mt_tabla = 1);

insert into nmMetaCampos
select co_id, 1,'10','Servicio',null,null
from nmCompany
where exists ( select 1 from nmMetaTabla where mt_company = co_id and mt_tabla = 1);

insert into nmMetaCampos
select co_id, 1,'11','Por cuenta de tercero',null,null
from nmCompany
where exists ( select 1 from nmMetaTabla where mt_company = co_id and mt_tabla = 1);

insert into nmMetaCampos
select co_id, 1,'12','Dación de pago',null,null
from nmCompany
where exists ( select 1 from nmMetaTabla where mt_company = co_id and mt_tabla = 1);

insert into nmMetaCampos
select co_id, 1,'13','Pago por subrogación',null,null
from nmCompany
where exists ( select 1 from nmMetaTabla where mt_company = co_id and mt_tabla = 1);

insert into nmMetaCampos
select co_id, 1,'14','Pago por consignación',null,null
from nmCompany
where exists ( select 1 from nmMetaTabla where mt_company = co_id and mt_tabla = 1);

insert into nmMetaCampos
select co_id, 1,'15','Condonación',null,null
from nmCompany
where exists ( select 1 from nmMetaTabla where mt_company = co_id and mt_tabla = 1);

insert into nmMetaCampos
select co_id, 1,'16','Cancelación',null,null
from nmCompany
where exists ( select 1 from nmMetaTabla where mt_company = co_id and mt_tabla = 1);

insert into nmMetaCampos
select co_id, 1,'98','NA',null,null
from nmCompany
where exists ( select 1 from nmMetaTabla where mt_company = co_id and mt_tabla = 1);

insert into nmMetaCampos
select co_id, 1,'99','Otros',null,null
from nmCompany
where exists ( select 1 from nmMetaTabla where mt_company = co_id and mt_tabla = 1);

update nmEmpleados set em_forma_pago = decode(em_forma_pago, 'E','01','C','02','T','03',null);

delete from nmMetaCampos where mc_campo in ('C','E','T');

alter table nmcxl modify cl_forma_pago varchar2(2);

alter table nmNomina_empleado modify ne_pac_msg varchar2(960);