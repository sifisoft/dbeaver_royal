

select * from diag where dg_emp = 80 and dg_plan = 'A' and dg_eje = 18 and dg_cg = :cuenta order by dg_dh DESC;

select t.*, t.rowid from asto t where as_emp = '80' and as_plan = 'A' and as_eje = 18 and as_per = :per and as_asi = :asi;

select t.*, t.rowid  from diag t where dg_emp = '80' and dg_plan = 'A' and dg_eje = 18 and dg_per = :per and dg_asi = :asi;

select t.* ,t.rowid from diag t where dg_int = to_char(:factura) order by dg_emp, dg_plan, dg_eje, dg_per, dg_asi;


select t.*, t.rowid from diag t where dg_desc like '%MIPEGRUS%';

--
select t.*, t.rowid  from ccmaes t where cc_emp = '80' and ltrim(rtrim(cc_factura)) = to_char(:factura) order by cc_tipo;

select t.*, t.rowid from ccmaes t where cc_emp = '80' and cc_plan = 'A' and cc_eje = 18 and cc_per = :per and cc_asi = :asi;

select t.*, t.rowid from ccmaes t where cc_emp = '80' and cc_factura like '%'|| :numero ||'%'
 order by cc_eje, cc_tipo desc, cc_per, cc_asi, cc_factura;

select * 
from empresas
