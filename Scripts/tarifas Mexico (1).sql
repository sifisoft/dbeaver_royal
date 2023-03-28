



-- lista de agencias.

select distinct ag_mayorista, ag_agencia, ag_nombre 
from Fragen a 
where ag_mayorista not in ('USA','CAN','EUR','SUD','AME')
and exists 
( 
 select 1 
 from Frconmaes b 
 where   b.cm_mayorista = a.ag_mayorista 
 and b.cm_agencia = a.ag_agencia 
 and b.cm_activo = 'Y' 
 and b.cm_fecha_fin > sysdate 
) 
order by ag_agencia




select * from fragen 
where ag_agencia = :agencia and ag_mayorista not in ('AME','USA','CAN');

select count(*) from fragen where  ag_mayorista not in ('AME','USA','CAN');

select unique ag_mayorista from fragen ;

select * from frpromoa 
where pa_agencia = :agencia and pa_hotel = '12';

select * from frconmaes
where cm_agencia = :agencia 
;


select t.*, t.rowid
from rsmaes t
where ma_reserv = '916986';

select unique ma_cont_n
from rsmaes
where ma_arrival > sysdate;


select *
from rscharter
where ch_charter = :agencia;


select * from rsconhed;