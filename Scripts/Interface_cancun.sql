
desc freserva

desc interface_reservaciones

desc freserva_travamerica_trg







select * from rshotel

select * from rstrans where tr_reserv = :reserv

select count(*) from rstrans where tr_done = 'N'

select * from freserva_travamerica

select t.*,t.rowid from rstrans t where tr_error is not null

select * from freserva where rv_hotel_renta is null and rv_llegada > sysdate

select * from freserva where rv_reserva = :resev

desc travamerica_utils



desc freserva_travamerica

select * from freserva

desc freserva

drop table rstrans

create table rstrans 
(
tr_stamp    date,
tr_hotel    varchar2(2),
tr_reserv   varchar2(8),
tr_source   varchar2(1),
tr_action   varchar2(1),
tr_done     varchar2(1),
tr_error    varchar2(500),
tr_rem      varchar2(600)
)
tablespace frontsmartdat 
storage (initial 10M next 5M pctincrease 20)

grant all on rstrans to public

create public synonym rstrans for rstrans


desc freserva 

-- tabla de reservas .. 
select unique rv_mayorista from freserva --where rv_hotel <> '9'





-- Tabla de fases y hoteles 
select * from frmodfas


create table kk as select * from freserva where rownum < 1

desc kk


select * from frmodfas



select * from rstrans

select * from freserva

select * from freserno





create table kk4 ( kk varchar2(1024))

select * from rstrans

desc rstrans

desc oasisInterface

execute oasisinterface.readHotel('04');

select * from kk4

delete from kk4

select * from rsmanames where mn_reserv = :reserv

select * from rsmaes where ma_reserv = :reserv



-- Touch Mexico todo futuro
select unique rv_mayorista  from freserva where rv_mayorista not in ('EUR','AME','FIT','SUD') and rv_status <> 'C' and rv_llegada between '01-jan-13' and  trunc(sysdate)

update freserva
set rv_status = rv_status
where rv_mayorista not in ('EUR','AME','FIT','SUD') and rv_status <> 'C' and rv_salida between '01-jan-13' and '31-jan-13'



desc freserva