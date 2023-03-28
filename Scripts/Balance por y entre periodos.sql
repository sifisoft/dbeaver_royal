

select ban_emp, ban_cg,  ct_desc, sum(ban_d), sum(ban_h)
from balancen a, cuentas b
where ban_emp = 60 and ban_plan = 'A' and ban_eje = 17 and ban_per in (10, 11, 12)
    and ct_emp = ban_emp
    and ct_plan = ban_plan
    and ct_eje = ban_eje
    and ct_cg = ban_cg
group by ban_emp, ban_cg, ct_desc    
order by ban_cg    
    

select ban_emp, ban_per, ban_cg,  b.ct_desc, ban_d, ban_h
from balancen a, cuentas b
where ban_emp = 80 and ban_plan = 'A' and ban_eje = 17 and ban_per in (10, 11, 12)
    and ct_emp = ban_emp
    and ct_plan = ban_plan
    and ct_eje = ban_eje
    and ct_cg = ban_cg
order by ban_per, ban_cg, ct_nivel    
    
    
select * from cuentas     


select ban_emp, ban_cg,  ct_desc, sum(ban_d), sum(ban_h)
from balancen a, cuentas b
where ban_emp = 80 and ban_plan = 'A' and ban_eje = 17 and ban_per in (10, 11, 12)
    and ct_emp = ban_emp
    and ct_plan = ban_plan
    and ct_eje = ban_eje
    and ct_cg = ban_cg
group by ban_emp, ban_cg, ct_desc    
order by ban_cg    
    