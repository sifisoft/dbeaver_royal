
/**
prepaymenets   Diag vs CCMAES
**/
select  *
from diag
where dg_emp = 80 and dg_plan = 'A' and dg_per between 1 and 7 and dg_cg like '437010301%' and dg_dh = 'H' -- prepagos
    and not exists (
        select 1
        from ccmaes
        where cc_emp = dg_emp
            and cc_plan = dg_plan
            and cc_eje = dg_eje
            and cc_per = dg_per
            and cc_asi = dg_asi
            and cc_importe = dg_imp
)


/**
Prepayments CCMAES vs DIAG
**/
select *
from ccmaes
where cc_emp = :emp and cc_plan = 'A' and cc_tipo = 7 and  exists (
    select 1
    from diag
    where dg_emp = cc_emp
        and dg_plan = cc_plan
        and dg_eje = cc_eje
        and dg_per = cc_per
        and dg_asi = cc_asi
        and dg_imp = cc_importe
)
order by cc_emp, cc_plan, cc_eje, cc_per
