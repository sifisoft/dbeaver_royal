


select unique substr(rl_cg,1,3) 
from cgmlregula where rl_emp = 40 and rl_plan = 'A' and rl_eje = 19
order by 1


select sum(decode(dg_dh,'D',dg_imp,0)) D, sum(decode(dg_dh,'H',dg_imp,0)) H 
from diag
where dg_emp = 40 and dg_plan = 'A' and dg_eje = 17 and dg_per = 99
 

select sum(decode(dg_dh,'D',dg_imp,0)) D, sum(decode(dg_dh,'H',dg_imp,0)) H 
from diag
where dg_emp = 60 and dg_plan = 'A' and dg_eje = 18 and dg_per = 0


delete from diag where dg_emp = 60 and dg_plan = 'A' and dg_eje = 18 and dg_per = 0

delete from asto where as_emp = 60 and as_plan = 'A' and as_eje = 18 and as_per = 0



select sum(ban_d), sum(ban_h) 
from balancen where ban_emp = 60 and ban_plan = 'A' and ban_eje = 17 and ban_per = 99


select t.*, t.rowid
from diag t
where dg_emp = 60 and dg_plan = 'A' and dg_eje = 17 and dg_per = 99


select * from cuentas


select * 
from cuentas a
where ct_emp = 40 and ct_plan = 'A' and a.ct_eje = 17 and not exists
(
select 1
from cuentas b
where b.ct_emp = a.ct_emp and b.ct_plan = a.ct_plan and b.ct_eje = 18 and b.ct_cg = a.ct_cg
)



select *
from cuentas
where ct_emp = 40 and ct_plan = 'A' and ct_cg = '116010101001'


select * 
from diag
where dg_emp = 60 and dg_plan = 'A' and dg_eje = 18 and dg_cg = '116010101001'