



select CC_EMP, CC_PLAN, CC_EJE, CC_PER, cc_asi, cc_apu, CC_CUENTA, CC_FACTURA, CC_TIPO, CC_IMPORTE, CC_SALDO, CC_MONEDA
from ccmaes 
where cc_emp = :emp and cc_eje = :eje and cc_tipo = 1 
order by cc_emp, cc_plan, cc_eje, cc_per, cc_asi




-- Ver excel en c:\tmp\Facturacion 2013.xlsx


select sum(cc_importe)
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 13 and cc_per = 1 and cc_tipo = 1


select sum(cc_importe)
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 13 and cc_per = :per and cc_tipo = 1

select sum(in_a_total), sum(in_a_coop)
from rinvoice
where in_ejercicio = 13 and in_period = :per

select sum(dg_imp) 
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 13 and dg_per = :per and dg_cg like '700%' and dg_dh = 'H' 

select sum(nvl(dg_imp,0))
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 13 and dg_per = :per and dg_cg like '700%' and dg_dh = 'H' and dg_desc not like 'Inv%'

desc rsoperator
