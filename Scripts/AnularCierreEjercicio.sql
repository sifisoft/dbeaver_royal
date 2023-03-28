
-- Proceso para anular el cierre de ejercicio
-- Se esta anulando cierre de ejercicio 2012  
-- Este query se corrio el 15-jan-13  

update cuentas
set	ct_sub='S'
where	ct_emp= :empresa and
  ct_plan='A' and
  (ct_eje=:oldEje or ct_eje=:newEje) and
  ct_nivel=5 and
  ct_sub='N';


update cuentas
set    ct_sub='N'
where    ct_emp=:empresa and
    ct_plan='A' and
    (ct_eje=:oldEje or ct_eje=:newEje) and
    ct_nivel < 5 and
    ct_sub='S';

commit;


-- Una vez hecho el cierre verificar balances. 
select sum(decode(dg_dh,'H',dg_imp,0)) h, sum(decode(dg_dh,'D',dg_imp,0)) D 
from diag t
where dg_emp = :company and dg_plan = 'A' and dg_eje = :oldEje and dg_per = 0
;

select * from diag where dg_emp = :company and dg_eje = :oldEje and dg_cg like '11601%';

-- Cuenta 116 en chart of accounts?????
select t.*, t.rowid 
from cuentas t
where ct_emp = :company and ct_eje = :eje and ct_cg like '1160101%';

-- Apuntes sin incorporar
select *
from asto
where as_emp = :empresa and as_eje = :oldEje and as_bd = 'B';

update asto 
set as_bd = 'D'
where as_emp = :empresa and as_eje = :oldEje and as_bd = 'B';


commit;


-- Revisar que todas las cuentas en el diario estén en el chartOfAccounts, reportar a Tarazona en caso que exista alguna cuenta
select t.*, t.rowid
from diag t
where dg_emp = :company and dg_plan = 'A' and dg_eje = :eje and dg_cg in (
    select dg_cg
    from diag
    where dg_emp = :company and dg_plan = 'A' and dg_eje = :eje
    minus 
    select ct_cg
    from cuentas
    where ct_emp = :company and ct_plan = 'A' and ct_eje = :eje and ct_nivel = 5
);

select * from diag where dg_emp = :company and dg_eje = :newEje and dg_per = 0

select * from cuentas where ct_emp = 40 and ct_plan = 'A' and ct_eje = 20 and ct_cg = '7001403'

-- Cuenta contable nula
select * from diag where dg_emp = :company and dg_plan = 'A' and dg_eje = :oldEje and dg_cg is null;

select * from diag where dg_emp = :company and dg_plan = 'A' and dg_eje = :oldEje and dg_cg = '7001403';

select * from cuentas where ct_emp = :company and ct_eje = :oldEje and ct_cg = :cuenta;

select * from rscharter where ch_charter = :charter;


-- TODAS LAS CUENTAS BALANCEADAS, si no hay datos quiere decir que todo OK...
-- Revisarlo despues de ejecutar cierre.
select ban_cg, sum(ban_h)-sum(ban_d) 
from balancen, cuentas 
where ban_emp=:pEmp and ban_plan=:pPlan and ban_eje=:pEje and ct_emp=ban_emp and ct_plan=ban_plan and ct_eje=ban_eje and ct_cg=ban_cg and ct_sub='S' 
group by ban_cg 
having  sum(ban_d) - sum(ban_h) != 0
order by 1
;



delete asto
where
	as_emp= :empresa and
	as_plan='A'	and
		((as_eje=:oldEje and as_per between 13 and 99)
		or (as_eje=:newEje  and as_per=0));



delete diag
where
	dg_emp=:empresa and
	dg_plan='A'	and
		((dg_eje=:oldEje and dg_per between 13 and 99)
		or (dg_eje=:newEje and dg_per=0));


delete balancen
where
	ban_emp=:empresa and
	ban_plan='A'	and
		((ban_eje=:oldEje and ban_per between 13 and 99)
		or  (ban_eje=:newEje and ban_per=0));


