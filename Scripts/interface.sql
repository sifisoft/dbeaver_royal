

/*
    tulum..
*/

desc freserva_travamerica_ot

drop database link cun_ot

create database link cun_ot connect to frtulum identified by service using 'cun03.world'

drop synonym freserva_travamerica_ot

create synonym freserva_travamerica_ot for freserva_travamerica@cun_ot

select * from freserva_travamerica_ot


/*
Sens
*/

desc freserva_travamerica_sens

drop database link cun_sens

create database link cun_sens connect to frsens identified by service using 'cun04.world'

drop synonym freserva_travamerica_sens

create synonym freserva_travamerica_sens for freserva_travamerica@cun_sens

select * from freserva_travamerica_sens



/*
    OC
*/
create database link cun_oc connect to frgrand identified by service using 'cun01.world'

drop synonym freserva_travamerica_oc

create synonym freserva_travamerica_oc for freserva_travamerica@cun_oc

select * from freserva_travamerica_oc

create synonym rstrans_oc for rstrans@cun_oc

select * from rstrans_oc

create synonym interface_Reservaciones_oc for interface_Reservaciones@cun_oc

desc interface_reservaciones_oc

/*
   PALM
*/
create database link cun_op connect to frpalm identified by service using 'cun09.world'

drop synonym freserva_travamerica_op

create synonym freserva_travamerica_op for freserva_travamerica@cun_op

select * from freserva_travamerica_op

create synonym rstrans_op for rstrans@cun_op

create synonym interface_Reservaciones_op for interface_Reservaciones@cun_op

desc interface_reservaciones_op

/* */

/*
   VIVA
*/
create database link cun_ov connect to frviva identified by service using 'cun07.world'

drop synonym freserva_travamerica_ov

create synonym freserva_travamerica_ov for freserva_travamerica@cun_ov

select * from freserva_travamerica_ov

create synonym rstrans_ov for rstrans@cun_ov

create synonym interface_Reservaciones_ov for interface_Reservaciones@cun_ov

desc interface_reservaciones_ov

/* */



/*
   SMART
*/
drop database link cun_smart

create database link cun_smart connect to frsmart identified by service using 'cun05.world'

drop synonym freserva_travamerica_smart

create synonym freserva_travamerica_smart for freserva_travamerica@cun_smart

select * from freserva_travamerica_smart

create synonym rstrans_smart for rstrans@cun_smart

create synonym interface_Reservaciones_smart for interface_Reservaciones@cun_smart

desc interface_reservaciones_smart

/* */


select * from rshotel

/*
   TULUM
*/
create database link cun_ot connect to frviva identified by service using 'cun03.world'

drop synonym freserva_travamerica_ot

create synonym freserva_travamerica_ot for freserva_travamerica@cun_ot

select * from freserva_travamerica_ot

create synonym rstrans_ot for rstrans@cun_ot

create synonym interface_Reservaciones_ot for interface_Reservaciones@cun_ot

desc interface_reservaciones_ot



select rsoperator.*
from rsopecharter, rsoperator where oc_operator in ('BKINGAI','DEDIRAI','WBCOCV') 
and op_id = oc_operator


desc mentry

desc pckgCRSRates

drop view a1
 
-- Compara VIVA.
-- 1. hacerlas pasar al hotel
-- 2. las que yano pasen se cancelan en RSMAES

create view a1 as

select ma_reserv, ma_arrival, ma_depart
from rsmaes, rshotel
where ma_hotel in ('01','02') and ma_can_d is null and ma_depart between '02-jan-13' and '1-feb-13' and ho_hotel = ma_hotel
minus 
select rv_reserva, rv_llegada, rv_salida
from freserva_travamerica@cun_oc
where rv_salida > '01-jan-13' and rv_can_f is null
order by 1,2

-- Paso 1 enviar todo lo que esta en RSMAES y no en FRESERVA 

insert into rstrans
select sysdate, ma_hotel, b.ma_reserv,'T','U','N',null,null
from a1 a, rsmaes b
where a.ma_reserv = b.ma_reserv
    and b.ma_hotel in ('01','02') 
    --and b.ma_inp_u <> 'OASIS'
    
select * from a1

-- Paso 2 cancelar RSMAES...
update rsmaes a
set ma_can_d = trunc(sysdate),
    ma_can_u = 'DIFF'
