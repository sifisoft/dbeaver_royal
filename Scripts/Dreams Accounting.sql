    
/*
    CONTA
    Arhivios de prueba en   c:\tmp\Dreams   o  Dropbox dentro de Travamerica            =TEXT(A1,"YYYYMMDD")
            Folio/factura es de 5 digitos y Trans es de  6 digitos
    1) Quitar los espacios en blaco de todas las columnas find/replace y/o  trim()
    2) Abrir c:\tmp\Dreams.xlsx y colocar los valores donde corresponden
    3) Importar los registros en   rinvoice_dreams
    4) Procesarlos

*/

-- Verificar las fechas.. para asegurarse que la conversion se  hizo de manera correcta.
select unique to_char(trunc(to_date(in_fecha,'YYYYMMDD'),'MONTH'),'MON-DD-YY') from rinvoice_dreams where in_entry is null;

select count(*) count, to_char(sum(nvl(in_total,0)),'999,999,999.09') from rinvoice_dreams where in_entry is null;

select unique in_emp from rinvoice_dreams where in_entry is null;



-- IMPORTANTE.
-- OJO OJO Asegurarse de la empresa que está procesando...

-- Dreams
execute travProductionDreams.generate ('81'); 

-- Noecu
execute travProductionDreams.generate ('82');

-- Sunscape
execute travProductionDreams.generate ('83');



-- REVERTIR FACTURACION
delete from diag
where exists (
    select 1
    from rinvoice_dreams
    where in_emp = 81 and in_eje = 21 and in_per = 7
        and dg_emp = in_emp
        and dg_plan = 'A' 
        and dg_eje = in_eje
        and dg_per = in_per
        and dg_asi = in_entry
);

delete from asto
where exists (
    select 1
    from rinvoice_dreams
    where in_emp = 81 and in_eje = 21 and in_per = 7
        and as_emp = in_emp
        and as_plan = 'A' 
        and as_eje = in_eje
        and as_per = in_per
        and as_asi = in_entry
);


delete from ccmaes
where exists (
    select 1
    from rinvoice_dreams
    where in_emp = 81 and in_eje = 21 and in_per = 7
        and cc_emp = in_emp
        and cc_plan = 'A' 
        and cc_eje = in_eje
        and cc_per = in_per
        and cc_asi = in_entry
);


delete from rinvoice_dreams where in_emp = 81 and in_eje = 21 and in_per = 7;




select *
from ccmaes
where cc_emp = 81 and cc_plan = 'A' and cc_eje = 21 and cc_per = 1




-- Insert into CCMAES

select * from diag
where dg_emp = '83' and dg_plan = 'A' and dg_eje = 22 and dg_per = 12;

-- valida cuentas contables.
select *
from diag
where dg_emp = :emp and dg_plan ='A' and dg_eje = 19 and not exists (
    select 1
    from cuentas
    where ct_emp = dg_emp
        and ct_plan = dg_plan
        and ct_eje = dg_eje
        and ct_cg = dg_cg
  )

select *
from ccmaes
where cc_emp = 81 and cc_plan = 'A' and cc_eje = 19 and cc_tipo = 1;




delete from rinvoice_dreams 
where in_entry is null;

select *
from rinvoice_dreams
where in_fecha like '2017%' and in_per < 10
order by in_eje, to_number(in_per), in_entry
;


select sum(dg_imp)
from diag
where dg_emp = 81 and dg_eje = 19 and dg_cg like '430%' and dg_per = 7 



select to_char(cc_fecmov,'YYYYMMDD'), 
        cc_factura,
        in_wholes,
        cc_cuenta, 
        op_name,
        cc_importe, 
        cc_eje, 
        cc_per,
        cc_asi
