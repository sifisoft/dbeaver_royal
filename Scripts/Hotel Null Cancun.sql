

ROYALINTERFACE_PCKG


ProcOasRsrv.toMares



select t.*, t.rowid from rstrans  t where nvl(tr_done,'N') = 'N'

select t.*, t.rowid from rstrans@palm  t where nvl(tr_done,'N') = 'N'

select t.*, t.rowid from rstrans@grand t  where nvl(tr_done,'N') = 'N'



select ma_hotel, ma_reserv, ma_room, ma_crs
from rsmaes
where ma_reserv = '120095679';

select * from rsroom where ro_hotel = :hotel 
order by ro_room;


select * from freserva_hoteles where rv_reserva = '011050251';

select * from rsmaes where ma_reserv = '011050251';

select * from rshotel;


select * from rsavailable_sum_trg  where av_charter_code = 'SELHOTEL';


select t.*, t.rowid from rstrans@palm t where tr_reserv = :reserv;


select * from freserva@palm where rv_reserva = :reserv;

select * from freserva_hoteles where rv_reserva = :reserv;

update freserva@palm set rv_reserva = rv_reserva where rv_reserva = :reserv;



