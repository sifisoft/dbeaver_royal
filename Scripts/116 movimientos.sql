

select * 
from diag
where dg_emp = 70 and dg_plan = 'A' and dg_eje = 17 and dg_per = 0 and dg_asi = :asi
order by dg_per, dg_asi, dg_apu 


select t.*, t.rowid 
from cuentas  t
where ct_emp = 70 and ct_eje = 17 and ct_cg = :cuenta


select t.*, t.rowid 
from diag t
where dg_emp = 70 and dg_plan = 'A' and dg_eje = 17 and (dg_cg = :cuenta or dg_cec = :cuenta)

update diag
set dg_cec = dg_cg
    , dg_cg = '116010101100'
where dg_emp = 70 and dg_plan = 'A' and dg_eje = 17 and dg_cg = :cuenta
    