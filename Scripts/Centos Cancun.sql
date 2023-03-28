



refreshrsavailable_sum_trg_mex;

execute refreshRSAVAILABLE_SUM_TRG_M2('01-OCT-15','30-NOV-15');

                    
select rv_agencia, rv_origen, rv_mayorista
from freserva_hoteles
where rv_llegada > sysdate and rv_agencia like 'FIT%';


select rv_agencia, rv_origen, rv_mayorista
from freserva_hoteles
where rv_llegada > sysdate-100 and rv_agencia = 'BOOKNGDI';



select unique rv_agencia, rv_origen
from freserva_hoteles
where rv_llegada > sysdate and rv_mayorista = 'DIRDIR' 
order by rv_agencia;

desc freserva_hoteles_temp2

create table freserva_hoteles_temp2 as select * from freserva_hoteles_temp where rownum < 1;

create table rsavailable_trg2 as select * from rsavailable_trg where rownum < 1;

create table rsavailable_sum_trg2 as select * from rsavailable_sum_trg  where rownum < 1;


select * from rsavailable_sum_trg2 where av_hotel in ('13','05');


create table rsavailable_trg2015 as select * from rsavailable_trg;

create table rsavailable_sum_trg20015 as select * from rsavailable_sum_trg;


delete from rsavailable_trg where av_hotel in ('13','05')  and av_date between '01-oct-15' and '30-nov-15';

delete from rsavailable_sum_trg where av_hotel in ('13','05')  and av_date between '01-oct-15' and '30-nov-15';

insert into rsavailable_trg select * from rsavailable_trg2 where av_hotel in ('13','05') and av_date between '01-oct-15' and '30-nov-15';

insert into rsavailable_sum_trg select * from rsavailable_sum_trg2 where av_hotel in ('13','05') and av_date between '01-oct-15' and '30-nov-15';

commit;
