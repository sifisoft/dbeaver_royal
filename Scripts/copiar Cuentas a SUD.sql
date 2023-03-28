

desc toinvoicing

select ag_agencia, ag_nombre, ag_dir1, ag_dir2, ag_tel, ag_fax, ag_pais, ag_razon_soc, ag_correo_factura_electronica, decode(ag_dias_prepago,null,'N',0,'N','Y') proforma, ag_rfc
from fragen
where ag_mayorista = 'SUD' and nvl(ag_sector,0) <> 99
order by ag_nombre

select *
from all_tables
where table_name like '%RSOPERA%'


select unique ch_charter
from rscharter
where ch_utl = 'SUD' and not exists ( select 1 from rsopecharter where oc_charter = ch_charter)


create table rscharter_load (
ch_hotel varchar2(2),
ch_charter varchar2(10),
ch_name varchar2(100),
ch_adress_1 varchar2(100),
ch_adress_2 varchar2(100),
ch_country varchar2(2),
ch_acc_inv varchar2(20),
ch_acc_prod varchar2(20),
ch_pri_inv varchar2(1)
)




select *
from rscharter_load

drop view a1

create view a1 as 
select *
from rscharter_load
where ch_acc_inv is not null

update rscharter_load
set ch_hotel = '06' where ch_hotel = '09'

select * from a1

select ch_hotel, ch_name,
    (select unique '430'||a.ch_hotel||substr(ch_acc_inv,6,7) from a1 where a1.ch_name = a.ch_name),
    (select unique '700'||a.ch_hotel||substr(ch_acc_prod,6,7) from a1 where a1.ch_name = a.ch_name)
from rscharter_load a
where ch_acc_inv is null 
and exists ( select 1 from a1 where a1.ch_name = a.ch_name ) 


update rscharter_load a
set ch_acc_inv = (select unique '430'||a.ch_hotel||substr(ch_acc_inv,6,7) from a1 where a1.ch_name = a.ch_name),
    ch_acc_prod = (select unique '700'||a.ch_hotel||substr(ch_acc_prod,6,7) from a1 where a1.ch_name = a.ch_name)
where ch_acc_inv is null 
and exists ( select 1 from a1 where a1.ch_name = a.ch_name ) 


select * from rscharter_load
    



delete from rscharter_load where ch_hotel is null


update rscharter a
set ch_acc_inv = (select b.ch_acc_inv from rscharter_load b where a.ch_hotel = b.ch_hotel and a.ch_charter = b.ch_charter),
    ch_acc_prod = (select b.ch_acc_prod from rscharter_load b where a.ch_hotel = b.ch_hotel and a.ch_charter = b.ch_charter),
    ch_pri_inv = (select b.ch_pri_inv from rscharter_load b where a.ch_hotel = b.ch_hotel and a.ch_charter = b.ch_charter)
where exists (select 1 from rscharter_load b where a.ch_hotel = b.ch_hotel and a.ch_charter = b.ch_charter and b.ch_acc_prod is not null)

select *
from rscharter
where ch_utl = 'SUD' and ch_acc_prod is not null

update rscharter_load
set ch_hotel = decode(ch_hotel,'06','09',ch_hotel)

select unique ch_acc_inv
from rscharter
where ch_utl = 'SUD' and ch_acc_inv is not null and ch_acc_inv not like '43008%' and not exists (
select 1 from cuentas 
where ct_emp = '60' and ct_plan = 'A' and ct_eje = 13 and ct_cg = ch_acc_inv
)    
order by ch_acc_inv



select unique ch_acc_prod
from rscharter
where ch_utl = 'SUD' and ch_acc_prod is not null and not exists (
select 1 from cuentas 
where ct_emp = '60' and ct_plan = 'A' and ct_eje = 13 and ct_cg = ch_acc_prod
)    
order by ch_acc_prod




select *
from rscharter_load
where ch_acc_inv like '43008%'

select * from rshotel


select *
from cuentas 
where ct_emp = '60' and ct_plan = 'A' and ct_eje = 13 and ct_cg = '43010040017'