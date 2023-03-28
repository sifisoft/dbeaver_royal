

select t.*, t.rowid
from mares t
where mr_llegada > '01-dec-12' and mr_mayorista = 'MEX'



select t.*, t.rowid from rsmanames t where mn_reserv = :reserv

select t.*, t.rowid from mares t where mr_reserva = :reserv

select t.*, t.rowid from rsmaes t where ma_reserv = :reserv

select * from rsmaesmo where mm_reserv = :reserv

select t.*, t.rowid from rstrans t where tr_reserv = :reserv


execute processMAREStoRSMAES.doit;

desc processMAREStoRSMAES



select *
from rstrans

where tr_done = 'N'


insert into oo
select a.*
from rsmaes a, a1 b
where a.ma_hotel = b.ma_hotel  and a.ma_reserv = b.ma_reserv 
order by a.ma_hotel, b.ma_reserv

delete from rstrans
    
    
update rstrans
set tr_done = 'N'
where tr_done = 'X'    
    
    
     
    select * from rsoperator
    
desc tainterface03

desc mares

grant all on rstrans to public

create public synonym rstrans for rstrans