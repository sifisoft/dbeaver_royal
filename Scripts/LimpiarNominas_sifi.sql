
/**
Limpiar nominas.
**/



delete from nmplazas

delete from nmEmp_concepto_periodicidad

delete from nmEmpleado_conceptos_fiscal

delete from nmEmpleado_conceptos

delete from nmNomina_errors

delete from nmNomina_empleado_fiscal

delete from  nmNomina_empleado

update nmempleados set em_tipo_nomina = null

delete from nmNomina_conceptos_fiscal

delete from nmNomina_conceptos

delete from nmCxl

delete from nmNomina

delete from nmAguinaldo_antiguedad

delete from nmVacaciones_antiguedad

delete from nmTiposNomina


 /** Update contadores **/
select t.*, t.rowid from nmCompany t



