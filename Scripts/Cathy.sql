


select * 
from diag
where dg_emp = 80 and dg_plan = 'A' and dg_eje = 16 and dg_per = 1 and dg_apu = 10 and dg_asi in 
(
select cc_asi
from ccmaes
where   cc_emp = dg_emp
    and cc_plan = dg_plan
    and cc_eje = dg_eje
    and cc_per = dg_per
    and cc_asi = dg_asi
    and cc_tipo = 1
)


select *
from ccmaes
where cc_emp= 80 and cc_plan = 'A' and cc_eje = 16 and cc_per = 1 and  cc_tipo = 1

select replace(dg_cg,'437','430')


update diag
set dg_cg = replace(dg_cg,'437','430')
where dg_emp = 80 and dg_plan = 'A' and dg_eje = 16 and dg_per = 1 and dg_apu = 10  and dg_asi in (
select cc_asi
from ccmaes
where   cc_emp = dg_emp
    and cc_plan = dg_plan
    and cc_eje = dg_eje
    and cc_per = dg_per
    and cc_asi = dg_asi
    and cc_tipo = 1
)    


update ccmaes


select *
from ccmaes
where   cc_emp = 80 
    and cc_plan = 'A' 
    and cc_eje = 16
    and cc_per = 1
    and cc_tipo = 1
    
    
update ccmaes
set cc_cuenta =  replace(cc_cuenta,'437','430')
where   cc_emp = 80 
    and cc_plan = 'A' 
    and cc_eje = 16
    and cc_per = 1
    and cc_tipo = 1
