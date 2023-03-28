
desc  processMARES

desc OasisInterface

desc OasisInterfaceOC


select * from travmarkets




-- Reservas en FRESERVA_HOTELES y no en RSMAES
select to_number(rv_hotel) cancun_hotel, rv_reserva, rv_llegada, rv_salida, rv_moneda, rv_importe
from freserva_hoteles
where   rv_llegada > trunc(sysdate,'month')
    and nvl(rv_status,'A') <> 'C'
    and rv_mayorista not in ('AME','EUR','SUD')
minus
select to_number(ho_hotel_cancun), ma_reserv, ma_arrival, ma_depart, ma_divisa, ma_due_tot
from rsmaes, rshotel
where   ma_arrival > trunc(sysdate,'MONTH')
    and ma_can_d is null
    and ho_hotel = ma_hotel
order by 1, 2


-- Reservas en RSMAES y no en FRESERVA_HOTELES 
select to_number(ho_hotel_cancun) hotelCancun, ma_reserv, ma_arrival, ma_depart, ma_divisa, ma_due_tot
from rsmaes, rshotel, rscharter
where   ma_arrival > trunc(sysdate,'MONTH')
    and ma_can_d is null
    and ho_hotel = ma_hotel
    and ch_hotel = ma_hotel
    and ch_charter = ma_charter
    and ch_utl not in ('AME','EUR','SUD')
minus
select to_number(rv_hotel) cancun_hotel, rv_reserva, rv_llegada, rv_salida, rv_moneda, rv_importe
from freserva_hoteles
where   rv_llegada > trunc(sysdate,'month')
    and nvl(rv_status,'A') <> 'C'
order by 1, 2
    

--
-- Reservas menores a 50 USD
--
select ch_utl, ho_hotel_cancun, ma_reserv, ma_charter, ma_inp_u, ma_inp_d, ma_arrival, ma_due_tot total,  round(ma_due_tot/ma_nites/ma_adult) avgRate, ma_divisa
from rsmaes t, rscharter, rshotel
where ma_can_d is null
    and ma_divisa = 'USD'
    and ma_depart > sysdate
    and ch_hotel = ma_hotel
    and ch_charter = ma_charter
    and ch_market not in ('AME','EUR','FIT','GAR')
    and ch_utl not in ('COR') and ch_charter not like 'COMP%'
    and ma_nites > 0
    and ma_due_tot/ma_nites/ma_adult < 50
    and ho_hotel = ma_hotel
order by  ch_utl, ho_hotel_cancun
    
--
-- Reservas menores a 500 pesos.
--
select ch_utl, ho_hotel_cancun, ma_reserv, ma_charter, ma_inp_u, ma_inp_d, ma_arrival, ma_due_tot total,  round(ma_due_tot/ma_nites/ma_adult) avgRate, ma_divisa
from rsmaes t, rscharter, rshotel
where ma_can_d is null
    and ma_divisa = 'MEX'
    and ma_depart > sysdate
    and ch_hotel = ma_hotel
    and ch_charter = ma_charter
    and ch_market not in ('AME','EUR','FIT','GAR')
    and ma_charter not like 'USO%'
    and ch_utl not in ('COR') and ch_charter not like 'COMP%'
    and ma_nites > 0
    and ma_due_tot/ma_nites/ma_adult < 500
    and ho_hotel = ma_hotel
order by  ch_utl, ho_hotel_cancun


--
-- Reservas menores a 50 USD
--
select ch_utl, ho_hotel_cancun, ma_reserv, ma_charter, ma_inp_u, ma_inp_d, ma_arrival, ma_due_tot total,  round(ma_due_tot/ma_nites/ma_adult) avgRate, ma_divisa
from rsmaes t, rscharter, rshotel
where ma_can_d is null
    and ma_divisa = 'USD'
    and ma_depart > sysdate
    and ch_hotel = ma_hotel
    and ch_charter = ma_charter
    and ch_market not in ('AME','EUR','FIT','GAR')
    and ch_utl not in ('COR') and ch_charter not like 'COMP%'
    and ma_nites > 0
    and ma_due_tot/ma_nites/ma_adult > 150
    and ho_hotel = ma_hotel
order by  ch_utl, ho_hotel_cancun


