

select *
from ccmaes
where cc_factura = '91247';

select *
from ccmaes a
where cc_emp = '82' and cc_tipo = 1 and cc_importe < 0 and cc_saldo < 0 and cc_eje >= 22
order by cc_factura

update ccmaes a
set cc_saldo = 0, cc_salext = 0
where cc_emp = '82' and cc_tipo = 1 and cc_importe < 0 and cc_saldo < 0 and cc_eje >= 22;
