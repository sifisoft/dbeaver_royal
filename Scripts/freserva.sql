
-- comparar Oasis Cancún.

-- Reservas de mas en oasis cancun
select count(*)
from rsmaes, rscharter
where  ma_hotel in ('01','02') 
    and ma_can_d is not null
    and ma_depart >= '01-jan-13'
    and ma_inp_d < trunc(sysdate)
    and ch_hotel = ma_hotel
    and ch_charter = ma_charter
    and ch_market not in ('NAM','SAM','EUR')
    and not exists ( select 1 from freserva_grand where rv_reserva = ma_reserv)
    
    
    select count(*) from mares
    where mr_hotel in ('01','02') and mr_salida > sysdate and mr_mayorista not in ('AME','EUR','FIT','GAR')  


select unique ch_market
from rscharter


select av_hotel, av_room
from rsavailable_trg
where av_date >= '01-jan-13' and not exists ( select 1 from rsroom where ro_hotel = av_hotel and ro_room = av_room) and av_market  in ( 'USA','CANADA','EUROPE')
group by av_hotel, av_room
order by av_hotel, av_room