--
-- Reservas menores a 500 pesos.
--
select ch_utl, ho_hotel_cancun, ma_reserv, ma_charter, ma_inp_u, ma_inp_d, ma_arrival, ma_due_tot total,  round(ma_due_tot/ma_nites/ma_adult) avgRate, ma_divisa
from rsmaes t, rscharter, rshotel
where ma_can_d is null
    and ma_divisa = 'MEX'
    and ma_depart > sysdate
    and ch_hotel = ma_hotel
    and ch_charter = ma_charter
    and ch_market not in ('AME','EUR','FIT','GAR')
    and ma_charter not like 'USO%'
    and ch_utl not in ('COR') and ch_charter not like 'COMP%'
    and ma_nites > 0
    and ma_due_tot/ma_nites/ma_adult > 1950
    and ho_hotel = ma_hotel
order by  ch_utl, ho_hotel_cancun










    



select * from travmarkets    
    
select unique ch_utl from rscharter    


select *
from rsmaes
where ma_reserv = '149041'     
    
    
    
select *
from freserva_hoteles 
where rv_mayorista = 'MEX' and rv_status = 'C' and rv_llegada = trunc(sysdate)








desc OasisInterface_pckg









select * from rstrans_info

select * from freserva_travamerica_oc where rv_reserva = '019783'


select count(*)  from rstrans where tr_done = 'N' and tr_hotel = '01'

select count(*) from rstrans@cun_oc where tr_done = 'N'

select * from rsmaes where ma_reserv = :reserv

select * from freserva_hoteles where rv_reserva = :reserv



select count(*) from rsmaes where ma_can_u = 'CANCUN'


create table dummy_oo as select * from rsmaes where ma_can_u = 'CANCUN'

update rsmaes set ma_can_d = null, ma_can_u = null where ma_can_u = 'CANCUN'


delete from rstrans
where tr_stamp < sysdate - 60 and tr_done = 'Y'

select count(*) from rstrans



select count(*) from rstrans@cun_oc where tr_done = 'N'


-- Reservas activas de MEX en RSMAES y que no existen o no estan activas en Cancun.. 
-- hay que CXL
        drop table dummyoo

        create table dummyoo as 
        select ma_hotel, ma_reserv 
        from rsmaes, rscharter, rshotel
        where ma_can_d is null 
            and ma_arrival >= '01-mar-13'
            and ch_hotel = ma_hotel
            and ch_charter = ma_charter
            and ch_utl not in ('EUR','SUD','FIT','GAR','AME')
            and ho_hotel = ma_hotel
        minus
        select ho_hotel, rv_reserva
        from freserva_hoteles,rshotel
        where   rv_llegada >= '01-mar-13'
            and rv_status <> 'C'    
            and to_number(ho_hotel_cancun) = to_number(rv_hotel)




        update rsmaes
        set ma_can_d = trunc(sysdate),
            ma_can_u = 'CANCUN'
        where (ma_hotel, ma_reserv) in ( select ma_hotel, ma_reserv from dummyoo)    
--
--




-- Reservas mexico diferentes en ATL

drop view a1

create or replace view a1 as


select to_number(rv_hotel) rv_hotel, rv_reserva, rv_agencia, rv_llegada, rv_salida, rv_importe, rv_moneda
from freserva_hoteles
where   rv_mayorista  not in ('EUR','SUD','FIT','GAR','AME')
    and rv_status <> 'C'
    and rv_llegada > '01-mar-13'
    and rv_hotel in (1,2)
minus
select to_number(ho_hotel_cancun), ma_reserv, ma_charter, ma_arrival, ma_depart, ma_due_tot, ma_divisa
from rsmaes, rshotel
where   ma_arrival > '01-mar-13'
    and ma_can_d is null
    and ho_hotel = ma_hotel    


select rv_hotel, rv_reserva, rv_agencia, rv_llegada, rv_salida, rv_importe, rv_moneda
from freserva_hoteles
where rv_reserva = :reserv
union 
select ma_hotel, ma_reserv, ma_charter, ma_arrival, ma_depart, ma_due_tot, ma_divisa
from rsmaes
where ma_reserv = :reserv






insert into rstrans@cun_ot
select sysdate, rv_hotel, rv_reserva, 'H','U','N',null,null
from a1


select count(*) from a1


select * from rshotel


create or replace view a1 as
select to_number(ho_hotel_cancun) ma_hotel, ma_reserv
from rsmaes, rscharter, rshotel
where   ma_arrival > '01-mar-13'
    and ma_can_d is null
    and ch_hotel = ma_hotel
    and ch_charter = ma_charter
    and ch_utl not in ('EUR','SUD','FIT','GAR','AME')
    and ho_hotel = ma_hotel
    and ho_hotel in ('07','11')
