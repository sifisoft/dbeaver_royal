
select count(*)
from mares
where mr_hotel in ('01','02') and mr_llegada >= '01-jan-13' and mr_mayorista not in ('AME','EUR','FIT','GAR')


select unique mr_mayorista from mares


drop table kk_mares_notin_rsmaes

select count(*) from kk_mares_notin_rsmaes

create table kk_mares_notin_rsmaes as


select ho_hotel, mr_reserva
from mares, rshotel
where mr_salida >= '01-jan-13' and mr_status not in ('C','N') and mr_hotel = ho_hotel_cancun and mr_mayorista not in ('AME','EUR','FIT','GAR')
minus 
select ma_hotel, ma_reserv
from rsmaes
where ma_depart >= '01-jan-13' and ma_can_d is null and ma_can_u is null


select count(*) from mares where mr_semaforo = '2' and mr_status != 'C' 


select *
from rsmaes
where ma_reserv = '101751'

select *
from mares
where mr_reservA = '101751'

select * from rshotel


select mr_semaforo, mr_status
from mares a, rshotel r, kk_mares_notin_rsmaes b
where r.ho_hotel = b.ho_hotel 
    and a.mr_reserva = b.mr_reserva
    and ho_hotel_cancun = mr_hotel

    
update mares a
set mr_semaforo = 2
where exists ( 
    select 1 
    from kk_mares_notin_rsmaes b, rshotel r 
    where r.ho_hotel = b.ho_hotel 
        and a.mr_reserva = b.mr_reserva
        and ho_hotel_cancun = a.mr_hotel
   ) 




drop table kk_rsmaes_notin_mares

select count(*) from kk_rsmaes_notin_mares

create table 


insert into kk_rsmaes_notin_mares

  
select ma_hotel, ma_reserv
from rsmaes, rscharter
where ma_depart >= '01-jan-13' and ma_inp_d < '01-jan-13'  and ma_can_d is null and ma_can_u is null and ch_hotel = ma_hotel and ch_charter = ma_charter and ch_market in ('MEX','SUD')
minus 
select ho_hotel, mr_reserva
from mares, rshotel
where mr_salida >= '01-jan-13' and mr_status not in ('C','N') and mr_hotel = ho_hotel_cancun  



select * from rshotel

select count(*)
from rsmaes, rscharter
where ma_depart >= '01-jan-13' and ma_inp_d < '01-jan-13' and ma_mod_d < '01-jan-13' and ma_can_d is null and ma_can_u is null and ch_hotel = ma_hotel and ch_charter = ma_charter and ch_market in ('MEX','SUD')
    and not exists ( select 1 from mares, rshotel where mr_hotel = ho_hotel_cancun and ho_hotel = ma_hotel and mr_reserva = ma_reserv and ma_room = mr_tipo_hab)
    
update rsmaes
set ma_room = ( select mr_tipo_hab from mares, rshotel where mr_hotel = ho_hotel_cancun and ho_hotel = ma_hotel and mr_reserva = ma_reserv ) 
where ma_depart >= '01-jan-13' and ma_inp_d < '01-jan-13' and ma_mod_d < '01-jan-13' and ma_can_d is null and ma_can_u is null 
    and not exists ( select 1 from mares, rshotel where mr_hotel = ho_hotel_cancun and ho_hotel = ma_hotel and mr_reserva = ma_reserv and ma_room = mr_tipo_hab)
    and exists ( select 1 from rscharter where ch_hotel = ma_hotel and ch_charter = ma_charter and ch_market in ('MEX','SUD')) 
    




select * from rsmaes where ma_reserv = :reserv

select * from mares where  mr_reserva = :reserv

select * from freserva_grand where rv_reserva = :reserv


select * from rshotel

select *
from rsmaes
where ma_hotel = '07' and ma_charter = 'EUROAMER'

select * from mares where mr_reserva = :reserv


update mares
set mr_semaforo = 2
where mr_reserva = :reserv


update rsmaes a
set ma_can_d = trunc(sysdate-1),
    ma_can_u = 'REFRESH'
where exists ( select 1 from kk_rsmaes_notin_mares b where a.ma_hotel = b.ma_hotel and a.ma_reserv = b.ma_reserv)


    

