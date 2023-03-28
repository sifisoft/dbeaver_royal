
select  * from diag where dg_emp = :emp and dg_plan = 'A' and dg_eje = 22 and dg_cg like '700%' and dg

select dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_cg, ct_desc, dg_int, dg_fdoc, dg_imp
from diag, cuentas
where dg_emp = :emp
    and dg_plan = 'A' 
    and dg_eje = 22 
    and dg_per between 1 and 12
    and dg_cg like '700%'
    and dg_dh = 'H' 
    and ct_emp = dg_emp
    and ct_plan = dg_plan
    and ct_eje = dg_eje
    and ct_cg = dg_cg
order by dg_per, dg_asi
;


-- para empresa 50 solo USA y CAN
select dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_cg, ct_desc, dg_int, dg_fdoc, dg_imp
from diag, cuentas
where dg_emp = :emp
    and dg_plan = 'A' 
    and dg_eje = 22 
    and dg_per between 1 and 12
    and dg_dh = 'H' 
    and ct_emp = dg_emp
    and ct_plan = dg_plan
    and ct_eje = dg_eje
    and ct_cg = dg_cg
    --and dg_cg like '700%'
    and  (dg_cg like '700__01%' or dg_cg like '700__02%')
order by dg_per, dg_asi
;




select dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_cg, ct_desc, dg_int, dg_fdoc, dg_imp
from diag, cuentas
where dg_emp = 55 
    and dg_plan = 'A' 
    and dg_eje = 21 
    and dg_per between 1 and 12
    and dg_cg like '700%'
    and dg_dh = 'H' 
    and ct_emp = dg_emp
    and ct_plan = dg_plan
    and ct_eje = dg_eje
    and ct_cg = dg_cg
    and upper(ct_desc) like '%WEB%'
order by dg_per, dg_asi
;



select cc_emp, cc_plan, cc_eje, cc_per, cc_cuenta, ct_desc, cc_factura, cc_feccon, cc_tipo, cc_asi, cc_importe, cc_saldo
from ccmaes, cuentas a
where cc_emp = 40 
    and cc_plan = 'A' 
    and cc_eje = 22 
    and cc_tipo = 1 
    and a.ct_emp = cc_emp
    and a.ct_plan = cc_plan
    and a.ct_eje = cc_eje
    and a.ct_cg = cc_cuenta
    and exists (
        select b.ct_cg
        from cuentas b
        where   b.ct_emp = a.ct_emp
            and b.ct_plan = a.ct_plan
            and b.ct_eje = a.ct_eje
            and b.ct_nivel = 4 
            and b.ct_desc like '%GROUPS%'
            and a.ct_cg like b.ct_cg||'%' 
    )
order by cc_per, cc_asi
;



select *
from cuentas 
where ct_emp = '50' and ct_plan = 'A' and ct_eje = 21 and ct_nivel = 4 and ct_desc like '%GROUPS%';




select ch_hotel, ch_charter, ch_name, ch_acc_prod, ch_acc_inv
from rscharter
where upper(ch_name) like '%GROUPS ATLANTA%'

select *
from cuentas
where ct_eje = 21 and upper(ct_desc) like '%WEBBEDS%'
order by ct_emp