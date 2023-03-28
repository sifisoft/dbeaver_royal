

select *
from cuentas
where ct_emp = :emp and ct_plan = 'A' and ct_eje = 19 and ct_cg = '572010101001';


select t.*, t.rowid
from banoas t       
where bo_oa_codigo = :emp and bo_plan = 'A' and bo_eje = 19;

select t.*, t.rowid 
from bancos t
order by ba_codigo;