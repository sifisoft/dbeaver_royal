


select *
from ccmaes
where cc_factura = :invoice;


select *
from diag
where dg_int = :invoice;


select * from rinvoice_dreams where in_folio = :invoice;


select  t.*, t.rowid
from diag  t
where dg_emp = 81 and dg_plan = 'A' and dg_eje = 20 and dg_per = 11 and dg_asi = 81681
;

select t.*, t.rowid
from asto t
where as_emp = 81 and as_plan = 'A' and as_eje = 20 and as_per = 11 and as_asi = 81680;
;


select t.*, t.rowid from ccmaes t where cc_emp = 81 and cc_factura = '73331'