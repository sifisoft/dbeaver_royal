

  
-- saldo inicial  DIAG BALANCE debe cuadrar vs reporte Balance.
select  sum(decode(dg_dh,'D',dg_imp,0))-sum(decode(dg_dh,'H',dg_imp,0)) IniBal  
from diag
where dg_emp = '60' 
    and dg_plan = 'A' 
    and dg_eje = 12 
    and dg_per between 0 and :per-1
    and substr(dg_cg,1,1)  between 0 and 5;
        

-- saldo inicial  DIAG  RESULTADOS debe cuadrar vs reporte Balance.
select  sum(decode(dg_dh,'D',dg_imp,0))-sum(decode(dg_dh,'H',dg_imp,0)) IniBal  
from diag
where dg_emp = '60' 
    and dg_plan = 'A' 
    and dg_eje = 12 
    and dg_per between 0 and :per-1
    and substr(dg_cg,1,1)  > 5;
    
    
-- saldo actual  DIAG BALANCE debe cuadrar vs reporte Balance.
select  sum(decode(dg_dh,'D',dg_imp,0))-sum(decode(dg_dh,'H',dg_imp,0)) IniBal  
from diag
where dg_emp = '60' 
    and dg_plan = 'A' 
    and dg_eje = 12 
    and dg_per = :per
    and substr(dg_cg,1,1)  between 0 and 5;
        

-- saldo actual  DIAG  RESULTADOS debe cuadrar vs reporte Balance.
select  sum(decode(dg_dh,'D',dg_imp,0))-sum(decode(dg_dh,'H',dg_imp,0)) IniBal  
from diag
where dg_emp = '60' 
    and dg_plan = 'A' 
    and dg_eje = 12 
    and dg_per = :per
    and substr(dg_cg,1,1)  > 5;




select sum(decode(dg_dh,'D',dg_imp,0)) D_5, 
         sum(decode(dg_dh,'H',dg_imp,0)) H_5
from diag
where dg_emp = '60' 
    and dg_plan = 'A' 
    and dg_eje = 16 
    --and dg_per = 12
    and dg_cg = :cuenta






select sum(decode(dg_dh,'D',dg_imp,0)) D_5, 
         sum(decode(dg_dh,'H',dg_imp,0)) H_5
from diag
where dg_emp = '60' 
    and dg_plan = 'A' 
    and dg_eje = 12 
    and dg_per = 12
    and substr(dg_cg,1,1)  between 0 and 5;

select sum(decode(dg_dh,'D',dg_imp,0)) D_6, 
         sum(decode(dg_dh,'H',dg_imp,0)) H_6
from diag
where dg_emp = '60' 
    and dg_plan = 'A' 
    and dg_eje = 12 
    and dg_per = 5
    and substr(dg_cg,1,1)  > 5;


-- Ecuentra asientos mal balanceados.... 
-- Balance debe ser igual a resultados es decir, 
-- cuentas <= 5 sum(d-h) debe ser igual a 
-- cuentas > 5  sum(d-h) 
-- la diferencia de D-H entre balance y resultados debe de ser igual
select dg_per, dg_asi, abs(nvl(D5,0)-nvl(H5,0)) - abs(nvl(D6,0)-nvl(H6,0))
from 
(
select dg_per, dg_asi, 
        sum(case when substr(dg_cg,1,1) <= 5 and dg_dh = 'D' then dg_imp end) D5,
        sum(case when substr(dg_cg,1,1) <= 5 and dg_dh = 'H' then dg_imp end) H5,
        sum(case when substr(dg_cg,1,1) >5 and dg_dh = 'D' then dg_imp end) D6,    
        sum(case when substr(dg_cg,1,1) >5 and dg_dh = 'H' then dg_imp end) H6
from diag
where dg_emp = '60' 
    and dg_plan = 'A' 
    and dg_eje = 16
    and dg_per >= 1
    --and substr(dg_cg,1,1)  between 0 and 5
group by dg_per, dg_asi
)
where abs(nvl(D5,0)-nvl(H5,0)) <> abs(nvl(D6,0)-nvl(H6,0));