minus
select to_number(rv_hotel), rv_reserva
from freserva_hoteles
where rv_status <> 'C'
    and rv_llegada > '01-mar-13'
    
    
select * from a1    



update rsmaes
set ma_can_d = trunc(sysdate),
    ma_can_u = 'CANCUN'
where ma_arrival > '01-mar-13'
    and ma_can_d is null
    and exists ( select 1 from rscharter where ch_hotel = ma_hotel and ch_charter = ma_charter and ch_utl not in ('EUR','SUD','FIT','GAR','AME') )
    and not exists  ( 
            select 1 
            from freserva_hoteles, rshotel 
            where   rv_status <> 'C' 
                and to_number(ho_hotel_cancun) = to_number(rv_hotel)
                and ho_hotel = ma_hotel
                and rv_reserva = ma_reserv
    )         
    
    
    
    
    select unique ch_utl from rscharter

insert into rstrans@cun_ov
select sysdate, ma_hotel, ma_reserv, 'H','U','N',null,null
from a1








select tr_hotel, count(*)
from rstrans
where tr_done = 'N'
group by tr_hotel

select tr_hotel, count(*)
from rstrans@cun_oc
where tr_done = 'N'
group by tr_hotel


select *
from rsmaes
where ma_reserv = '402228'

select t.*, t.rowid
from rscharter T
where ch_hotel = '03' and CH_CHARTER = 'REDAIOCV'

select *
from rinvoice
where in_hotel = '03' and in_wholes like 'REDA%'

select * from rstrans@cun_oc where tr_done = 'N' and tr_hotel not in ( '01','02')

update rstrans
set tr_done = 'E' 
where tr_done = 'N' and tr_stamp < '01-feb-13' 

desc oasisInterfaceOc



select * from rsmaes where ma_reserv = :reserv

drop view a1

select ma_hotel, ma_reserv, ma_arrival, ma_depart, ma_due_tot, ma_divisa, ma_can_d, ma_mod_d
from rsmaes
where ma_reserv = :reserv

select unique ma_hotel, ma_charter
from rsmaes
where ma_arrival > '01-jan-13' and ma_can_d is null and
         not exists ( select 1 from rscharter where ch_hotel = ma_hotel and ch_charter = ma_charter)


desc freserva_hoteles


select t.rowid, t.*
from rscharter t
where exists 
(
select 1
from rsmaes, rstrans
where ma_hotel= tr_hotel 
    and ma_reserv = tr_reserv
    and tr_done = 'E'
    and tr_error like '%Tipo de%'
    and ch_hotel = ma_hotel
    and ch_charter = ma_charter
)    
order by ch_utl,ch_hotel, ch_charter


select * from rsroom order by ro_hotel

select * from rstrans


update rstrans
set tr_done = 'N'
where tr_done = 'E' and tr_error like '%Tipo de%'

--select ch_utl,ma_hotel, ma_charter, ma_reserv, ch_nav_room, ma_room, ma_inp_d, ma_inp_u, ma_mod_u, ma_mod_d
insert into rstrans
select sysdate, ma_hotel, ma_charter, 'T','U','N',null,null  
from rsmaes, rstrans, rscharter
where ma_hotel= tr_hotel 
    and ma_reserv = tr_reserv
    and tr_done = 'E'
    and tr_error like '%Tipo de%'
    and ch_hotel = ma_hotel
    and ch_charter = ma_charter
    and ma_inp_u <> 'OASIS'
order by ch_utl, ma_charter    
    



select *
from rstrans
where tr_done = 'E' and tr_error like '%Tipo de habi%'




select * from rshotel

select * from rscharter where ch_charter = 'MMTGAP' and ch_hotel = '01'


desc isTravMarket


select ma_hotel, ma_reserv, ma_charter, ma_arrival, ma_depart, ma_nites, ma_room, ma_adult, ma_due_tot, ma_divisa, ma_mod_d  from rsmaes t where ma_reserv = :reserv
union
select rv_hotel, rv_reserva, rv_agencia, rv_llegada, rv_salida, rv_noches, rv_tipo_hab, rv_adulto, rv_importe, rv_moneda, rv_mod_f from freserva_hoteles   where rv_reserva = :reserv

select * from freserva_hoteles@comer03 where rv_reserva = :reserv

select * from rsmaes where ma_reserv  = :reserv

select *  from mares where mr_reserva = :reserv

select * from rstrans where tr_reserv = :reserv order by tr_stamp

