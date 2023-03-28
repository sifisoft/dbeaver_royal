



avalon_pckg


select *
from rsmaes_avalon
where ma_reserv = :confirmation;


select *
from rsmaes_avalon
where ma_reserv = :confirmation and ma_line = 17;


select * 
from entidad_avalon_crs
where entidad_avalon = :to_name
order by 2;


select t.*, t.rowid
from rsmaes t
where ma_reserv = :confirmation;

select *
from rinvoice
where in_reserv = :confirmation;