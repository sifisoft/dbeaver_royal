
select ne_regimen_contrato
from nmNomina_empleado
where ne_company = :company and ne_numero_nomina = :numeroNomina and ne_empleado in ( 
269
);


update nmNomina_empleado
set ne_regimen_contrato = 2
where ne_company = :company and ne_numero_nomina = :numeroNomina and ne_empleado in ( 
269
);