select count(*) 
from rstrans
where tr_done = 'N'

select * from rsmaes where ma_reserv = '018105'

-- ********************
-- Actualiza movimientos del MARES a Travamerica..
        drop view a1
        
        select rsmaes.* from rsmaes, a1 where ma_hotel = hotel and ma_reserv = reserv order by ma_hotel, ma_reserv

        create view a1 as
        
        
        select ho_hotel hotel, mr_reserva reserv, mr_llegada, mr_salida, mr_tipo_hab
        from mares, rshotel
        where mr_salida > '01-jan-13'   and  mr_status not in ('C','N') and mr_hotel = ho_hotel_cancun and mr_mayorista not in ('AME','EUR','FIT','SUD')  and mr_llegada >= trunc(sysdate)
        minus 
        select ma_hotel, ma_reserv, ma_arrival, ma_depart, ma_room
        from rsmaes
        where ma_can_d is null

        select * from a1

        insert into rstrans
        select sysdate, hotel, reserv, 'H','I','N',null,null
        from a1 

        drop view a1


-- Se manda actualización de las reservas Travamerica a Cancún para mercados 
-- MEX y SUD
        drop view a1 
        
        create view a1 as
        
        
        select ma_hotel, ma_reserv , ma_arrival , ma_depart  , ma_due_tot, ma_divisa
        from rsmaes, rscharter
        where ma_can_d is null and ma_depart >= '01-jan-13' --and ma_inp_d < '01-jan-13'
            and ch_hotel = ma_hotel
            and ch_charter = ma_charter
            and ch_market in ('MEX','SUD')
            and ma_Inp_u <> 'OASIS'
        minus 
        select ho_hotel, mr_reserva , mr_llegada , mr_salida , mr_importe, mr_moneda
        from mares, rshotel
        where mr_status not in ('C','N') and mr_hotel = ho_hotel_cancun


        insert into rstrans
        select sysdate, ma_hotel, ma_reserv, 'T','I','N',null,null
        from a1 

-- toque de hoy a reservas sud
        insert into rstrans
        select sysdate, ma_hotel, ma_reserv,'T','I','N',null,null
        from rsmaes, rscharter
        where   ch_hotel = ma_hotel 
            and ch_charter = ma_charter
            and ch_utl = 'SUD'
            and ( (ma_inp_d >= trunc(sysdate-5) and ma_inp_u <> 'OASIS') or
                 (ma_mod_d >= trunc(sysdate-5) and ma_mod_u <> 'OASIS') or
                 (ma_can_d >= trunc(sysdate-5) and ma_can_u <> 'OASIS'))



-- Actualizacion de tipo de cuarto de Travamerica para Cancún.
--
            create view a1 as 

            select ma_hotel, ma_reserv, ma_arrival , ma_depart  , ma_room
            from rsmaes, rscharter
            where ma_can_d is null and ma_depart >= '01-jan-13' --and ma_inp_d < '01-jan-13'
                and ch_hotel = ma_hotel
                and ch_charter = ma_charter
                and ch_market in ('MEX','SUD')
                and ma_Inp_u <> 'OASIS'
            minus
            select ho_hotel, mr_reserva, mr_llegada , mr_salida , mr_tipo_hab
            from mares, rshotel
            where mr_status not in ('C','N') and mr_hotel = ho_hotel_cancun

            insert into rstrans
            select sysdate, ma_hotel, ma_reserv, 'T','I','N',null,null
            from a1 

-- Actualiza totales de lo que tienen en Cancún
            update rsmaes a
            set ma_due_tot = (select mr_importe from mares, rshotel where mr_hotel = ho_hotel_cancun and ho_hotel = a.ma_hotel and mr_reserva = ma_reserv),
                 ma_divisa = (select mr_moneda from mares, rshotel where mr_hotel = ho_hotel_cancun and ho_hotel = a.ma_hotel and mr_reserva = ma_reserv)
                  -- ma_room = (select mr_tipo_hab from mares, rshotel where mr_hotel = ho_hotel_cancun and ho_hotel = a.ma_hotel and mr_reserva = ma_reserv)
            where  exists ( select 1 from a1 b where b.ma_hotel = a.ma_hotel and b.ma_reserv = a.ma_reserv )
                and exists ( select 1 from mares, rshotel where mr_hotel = ho_hotel_cancun and  ho_hotel = a.ma_hotel and mr_reserva = ma_reserv) 

drop view a2          
    
create view a2 as    