where exists   ( select 1 from a1 where a1.ma_reserv = a.ma_reserv) and ma_hotel in ('01','02')      
    
    
select * from freserva_travamerica@cun_ov where RV_RESERVA = :reserv 

select * from rsmaes where ma_reserv = :reserv  

select * from rstrans where tr_reserv = :reserv  

select t.*, t.rowid from rshotel t

 

drop view a3

create view a3 as

select to_number(rv_hotel) rv_hotel, 
    rv_reserva, rv_llegada, rv_salida
from freserva_travamerica@cun_oc
where rv_salida between '02-jan-13' and '31-jan-13' and rv_status <> 'C' 
minus
select to_number(ho_hotel_cancun), 
    ma_reserv, ma_arrival, ma_depart
from rsmaes, rshotel
where ma_hotel in ('01','02') and ma_can_d is null and ma_depart > '01-jan-13' and 
      ho_hotel = ma_hotel
      

select * from a3


select * from rsmaes where ma_reserv = :reserv      
      

desc refreshrsavailable_sum_trg      
      

      


insert into rstrans@cun_oc
select sysdate, rv_hotel, rv_reserva, 'H','U','N',null,null
from a3

select * from rstrans@cun_op where tr_done = 'N'

select ma_reserv
from a1
minus
select rv_reserva
from a3

    
select rv_mayorista, rv_agencia, rv_reserva, rv_status, rv_llegada, rv_salida, rv_hotel_renta from freserva@cun_op where rv_reserva = :reserv

select t.*, t.rowid from rsmaes t where ma_reserv = :reserv

update rsmaes
set ma_can_d = trunc(sysdate),
ma_can_u = 'NEWSYS'
where ma_hotel = :hotel and ma_reserv = :resrv


select * from rstrans where tr_reserv = 'E75696'

insert into rstrans
values ( sysdate, '09','E75696','T','U','N',null,null)

select ho_hotel, ho_desc, ho_hotel_cancun
from rshotel

select t.*, t.rowid from rsmaes t where ma_reserv = 'E75696'





select ch_utl mayorista, op_inv_currency moneda, a.*, b.*
from rsconhed a,  rscondet b, rscharter c, rsopecharter, rsoperator
where a.ch_hotel = cd_hotel
      and a.ch_charter = cd_charter
      and a.ch_type = cd_type
      and a.ch_end_sea = cd_end_sea
      and a.ch_activ = 'Y'
      and c.ch_hotel = a.ch_hotel
      and c.ch_charter = a.ch_charter
      and c.ch_utl in ('MEX','SUD')
      and oc_charter = a.ch_charter
      and op_id = oc_operator
order by ch_utl, a.ch_hotel, a.ch_charter, a.ch_sta_sea
      
      
select * from rsoperator
      

select t.*, t.rowid from rsroom t where ro_hotel = '04'


select * from rsmaes
where ma_arrival >= '01-jan-13' and 

select * from rshotel


create table rsmaes_JAN13 as select * from rsmaes where ma_depart >= '01-jan-13'

desc processMares

execute refreshrsavailable_sum_trg(trunc(sysdate-5,'MONTH'),last_day(add_months(sysdate,1)));

desc oasisInterface


desc interface_reservaciones_op

select * from all_objects where object_name = 'INTERFACE_RESERVACIONES_OP'



select t.*, t.rowid from rstrans_info t

select * from mares where mr_reserva = :reserv

select * from rsmaes where ma_reserv = :reserv

select t.*, t.rowid from rstrans t where tr_reserv = :reserv

select * from rshotel

select t.*, t.rowid from rstrans_info t


execute oasisinterface.readHotel('07');

execute oasisinterface.writeHotel('07');

select * from rshotel

select * from rscharter where CH_CHARTER = 'VACSTD'

select * from rsmanames where mn_reserv = :reserv

select * from rsmaes where ma_reserv = :reserv

select t.*, t.rowid from rstrans t where tr_reserv = :reserv

select * from freserva_hoteles where rv_reserva = :reserv

select count(*) from rstrans where tr_hotel = '04'

select * from rsroom where ro_room = 'GRST'

select * from mares where mr_reserva = :reserv

select * from rstrans_sens where tr_reserv = :reserv

select T.*, t.rowid from rstrans t where tr_error like '%Tipo de habitacion%'

select t.*,t.rowid from rstrans t where tr_hotel = '04' and tr_done = 'N'

desc mares


select * from mares where mr_reserva = :reserv

select t.*, t.rowid from rstrans_info t