from ccmaes, rinvoice, rsopecharter, rsoperator
where cc_emp = 60 
    and cc_plan = 'A' 
    and cc_eje = 17 
    and cc_per < 10
    and cc_tipo = 1
    and in_ejercicio(+) = cc_eje
    and in_period(+) = cc_per
    and in_ledger(+) = cc_asi
    and oc_charter(+) = in_wholes
    and op_id(+) = oc_operator
group by 
    to_char(cc_fecmov,'YYYYMMDD'), 
        cc_factura,
        in_wholes,
        cc_cuenta, 
        op_name,
        cc_importe, 
        cc_eje, 
        cc_per,
        cc_asi
order by cc_eje, cc_per, cc_asi
;
        

select sum(cc_importe) from ccmaes where cc_emp = 60 and cc_plan ='A' and cc_eje = 17 and cc_tipo = 1;
        
        
        




delete from rinvoice_dreams
where in_entry is null;


select * from ccmaes;

select to_char(sum(in_total),'999,999,999.09')
from rinvoice_dreams
where in_entry is null;


select to_char(sum(in_total),'999,999,999.09')
from rinvoice_dreams
where in_eje = 18 and in_per = 9; 


commit;

--select '#'||in_to_desc||'#'
select *
from rinvoice_dreams
where in_eje = 16 and in_per = 12; 




select * from rinvoice_dreams
where in_per = 7 and not exists
(select 1 from cuentas
where ct_emp = 80 and ct_plan = 'A' and ct_cg = in_account)



select to_char(sum(in_total),'999,999,999.09')
from rinvoice_dreams
where in_eje = 15 and  in_per = 10










select sum(cc_importe)
from ccmaes
where cc_emp = 80 and cc_per = :per and cc_tipo = 1

select t.*, t.rowid
from diag t
where dg_emp = 80 and  dg_per = 10




select t.*, t.rowid
from diag t
where dg_emp = 80 and dg_plan = 'A' and 
not exists ( select 1 from cuentas where ct_emp = dg_emp and ct_plan = dg_plan and ct_eje = dg_eje and ct_cg = dg_cg)

select *
from ccmaes
where cc_emp = 80 and cc_plan = 'A' and 
not exists ( select 1 from cuentas where ct_emp = cc_emp and ct_plan = cc_plan and ct_eje = cc_eje and ct_cg = cc_cuenta)

select *
from diag
where dg_emp = 80 and dg_per = 12 
order by dg_per






select *
from ccmaes
where cc_emp = 80 and cc_tipo = 1 and cc_per = 9


update ccmaes
set cc_factura = trim(cc_factura)
where cc_emp = 80


select * from diag
where dg_emp = 80 and not exists 
( select 1 from asto where dg_emp = as_emp and dg_plan = as_plan and dg_eje = as_eje and dg_per = as_per and dg_asi = as_asi)


select t.*, t.rowid 
from asto t
where as_emp = 80 and as_plan = 'A' and as_eje = 14 and as_per = 5 and as_asi = 3


select *
from rinvoice_dreams

where trim(in_folio) in ('X20140908','F00000639','X20140932')



select dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_imp
from diag
where dg_emp = 80  
minus
select cc_emp, cc_plan, cc_eje, cc_per, cc_asi, cc_importe
from ccmaes
where cc_emp = 80 
 


reportBalanceStatement


select t.*, t.rowid from empresas t

oasisStatement

ledgerReport


desc accountEntries


select * from bancos


select * from cuentas
where ct_emp  = 80 and ct_cg like '572%'


select t.*, t.rowid
from diag t
where dg_emp= 80 and dg_per = 8

select t.*, t.rowid
from ccmaes t 
where cc_emp = 80 and cc_per = 12 and cc_tipo = 1

select *
from diag
where dg_emp = 80 and dg_plan = 'A' and dg_eje = 14 and dg_per = 12 and upper(dg_desc) like 'INV%'



----  ***************************************

select *
from diag
where dg_emp = 80 and dg_cg = '430130101024' 

update diag
set dg_cg = '430130301032'
where dg_emp = 80 and dg_cg = '430130101024'