select a.*
from rsmaes a, kk_rsmaes_notin_mares b
where   a.ma_hotel = b.ma_hotel 
    and a.ma_reserv = b.ma_reserv


select * 
from kk_rsmaes_notin_mares 
where ma_hotel in ('01','02')

select mr_hotel, ma_hotel, mr_reserva
from mares, kk_rsmaes_notin_mares
where mr_hotel in ('01','02') and ma_hotel in ('01','02') and mr_reserva = ma_reserv and mr_hotel <> ma_hotel





select * from rshotel


select count(*)
from rsmaes, rscharter
where ma_depart >= '01-jan-13' and ma_inp_d < '01-jan-13' and ma_can_d is null and ma_can_u is null and ch_hotel = ma_hotel and ch_charter = ma_charter and ch_market in ('MEX','SUD')


select count(*)
from mares, rshotel
where mr_salida >= '01-jan-13' and mr_status not in ('C','N') and mr_hotel = ho_hotel_cancun and mr_mayorista not in ('AME','EUR','FIT','GAR')


select count(*) from kk_mares_notin_rsmaes


select count(*) from mares where mr_semaforo = 2

select a.*
from rsmaes a, kk_mares_notin_rsmaes
where   ma_hotel = ho_hotel 
    and ma_reserv = mr_reserva
    and ma_can_d is not null
    and ma_can_u = 'TRASPASO'
    


update rsmaes a
set ma_can_u = null,
    ma_can_t = null,
    ma_cancel = null
where exists ( select 1 from kk_mares_notin_rsmaes where ho_hotel  = ma_hotel and ma_reserv = mr_reserva) and ma_can_u = 'TRASPASO'


update rsmaes
set ma_charter = (select mr_agencia from mares, rshotel where ho_hotel_cancun = mr_hotel and ho_hotel = ma_hotel and mr_reserva=ma_reserv )
where ma_depart >= '01-jan-13' and ma_charter = 'MEXDISPO' and ma_can_d is null and exists
(select 1 from mares, rshotel where ho_hotel_cancun = mr_hotel and ho_hotel = ma_hotel and mr_reserva=ma_reserv)     




    
select *
from rsmaes a, kk_mares_notin_rsmaes 
where   ma_reserv = mr_reserva 
    and ma_hotel <> ho_hotel
    and ho_hotel in ('01','02')
    and ma_hotel in ('01','02')
          


select * from freserva where rv_reserva = :reserva

select * from freserva_grand where rv_reserva = :reserva

select * from rsmaes where ma_reserv = :reserva

select * from mares where mr_reserva = :reserva


select  mr_hotel, mr_reserva, mr_agencia, mr_mayorista, mr_tipo_hab
from MARES
  where MR_MAYORISTA in ('MEX','SUD','DIR','COR','USO','INT')
  and MR_STATUS != 'C'
  and MR_SALIDA >= '01-JAN-13'
  --and mr_hotel in ('01','02') 
  and not exists ( select 1 from rsroom, rshotel  where ho_hotel_cancun = mr_hotel and ro_hotel = ho_hotel and ro_room = mr_tipo_hab)
order by mr_hotel, mr_tipo_hab 
  

select t.*, t.rowid
from rsroom t
--where ro_hotel = '06'
  --and mr_hotel in ('01','02')
order by ro_hotel, ro_room

select * 
from rshotel



select unique mr_mayorista
from mares



select *
from rscharter
where ch_hotel = '02' and ch_charter = :agency



select count(*)
from mares where mr_semaforo = 2

select *
from freserva_grand
where rv_reserva = :reserva 


select * from rshotel

    select count(*) from MARES
    where mr_mayorista not in ('AME','EUR','FIT','GAR')  
         and MR_STATUS != 'C'
         and MR_SALIDA >= '01-JAN-13'
       and MR_HOTEL in ('09','12')
       --and mr_semaforo = '1' 


  

   select count(*) from mares
   where mr_status!= 'C'
     and mr_mayorista not in ('AME','EUR','FIT','GAR')
     and mr_salida between '01-JAN-13' and '31-JAN-13'
     and mr_hotel in ('01','02')
     
     
       


select *
from mares
where MR_RESERVA = '431727'