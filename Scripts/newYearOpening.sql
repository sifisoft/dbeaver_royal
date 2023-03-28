/*
Entrar en  http://conta.travamerica.com
y crear los periodos y sus dias respectivos para la empresa 60 y 80
*/

select unique cc_emp
from ccmaes
where cc_eje = 19 and cc_per = 12;



-- Una vez que creó los periodos para empresa 60, copiarlos a empresa 80.
insert into eperiod
select :company, ep_plan, ep_eje, ep_per, ep_fini, ep_ffin, ep_situ
from eperiod
where ep_emp = 50 and ep_plan = 'A' and ep_eje = 20;

select * from numeros where nm_eje = 20 order by nm_emp, nm_per;


-- Numeros
insert into numeros
select :destEmp, nm_plan, 20, nm_per, :Secuencia
from  numeros 
where nm_emp = :sourceEmpresa and nm_eje = 20
order by nm_emp, nm_plan, nm_eje, nm_per;


-- Bancos
insert into banoas
select bo_oa_codigo, bo_plan, :newEje, bo_ctacon, bo_ba_codigo, bo_cueban, bo_di_codigo, bo_nmtran, bo_nmcheq
from banoas
where bo_oa_codigo = :company and bo_plan = 'A' and bo_eje = :oldEje;




-- Cuentas contables.
insert into cuentas
select ct_emp, ct_plan, :newEje, ct_cg, ct_desc, ct_sub, ct_tcg, ct_nivel, ct_otcec, ct_fecha, ct_ctady, ct_usua, ct_operator
from cuentas
where ct_emp = :company and ct_plan = 'A' and ct_eje = :oldEje
group by ct_emp, ct_plan, :newEje, ct_cg, ct_desc, ct_sub, ct_tcg, ct_nivel, ct_otcec, ct_fecha, ct_ctady, ct_usua, ct_operator;


commit;

insert into clientes
select 55, cl_plan, cl_cliente, cl_razon, cl_direc1, cl_direc2, cl_me_codigo, cl_pa_codigo, cl_zc_codigo, cl_di_codigo, cl_cif, cl_telef, cl_fax, cl_telex, cl_conadm, cl_conven, cl_diacre,cl_limite, cl_clicod
from clientes 
where cl_emp = 50;

rollback;


select t.*, t.rowid
from oim_usr  t
where cdidenti like 'GESC%';


select t.*, t.rowid
from param t
where pd_usua like 'GES%';

select * from rshotel;

-- Update Ejercicio and Period from RSHOTEL...
update rshotel
set ho_eje = :newEje, ho_per = 1;


-- Create new users....
insert into oim_usr
select replace(cdidenti,'6017','6018'), cdclave, dsusuari, cduecono, cdperfil,otpath from oim_usr
where cdidenti like '%6017';

insert into oim_usr
select replace(cdidenti,'8017','8018'), cdclave, dsusuari, cduecono, cdperfil,otpath from oim_usr
where cdidenti like '%8017';

select * from param;

-- New year Users PARAM...
insert into param
select replace(cdidenti,'6017','6018'), '60', 'A', 18, 1, '',''
from oim_usr
where cdidenti like '%6017';

insert into param
select replace(cdidenti,'8017','8018'), '80', 'A', 18, 1, '',''
from oim_usr
where cdidenti like '%8017';


-- Give grants to the new users.....
insert into oim_func
select replace(cdidenti,'6017','6018'), cdfunci, swaltas, swbajas, swmodifi, swconsul
from oim_func
where cdidenti like '%6017%';

insert into oim_func
select replace(cdidenti,'8017','8018'), cdfunci, swaltas, swbajas, swmodifi, swconsul
from oim_func
where cdidenti like '%8017%';



-- Bancos
insert into banoas
select bo_oa_codigo, bo_plan, 18, bo_ctacon, bo_ba_codigo, bo_cueban, bo_di_codigo, bo_nmtran, bo_nmcheq
from banoas
where bo_oa_codigo = 60 and bo_plan = 'A' and bo_eje = 17;

insert into banoas
select bo_oa_codigo, bo_plan, 18, bo_ctacon, bo_ba_codigo, bo_cueban, bo_di_codigo, bo_nmtran, bo_nmcheq
from banoas
where bo_oa_codigo = 80 and bo_plan = 'A' and bo_eje = 17;



-- Copy chart of accounts......
insert into cuentas
select ct_emp, ct_plan, 18, ct_cg, ct_desc, ct_sub, ct_tcg, ct_nivel, ct_otcec, ct_fecha, ct_ctady, ct_usua, ct_operator
from cuentas
where ct_emp = '60' and ct_plan = 'A' and ct_eje = 17;

insert into cuentas
select ct_emp, ct_plan, 18, ct_cg, ct_desc, ct_sub, ct_tcg, ct_nivel, ct_otcec, ct_fecha, ct_ctady, ct_usua, ct_operator
from cuentas
where ct_emp = '80' and ct_plan = 'A' and ct_eje = 17;



/** copiar cuentas de 50 a 55 **/
insert into cuentas
select '55', ct_plan, :eje, ct_cg, ct_desc, ct_sub, ct_tcg, ct_nivel, ct_otcec, ct_fecha, ct_ctady, ct_usua, ct_operator
from cuentas a
where   a.ct_emp = '50' 
    and a.ct_plan = 'A' 
    and a.ct_eje = :eje
    and not exists ( 
            select 1 
            from cuentas b
            where   b.ct_emp = '55' 
                and b.ct_plan = a.ct_plan
                and b.ct_eje = a.ct_eje
                and b.ct_cg = a.ct_cg
            )
;






select * from cuentas where ct_emp = 60 and ct_plan = 'A' and ct_eje = 17;





-- Entries sin incorporar, para cerrar el ejercicio todo debe estar incorporado.
select *
from asto
where as_emp = :company and as_plan = 'A' and as_eje = :oldEje and as_bd = 'B'


--- EMPRESA   80

-- Create new users....
insert into oim_usr
select replace(cdidenti,'6014','8014'), cdclave, dsusuari, cduecono, cdperfil,otpath from oim_usr
where cdidenti like '%6014'

select * from param

-- New year Users PARAM...
insert into param
select replace(cdidenti,'6014','8014'), '80', 'A', 14, 1, '',''
from oim_usr
where cdidenti like '%6014'

-- Give grants to the new users.....
insert into oim_func
select replace(cdidenti,'6014','8014'), cdfunci, swaltas, swbajas, swmodifi, swconsul
from oim_func
where cdidenti like '%6014%'

insert into eperiod
select 80, ep_plan, ep_eje, ep_per, ep_fini, ep_ffin, ep_situ
from eperiod t
where ep_emp = 60 and ep_eje = 14


select * from numeros
where nm_emp = 60 and nm_eje = 15;

select *
from cuentas
where ct_emp= 80 and ct_plan = 'A' and ct_eje = 17 and ct_cg like '116%';


select *
from diag
where dg_emp = 60 and dg_plan = 'A' and dg_eje = 16 and dg_cg like '116%';

select *
from cgmlregula
where rl_emp = 60 and rl_plan = 'A' and rl_eje = 16;

select *
from diag
where dg_emp = 80 and dg_plan = 'A' and dg_eje = 16 and dg_per = 99;


-- Sin Incorporar.
select *
from asto
where as_eje = 16 and as_bd != 'D';


select *
from diag
where dg_emp = 80 and dg_plan = 'A' and dg_cg = '430010101001';

select *
from wauxcg;

delete from wauxcg;

select T.*, T.ROWID 
from cuentas T
where ct_emp= :company and ct_eje = :oldEje and ct_cg like '1160101%'