
select   
		ct_ctady,  
		ct_desc ,  
		sum(nvl(ban_d,0)-nvl(ban_h,0)) diag_DminH,  
		(  
              SELECT sum(abs(nvl(cc_saldo,0))*(-1))  
              FROM CCMAES 
              WHERE CC_EMP = :company AND  
              CC_PLAN = :plan AND  
              CC_CUENTA = ban_cg AND  
              cc_factura ='0000000'  
		) ccmaes_saldos,  
		sum(nvl(ban_d,0)-nvl(ban_h,0)) - (  
             select sum(abs(nvl(cc_saldo,0))*(-1))  
             FROM CCMAES  
             WHERE  CC_EMP = :company AND  
                    CC_PLAN = :plan AND  
                    CC_CUENTA = ban_cg AND  
                    cc_factura ='0000000'  
		) diff  
from cuentas,balancen ,clientes,ccinicon  
where ic_codigo= 'AN' and  
    ban_emp= :company and  
    ban_plan= :plan and  
    ban_eje= to_number(:year) and  
    substr(ban_cg,1,3)=ic_vali and  
    ban_emp=ic_empresa and  
    ban_plan=ic_plan and  
    ban_emp=ct_emp and  
    ban_plan=ct_plan and  
    ban_eje=ct_eje and  
    ban_cg=ct_cg and  
    ban_emp=cl_emp (+) and  
    ban_plan=cl_plan (+) and  
    ban_cg=cl_cliente(+) and  
    length(ban_cg) = :niv  
group by ban_emp, ban_plan, ban_eje, ban_cg, ct_ctady, ct_desc, cl_di_codigo  
having sum(nvl(ban_d,0)-nvl(ban_h,0)) <> 0  
order by 5 desc;



/**
prepaymenets   Diag vs CCMAES
**/
select  *
from diag
where dg_emp = 40 and dg_plan = 'A' and dg_cg like '437%' and dg_dh = 'H' -- prepagos
    and not exists (
        select 1
        from ccmaes
        where cc_emp = dg_emp
            and cc_plan = dg_plan
            and cc_eje = dg_eje
            and cc_per = dg_per
            and cc_asi = dg_asi
            and cc_importe = dg_imp
            and cc_tipo = 7
)
;

/**
Payments   Diag vs CCMAES
**/
select  *
from diag
where dg_emp = 40 and dg_plan = 'A' and dg_cg like '437%' and dg_dh = 'D' -- prepagos
    and not exists (
        select 1
        from ccmaes
        where cc_emp = dg_emp
            and cc_plan = dg_plan
            and cc_eje = dg_eje
            and cc_per = dg_per
            and cc_asi = dg_asi
            and cc_importe = dg_imp
            and cc_tipo = 6
)
;


/**
Prepayments CCMAES vs DIAG
**/
select *
from ccmaes
where cc_emp = :emp and cc_plan = 'A' and cc_tipo = 7 and  not exists (
    select 1
    from diag
    where dg_emp = cc_emp
        and dg_plan = cc_plan
        and dg_eje = cc_eje
        and dg_per = cc_per
        and dg_asi = cc_asi
        and dg_imp = cc_importe
        and dg_cg = cc_cuenta
)
order by cc_emp, cc_plan, cc_eje, cc_per;


/**
Payments CCMAES vs DIAG
**/
select *
from ccmaes
where cc_emp = :emp and cc_plan = 'A' and cc_tipo = 6 and  not exists (
    select 1
    from diag
    where dg_emp = cc_emp
        and dg_plan = cc_plan
        and dg_eje = cc_eje
        and dg_per = cc_per
        and dg_asi = cc_asi
        and dg_imp = cc_importe
        and dg_cg = cc_cuenta
)
order by cc_emp, cc_plan, cc_eje, cc_per;

/**
Cuentas de DIAG todas en Cuentas???
**/
select dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_cg, dg_imp
from diag
where dg_emp = :emp and 
(
    dg_cg is null or 
        not exists (
            select 1
            from cuentas 
            where   ct_emp = dg_emp
                and ct_plan = dg_plan
                and ct_eje = dg_eje
                and ct_cg = dg_cg
        )
);


/**
Prepayments has correct balance(saldo)
**/
select cc_numero, sum(decode(cc_tipo,7, cc_importe)) importe,  sum(decode(cc_tipo,6, cc_importe)) pagos,sum(decode(cc_tipo,7, cc_saldo)) saldo
from ccmaes
where cc_emp = :emp and cc_plan = 'A' and cc_tipo in (6,7)
group by cc_emp, cc_plan, cc_numero
having sum(decode(cc_tipo,7, cc_importe))-sum(decode(cc_tipo,6, cc_importe)) <> sum(decode(cc_tipo,7, cc_saldo)) 
;


select *
from diag
where dg_emp = 40 and dg_plan = 'A' and dg_eje = 19 and dg_per < 1;

