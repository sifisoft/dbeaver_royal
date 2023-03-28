

select * from asto
where as_emp = 83 and as_plan = 'A' and as_eje = 20 and not exists (
    select 1
    from diag
    where dg_emp = as_emp
        and dg_plan = as_plan
        and dg_eje = as_eje
        and dg_per = as_per
        and dg_asi = as_asi
)
order by as_asi;


delete from asto
where as_emp = 83 and as_plan = 'A' and as_eje = 20 and not exists (
    select 1
    from diag
    where dg_emp = as_emp
        and dg_plan = as_plan
        and dg_eje = as_eje
        and dg_per = as_per
        and dg_asi = as_asi
)
;



select * from freserva_hoteles_usd;  



select *
from diag
where dg_emp = 8 and dg_plan = 'A' and dg_eje = 20 and dg_per > 2;



select *
from ccmaes
where cc_emp = 83 and cc_plan = 'A' and cc_eje = 20 and cc_per > 2;

delete from ccmaes
where cc_emp = 83 and cc_plan  = 'A' and cc_eje = 20 and cc_per > 2;


select * from ccmaes
where cc_emp = 83 and cc_plan = 'A' and cc_eje = 20 and cc_per= 1 and cc_tipo = 1 and  
not exists (
    select 1 
    from rinvoice_dreams 
    where   in_emp = cc_emp 
        and in_eje = cc_eje  
        and in_per = cc_per 
        and in_entry = cc_asi
);

delete from ccmaes
where cc_emp = 83 and cc_plan = 'A' and cc_eje = 20 and cc_per= 1 and cc_tipo = 1 and  
not exists (
    select 1 
    from rinvoice_dreams 
    where   in_emp = cc_emp 
        and in_eje = cc_eje  
        and in_per = cc_per 
        and in_entry = cc_asi
);


select * from diag
where dg_emp = 83 and dg_plan = 'A' and dg_eje = 20 and dg_per= 1 and dg_cg like '430%' and  
not exists (
    select 1 
    from rinvoice_dreams 
    where   in_emp = dg_emp 
        and in_eje = dg_eje  
        and in_per = dg_per 
        and in_entry = dg_asi
);



select * from diag
where dg_emp = 83 and dg_plan ='A' and dg_eje = 20 and dg_per > 2;


select * 
from ccmaes
where cc_factura  = '4322' and cc_tipo = 1;

delete from rinvoice_dreams
where in_emp = 83 and in_eje = 20 and in_per = 1 and in_folio > '4288';
