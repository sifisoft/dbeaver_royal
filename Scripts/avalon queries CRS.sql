

execute avalonBookings.getAvalonBookings; 

rsmaes

select count(*) from rsmaes where ma_inp_u = 'AVALON';

select * from rinvoice_eliminated where in_reserv like :booking||'%';


delete from rinvoice_eliminated where in_reserv in ('GOCRS220002702-1','GOCRS220003006-1','GOCRS220003006-2','GOCRS220003006-3','GOCRS220003006-4','GOCRS220003006-5','GOCRS220005167-1','GOCRS220005192-1','GOCRS220015824-1','GOCRS220005120-1','GOCRS220016570-1','GOCRS220006500-1','GOCRS220006500-2','GOPRS220005083-1','GOCRS220019300-1','GOCRS220022442-1','SMARS220001724-1','GOCRS220005143-1','GOCRS220005143-2','GOCRS220005143-3','GOCRS220005143-4','GOCRS220005143-5','GOCRS220005143-6','GOCRS220005143-7','GOCRS220005143-8','GOCRS220005143-9','GOCRS220005143-10','GOCRS220005143-11','GOCRS220005143-12','GOCRS220005143-13','GOCRS220005143-14','GOCRS220005143-15','GOCRS220005143-16','GOCRS220005143-17','GOCRS220005143-18','GOCRS220005143-19','GOCRS220005143-20','GOCRS220005143-21','GOCRS220005143-22','GOCRS220005143-23','GOCRS220005143-24','GOCRS220005143-25','GOCRS220005143-26','GOCRS220005143-27','GOCRS220005143-28','GOCRS220005143-29','GOCRS220005143-30','GOCRS220005143-31','GOCRS220005143-32','GOCRS220005143-33','GOCRS220005143-34','GOCRS220016657-1','GOCRS220018184-1','GOCRS220018196-1','GOCRS220018578-1','GOCRS220020517-1','GOCRS220019630-1','GOCRS220020435-1','GOCRS220020672-1','GOCRS220021216-1','GOCRS220021335-1','GOCRS220021299-1','GOCRS220021339-1')



select * from rsmaes_avalon where ma_reserv = :booking

select * from entidad_avalon_crs where entidad_negocio_avalon like '%EXPEDIA INC.%';

select * from rscharter where ch_charter = 'EXPIDIA'

select * from rinvoice where in_reserv like :booking||'%'


select *
from rsmaes
where ma_inp_u = 'AVALON';




select MA_HOTEL, MA_RESERV, MA_LINE, MA_CHARTER, MA_SUBCHAR, MA_GROUP, MA_COUNTRY, MA_CITY, MA_ADRESS1, MA_ADRESS2, MA_GUEST, MA_VIP, MA_SOURCE, MA_CONT_N, MA_CONT_T, MA_ARRIVAL, MA_DEPART, MA_NITES, MA_ARR_TIME, MA_FLIGHT, MA_CARRIER, MA_ROOM, MA_RATE, MA_ADULT, MA_CHILD, MA_INFANT, MA_PLAN_1, MA_PLAN_2, MA_PACKAGE, MA_FIRST, MA_REM_USER, MA_REM_SYS, MA_INP_U, MA_INP_D, MA_INP_T, MA_CAN_D, MA_CAN_U, MA_CAN_T, MA_CAN_C, MA_MOD_U, MA_MOD_D, MA_MOD_T, MA_TRANS, MA_ROOMING, MA_VOUCHER, MA_DUE_TOT, MA_DEP_REC, MA_DEP_TOT, MA_AGCY_CNF, MA_SPECIAL, MA_A_RATE, MA_ROOM_NUM, MA_PREV_HOTEL, MA_PREV_RESERV, MA_CRS, MA_PEN_AGEN, MA_DIVISA, MA_MAYORISTA, MA_LAST_N, MA_FIRST_N
from rsmaes_avalon@xe;



create or replace view rsmaes_avalon_sintotal as 
select getHotelCodeFromAvalon(r.ma_hotel, r.ma_room) MA_HOTEL, MA_RESERV, MA_LINE, MA_CHARTER, MA_SUBCHAR, MA_GROUP, MA_COUNTRY, MA_CITY, MA_ADRESS1, MA_ADRESS2, MA_GUEST, MA_VIP, MA_SOURCE, MA_CONT_N, MA_CONT_T, MA_ARRIVAL, MA_DEPART, MA_NITES, MA_ARR_TIME, MA_FLIGHT, MA_CARRIER, MA_ROOM, MA_RATE, MA_ADULT, MA_CHILD, MA_INFANT, MA_PLAN_1, MA_PLAN_2, MA_PACKAGE, MA_FIRST, MA_REM_USER, MA_REM_SYS, MA_INP_U, MA_INP_D, MA_INP_T, MA_CAN_D, MA_CAN_U, MA_CAN_T, MA_CAN_C, MA_MOD_U, MA_MOD_D, MA_MOD_T, MA_TRANS, MA_ROOMING, MA_VOUCHER, MA_DUE_TOT, MA_DEP_REC, MA_DEP_TOT, MA_AGCY_CNF, MA_SPECIAL, MA_A_RATE, MA_ROOM_NUM, MA_PREV_HOTEL, MA_PREV_RESERV, MA_CRS, MA_PEN_AGEN, MA_DIVISA, MA_MAYORISTA, MA_LAST_N, MA_FIRST_N, trav_description ma_market, trav_order ma_market_order 
from (
select *
from rsmaes_avalon_sintotal@xe
) r, travMarkets
where trav_code = ma_mayorista;





select entidad_negocio_avalon, count(*)
from entidad_avalon_crs
group by entidad_negocio_avalon
having count(*) > 1;


-- Operadores sin conversion CRS
select unique ma_charter
from rsmaes_avalon
where ma_mayorista in ('USA','ALG','CAN','SUD','EUR') and ma_can_d is null and ma_depart between sysdate-30 and sysdate+30 and not exists (
select 1
from entidad_avalon_crs
where entidad_negocio_avalon = ma_charter
    and cod_crs is not null
)

select ma_hotel, ma_reserv, ma_line, ma_due_tot, ma_divisa, ma_mayorista
from rsmaes_avalon
where ma_can_d is null;


select count(*)
from rsmaes_avalon_new
where ma_mayorista in ('USA','ALG','CAN','SUD','EUR') and ma_can_d is null and ma_depart between '01-sep-22' and '30-sep-22' and ma_due_tot = 0;

select count(*)
from rsmaes_avalon_old
where ma_mayorista in ('USA','ALG','CAN','SUD','EUR') and ma_can_d is null and ma_depart between '01-sep-22' and '30-sep-22' and ma_due_tot = 0;



create public synonym rsmaes_avalon_old for rsmaes_avalon_old@xe;

create public synonym rsmaes_avalon_new for rsmaes_avalon_new@xe;

create public synonym rsmaes_avalon_new for rsmaes_avalon_new@xe;


alter table rsmaes modify ma_group varchar2(30);

alter table rsmaes modify ma_room varchar2(20);

alter table rsmaes modify ma_room_num varchar2(20);

alter table rsmaes modify ma_mayorista varchar2(20);

alter table rsmanames modify mn_last_n varchar2(60);

alter table rsmanames modify mn_first_n varchar2(60);