--
-- Reservas menores a 50 USD
--
select ch_utl, ho_hotel_cancun, ma_reserv, ma_charter, ma_inp_u, ma_inp_d, ma_arrival, ma_due_tot total,  round(ma_due_tot/ma_nites/ma_adult) avgRate, ma_divisa
from rsmaes t, rscharter, rshotel
where ma_can_d is null
    and ma_divisa = 'USD'
    and ma_depart > sysdate
    and ch_hotel = ma_hotel
    and ch_charter = ma_charter
    and ch_market not in ('AME','EUR','FIT','GAR')
    and ch_utl not in ('COR') and ch_charter not like 'COMP%'
    and ma_nites > 0
    and ma_due_tot/ma_nites/ma_adult < 50
    and ho_hotel = ma_hotel
order by  ch_utl, ho_hotel_cancun
    
--
-- Reservas menores a 500 pesos.
--
select ch_utl, ho_hotel_cancun, ma_reserv, ma_charter, ma_inp_u, ma_inp_d, ma_arrival, ma_due_tot total,  round(ma_due_tot/ma_nites/ma_adult) avgRate, ma_divisa
from rsmaes t, rscharter, rshotel
where ma_can_d is null
    and ma_divisa = 'MEX'
    and ma_depart > sysdate
    and ch_hotel = ma_hotel
    and ch_charter = ma_charter
    and ch_market not in ('AME','EUR','FIT','GAR')
    and ma_charter not like 'USO%'
    and ch_utl not in ('COR') and ch_charter not like 'COMP%'
    and ma_nites > 0
    and ma_due_tot/ma_nites/ma_adult < 500
    and ho_hotel = ma_hotel
order by  ch_utl, ho_hotel_cancun


select ch_utl, ho_hotel_cancun, ma_reserv, ma_charter, ma_inp_u, ma_inp_d, ma_arrival, ma_due_tot total,  round(ma_due_tot/ma_nites/ma_adult) avgRate, ma_divisa
from rsmaes t, rscharter, rshotel
where ma_can_d is null
    and ma_divisa = 'MEX'
    and ma_depart > sysdate
    and ch_hotel = ma_hotel
    and ch_charter = ma_charter
    and ch_market not in ('AME','EUR','FIT','GAR')
    and ma_charter not like 'USO%'
    and ch_utl not in ('COR') and ch_charter not like 'COMP%'
    and ma_nites > 0
    and ma_due_tot/ma_nites/ma_adult > 2000
    and ho_hotel = ma_hotel
order by  ch_utl, ho_hotel_cancun





select ch_utl, ho_hotel_cancun, ma_reserv, ma_charter, ma_inp_u, ma_inp_d, ma_arrival, ma_due_tot total,  round(ma_due_tot/ma_nites/ma_adult) avgRate, ma_divisa
from rsmaes t, rscharter, rshotel
where ma_can_d is null
    and ma_divisa = 'USD'
    and ma_depart > sysdate
    and ch_hotel = ma_hotel
    and ch_charter = ma_charter
    and ch_market not in ('AME','EUR','FIT','GAR')
    and ch_utl not in ('COR') and ch_charter not like 'COMP%'
    and ma_nites > 0
    and ma_due_tot/ma_nites/ma_adult > 200
    and ho_hotel = ma_hotel
order by  ch_utl, ho_hotel_cancun





select * from a2

-- Actaliza totales de lo que tiene Cancun para reservas con tarifa elevada.
update rsmaes a 
set ma_due_t


select ma_hotel, ma_reserv, ma_charter, ma_inp_d, ma_due_tot total,  round(ma_due_tot/ma_nites/ma_adult) avgRate, ma_divisa, t.rowid
from rsmaes t, rscharter
where ma_can_d is null
    and ma_divisa = 'USD'
    and ma_depart > '01-jan-13'
    and ch_hotel = ma_hotel
    and ch_charter = ma_charter
    and ch_market not in ('AME','EUR','FIT','GAR')
    and ma_nites > 0
    and ma_due_tot/ma_nites/ma_adult >= 200
order by ma_hotel, ma_charter
ot = (select rv_importe from freserva_hoteles, rshotel where to_number(rv_hotel) = to_number(ho_hotel_cancun) and a.ma_hotel = ho_hotel and a.ma_reserv = rv_reserva), 
      ma_divisa = (select rv_moneda from freserva_hoteles, rshotel where to_number(rv_hotel) = to_number(ho_hotel_cancun) and a.ma_hotel = ho_hotel and a.ma_reserv = rv_reserva)