--

select *
from diag
where dg_emp = 80 and dg_cg = '700130101024' 

update diag
set dg_cg = '700130301032'
where dg_emp = 80 and dg_cg = '700130101024' 



---- *************************************

select *
from ccmaes
where cc_emp = 80 and cc_cuenta = '430130101024'


update ccmaes
set cc_cuenta = '430130301032'
where cc_emp = 80 and cc_cuenta = '430130101024' 




select *
from diag
where dg_emp = 80 and dg_plan = 'A' and dg_eje = 14 and dg_per = 12 and dg_asi = 1022


select *
from ccmaes
where cc_factura = 'F00000430'


update ccmaes
set cc_cuenta = trim(cc_cuenta)
where cc_emp = 80

update diag
set dg_cg = trim(dg_cg)
where dg_emp = 80


select *
from ccmaes
where cc_emp = 80 and cc_plan = 'A' and cc_eje = 15 and cc_tipo = 7


select ccmaes.*, ct_desc AccountingClient
from ccmaes, cuentas
where cc_emp = 80 and cc_plan = 'A' and cc_eje = 15 and cc_per = 2 and cc_tipo in ('6','7')
    and ct_emp = cc_emp
    and ct_plan = cc_plan
    and ct_eje = cc_eje
    and ct_cg = cc_cuenta
order by cc_numero, cc_tipo


select in_folio
from rinvoice_dreams_temp
group by in_folio
having count(*) > 1

select t.*, t.rowid
from rinvoice_dreams_temp t
where in_folio = 'F00013134'


select *
from ccmaes
where cc_emp = 80 and cc_plan = 'A' and cc_eje = 16 and cc_per = 1 and cc_tipo = 1

update ccmaes
set cc_cuenta = ( select in_account from rinvoice_dreams_temp where in_folio = cc_factura) 
where cc_emp = 80 and cc_plan = 'A' and cc_eje = 16 and cc_per = 1 and cc_tipo = 1


select *
from diag
where dg_emp = 80 and dg_plan = 'A' and dg_eje = 16 and dg_per = 1  and dg_asi in (
    select cc_asi
    from ccmaes
    where cc_emp = dg_emp and cc_plan = dg_plan and cc_eje = dg_eje and cc_per = dg_per and cc_tipo = 1
)


update diag
set dg_cg = (
    select cc_cuenta
    from ccmaes
    where cc_emp = dg_emp and cc_plan = dg_plan and cc_eje = dg_eje and cc_per = dg_per and cc_tipo = 1 and cc_asi = dg_asi
)
where dg_emp = 80 and dg_plan = 'A' and dg_eje = 16 and dg_per = 1 and dg_dh = 'D' and dg_asi in (
    select cc_asi
    from ccmaes
    where cc_emp = dg_emp and cc_plan = dg_plan and cc_eje = dg_eje and cc_per = dg_per and cc_tipo = 1
)

update diag
set dg_cg = (
    select '700'||substr(cc_cuenta,4)
    from ccmaes
    where cc_emp = dg_emp and cc_plan = dg_plan and cc_eje = dg_eje and cc_per = dg_per and cc_tipo = 1 and cc_asi = dg_asi
)
where dg_emp = 80 and dg_plan = 'A' and dg_eje = 16 and dg_per = 1 and dg_dh = 'H' and dg_asi in (
    select cc_asi
    from ccmaes
    where cc_emp = dg_emp and cc_plan = dg_plan and cc_eje = dg_eje and cc_per = dg_per and cc_tipo = 1
)


select sum(in_total)
from rinvoice_dreams_temp;



select * 
from cuentas
where ct_emp = 60 and ct_cg = '572010101006';



update rinvoice_dreams
set in_emp = 81
where in_eje = 19 and in_per = 10;



select t.*, t.rowid from ccmaes t where cc_emp = 83 and cc_factura = '5373'