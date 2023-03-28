

select * from rstrans where tr_reserv = :reserv

select * from rsmaes where ma_reserv = :reserv

select * from rsmaesmo where mm_reserv = :reser

select * from rsmanames where mn_reserv = :reserv

select * from rsmanames_2013 where mn_reserv = :reserv

select * from cat where table_name like '%MANAMES%'

select * from rsmanames_interface

create table rsmanames_2013 as select * from rsmanames

select * from rsmaes where ma_reserv = :reserv

select * from freserno

desc OasisInterface


select * from mares where mr_reserva = :reserv


select *
from rsmaes
where ch_hotel = ma_hotel
    and ch_charter = ma_charter
    and ma_can_d is null
    and (ma_mod_d <  
    
    
select *
from mares
where   mr_mayorista = 'SUD' 
    and mr_llegada >= '01-feb-13' 
    and mr_status <> 'C' 
    and not exists ( select 1 from rsmaes, rshotel where ho_hotel_cancun = mr_hotel and ma_hotel = ho_hotel and ma_reserv = mr_reserva and ma_mod_d >= '24-JAN-13')
    
select *
from maresaux    
where mr_mayorista = 'SUD'      
order by mr_hotel, mr_reserva


select * from rsmanames
where mn_reserv = :reserv

select * from mares where mr_reserva = :reserv


select * from freserva_hoteles where rv_reserva = :reserv

drop table freserno_ot

select * from rshotel

create table freserno_op as
select *
from freserno@cun_op
where       exists ( select 1 from freserva@cun_op where rv_reserva = vn_reserva and rv_mayorista = 'SUD' and rv_llegada >= '01-jan-13' and rv_status <> 'C')

select count(*) from freserno_op

delete from freserno_op
where exists ( select 1 from rsmaes where ma_hotel in ('09','12') and ma_reserv = vn_reserva and ma_mod_d > '23-JAN-13' )

drop view a1

create view a1 as 
select ma_hotel, ma_reserv, vn_secuencia, vn_apellido, vn_nombre 
from rsmaes, freserno_op
where ma_reserv = vn_reserva 
    and ma_hotel in ('09', '12')
order by ma_hotel,ma_reserv

delete from rsmanames a where exists ( select 1 from a1 b where a.mn_hotel = b.ma_hotel and a.mn_reserv = b.ma_reserv)

insert into rsmanames select * from a1


select *
from freserno@cun_op
where vn_reserva = :reserv

select * from rshotel

drop table freserno_op

create table freserno_op as
select *
from freserno@cun_op
where       exists ( select 1 from freserva@cun_op where rv_reserva = vn_reserva and rv_mayorista = 'SUD' and rv_llegada >= '01-jan-13' and rv_status <> 'C' and rv_cap_u <> 'SISTEMAS')

delete from freserno_op
where exists ( select 1 from rsmaes where ma_hotel in ('09','12') and ma_reserv = vn_reserva and ma_mod_d > '23-JAN-13' )

drop view a1

create view a1 as 
select ma_hotel, ma_reserv, vn_secuencia, vn_apellido, vn_nombre 
from rsmaes, freserno_op
where ma_reserv = vn_reserva 
    and ma_hotel in ('09','12')
order by ma_hotel,ma_reserv

select count(*) from a1

delete from rsmanames a where exists ( select 1 from a1 b where a.mn_hotel = b.ma_hotel and a.mn_reserv = b.ma_reserv)

insert into rsmanames select * from a1






select * from rsmaes where ma_reserv = :reserv



select mn_hotel, mn_reserv, mn_sequence
from rsmanames
where exists ( select 1 from a1 where mn_hotel = ma_hotel and mn_reserv = ma_reserv)
minus
select ma_hotel, ma_reserv, vn_secuencia
from a1

select * from a1 where ma_hotel = '02' and ma_reserv = '130820'

select * from rsmanames

select count(*)
from rscharter, rsmaes
where ma_hotel = ch_hotel
    and ma_charter = ch_charter
    and ma_hotel in ('01','02')
    and ma_arrival >= '01-jan-13'
    and exists ( select 1 from freserno_oc where vn_reserva = ma_reserv)
    
     


    
    
select * from freserva    

select * from freserno@cun_oc    


desc oasisinterface

