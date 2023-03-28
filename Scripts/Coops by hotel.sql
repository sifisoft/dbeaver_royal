

select * 
from rscoop_hotel;


select 
from rsoperator
where op_id = 'JETSTAI';


select *
from rshotel;


select ma_hotel, ma_reserv, ma_charter, ma_arrival, ma_depart, ma_due_tot, ma_proforma
from rsmaes
where ma_hotel = '03' and ma_reserv in (
'428826',
'428827',
'428825',
'428828'
);