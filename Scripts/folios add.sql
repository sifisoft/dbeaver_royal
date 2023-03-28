



--
-- FOLIOS NOMINA
--

select co_id , co_nombre, co_cfdi_contratados, co_seq_cfdi, t.rowid
from nmCompany t
where co_id = :company
order by co_id


update nmCompany 
set co_cfdi_contratados = nvl(co_cfdi_contratados,0) + &foliosAdquiridos,
    co_seq_cfdi = nvl(co_seq_cfdi,0)
where co_id = :company

commit;

--
-- Folios Ingresos
--
select em_id, em_nombre, em_cfdi_contratados, em_seq_cfdi from inEmpresas where em_id = :empresa;

update inEmpresas 
set em_seq_cfdi = nvl(em_seq_cfdi ,0),
    em_cfdi_contratados = nvl(em_cfdi_contratados,0) + :contratados
where em_id = :empresa;    



--
--  FOLIOS CONTROL FACTURAS
--

select * from facempresas

update facEmpresas
set em_cfdi_contratados = em_cfdi_contratados + :foliosComprados
where em_empresa = 104


select count(*)
from facComprobante
where cm_empresa = 104 and cm_cancelado = '1'

R_19

R_24


delete from facConceptos where co_empresa = 104 and exists ( select * from facComprobante where cm_empresa = co_empresa and cm_cancelado = '1' and cm_folio = co_folio)

delete from facHistorico_comprobantes where his_empresa = 104 and exists ( select 1 from facComprobante where cm_empresa = his_empresa and cm_folio = his_folio and cm_cancelado = '1')

delete from facTraslados where tr_empresa = 104 and exists ( select 1 from facComprobante where cm_empresa = tr_empresa and cm_folio = tr_folio and cm_cancelado = '1')

delete from facComprobante where cm_empresa = 104 and cm_cancelado = '1'


select count(*)
from nmNomina_empleado
where ne_company = :company and ne_numero_nomina like '2016%' and ne_seq_folio = '1'
s


desc nmNominaempleado_view

PROCESSISRANUAL

getconceptovalue


getIsrAnual