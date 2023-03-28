

-- ROOM RATE CODE
select t.*, t.rowid
from rsgds_rate t
where gds_hotel = :hotel
order  by gds_hotel, gds_rate, gds_room

-- HOTEL CODE
select t.*, t.rowid 
from rsgds_hotel t
order by gds_hotel

-- RESERVATIONS
select t.*, t.rowid
from rsmaes t
where ma_inp_u like 'SX%'

/* plsql package that handle bookings */
desc gds

desc rsmaes_gds

desc rsgds_rate

-- Esta columna se usa para guardar los codigos de operadores
-- para reservas que provienen de un GDS 
alter table rsgds_rate 
add gds_trav_rate_gds varchar2(10)


select *        
from rsmaes
where ma_reserv = :reserv

select *
from rsmanames
where mn_reserv = :reserv



select *
from rsmaes
where ma_voucher = '56467IC000068'

update rsmaes
set ma_can_d = trunc(sysdate),
     ma_can_t = to_char(sysdate,'HH24MI'),
     ma_can_u = 'SYSTEM'
where ma_reserv = :reserva     
         




desc rsmaes_gds 

select t.*, t.rowid
from rsmaes_gds t






alter table rsmaes add ma_ta_code varchar2(20);

alter table rsmaes add ma_ta_name varchar2(100);

alter table rsmaes add ma_ta_add1 varchar2(80);

alter table rsmaes add ma_ta_add2 varchar2(80);

alter table rsmaes add ma_ta_city varchar2(80);

alter table rsmaes add ma_ta_state varchar2(80);

alter table rsmaes add ma_ta_country varchar2(80);

alter table rsmaes add ma_ta_tel varchar2(30);

alter table rsmaes add ma_ta_email varchar2(400);



create table zz ( zz varchar2(50));


select * from gds.booking() from dual

select * from rinvoice

delete from rsgds_rate
