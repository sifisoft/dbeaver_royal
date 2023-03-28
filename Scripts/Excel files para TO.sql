
genMLT_xls

genExpedia_xls

genTUI

genITSVx

genTRVIMP

genTRVLIMPXLS

genTransatXLS


genTOURICOXLS

genCheapCaribbean_xls

genVacationExpress_xls

genTravelBrands_xls

genPriceline_xls

genLibgoxls_trav

genLibgoxls_trav_ca

TravInvoicing_nolitour

genHotels4U_xls

genOrbitz_xls

genDestinoTV_xls

commit;

insert into cuentas
select 55, ct_plan, ct_eje, ct_cg, ct_desc, ct_sub, ct_tcg, ct_nivel, ct_otcec, ct_fecha, ct_ctady, ct_usua, ct_operator
from cuentas a 
where ct_emp = 50 and ct_plan = 'A' and ct_eje = 19 and not exists (
select 1
from cuentas b
where b.ct_emp = 55
    and b.ct_plan = a.ct_plan 
    and b.ct_eje = a.ct_eje
    and b.ct_cg = a.ct_cg
);


select *
from diag
where dg_emp = 40 and dg_plan = 'A' and dg_eje = 19 and dg_per = 3 and dg_cg is null;

