


 execute genAvalonOutOfRangeBookingsXLS;


select ho_hotel, ho_avg_rate_min, ho_avg_rate_max, t.*, t.rowid
from rshotel t
order by to_number(t.ho_hotel);

alter table rshotel drop column ho_rate_avg;

alter table rshotel add ho_avg_rate_max number(12,2);


select trunc(10.70) from dual;

select *
from travmarkets

select ma_hotel, ho_desc
from rsmaes_avalon, rshotel
where ma_arrival between '01-jan-23' and '31-jan-23'
    and ma_hotel = ho_hotel
group by ma_hotel, ho_desc    
order by to_number(ma_hotel)

select * from rsmaes


select 'HT'||ma_hotel ma_hotel, ma_reserv, ma_line, ma_charter, ma_room, ma_arrival, ma_depart, ma_due_tot, ma_nites, ma_adult, ma_divisa, round(convertToUSD(ma_inp_d, nvl(ma_divisa,'USD'), ma_due_tot)/decode(nvl(ma_nites,0),0,1,ma_nites)/ma_adult,2) RN_PAX_USD, ma_mayorista, ma_inp_d, ma_inp_u 
from rsmaes_avalon, rshotel
where   ma_arrival > sysdate 
    and ma_can_d is null 
    and ho_hotel = ma_hotel
    and trunc(convertToUSD(ma_inp_d, nvl(ma_divisa,'USD'), ma_due_tot)/decode(nvl(ma_nites,0),0,1,ma_nites)/ma_adult) not between ho_avg_rate_min and ho_avg_rate_max
    and ma_mayorista not in ('COR','TC','USO', 'OTLC','VILLAS DEL PALMAR')
    and ma_adult > 1
order by ma_hotel, ma_charter, ma_arrival, ma_nites    
;
    
    
     genAvalonZeroBookingsXLS