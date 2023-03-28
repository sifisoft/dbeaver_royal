

select *
from freserva_hoteles
where   rv_can_f is not null 
    and (rv_llegada >= trunc(sysdate)-10 or rv_can_f > trunc(sysdate-10))
    and rv_can_u = 'NOSHOWS'
    
    
 
    
    
create table rscxl_noshows
tablespace hotel
storage (initial 100M next 10M pctincrease 20)
as select * from freserva_hoteles
where rownum < 1    


insert into rscxl_noshows    
select *
from freserva_hoteles
where   rv_can_f is not null 
    and (rv_llegada >= '01-jan-15' or rv_can_f >= '01-jan-15')    



delete from rscxl_noshows
where rv_llegada >= trunc(sysdate-90)

insert into rscxl_noshows
select * 
from freserva_hoteles
where rv_can_f is not null 
    and rv_llegada >= trunc(sysdate-90) 







