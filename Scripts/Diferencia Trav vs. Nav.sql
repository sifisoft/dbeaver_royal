
-- 07,11  Viva MXVIVA
-- 09,12   Palm MXPBEACH
-- 01,02   Oasis MXGCANCUN

select confirmation
from kk3
where
not exists (
select 1
from maresnav
where mr_hotel in ('03') and mr_status not in ('C','N') and mr_reserva = confirmation
)
order by 1


-- Bookings on  Navision but diferent or not exist on Travamerica
select confirmation, nights, arrival, departure  
from kk3
where
not exists (
select 1
from maresnav
where mr_hotel in ('01','02') and mr_status not in ('C','N') and mr_reserva = confirmation and mr_noches = nights and mr_llegada = arrival and mr_salida = departure
)
order by 1


-- Travamerica Bookings that does not exists or diferent on Navision
select mr_reserva, mr_noches, mr_llegada, mr_salida
from maresnav
where mr_hotel in ('03') and 
          nvl(mr_status,'X') not in ('C','N') and
          (
          mr_llegada between '01-AUG-12' and '31-AUG-12' or
          mr_salida between '01-AUG-12' and '30-aug-12' or
          (mr_llegada < '01-aug-12' and mr_salida > '30-aug-12')
          )
and not exists ( 
    select 1 
    from kk3
    where confirmation = mr_reserva 
        and nights = mr_noches
        and  arrival = mr_llegada
        and  departure = mr_salida 
)
order by mr_reserva




select *
from maresnav
where mr_hotel in ('03','04') and mr_agencia = 'USOCASA' and mr_status not in ('C','N') and mr_salid >= '01-aug-12'





select mr_reserva
from maresnav
where mr_hotel in ('03') and 
          nvl(mr_status,'X') not in ('C','N') and
          (
          mr_llegada between '01-AUG-12' and '31-AUG-12' or
          mr_salida between '01-AUG-12' and '30-aug-12' or
          (mr_llegada < '01-aug-12' and mr_salida > '30-aug-12')
          )
and not exists ( 
    select 1 
    from kk3
    where confirmation = mr_reserva 
)
order by mr_reserva





select *
from maresnav
where mr_reserva = :reserva




select * from rshotel


select count(*)
from maresnav
where mr_hotel in ('01','02') and 
          nvl(mr_status,'X') not in ('C','N') and
          (
          mr_llegada between '01-AUG-12' and '31-AUG-12' or
          mr_salida between '01-AUG-12' and '30-aug-12' or
          (mr_llegada < '01-aug-12' and mr_salida > '30-aug-12')
          )
          



select t.*, t.rowid
from maresnav t
where mr_reserva = :reserva




select ta_reserva 
from kk3
where ta_hotel in ('05','06') and 
not exists (
select 1
from maresnav
where mr_hotel in ('05','06') and mr_status not in ('C','N') and mr_reserva = ta_reserva
)
order by 1




select mr_reserva 
from maresnav
where mr_hotel in ('05','06') and 
          nvl(mr_status,'X') not in ('C','N') and
          (
          mr_llegada between '01-AUG-12' and '31-AUG-12' or
          mr_salida-1 between '01-AUG-12' and '31-aug-12' or
          (mr_llegada < '01-aug-12' and mr_salida-1 > '31-aug-12')
          )
and not exists ( 
    select 1 
    from kk3
    where ta_reserva = mr_reserva and ta_hotel in ('05','06') 
)
order by mr_reserva




delete from kk

           
select * from kk3 where ta_reserva = :reserva


select t.*, t.rowid
from maresnav t
where mr_reserva = :reserv




select *
from maresnav
where mr_hotel in ('01','02') and ma



update maresnav
set mr_status = 'C', mr_notas_central = mr_notas_central ||' ARRANQUE'
where mr_hotel in ('01','02') and mr_reserva in (select * from kk)

delete from kk3



select mr_reserva, mr_noches, mr_llegada, mr_salida
from maresnav
where mr_hotel in ('09','12') and
           nvl(mr_status,'X') not in ('C','N') and
           (
           mr_llegada between to_date('01-AUG-12','dd-mon-yy') and to_date('31-AUG-12','dd-mon-yy') or
           mr_salida between to_date('01-AUG-12','dd-mon-yy') and to_date('30-aug-12','dd-mon-yy') or
           (mr_llegada < to_date('01-aug-12','dd-mon-yy') and mr_salida > to_date('30-aug-12','dd-mon-yy') )
           )
and not exists (
     select 1
     from navBookings
     where confirmation = mr_reserva
         and nights = mr_noches
         and arrival = mr_llegada
         and departure = mr_salida
)
order by mr_reserva



select confirmation, nights, arrival, departure
from navBookings
where
not exists (
select 1
from maresnav
where mr_hotel in ('09','12') and mr_status not in ('C','N') and 
mr_reserva = confirmation and mr_noches = nights and mr_llegada = 
arrival and mr_salida = departure
)
order by 1
