


select t.*, t.rowid
from nmMenu t
order by me_id

insert into nmMenu
values (7650,7000, 'GENERAL', 'administracion/cargaNominaExcel.htm', 'Carga Nominas', null,null);

insert into nmUsuario_opciones
values ('sifi',7650);


-- Tamaño de tablas
select SUM(data_length) from all_tab_columns where table_name = :tabla


select *
from nmAguinaldo_Antiguedad


where uc_company = 1 and uc_username = 'sifi'


select t.*, t.rowid
from nmCompany t

select t.*, t.rowid
from nmPac t


select *
from nmEmail


select t.*, t.rowid
from nmEmpleado_conceptos t
where ec_empleado = 5


select * from nmPac

select * from nmNomina_empleado where ne_empleado = 10

select * from nmNomina where nm_numero_nomina = 201407




desc DIM_GETSUBSIDIOT

desc DIM_GETBG

desc DIM_GETTOTAL

desc getFIV

desc getFSD

desc getFT
 
desc getFTA

desc getFUT

desc getHED

desc getHET

desc DIM_getSubsidioT


select * from nmNomina_empleado

update nmNomina_empleado
set ne_seq_folio = null, ne_pac_msg = null, ne_pac_uddi = null, ne_pac_xml_url, ne_recibo_cfdi = null
where ne_emplado in (2,49)


select ne_faltas
from nmNomina_empleado


update nmNomina_carga


select * 
from nmNomina_empleado 
where ne_empleado = :emp

select * 
from nmNOmina_conceptos
where nc_tipo_nomina = 'N' and  nc_empleado = :emp


select *
from nmEmpleados
where em_id = :emp

select * from nmEmpleados_grupo


alter table nmConceptos_log
modify btc_rango varchar2(3)


select * from nmParametrosPD


alter table nmParametrosPD
add ppd_prevsoc_pctbg number(5,2)


select * from nmParametrosPD
order by ppd_company, to_number(ppd_campo_id)