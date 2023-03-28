

rsbyEmpresa_invoicing



--- Reporte de José
select dg_emp company, dg_plan plan, dg_eje year, dg_per period, dg_asi entry, dg_apu line, dg_cg account, dg_dh DH, dg_imp total, dg_desc Concepto, ct_desc Tour_Operator, dg_fdoc invoice_date, dg_doc documento, dg_int factura, dg_cgcon contrapartida
from diag, cuentas
where dg_emp = :company 
    and dg_plan ='A' 
    and dg_eje = 20 
    and dg_cg like '700%'
    and dg_cg not like '_____03%'   -- EUR 
    and dg_dh = 'H'  
    and dg_per between 1 and 12
    and ct_emp = dg_emp
    and ct_plan = dg_plan
    and ct_eje = dg_eje
    and ct_cg = dg_cg
order by dg_per, dg_asi, dg_apu;


-- EUR produccion
select dg_emp company, dg_plan plan, dg_eje year, dg_per period, dg_asi entry, dg_apu line, dg_cg account, dg_dh DH, dg_imp total, dg_desc Concepto, dg_fdoc invoice_date, dg_doc documento, dg_int factura, dg_cgcon contrapartida
from diag
where dg_emp = 50 
    and dg_plan ='A' 
    and dg_eje = 20 
    and dg_cg like '700%'
    and dg_cg like '_____03%' 
    and dg_dh = 'H'  
    and dg_per between 1 and 12
order by dg_per, dg_asi, dg_apu;




-- Reportes TARAZONA

select  dg_emp company, dg_plan plan, dg_eje year, dg_per period, dg_cg account,  ct_desc tour_operator, dg_int invoice, dg_fdoc invoice_date, dg_asi entry, dg_apu line,  dg_imp total
from diag, cuentas
where dg_emp = 50  -- La 50 sin MEX sin SUD
    and dg_plan ='A' 
    and dg_eje = 20 
    and dg_cg like '700%'
    and dg_cg not like '_____04%'    
    and dg_cg not like '_____06%'
    and dg_dh = 'H'  
    and dg_per = :per
    and ct_emp = dg_emp
    and ct_plan = dg_plan
    and ct_eje = dg_eje
    and ct_cg = dg_cg
order by dg_per, dg_asi, dg_apu;

select  dg_emp company, dg_plan plan, dg_eje year, dg_per period, dg_cg account,  ct_desc tour_operator, dg_int invoice, dg_fdoc invoice_date, dg_asi entry, dg_apu line,  dg_imp total
from diag, cuentas
where dg_emp = 83 
    and dg_plan ='A' 
    and dg_eje = 20 
    and dg_cg like '700%'
    and dg_dh = 'H'
    --and dg_cg not like '_____06%'    -- Sin MEX  la 81,82 y 83  
    and dg_per = :per
    and ct_emp = dg_emp
    and ct_plan = dg_plan
    and ct_eje = dg_eje
    and ct_cg = dg_cg
order by dg_per, dg_asi, dg_apu;


select * from ccmaes;

select cc_emp company, cc_plan plan, cc_eje year, cc_per period, cc_cuenta account,  ct_desc tour_operator, cc_factura invoice, cc_fecmov invoice_date, cc_asi entry, cc_apu line,  cc_importe total
from ccmaes, cuentas
where   cc_emp = '81' 
    and cc_plan = 'A' 
    and cc_eje = 20 
    and cc_per = :per 
    and cc_tipo = 1
    and ct_emp = cc_emp
    and ct_plan = cc_plan
    and ct_eje = cc_eje
    and ct_cg = cc_cuenta
order by cc_per, cc_asi, cc_apu;



select cc_factura, cc_importe
from ccmaes, cuentas
where   cc_emp = '83' 
    and cc_plan = 'A' 
    and cc_eje = 20 
    and cc_per = :per 
    and cc_tipo = 1
    and ct_emp = cc_emp
    and ct_plan = cc_plan
    and ct_eje = cc_eje
    and ct_cg = cc_cuenta
minus
select dg_int, dg_imp
from diag
where dg_emp = '83' 
    and dg_plan = 'A'
    and dg_eje = 20
    and dg_per = :per
    and dg_cg like '700%'
    and dg_dh = 'H'
;


select dg_int, dg_imp
from diag
where dg_emp = '83' 
    and dg_plan = 'A'
    and dg_eje = 20
    and dg_per = :per
    and dg_cg like '700%'
    and dg_dh = 'H'
minus
select cc_factura, cc_importe
from ccmaes, cuentas
where   cc_emp = '83' 
    and cc_plan = 'A' 
    and cc_eje = 20 
    and cc_per = :per 
    and cc_tipo = 1
    and ct_emp = cc_emp
    and ct_plan = cc_plan
    and ct_eje = cc_eje
    and ct_cg = cc_cuenta
;


select *
from diag
where dg_emp = '81' 
    and dg_plan = 'A'
    and dg_eje = 20
    and dg_per = :per
    and dg_cg like '700%'
    and dg_dh = 'H'
    and dg_imp = 20253.05
order by dg_asi    

    

select sum(cc_importe)
from ccmaes
where   cc_emp = '83' 
    and cc_plan = 'A' 
    and cc_eje = 20 
    and cc_per = :per 
    and cc_tipo = 1
;

select sum(dg_imp)
from diag
where dg_emp = '83' 
    and dg_plan = 'A'
    and dg_eje = 20
    and dg_per = :per
    and dg_cg like '700%'
    and dg_dh = 'H';

