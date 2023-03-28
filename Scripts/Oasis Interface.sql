
-- INTEFACE SETUP
select t.*, t.rowid from rsinterface_setup t;

insert into rsinterface_setup
select *
from rsinterfce_setup_backup
where ri_hotel in ('03','10','15')


select t.*, t.rowid from rshost_dblink  t;

royalInterface_pckg.royal_palm

interface_royal_palm


-- Reservas RSMAES que las conviertes a MARES para env�o
ROYALINTERFACE_PCKG.toMares

-- Procesa reservas que envia Cielo
ProcOasRsrv.procrsrv

ProcOasRsrv.toMares


select * from all_db_links;


update rstrans@palm set tr_done = 'E', tr_error = 'NO BOOKING NUMBER' where tr_done = 'N' and tr_reserv is null;


-- Clean RSTRANS para ser ejecutado desde la Linux.. 

select t.*, t.rowid from rstrans@palm t where nvl(tr_done,'N') = 'N'

select t.*, t.rowid from rstrans@smart t where nvl(tr_done,'N') = 'N'

select t.*, t.rowid from rstrans@sens t where nvl(tr_done,'N') = 'N'

select t.*, t.rowid from rstrans@grand t where nvl(tr_done,'N') = 'N'


select 
from rstrans@cun_os.travamerica.com t
where tr_done = 'N'
order by tr_reserv


SELECT *
FROM rstrans
WHERE tr_done = 'E' and tr_stamp > sysdate-2;

select count(*)
from rstrans
WHERE tr_done = 'E' and tr_stamp > sysdate-2;

UPDATE rstrans
SET tr_done = 'N'
WHERE tr_done = 'E' and tr_stamp > sysdate-4;

COMMIT;

-- Cancun

freserva

select count(*) from rstrans where tr_done = 'N';



select *
from rsmaes
where ma_reserv = '211098110';