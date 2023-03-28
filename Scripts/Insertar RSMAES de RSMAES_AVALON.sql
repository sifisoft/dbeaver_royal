


alter table rsmaes
modify ma_divisa varchar2(5);





select ma_hotel, ma_reserv, '1', ma_last_n, ma_first_n
from rsmaes_avalon b, entidad_avalon_crs
where (  
        (b.ma_arrival >= '01-jan-23' and b.ma_depart <= '31-jan-23')
    or  (b.ma_arrival <  '01-jan-23' and b.ma_depart > '01-jan-23')
    or  (b.ma_arrival <  '31-jan-23' and b.ma_depart > '31-jan-23')
    )
    and b.ma_can_d is null
    and entidad_negocio_avalon (+) = b.ma_charter
    and not exists (select 1 from rsmaes c where c.ma_hotel = b.ma_hotel and c.ma_reserv = b.ma_reserv||'-'||b.ma_line) 
;
    
drop table rsmanames_jan2023;

create table rsmanames_jan2023 as 
select ma_hotel, ma_reserv, ma_line, '1' ma_sequence, nvl(ma_last_n,'X') mn_last_n, nvl(ma_first_n,'X') mn_first_n
from rsmaes_avalon b
where (  
        (b.ma_arrival >= '01-jan-23' and b.ma_depart <= '31-jan-23')
    or  (b.ma_arrival <  '01-jan-23' and b.ma_depart > '01-jan-23')
    or  (b.ma_arrival <  '31-jan-23' and b.ma_depart > '31-jan-23')
    )
    and b.ma_can_d is null
;
  

insert into rsmaes 
(MA_HOTEL, MA_RESERV, MA_CHARTER, MA_SUBCHAR, MA_GROUP, MA_SOURCE, MA_ARRIVAL, MA_DEPART, MA_NITES, MA_ROOM, MA_RATE, MA_ADULT, MA_CHILD, MA_INFANT, MA_PLAN_1, MA_REM_USER, MA_REM_SYS, MA_INP_U, MA_INP_D, MA_CAN_D, MA_CAN_U, MA_MOD_U, MA_MOD_D, MA_VOUCHER, MA_DUE_TOT, MA_DEP_REC, MA_DEP_TOT, MA_A_RATE, MA_ROOM_NUM, MA_DIVISA, MA_MAYORISTA)
select MA_HOTEL, MA_RESERV, MA_CHARTER, MA_SUBCHAR, MA_GROUP, MA_SOURCE, MA_ARRIVAL, MA_DEPART, MA_NITES, MA_ROOM, MA_RATE, MA_ADULT, MA_CHILD, MA_INFANT, MA_PLAN_1, MA_REM_USER, MA_REM_SYS, MA_INP_U, MA_INP_D, MA_CAN_D, MA_CAN_U, MA_MOD_U, MA_MOD_D, MA_VOUCHER, MA_DUE_TOT, MA_DEP_REC, MA_DEP_TOT, MA_A_RATE, MA_ROOM_NUM, MA_DIVISA, MA_MAYORISTA
from rsmaes_jan2023 b
where not exists ( select 1 from rsmaes a where a.ma_hotel = b.ma_hotel and a.ma_reserv = b.ma_reserv)


insert into rsmanames
(MN_HOTEL, MN_RESERV, MN_SEQUENCE, MN_LAST_N, MN_FIRST_N)
select MA_HOTEL, MA_RESERV||'-'||ma_line, '1', MN_LAST_N, MN_FIRST_N
from rsmanames_jan2023
where not exists (
    select 1
    from rsmanames
    where mn_hotel = ma_hotel and mn_reserv = ma_reserv||'-'||ma_line
)


delete from rsmanames
where exists ( 
    select 1
    from rsmaes
    where   ma_source = 'AVALON'
        and mn_hotel = ma_hotel
        and mn_reserv = ma_reserv
)


select * from rsmanames where mn_hotel = '02' and  mn_reserv = 'GOCRS220070646-39';

select * from rsmaes where ma_hotel = '02' and  ma_reserv = 'GOCRS220070646-39';




select * from rsmanames_avalon;



select *
from rsmaes
where ma_source = 'AVALON'



select *
from rinvoice
where in_arrival > trunc(sysdate,'MONTH');

DELETE from rsmaes
where ma_source = 'AVALON';


select *
from rstrans_avalon
order by tr_stamp desc


travInvoicing_mex


grep -i 


select * 
from rsmaes
where ma_arrival >= '01-jan-23'


rsoperator

select *
from rsmaes
where ma_arrival >= '01-jan-23' and  ma_source != 'AVALON'