delete cgmlregula
where
	rl_emp=:empresa and
	rl_plan='A' and
	rl_eje=:oldEje;



update eperiod
set	ep_situ='A'
where	ep_emp=:empresa and
	ep_plan='A' and
		((ep_eje=:oldEje and ep_per between 13 and 99)
		or (ep_eje=:newEje and ep_per=0));

commit;		
		
















commit;

--<><><>   EJERCICIOS DEL USUARIO
select T.*, T.ROWID 
from param T
where pd_usua = 'GESCON'
order by pd_usua;

select t.*, t.rowid
from oim_usr t;


select *
from diag
where dg_emp = :emp and dg_plan = 'A' and dg_eje = :eje and dg_per  = 0;

select *
from wauxcg

select * 
from cuentas 
where ct_emp = '60' 
    and ct_plan = 'A' 
    and ct_eje = 13 
    and ct_cg like '116%'
-- 116010101011
;

-- Entries sin incorporar.
select *
from asto
where as_emp = 60 and as_plan = 'A' and as_eje = 13 and as_bd = 'B'
;


select *
from diag
where dg_emp = :company and dg_plan = 'A' and dg_eje = :eje and dg_per = :per



select unique dg_cg, ct_desc
from diag, cuentas
where dg_emp = 70 and dg_plan = 'A' and dg_eje = 17 
    and ct_emp = dg_emp
    and ct_plan = dg_plan 
    and ct_eje = dg_eje 
    and ct_cg = dg_cg
order by dg_cg


select * from cuentas

select * from balancen


select *
from cuentas
where ct_emp = 80 and ct_plan = 'A' and ct_eje = 17 and ct_cg like '116%'


select unique as_bd, count(*)
from asto
where as_emp = 80 and as_eje = 15
group by as_bd

select *
from asto
where as_emp = 80 and as_eje = 15 and as_bd = 'B'

select *
from diag
where dg_emp = 80 and dg_plan = 'A' and dg_eje = 15 and dg_per = 99



select *
from cuentas
where ct_emp = 80 and ct_plan = 'A' and ct_eje = 15 and (ct_cg like '6%' or ct_cg like '7%')  and ct_nivel = 5


select t.*, t.rowid
from cuentas t
where ct_emp = 80 and ct_plan = 'A' and ct_eje = 15 and ct_sub = 'S' and ct_nivel < 5


select *
from cgmlregula
where rl_emp = 80 and rl_plan = 'A' and rl_eje = 15

select *
from cgmcregula
where rc_emp = 80 and rc_plan = 'A' and rc_eje = 15


select * 
from diag 
where dg_emp = 80 and dg_plan = 'A' and dg_eje = 15 and dg_per = 13

select to_char(sum(decode(dg_dh, 'H',dg_imp,0)) - sum(decode(dg_dh,'D', dg_imp,0)),'999,999,999,999.09')
from diag
where dg_emp = 80 and dg_plan = 'A' and dg_eje = 15 and dg_per = 13 and dg_cg not like '116%'



select ban_cg, sum(ban_d), sum(ban_h)
from balancen, cuentas
where   ban_emp  = 80 
    and ban_plan = 'A' 
    and ban_eje = 15 
    and ban_per = :per 
    and ct_emp = ban_emp
    and ct_cg = ban_cg
    and ct_sub = 'S' 
group by ban_cg

select sum(ban_d) - sum(ban_h)
from balancen, cuentas
where   ban_emp  = 60 
    and ban_plan = 'A' 
    and ban_eje = 15 
    and ban_per = :per 
    and ct_emp = ban_emp
    and ct_cg = ban_cg
    and ct_sub = 'S' 

select sum(decode(dg_dh,'H', dg_imp,0)) - sum(decode(dg_dh, 'D', dg_imp, 0))
from diag
where dg_emp = 80
    and dg_plan = 'A' 
    and dg_eje = 15
    and dg_per = 13