where exists ( select 1 from a2 b where b.ma_hotel = a.ma_hotel and b.ma_reserv = a.ma_reserv)  
    and exists ( select 1 from freserva_hoteles, rshotel where to_number(rv_hotel) = to_number(ho_hotel_cancun) and a.ma_hotel = ho_hotel and a.ma_reserv = rv_reserva)

select * from freserva_hoteles where rv_reserva = :reserv





select ma_hotel, ma_reserv, ma_charter, ma_inp_d, ma_due_tot total,  round(ma_due_tot/ma_nites/ma_adult) avgRate, ma_divisa, t.rowid
from rsmaes t, rscharter
where ma_can_d is null
    and ma_divisa = 'MEX'
    and ma_depart > '01-jan-13'
    and ch_hotel = ma_hotel
    and ch_charter = ma_charter
    and ch_market not in ('AME','EUR','FIT','GAR')
    and ma_nites > 0
    and ma_due_tot/ma_nites/ma_adult >= 1900
order by ma_hotel, ma_charter




select *
from rsoperator
where op_id = 'TURAVIA'     
    
select *
from rsmaes where ma_reserv = :reserv

select *
from rscharter
where ch_charter = 'DESPEGAR'

select *
from rspromomex
where hotel = '02'


select * from rstrans where trunc(tr_stamp) = trunc(sysdate) and tr_error is null

select av_hotel, av_date, trav_description, trav_order, sum(av_res) RES, sum(av_total) USD
from rsavailable_sum_trg, travmarkets
where trav_code = av_market and av_date between '01-jan-13' and '31-jan-13'
group by av_hotel, av_date, trav_description, trav_order
order by av_hotel, av_date, trav_order


select *
from rsavailable_sum_trg

alter table rsavailable_sum_trg add av_arrivals number(5)


desc refreshrsavailable_trg

select *
from travmarkets


select *
from rsroom
where ro_hotel = '01'


select *
from rschater
where ch_utl 

select ch_hotel, ch_charter, ch_nav_room
from rscharter
where ch_utl in ('AME','EUR') and exists ( select 1 from rsmaes where ma_charter = ch_charter and ma_arrival >= '01-jan-13' and not exists ( select 1 from rsroom where ro_hotel = ma_hotel and ro_room = ma_room) )
order by ch_charter  


select t.*, t.rowid
from travmarkets t


select unique ch_utl from rscharter



select ch_hotel, ch_charter, ch_nav_room
from rscharter
where ch_utl in ('AME','EUR','FIT') 
    and  exists ( select 1 from rsmaes where ma_hotel = ch_hotel and ma_charter = ch_charter and ma_depart >= '01-jan-13' )
    and not exists ( select 1 from rsroom where ro_hotel = ch_hotel and ro_room = ch_nav_room and ro_room <> 'ROH')
order by ch_charter     


select ho_hotel_cancun, ma_reserv, ma_charter, round(ma_due_tot/ma_nites/ma_adult) avgRate, ma_inp_d, ma_arrival, ma_depart, ma_inp_u, ma_inp_d, ma_mod_d, ma_mod_u, ma_can_d
from rsmaes, rscharter, rshotel
where ma_can_d is null
    and ma_divisa = 'USD'
    and ma_depart > '01-jan-13'
    and ch_hotel = ma_hotel
    and ch_charter = ma_charter
    and ch_market in ('MEX','SUD')
    and ma_nites > 0
    and ma_due_tot/ma_nites/ma_adult <= 50
    and ho_hotel = ma_hotel
order by ma_inp_u, ma_charter


select ma_hotel, ma_reserv, ma_charter, round(ma_due_tot/ma_nites/ma_adult) avgRate,ma_inp_d,  ma_arrival, ma_depart, ma_inp_u, ma_inp_d, ma_mod_d, ma_can_d
from rsmaes, rscharter
where ma_can_d is null
    and ma_divisa = 'USD'
    and ma_depart > '01-jan-13'
    and ch_hotel = ma_hotel
    and ch_charter = ma_charter
    and ch_market in ('MEX','SUD')
    and ma_nites > 0
    and ma_due_tot/ma_nites/ma_adult > 250
order by ma_inp_u, ma_hotel, ma_reserv


desc taInterface@comer03


desc mentry

select * from rstrans where tr_done = 'N'

select *
from rstrans
where tr_error is not null and
      tr_error like '%Tipo de %' and 
      tr_done = 'E'
      

select *
from rsmaes
where ma_reserv = :reserv      