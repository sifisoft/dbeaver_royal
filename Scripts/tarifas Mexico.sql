


select * from fragen 
where ag_agencia = :agencia;

select * from frpromoa 
where pa_agencia = :agencia;

select * from frconmaes
where cm_agencia = :agencia 
;


select t.*, t.rowid
from rsmaes t
where ma_reserv = '120297906';

select unique ma_cont_n
from rsmaes
where ma_arrival > sysdate;


select *
from rscharter
where ch_charter = :agencia;


select * from rsconhed;