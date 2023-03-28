


PROCOASRSRV;

ProcOasRsrv.procrsrv
--
--*****  Royal

select t.*, t.rowid
from rsinterface_setup t
order by ri_host;


ROYALINTERFACE_PCKG.toMares


mares_table

mares_type

mares


-- Ver errores
select t.*, t.rowid
from rstrans t
where tr_stamp > trunc(sysdate-5) and tr_error not like 'Cancun%'
order by tr_stamp desc;

select t.*, t.rowid
from rstrans t
where tr_stamp > trunc(sysdate-5) and nvl(tr_done,'N') = 'N'
order by tr_stamp desc;


-- reenvia reservas que tuvieron problemas de Oracle
update rstrans
set tr_done = null
where tr_stamp > trunc(sysdate-3) and tr_error like '%ORA-%'

-- reenvia reservas que tuvieron problemas de webservice
update rstrans
set tr_done = null
where tr_stamp > trunc(sysdate-1) and tr_error like '%No hay%'

-- Listener refused
update rstrans
set tr_done = null
where tr_stamp > trunc(sysdate-1) and tr_error like '%Listener refused%'


desc freserva@cun_oc.travamerica.com

select t.*, t.rowid from rstrans t where tr_reserv = :reserv;

select * from freserva_hoteles where rv_reserva = :reserv; 

select t.*, t.rowid
from rstrans@cun_oc.travamerica.com t
where tr_reserv = '020059008';

select count(*) from freserva@cun_oc.travamerica.com where rv_llegada >= '01-nov-20' and rv_can_u = 'NOSHOWS';

update freserva@cun_oc.travamerica.com 
set rv_llegada = rv_llegada
where rv_llegada >= '01-nov-20' and rv_can_u = 'NOSHOWS';


update freserva@cun_op.travamerica.com 
set rv_llegada = rv_llegada
where rv_llegada >= '01-nov-20' and rv_can_u = 'NOSHOWS';



select t.*, t.rowid from rstrans@cun_oc.travamerica.com t where tr_done = 'N';

select count(*) from rstrans@cun_op.travamerica.com t where tr_done = 'N';

select count(*) from rstrans@cun_smart.travamerica.com t where tr_done = 'N';





select t.*, t.ROWID from rsmaes where ma_reserv = :reserv;



desc freserva@cun_oc.travamerica.com

select * from freserva@cun_oc.travamerica.com where rv_reserva = '020059008';

--*****  Cancun
select t.*, t.rowid
from rstrans@cun_oc.travamerica.com t
where tr_stamp > trunc(sysdate-5) and tr_error not like 'Cancun%' and tr_error not like 'Trying to CXL%';

select t.*, t.rowidfrom rstrans@cun_op.travamerica.com t
where tr_stamp > trunc(sysdate-5) and tr_error not like 'Cancun%' and tr_error not like 'Trying to CXL%';

select t.*, t.rowid
from rstrans@cun_smart.travamerica.com t
where tr_stamp > trunc(sysdate-5) and tr_error not like 'Cancun%' and tr_error not like 'Trying to CXL%';

select t.*, t.rowid
from rstrans@cun_sens.travamerica.com t
where tr_stamp > trunc(sysdate-5) and tr_error not like 'Cancun%' and tr_error not like 'Trying to CXL%';



-- limpiar errores para el "No se pudo..."
update rstrans@cun_oc.travamerica.com 
set tr_done = null
where tr_stamp > trunc(sysdate-5) and tr_error not like 'Cancun%' and tr_error not like 'Trying to CXL%';

update rstrans@cun_op.travamerica.com t
set tr_done = null
where tr_stamp > trunc(sysdate-5) and tr_error not like 'Cancun%' and tr_error not like 'Trying to CXL%';

update rstrans@cun_smart.travamerica.com t
set tr_done = null
where tr_stamp > trunc(sysdate-5) and tr_error not like 'Cancun%' and tr_error not like 'Trying to CXL%';

update rstrans@sens
set tr_done = null
where tr_stamp > trunc(sysdate-1) and tr_error like 'No se pudo%'

update rstrans@tulum
set tr_done = null
where tr_stamp > trunc(sysdate-1) and tr_error like 'No se pudo%'


-- Packages 
ROYALINTERFACE_PCKG.TOMARES

mares_type

mares_table




select t.*, t.rowid from rstrans@grand t where tr_hotel = '18';

select t.*, t.rowid from rstrans@grand t where nvl(tr_done,'N') = 'N';



update rstrans@grand  set tr_done = 'E' where tr_hotel = 'DC' and nvl(tr_done,'N') ='N';

-- Hotel NULL or Invalid.. check what is the system holding... 

select t.*, t.rowid  
from rstrans@grand t
where nvl(tr_done,'N') = 'N';


select t.*, t.rowid 
from rstrans@palm t
where nvl(tr_done,'N') = 'N';

update rstrans@palm  set tr_done = 'E' where tr_hotel in ('DC','13') and nvl(tr_done,'N') ='N';

select t.*, t.rowid 
from rstrans@smart t
where nvl(tr_done,'N') = 'N';

select t.*, t.rowid 
from rstrans@sens t
where nvl(tr_done,'N') = 'N';


select t.*, t.rowid 
from rstrans@tulum t
where nvl(tr_done,'N') = 'N';


update rstrans@sens
set tr_done = 'Y' 
where tr_done = 'N' and tr_hotel = '17';





hbsi