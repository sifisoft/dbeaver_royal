
-- Paso 1. Apuntes sin incorporar
select *
from asto
where as_emp = :empresa and as_eje = :oldEje and as_bd = 'B';

update asto 
set as_bd = 'D'
where as_emp = :empresa and as_eje = :oldEje and as_bd = 'B';



-- Paso 2. Cerrar los periodos 1 al 12 del ejercicio "viejo"
update eperiod
set	ep_situ='C'
where	ep_emp=:empresa 
    and	ep_plan='A' and
	ep_eje=:oldEje and ep_per between 1 and 12;

	
-- Paso 3. Abre los  Periodos 13 y 99 para el ejercicio "viejo"  y abre el periodo 0 para el "nuevo"
update eperiod
set	ep_situ='A'
where	ep_emp=:empresa and
	ep_plan='A' and
		((ep_eje=:oldEje and ep_per between 13 and 99)
		or (ep_eje=:newEje and ep_per=0));
		
		


-- Paso 4. Verifica que existan todas las cuentas del Diario en el Chart of Accounts.
select dg_emp, dg_plan, dg_eje, dg_cg
from diag
where dg_emp = :empresa and dg_plan = 'A' and dg_eje = :oldEje and not exists (
    select 1
    from cuentas
    where   ct_emp = dg_emp
        and ct_plan = dg_plan
        and ct_eje = dg_eje
        and ct_cg = dg_cg
)
group by dg_emp, dg_plan, dg_eje, dg_cg;



--- Paso 5. Ejecutar Balance Recreation...  una vez que todas las cuentas est�n listas y todo incorporado.



-- Paso 6.  Verifica cuenta  116
select * 
from diag 
where   dg_emp = :empresa 
    and dg_eje = :oldEje 
    and dg_cg like '11601%';


-- Una vez hecho el Cierre. revisar


-- TODAS LAS CUENTAS BALANCEADAS, si no hay datos quiere decir que todo OK...
-- Revisarlo despues de ejecutar cierre.
select ban_cg, sum(ban_h)-sum(ban_d) 
from balancen, cuentas 
where ban_emp=:empresa and ban_plan=:pPlan and ban_eje=:pEje and ct_emp=ban_emp and ct_plan=ban_plan and ct_eje=ban_eje and ct_cg=ban_cg and ct_sub='S' 
group by ban_cg 
having  sum(ban_d) - sum(ban_h) != 0
order by 1
;


select *
from diag
where dg_emp = :empresa and dg_plan = 'A' and dg_eje = :newEje and dg_per = 0;

select *
from diag
where dg_emp = :empresa and dg_plan = 'A' and dg_eje = :oldEje and dg_per in (13,99);



select * from diag where dg_emp = :empresa and dg_plan = 'A' and dg_eje = :oldEje and dg_cg = '43018';

select * from balancen where ban_emp = :empresa and ban_plan = 'A' and ban_eje = :oldEje and ban_cg = '43018';



-- SI TODO OK SE PROCEDE AL CIERRE PERIODO 13 Y 99 DEL EJERCICIO VIEJO Y  PERIODO 0 DEL EJERCICIO NUEVO 
update eperiod
set	ep_situ='C'
where	ep_emp=:empresa and
	ep_plan='A' and
		((ep_eje=:oldEje and ep_per between 13 and 99)
		or (ep_eje=:newEje and ep_per=0));


 