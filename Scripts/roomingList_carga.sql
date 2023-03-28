

select * from roominglist_carga;

update rsmaes set ma_can_d = ma_can_d
where ma_hotel in ('02','06','12') and ma_arrival > sysdate and ma_charter like 'MUFE21%' and ma_can_d is not null;



select *
from freserva_hoteles
where rv_hotel = '' and rv_agencia = 'GROUPSAI' and rv_status != 'C'  and rv_llegada > sysdate and not exists ( 
select 1
from rsmaes
where   --ma_hotel = '02' and 
        ma_reserv = rv_reserva
    and ma_can_d is null
)


select *
from freserva_hoteles
where rv_reserva in ('120248002',
'120248015',
'120248040',
'120248041',
'120248045',
'120248046',
'120248058'
) and rv_status != 'C'



120247707 a 120247893
120247895 a 120247900
120247906 a 120247918
120247920 a 120247934
120247936 a 120247938
120247940 a 120247942
120247944 a 120247945
120247971 a 120247977
120247979 a 120247999

'120248002',
'120248015',
'120248040',
'120248041',
'120248045',
'120248046',
'120248058'
    


select *
from rstrans
where tr_reserv  = '020045895'

select count(*) 
from rstrans
where tr_hotel = '02' and tr_done is null;

select *
from rsmaes
where ma_reserv = '120247815'

update rsmaes set ma_cancel = sysdate
where ma_hotel = '02' and ma_charter = 'MUFE21ST' and ma_can_d is not null;


insert into rstrans 
select sysdate, ma_hotel, ma_reserv, 'T','U',null,null,null
from rsmaes
where ma_hotel = '12' and ma_charter like 'MUFE21%' and ma_can_d is not null;





select *
from rshotel;

select *
from rsroom
where ro_hotel = '06';

rsmaes

rsmanames


select * from roomingList_carga;

update rsmaes
set ma_can_d = sysdate, ma_can_u = 'JTARAZ',  ma_rem_user= 'TEST BOOKING' 
where exists (
    select 1 from roomingList_carga
    where   ca_hotel = '02'
        and ca_hotel = ma_hotel
        and ca_royal_booking = ma_reserv
)

select * from rsmaes where ma_hotel = '02' and ma_inp_u is null and trunc(ma_inp_d) = trunc(sysdate) and ma_can_d is not null;




select ma_can_d, count(*)
from rsmaes
where ma_hotel = '02' and ma_inp_u is null and trunc(ma_inp_d) = trunc(sysdate-1)
group by ma_can_d;


select ma_can_d, count(*)
from rsmaes
where ma_hotel = '02' and (ma_inp_u is null or ma_inp_u like 'JTARA%') and trunc(ma_inp_d) = trunc(sysdate-1)
group by ma_can_d



update rsmaes
set ma_cancel = ma_can_d
where ma_hotel = '02' and ma_arrival >= trunc(sysdate) and (ma_inp_u is null or ma_inp_u like 'JTARA%') and trunc(ma_inp_d) = trunc(sysdate-1)




update rsmaes
set ma_can_d = sysdate, ma_can_u = 'JTARAZ',  ma_rem_user= 'TEST BOOKING' 
where exists (
    select 1 from roomingList_carga
    where   ca_hotel = '02'
        and ca_hotel = ma_hotel
        and ca_royal_booking = ma_reserv
)


update roomingList_carga
set ca_royal_booking = null,
    ca_processed = null,
    ca_process_user = null,
    ca_process_date = null
where ca_hotel = '02' ;

    

select * from roomingList_carga;

delete from roomingList_carga;

create table roomingList_carga  (
    ca_carga_file       varchar2(360),
    ca_line             number(6),
    ca_hotel            varchar2(2),
    ca_charter_code     varchar2(8),
    ca_room_code        varchar2(6),    
    ca_fn1              varchar2(30),
    ca_ln1              varchar2(30),
    ca_fn2              varchar2(30),
    ca_ln2              varchar2(30),
    ca_fn3              varchar2(30),
    ca_ln3              varchar2(30),
    ca_fn4              varchar2(30),
    ca_ln4              varchar2(30),
    ca_single           varchar2(1),
    ca_double           varchar2(1),
    ca_triple           varchar2(1),
    ca_quad             varchar2(1),
    ca_arrival          date,
    ca_depart           date,
    ca_nights           number(1),
    ca_adults           number(1),
    ca_children         number(1),
    ca_infants          number(1),
    ca_load_date        date,
    ca_royal_booking    varchar2(12),
    ca_process_date     date,
    ca_process_user     varchar2(15),
    ca_processed        varchar2(1),
    ca_error            varchar2(1024)
)
tablespace hotel
storage (initial 10M next 1M pctincrease 20)


rsmaes