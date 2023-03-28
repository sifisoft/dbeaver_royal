


select mr_hotel, count(*)
from mares
where mr_llegada >= '01-dec-12' and nvl(mr_importe,0) = 0 and mr_status not in ('C','N') and mr_mayorista not in ('EUR','AME','USA','CAN') and mr_hotel != 99
group by mr_hotel
order by mr_hotel



select ma_hotel, ma_reserv, ma_charter, ma_arrival, ma_depart, ma_nites, ma_due_tot, ma_inp_u
from rsmaes, rscharter
where ma_arrival >= trunc(sysdate,'MONTH') and ma_can_d is null and
         nvl(ma_due_tot,0) = 0 and  
         ch_hotel = ma_hotel and 
         ch_charter = ma_charter and 
         ch_market in ('EUR','NAM') and
         ch_charter not in ('COMPS') 
order by ma_arrival, ma_hotel         
         
         
select unique ch_market
from rscharter