

royalinterface_pckg

avalonBN_pckg

avalon_pckg

mares_avalon_type





select * from entidad_avalon_crs;


select  t.*, t.rowid from rstrans_avalon t order by tr_stamp desc;


select  t.*, t.rowid from rstrans_avalon t where tr_reserv = :booking;

select count(*) from rstrans_avalon where tr_done = 'N';


select * from rsmaes where ma_reserv = '211094546'

