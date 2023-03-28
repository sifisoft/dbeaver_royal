
select * 
from nmMetaCampos
where mc_company = 1 and mc_tabla = 61 and mc_campo = 'DTA'


insert into nmMetaCampos
values (:company, 61, 'DTSF','getDTSF(em_company,em_id,pFinal)',null,null) 


update nmConceptos_cat
set cp_formula_plsql = replace(cp_formula_plsql, '*A001','*getConstantValue(em_company, ''A001'')')  
where cp_formula_plsql like '%*A001%'



select *  
from nmempleado_conceptos
where ec_formula_plsql like '%*A002%'

update nmEmpleado_conceptos
set ec_formula_plsql = replace(ec_formula_plsql, '*A005','*getConstantValue(em_company, ''A005'')')  
where ec_formula_plsql like '%*A005%'


select t.*, t.rowid
from nmMetaCampos t
where mc_company = 113 and mc_tabla = 52





select *
from nmEmpleado_conceptos
where ec_company = 109 and ec_concepto = 'P053'

select *
from nmConceptos_cat 
where cp_company = 109




getConstantValue(em_company, 'A002')


select t.*, t.rowid
from nmCompany t
where co_id = 115

select em_company, em_id, nvl(ne_nombre,em_nombre), nvl(ne_apellido_paterno, nvl(em_apellido_paterno,' ')), nvl(ne_apellido_materno,nvl(em_apellido_materno,' ')), nvl(ne_rfc,em_rfc), nvl(ne_imss,nvl(em_imss,' ')), nvl(ne_curp,em_curp) , getdep(em_company, em_id) , getPlaNom(em_company, em_id, 'F') , getfa(em_company, em_id, '01/12/2014', '15/12/2014') , getDT(em_company, em_tipo_nomina, em_id, '01/12/2014', '15/12/2014'), ne_tipo_nomina , getAT(em_company, em_id, '01/12/2014', '15/12/2014') from nmEmpleados, nmNomina_Empleado, nmMetaCampos, nmDepartamentos  where em_company = 100    and em_company = ne_company    and em_id = ne_empleado    and mc_company = ne_company    and mc_tabla = 68    and mc_campo = ne_puesto    and de_company = ne_company     and de_departamento_id = ne_departamento_id    and em_tipo_nomina in ('C','D','EV','P','S','SE')   and em_tipo_nomina = ne_tipo_nomina    and ne_numero_nomina = '201423'  order by de_orden_imp, ne_departamento_id, 2




select * from ebb_load