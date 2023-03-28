


select cc_emp empresa, cc_plan plan, cc_eje year, cc_per month, cc_asi entry, cc_apu line, cc_cuenta account, cc_feccon inpDate, cc_importe total, cc_saldo balance 
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_tipo = 1 and cc_saldo > 0 and cc_saldo < 1