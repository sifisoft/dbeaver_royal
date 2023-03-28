
select * from rinvoice where in_inv_num = :factura

select *
from rinvoice 
where in_inv_date = '7-JAN-15' and in_ledger is not null and in_period = 12
order by in_inv_num


select *
from ccmaes
where cc_emp = 60 and cc_plan = 'A' and cc_eje = 14 and cc_factura in 
(
select unique in_inv_num
from rinvoice 
where in_inv_date = '7-JAN-15' and in_ledger is not null and in_period = 12
)
and cc_tipo = 1


select *
from diag
where dg_emp = 60 and dg_plan = 'A' and dg_eje = 14 and dg_per = 12 and dg_asi in 
(
    select cc_asi
    from ccmaes
    where cc_emp = 60 and cc_plan = 'A' and cc_eje = 14 and cc_factura in 
    (
    select unique in_inv_num
    from rinvoice 
    where in_inv_date = '7-JAN-15' and in_ledger is not null and in_period = 12
    )
    and cc_tipo = 1
)


delete from asto
where as_emp = 60 and as_plan = 'A' and as_eje = 14 and as_per = 12 and as_asi in
(
    select cc_asi
    from ccmaes
    where cc_emp = 60 and cc_plan = 'A' and cc_eje = 14 and cc_factura in 
    (
    select unique in_inv_num
    from rinvoice 
    where in_inv_date = '7-JAN-15' and in_ledger is not null and in_period = 12
    )
    and cc_tipo = 1
) 


delete from diag
where dg_emp = 60 and dg_plan = 'A' and dg_eje = 14 and dg_per = 12 and dg_asi in
(
    select cc_asi
    from ccmaes
    where cc_emp = 60 and cc_plan = 'A' and cc_eje = 14 and cc_factura in 
    (
    select unique in_inv_num
    from rinvoice 
    where in_inv_date = '7-JAN-15' and in_ledger is not null and in_period = 12
    )
    and cc_tipo = 1
) 

delete from ccmaes
where cc_emp= 60 and cc_plan = 'A' and cc_eje = 14 and cc_per = 12 and cc_tipo = 1 and  cc_factura in 
(
    select unique in_inv_num
    from rinvoice 
    where in_inv_date = '7-JAN-15' and in_ledger is not null and in_period = 12
)

update rinvoice
set in_ledger = null , in_period = null, in_ejercicio = null
where in_inv_date = '7-JAN-15' and in_ledger is not null and in_period = 12