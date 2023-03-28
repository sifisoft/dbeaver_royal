
select in_inv_date, in_inv_num, in_ledger, in_period, in_empresa, in_divisa
from rinvoice
where in_divisa = 'MEX' and in_inv_num is not null and in_inv_date = trunc(sysdate)
order by in_inv_date;


update rinvoice 
set in_empresa = 55
where in_divisa = 'MEX' and in_inv_num is not null and in_inv_date = trunc(sysdate) and in_ledger is null;

commit;



select in_inv_date, in_inv_num, in_ledger, in_period, in_empresa, in_divisa
from rinvoice
where in_divisa = 'MEX'
order by in_inv_date;


select *
from rshotel;

update rshotel
set ho_adress = 'TEST SNAP'
where ho_hotel = 18;

commit;


