

select *
from ccmaes
where cc_factura = 'F00003314'

select *
from diag
where dg_doc = 'F00003314' or dg_int = 'F00003314'


select *
from diag
where dg_emp = 80 and dg_plan = 'A' and dg_eje = 15 and dg_per = 2 and dg_asi = 1080


select * 
from reacomodo

update reacomodo
set invoice = trim(invoice),
    account430 = trim(account430),
    account700 = trim(account700)


select * 
from diag
where dg_emp = 80 and (dg_doc in (select invoice from reacomodo) or dg_int in (select invoice from reacomodo))
order by dg_emp, dg_plan, dg_eje, dg_per, dg_asi

update diag
set dg_cg = (select account700 from reacomodo where invoice = dg_doc or invoice = dg_int)
where dg_emp = 80 and (dg_doc in (select invoice from reacomodo) or dg_int in (select invoice from reacomodo)) and dg_cg like '700%'


select * 
from ccmaes
where cc_emp = 80 and cc_factura in (select invoice from reacomodo) and cc_cuenta like '430%'



update ccmaes
set cc_cuenta = ( select account430 from reacomodo where invoice = cc_factura)
where cc_emp = 80 and cc_factura in (select invoice from reacomodo) and cc_cuenta like '430%'


select * from cat




select invoice, count(*)    
from reacomodo
group by invoice
having count(*) > 1

select t.*, t.rowid
from reacomodo t 
where invoice in ('F00003685','F00003991')