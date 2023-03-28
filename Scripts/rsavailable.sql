

refreshRSAVAILABLE_SUM_TRG_Avalon


select convertToUSD(ma_inp_d, nvl(ma_divisa,'USD'), ma_due_tot), t.* from rsmaes_avalon t where ma_reserv = :avalonBooking;

select * from travusd_convertion order by stamp_date desc;


execute refreshrsavailable_sum_trg(trunc(sysdate-21,'MONTH'),last_day(add_months(sysdate,12)));

execute refreshrsavailable_trg(trunc(sysdate-21,'MONTH'),last_day(add_months(sysdate,12)));

execute refreshrsavailable_sum_trg_avalon(trunc(trunc(sysdate),'MONTH'),last_day(add_months(trunc(sysdate),3)));



select *
from rsmaes_avalon
where ma_arrival between '01-oct-22' and '19-oct-22' and ma_can_d is null and ma_room_num is null
order by ma_arrival;


select * 
from rsmaes
where ma_reserv = :reserv;