;

select dg_cg, dg_dh, dg_imp from diag where dg_emp = 60 and dg_plan = 'A' and dg_eje = 18 and dg_per = 0
minus
select dg_cg, dg_dh, dg_imp from diagCierre2017backup where dg_emp = 60 and dg_plan ='A' and dg_eje = 18 and dg_per = 0;


select *
from diagCierre2017Backup
where dg_cg = '572010101001' and dg_per = 0;

select *
from diag
where dg_emp = 60 and dg_plan ='A' and dg_eje = 18 and dg_per = 0 and dg_cg = '572010101001';


select dg_emp, dg_plan, dg_eje, dg_per, dg_asi
from diag
where dg_emp = 80 and dg_plan = 'A' and dg_eje = 15 and dg_per between 1 and 12
group by dg_emp, dg_plan, dg_eje, dg_per, dg_asi
having sum(decode(dg_dh,'H', dg_imp,0)) - sum(decode(dg_dh, 'D', dg_imp, 0)) <> 0


select  sum(decode(dg_dh,'H', dg_imp,0)) - sum(decode(dg_dh, 'D', dg_imp, 0))
from diag
where dg_emp = 80 and dg_plan = 'A' and dg_eje = 15 and dg_per between 0 and 13


select sum(ban_h)- sum(ban_d)
from balancen
where   ban_emp  = :empresa 
    and ban_plan = 'A' 
    and ban_eje = :eje 
    and ban_per between 0 and 99 
    and length(ban_cg) > 9 


select sum(ban_h)- sum(ban_d)
from balancen, cuentas
where   ban_emp  = 80 
    and ban_plan = 'A' 
    and ban_eje = 15 
    and ban_per between 0 and 99 
    and ct_emp = ban_emp 
    and ct_plan = ban_plan
    and ct_eje = ban_eje
    and ct_sub = 'S' ;



select *
from cuentas
where ct_emp = :company and ct_eje = :eje and ct_cg = :cuenta;





-- Revisar apuntes en diario con cuentas que no existen en CUENTAS. 
select *
from diag
where dg_emp = :company and dg_plan = 'A' and dg_eje = :eje and dg_cg in (
    select dg_cg
    from diag
    where dg_emp = :company and dg_plan = 'A' and dg_eje = :eje
    minus 
    select ct_cg
    from cuentas
    where ct_emp = :company and ct_plan = 'A' and ct_eje = :eje and ct_nivel = 5
);

select * from diag where dg_emp = :company and dg_plan = 'A' and dg_eje = 16 and dg_per = 1 and dg_asi = 1200;

select unique dg_cg
from diag
where dg_emp = 80 and dg_plan = 'A' and dg_eje = 15 and not exists ( select 1 from cuentas where ct_emp = dg_emp and ct_plan = dg_plan and ct_eje = dg_eje and ct_cg = dg_cg)

select unique dg_cg
from diag
where dg_emp = 60 and dg_plan = 'A' and dg_eje = 15 and not exists ( select 1 from cuentas where ct_emp = dg_emp and ct_plan = dg_plan and ct_eje = dg_eje and ct_cg = dg_cg);



select *
from diag 
where dg_emp = 80 and dg_plan = 'A' and dg_eje = 17 and dg_per = 0;


select t.*, t.rowid
from diag t
where dg_emp = :company and dg_eje = :oldEje and dg_cg in  ('700700101027','430430101027')

select t.*, t.rowid 
from ccmaes t
where cc_emp = :company and cc_eje = :eje and cc_per = :per and cc_asi in (1174,1190,300,337,853);



select * from closingYearlog;

-- Ejecutar Cierre.
declare
errorMsg varchar2(1024);
begin
    closeYear.doit(70, 'A', 17, 0, 12, '116010101011', 'GESCON', '12/31/2017', errorMsg);
    dbms_output.put_line(errorMsg);
end;


select *
from freserva_hoteles
where rv_agencia = 'RBPHAIMX'


 
