

select * 
from cuentas
where ct_nivel = 3 and ct_cg like '437%' and substr(ct_cg,6,2) = '01';

select count(*)
from ccmaes
where cc_emp = 30 and  cc_tipo =7 and cc_saldo > 0 and substr(cc_cuenta,6,2) = '01'


select *
from ccmaes
where cc_emp = 30 and  cc_tipo =7 and cc_saldo > 0 and cc_cuenta like '437%' and substr(cc_cuenta,6,2) = '01'


select *
from ccmaes
where cc_emp = 60 and  cc_tipo =7 and cc_saldo > 0 and cc_cuenta like '437%' and substr(cc_cuenta,6,2) = '01';


select *
from ccmaes
where cc_emp in( 30,60) and  cc_tipo =1 and cc_saldo > 0
order by cc_emp,cc_plan, cc_eje, cc_per, cc_asi, cc_tipo

update ccmaes
set cc_rooming = 'AJUT 0', cc_clicod = cc_saldo, cc_saldo = 0
where cc_emp = 60 and  cc_tipo =1 and cc_saldo > 0;



-- Prepagos... 

update ccmaes
set cc_rooming = 'AJUT 0', cc_clicod = cc_saldo, cc_saldo = 0
where cc_emp = 30 and  cc_tipo =7 and cc_saldo > 0 and cc_cuenta like '437%' and substr(cc_cuenta,6,2) = '01';

update ccmaes
set cc_rooming = 'AJUT 0', cc_clicod = cc_saldo, cc_saldo = 0
where cc_emp = 60 and  cc_tipo =7 and cc_saldo > 0 and cc_cuenta like '437%' and substr(cc_cuenta,6,2) = '01';


-- Facturas ....

update ccmaes
set cc_rooming = 'AJUT 0', cc_clicod = cc_saldo, cc_saldo = 0
where cc_emp = 30 and  cc_tipo =1 and cc_saldo > 0;

update ccmaes
set cc_rooming = 'AJUT 0', cc_clicod = cc_saldo, cc_saldo = 0
where cc_emp = 60 and  cc_tipo =1 and cc_saldo > 0;






