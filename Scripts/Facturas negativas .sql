
select *
from ccmaes
where cc_emp = :emp and 
cc_factura = :factura;

select *
from ccmaes
where cc_emp = :emp and cc_tipo = '1' and cc_saldo < 0 and cc_fecmov > to_date('01-jan-20','dd-mon-yy')
order by cc_emp, cc_plan, cc_eje, cc_per, cc_asi;

update ccmaes
set cc_saldo = 0, cc_salext = 0
where cc_emp = :emp and cc_tipo = '1' and cc_saldo < 0 and cc_fecmov > to_date('01-jan-20','dd-mon-yy');


select sum(cc_importe)
from ccmaes
where cc_emp = 81 and cc_plan = 'A' and cc_eje = 22 and cc_per = 12 and cc_tipo = 1;


select unique cc_cuenta
from ccmaes
where cc_emp = 81 and cc_plan = 'A' and cc_eje = 22 and cc_per = 12 and cc_tipo = 1 and not exists (
select 1
from cuentas
where ct_emp = cc_emp
    and ct_plan = cc_plan
    and ct_eje = cc_eje
    and ct_cg = cc_cuenta
)
