
select *
from travusd_convertion
order by stamp_date desc;


select t.*, t.rowid
from empresas t
order by em_emp;

select 30, ho_hotel, ho_invoice
from rshotel
order by ho_hotel


select t.em_emp, t.em_nom, t.em_seq_invoice,  t.rowid
from empresas t
order by em_emp;


select t.*, t.rowid
from conta.email  t
order by em_empresa;


select t.*, t.rowid
from planes t
order by pl_emp

COMMIT;

select * 
from rsempresa_invoices
where ei_emp = '55';


select *
from numeros
where nm_eje = 19

SELECT * FROM numeros WHERE nm_eje = 19;

insert into numeros
select 55, nm_plan, nm_eje, nm_per, nm_cg
from  numeros 
WHERE nm_emp = 50 AND nm_eje = 19
order by nm_emp, nm_plan, nm_eje, nm_per;

select t.*, t.rowid from banoas t where bo_oa_codigo = :emp;



-- Bancos
insert into banoas
select 81, bo_plan, bo_eje, bo_ctacon, bo_ba_codigo, bo_cueban, bo_di_codigo, bo_nmtran, bo_nmcheq
from banoas
where bo_oa_codigo = 80 and bo_plan = 'A' and bo_eje = 19;

insert into eperiod
select 81, ep_plan, ep_eje, ep_per, ep_fini, ep_ffin, ep_situ
from eperiod
where ep_emp = 80 and ep_plan = 'A' and ep_eje = 19;

COMMIT;

select t.*, t.rowid from rsoperator t where op_name like '%DESP%';

select * from rinvoice where in_inv_num like '55%';

select * from rinvoice where in_inv_num = '5005000130';

select * from rinvoice where in_wholes like 'DESP%';



SELECT * FROM fragen;



select * from rsoperator, rsopecharter
where op_id = oc_operator
    and oc_charter = 'JTBLPSLP'
;

select * from rshotel

COMMIT;

SELECT * FROM fragen;


select closeYear.doit(70, 'A', 17, 0, 12, '116010101011', 'GESCON', '12/31/2017')
from dual


SELECT t.*, t.rowid
FROM rinvoice t 
WHERE in_inv_num = '5512000001';


SELECT t.*, t.rowid
FROM rsempresa_invoices t
WHERE ei_emp = '55';

COMMIT;


select t.*, t.rowid 
from rsmaes  t
where ma_reserv = '706102'


SELECT *
FROM fragen
WHERE ag_agencia = 'MAGNI';

SELECT * FROM rsoperator WHERE op_name LIKE 'DESPE%'

select t.*, t.rowid 
from rsmaes t where ma_reserv = '706261'
;


UPDATE RSMAES
SET MA_MAYORISTA = 'MEX'
WHERE ma_arrival >= trunc(sysdate) AND ma_can_d IS NULL AND ma_crs = 'MEX'
	AND NOT EXISTS (
		select 1
		FROM fragen
		WHERE ag_mayorista = ma_mayorista
			AND ag_agencia = ma_charter
);

select * from rinvoice where in_wholes like 'DESPE%';

COMMIT;



SELECT to_char(min(in_inv_date),'mon-dd-yyyy')
FROM rinvoice
WHERE in_wholes IN (SELECT oc_charter FROM rsoperator, rsopecharter WHERE op_id = 'EXPIDIA') AND in_empresa = 50;


SELECT * FROM rsoperator WHERE op_name LIKE 'EXP%'


INSERT INTO rscoop_hotel
select 'MLT1', ch_hotel, ch_coop_pct 
from rscoop_hotel
WHERE ch_touroperator = 'JETSTAI';

COMMIT;

SELECT t.*, t.rowid
FROM rscoop_hotel t
WHERE ch_touroperator = 'MLT1';

SELECT * FROM rshotel;


SELECT * FROM rshotel;

select *
from cuentas
where ct_emp = 80 and ct_eje = 19;

insert into cuentas
select :newEmp, ct_plan, ct_eje, ct_cg, ct_desc, ct_sub, ct_tcg, ct_nivel, ct_otcec, ct_fecha, ct_ctady, ct_usua, ct_operator
from cuentas
where ct_emp = :sourceEmp and ct_eje = 19;