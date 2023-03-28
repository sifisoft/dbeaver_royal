
select t.*, t.rowid from rsoperator t where inv_email like '%'||:email||'%';


----- ASTO
select t.*, t.rowid from asto t where as_emp = :emp and as_plan = 'A' and as_eje = :eje and as_per = :per and as_asi = :asi;

---- DIAG
select t.*, t.rowid  from diag t where dg_emp = :emp and dg_plan = 'A' and dg_eje= :eje and dg_per = :per and dg_asi = :asi order by dg_apu, dg_dh;

select t.* ,t.rowid from diag t where dg_int = to_char(:factura) order by dg_emp, dg_plan, dg_eje, dg_per, dg_asi;

select * from diag where dg_emp = :emp AND dg_plan = :plan AND dg_eje = :eje AND dg_cg = :cuenta ORDER BY dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_apu;

select t.*, t.rowid from diag t where dg_desc like '%MIPEGRUS%';

SELECT * FROM diag WHERE dg_emp = :emp AND dg_plan = :plan AND dg_eje = :eje AND dg_per = :per AND dg_cg IS NULL; 

select unique dg_int from diag where dg_emp = :emp and dg_plan = 'A' and dg_eje= :eje and dg_per = :per and dg_asi = :asi order by 1;

-- Actualiza saldo a cero de facturas con saldo negativo..
   
select * from ccmaes where cc_emp = 83 and   cc_eje = 21 and cc_tipo = 1 and  cc_saldo < 0;

update ccmaes set cc_saldo = 0, cc_salext = 0 where cc_emp = 83 and   cc_eje = 21 and cc_tipo = 1 and  cc_saldo < 0;

---- CCMAES 
select t.*, t.rowid from ccmaes t where cc_emp = :emp and cc_plan = 'A' and cc_eje =  :eje and cc_per = :per and cc_asi = :asi;

select t.*, t.rowid  from ccmaes t where ltrim(rtrim(cc_factura)) = to_char(:factura) order by cc_emp, cc_tipo;

select t.*, t.rowid from ccmaes t where  cc_numero = :numero order by cc_emp, cc_eje desc, cc_tipo  desc, cc_per, cc_asi, cc_factura;

select t.*, t.rowid from ccmaes t where cc_numero = :numero  and cc_emp = :empresa order by cc_emp, cc_eje, cc_tipo  desc, cc_per, cc_asi, cc_factura;

select t.*, t.rowid from ccmaes t where cc_emp = :emp and cc_tipo = 7 and cc_saldo > 0 

--- RINVOICE
select t.*, t.rowid from rinvoice t where in_ejercicio = :eje and in_empresa = :emp AND in_period = :per and in_ledger = :asi;

select in_empresa, t.*, t.rowid  from rinvoice t where in_inv_num = to_char(:factura); 

select sum(in_a_total) from rinvoice t where in_inv_num = to_char(:factura);

select in_hotel, in_wholes, in_ledger, in_period, in_inv_num  from rinvoice where in_inv_num = :factura;

select t.*, t.rowid from rinvoice t where in_reserv = :reserv;

select t.*, t.rowid from rinvoice, rscharter t where in_inv_num = :invoice AND ch_hotel = in_hotel AND ch_charter = in_wholes;

select t.*, t.rowid from rinvoice t where in_reserv = :reserv;


select t.*, t.rowid from rsmaes t where ma_reserv = :reserv;

select t.*, t.rowid from rscharter t where  ch_charter = :charter;

select t.*, t.rowid from rsmaes t where ma_reserv = :reserv;

select rsoperator.* from rsoperator, rsopecharter where op_id = oc_operator and oc_charter = :charter;

select a.*, a.rowid from cuentas a where ct_cg = :cta and ct_emp = 50;


delete from asto
where as_emp = :emp 
and not exists (
    select 1
    from diag
    where   dg_emp = as_emp
        and dg_plan = as_plan
        and dg_eje = as_eje
        and dg_per = as_per
        and dg_asi = as_asi
)





select in_divisa, in_inv_num, in_empresa from rinvoice where in_inv_num in (
'5005002279','5009004771','5012004888','5012004889','5012004890','5013002253','5009004812','5013002273','5013002274','5012004938','5012004939','5013002281','5005002307'
);

select  *
from ccmaes
where cc_factura in (
'5005002279','5009004771','5012004888','5012004889','5012004890','5013002253','5009004812','5013002273','5013002274','5012004938','5012004939','5013002281','5005002307'
)




update rinvoice set in_empresa = 55 where in_inv_num in (
'5005002279','5009004771','5012004888','5012004889','5012004890','5013002253','5009004812','5013002273','5013002274','5012004938','5012004939','5013002281','5005002307'
) and in_divisa = 'MEX';


COMMIT;


/**
Copiar cuentas faltantes de la 82 a la 83.
**/
insert into cuentas
select 83, ct_plan, ct_eje,  
    case 
        when substr(ct_cg,4,2) = '82' then
            substr(ct_cg,1,3)||'83'||substr(ct_cg,6)
        else 
            ct_cg
        end ct_cg,
    ct_desc, ct_sub, ct_tcg, ct_nivel, ct_otcec, ct_fecha, ct_ctady, ct_usua, ct_operator
from cuentas a
where   ct_emp = 82  
    and ct_plan ='A' 
    and ct_eje = 19 
    and not exists (
        select 1
        from cuentas b
        where   b.ct_emp = 83 
            and b.ct_plan = a.ct_plan 
            and b.ct_eje = a.ct_eje 
            and b.ct_cg = (
                        case 
                        when substr(a.ct_cg,4,2) = '82' then
                            substr(a.ct_cg,1,3)||'83'||substr(a.ct_cg,6)
                        else 
                            a.ct_cg
                        end
                    ) 
);


insert into cuentas
select ct_emp, ct_plan, 18, ct_cg, ct_desc, ct_sub, ct_tcg, ct_nivel, ct_otcec, ct_fecha, ct_ctady, ct_usua, ct_operator
from cuentas a
where ct_emp = 40  and ct_plan ='A' and ct_eje = 19 and not exists (
    select 1
    from cuentas b
    where b.ct_emp = a.ct_emp and b.ct_plan = a.ct_plan and b.ct_eje = 18 and b.ct_cg = a.ct_cg 
);



-- 

select *
from cuentas 
where ct_emp = 83 and ct_plan = 'A' and ct_eje = 19 and ct_cg like '43783%';




-- Verificar Balance.

select ban_cg, sum(ban_h)-sum(ban_d) 
from    balancen, cuentas 
where   ban_emp=:pEmp 
    and ban_plan=:pPlan 
    and ban_eje=:pEje
    --and ban_per between 0 and 12 
    and ct_emp=ban_emp 
    and ct_plan=ban_plan 
    and ct_eje=ban_eje 
    and ct_cg=ban_cg 
    and ct_sub='S' 
    and ct_cg = :cuenta
group by ban_cg having  sum(ban_d) - sum(ban_h) != 0;




SELECT t.*, t.rowid 
FROM rshotel t


select * from diag where dg_emp = 60 and dg_plan = 'A' and dg_eje = 17  and dg_cg = '437010101113';

select * from diag where dg_emp = 60 and dg_plan = 'A' and dg_eje = 18 and dg_per = 0 and dg_cg like '437010401001'


select * from diag where dg_emp = 70 and dg_plan = 'A' and dg_eje = 17 and dg_per = 99 and dg_cg = '437010401008'

select * from diag where dg_emp = 70 and dg_plan = 'A' and dg_eje = 18 and dg_per = 0 and dg_cg like '437010401008'



SELECT t.*, t.rowid FROM email t;

COMMIT;


select *
from diag
where   dg_emp = :empresa
    and dg_plan = :plan
    and dg_eje = :eje
    and dg_per between 1 and 12
    and dg_cg = :cuenta
order by dg_dh desc


select *
from ccmaes
where cc_tipo = 8


SELECT * FROM rshotel;


select *
from diag
where dg_emp = 60 and dg_plan = 'A' and  dg_eje >= 15 and dg_cg = :cuenta
order by dg_per, dg_asi






select * from cuentas where ct_emp = :company and ct_eje = :oldEje and ct_cg = :cuenta

select * from 


delete from diag 
where dg_emp = 70 and dg_plan = 'A' and dg_eje = 18 and dg_per = 0 and dg_cg in (
'430010401096',
'430010401168',
'430010401232',
'430010401242',
'430010401270',
'430010401302',
'430010401304',
'430020401014',
'430020401035',
'430020401057',
'430020401096',
'430020401174',
'430020401189',
'430020401196',
'430020401204',
'430020401213',
'430020401215',
'430020401232',
'430020401265',
'430020401270',
'430020401287',
'430040401005',
'430040401021',
'430040401090',
'430040401139',
'430040401197',
'430040401213',
'437010401165',
'437010401226',
'437010401268',
'437010401297',
'437010401302',
'437010401304'
)


















--

select *
from ccmaes
where cc_emp = 80 and cc_plan = 'A' and cc_eje = 14 and cc_per = 10 and cc_cuenta = '572010101001'


select t.*, t.rowid  from diag t where dg_emp = '80' and dg_plan = 'A' and dg_eje = 15 and dg_per = :per and dg_asi = :asi      --and dg_apu = :apu




select * from ccmaes where cc_emp = 60 and cc_plan = 'A' and cc_saldo < 0


update rinvoice
set in_a_paid = null
where in_inv_num in 
(
'2029574',
'2029607',
'2029630',
'2029575',
'2029608',
'2029631',
'2029576',
'2029610',
'2029632',
'2029577',
'2029611',
'2029633',
'2029578',
'2029612',
'2029634',
'2029588',
'2029613',
'2029635',
'2029589',
'2029614',
'2029636',
'2029590',
'2029618',
'2029637',
'2029591',
'2029619',
'2029638',
'2029592',
'2029620',
'2029639',
'2029593',
'2029621',
'2029641',
'2029594',
'2029622',
'2029642',
'2029595',
'2029623',
'2029645',
'2029596',
'2029625',
'2029646',
'2029597',
'2029626',
'2030102',
'2029598',
'2029627',
'2030103',
'2029599',
'2029629'
)


select t.* ,t.rowid from diag t where dg_doc = :numero  and dg_dh = 'H' order by dg_emp, dg_plan, dg_eje, dg_per, dg_asi

select t.* ,t.rowid from diag t where dg_desc like '%'|| :numero || '%'   order by dg_emp, dg_plan, dg_eje, dg_per, dg_asi

select t.* ,t.rowid from diag t where dg_eje >= 13 and (dg_desc like '%RECLASI%'  or dg_desc like '%REC%')  order by dg_emp, dg_plan, dg_eje, dg_per, dg_asi


select t.*, t.rowid from diag t where dg_imp = :importe

select t.* ,t.rowid from numeros t where nm_emp = '60'  and nm_plan = 'A' and nm_eje = 14

select t.*, t.rowid from rinvoice t  where in_reserv = :reserv

select t.*, t.rowid from rscharter t where ch_charter = :charter

select t.*, t.rowid from rsopecharter  t where oc_charter = :charter

select * from rsoperator where op_id LIKE 'COPA%'

select * from cuentas where ct_emp = '60' and ct_plan = 'A' and ct_eje = 14 and ct_nivel = 2 --and ct_cg = :cta 

select * from ccmaes where cc_emp = '60' and cc_plan = 'A' and cc_eje = 14 and cc_tipo = 8

select * from clientes where cl_cliente = :cuenta

select * from rshotel


/**
Quitar facturas contabilizadas en otros periodos del DIAG
**/

select * 
from diag
where dg_emp= '60' and dg_plan = 'A' and dg_eje = 14 and dg_per = 3 and
dg_asi in (
select in_ledger 
from rinvoice 
where in_inv_date = '3-apr-2014' and in_inv_num <> '0000000' 
)
order by dg_asi


delete from diag
where dg_emp= '60' and dg_plan = 'A' and dg_eje = 14 and dg_per = 3 and
dg_asi in (
select in_ledger 
from rinvoice 
where in_inv_date = '3-apr-2014' and in_inv_num <> '0000000' 
)

delete from asto
where as_emp = '60' and as_plan = 'A' and as_eje = 14 and as_per = 3 and
as_asi in (
select in_ledger 
from rinvoice 
where in_inv_date = '3-apr-2014' and in_inv_num <> '0000000' 
)


/**
De CCMAES
**/
select *
from ccmaes 
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 14 and cc_per = 3 and
cc_asi in (
select in_ledger 
from rinvoice 
where in_inv_date = '3-apr-2014' and in_inv_num <> '0000000' 
)
order by cc_asi


delete from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 14 and cc_per = 3 and 
cc_asi in (
    select in_ledger 
    from rinvoice 
    where in_inv_date = '3-apr-2014' and in_inv_num <> '0000000' 
)


select * 
from rinvoice 
where in_inv_date = '3-apr-2014' and in_inv_num <> '0000000'
order by in_inv_num


update rinvoice 
set in_ejercicio = null,
    in_ledger = null,
    in_period = null
where in_inv_date = '3-apr-2014' and in_inv_num <> '0000000'
    


select t.*, t.rowid
from ccmaes  t
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 14 and cc_factura in (
'1023865',
'1023863',
'1023871',
'2020875',
'2020869',
'4010368',
'1206651',
'1206646'
)
order by cc_factura, cc_tipo




drop view a1


select * from ccmaes where cc_emp = '01'

create view a1 as 
select in_ejercicio, in_period, in_ledger
from rinvoice
where in_inv_date >= trunc(sysdate-1) and in_ledger is not null and in_inv_num <> '0000000'
group by in_ejercicio, in_period, in_ledger

delete from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 14 and 
    exists ( select 1 from a1 where in_period = cc_per and in_ledger = cc_asi)

delete from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 14 and 
    exists ( select 1 from a1 where in_period = dg_per and in_ledger = dg_asi)
    
delete from asto
where as_emp = '60' and as_plan = 'A' and as_eje = 18 and
    exists ( select 1 from a1 where in_period = as_per and in_ledger = as_asi)    

update rinvoice
set in_ejercicio = null,
    in_period = null,
    in_ledger = null
where in_inv_date >= trunc(sysdate-1) and in_ledger is not null and in_inv_num <> '0000000'
    

select * from rinvoice where in_inv_num = :invoice

/*
Pls do ALL the validations.....
*/

-- List of yesterday's invoices not in accounting today.
select in_hotel, in_reserv, in_wholes, in_inv_num, in_depart
from rinvoice
where in_inv_date between trunc(sysdate-90) and trunc(sysdate -1) and 
	  in_inv_num is not null and in_ledger is null;
	  
	   

-- Check RINVOICE inside differences.
select t.in_hotel, t.in_reserv, t.in_inv_num, t.in_a_room, t.in_a_total, t.in_a_coop, t.in_period, t.in_ledger, t.rowid
from rinvoice t
where in_ejercicio = 14 and in_a_room <> nvl(in_a_total,0) + nvl(in_a_coop,0)
order by in_inv_num;



-- Duplicated Invoices....
select in_hotel, in_wholes, in_inv_num
from rinvoice  a
where  in_ejercicio = 14 and 
      exists (
        select 1
        from rinvoice b
        where b.in_hotel = a.in_hotel
            and b.in_wholes != a.in_wholes
            and b.in_inv_num = a.in_inv_num
      )  ;



-- Repeated invoice numbers under a single Ledger Entry....
-- Delete Entry and do accounting again...
select cc_asi
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 14  and cc_tipo = 1
group by cc_emp, cc_plan, cc_eje, cc_per, cc_asi
having count(*) > 1 ;


-- CCMAES minus rinvoice...
select ltrim(cc_factura), cc_importe, cc_asi, cc_per
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 16  and cc_tipo = 1 
minus
select in_inv_num, sum(in_a_total), in_ledger , in_period
from rinvoice
where in_ejercicio = 16
group by in_inv_num, in_ledger,in_period;


-- RINVOICE minis CCMAES....
select in_inv_num, sum(in_a_total), in_ledger 
from rinvoice
where in_period = :per and in_ejercicio = 14
group by in_ledger,in_inv_num
minus
select ltrim(cc_factura), cc_importe, cc_asi
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 14 and cc_per = :per and cc_tipo = 1



-- DIAG minus rinvoice.... 430....
select dg_per, dg_asi, dg_imp
from diag
where dg_emp = '60' and dg_eje = 14 and dg_per = :per and dg_dh = 'D' and dg_cg like '430%'
minus
select in_period, in_ledger, sum(in_a_total) in_a_total
from rinvoice
where in_period = :per and in_ejercicio = 14
group by in_period, in_ledger



-- Rinvoice  vs DIAG...
select in_period, in_ledger, sum(in_a_total) in_a_total
from rinvoice
where in_period = :per and in_ejercicio = 14
group by in_period, in_ledger
minus
select dg_per, dg_asi, dg_imp
from diag
where dg_emp = '60' and dg_eje = 14 and dg_per = :per and dg_dh = 'D' and dg_cg like '430%'


select t.*, t.rowid from rinvoice t where in_inv_num = :invoice

select * from rinvoice where in_ejercicio = 12 and in_period = :per and in_ledger = :asi


select t.*, t.rowid
from ccmaes t
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 12 and cc_per = :per and cc_asi = :asi

select t.*, t.rowid
from ccmaes t
where cc_emp = '60' and cc_plan = 'A'  and cc_numero = 'WT1231S4'


select t.*, t.rowid
from ccmaes t
where cc_emp = '60' and cc_plan = 'A'  and cc_factura = '4003780'

select T.*, t.rowid 
from diag t
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 12 and dg_per = :per and dg_asi = :asi

select t.*, t.rowid
from asto t
where as_emp = '60' and as_plan = 'A'  and as_eje = 12 and as_per = :per and as_asi = :asi




select *
from rscharter
where ch_hotel = :hotel and ch_charter = :charter

-- DIAG minus rinvoice.... 700....
select dg_per, dg_asi, dg_imp
from diag
where dg_emp = '80' and dg_eje = 14 and dg_per = :per and dg_dh = 'H' and dg_cg like '700%'
minus
select in_period, in_ledger, sum(in_a_room) in_a_total
from rinvoice
where in_period = :per and in_ejercicio = 14
group by in_period, in_ledger



-- RINVOICE - DIAG (700)...
select in_period, in_ledger, sum(in_a_room) in_a_total
from rinvoice
where in_period = :per and in_ejercicio = 14 
group by in_period, in_ledger
minus
select dg_per, dg_asi, dg_imp
from diag
where dg_emp = '80' and dg_eje = 14 and dg_per = :per and dg_dh = 'H' and dg_cg like '700%'


-- RINVOICE minus (430 + 657)......
select in_period, in_ledger, sum(in_a_room) in_a_total
from rinvoice
where in_period = :per and in_ejercicio = 14
group by in_period, in_ledger
minus
select a.dg_per, a.dg_asi, sum(a.dg_imp+nvl(b.dg_imp,0))
from diag a, diag b
where  a.dg_emp = '80'
   and a.dg_plan = 'A' 
   and a.dg_eje = 14
   and a.dg_per = :per 
   and a.dg_dh = 'D' 
   and a.dg_cg like '430%' 
   and b.dg_emp(+) = a.dg_emp
   and b.dg_plan(+) = a.dg_plan 
   and b.dg_eje(+) = a.dg_eje 
   and b.dg_per(+) = a.dg_per 
   and b.dg_asi(+) = a.dg_asi 
   and b.dg_dh(+) = 'D' 
   and b.dg_cg(+) like '657%' 
group by a.dg_per, a.dg_asi




select *
from rinvoice
where in_ejercicio = 11 and in_period = :per and in_ledger = :asi

select *
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 11 and dg_per = :per and dg_asi = :asi

select *
from rscharter
where ch_hotel = '02' and ch_charter = :charter



-- The sum must be equal to the sum of the co-op on RSINVOICE otherwise 
-- someone load refunds, or advertising discounts without loading CCMAES entries.
-- check those entries with Mr. Tarazona.
select sum(dg_imp)
from diag
where dg_emp = 80 and dg_plan = 'A' and dg_eje = 14 and dg_per = :per and dg_dh = 'D' and (dg_cg like '657%' or dg_cg like '700%' or dg_cg like '720%') and
not exists (
	select 1
	from ccmaes
	where cc_emp = 80 and cc_plan = 'A' and cc_eje = 14 and cc_per = dg_per and cc_asi = dg_asi and cc_tipo = '8' 
)




/*..
  TOTALS..
*/..

-- TOTAL..
select sum(cc_importe)
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 16 and cc_per = :per and cc_tipo = 1

select sum(in_a_coop)
from rinvoice
where nvl(in_ejercicio,11) = 14 and in_period = :per

select *
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 16 and dg_dh = 'H' and dg_cg ='430020101016'   
order by dg_emp, dg_plan, dg_eje, dg_per, dg_asi   

select *
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 16 and dg_dh = 'D' and dg_cg ='430020101016'      

	  


-- Totals by Hotel on CCMAES...
select substr(cc_cuenta,1,5), sum(cc_importe)
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 9 and cc_per = :per and cc_tipo = 1	  
group by substr(cc_cuenta,1,5)


-- Totals by Hotel on DIAG.....
select substr(dg_cg,1,5), to_char(sum(dg_imp),'9,999,999.09')
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 9 and dg_per = :per and dg_dh = 'H' and dg_cg like '700%'	  
group by substr(dg_cg,1,5)

-- Totals by Hotel on DIAG..
select substr(dg_cg,1,5), to_char(sum(dg_imp),'9,999,999.09')
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 9 and dg_per = :per and dg_dh = 'D' and dg_cg like '430%'	  
group by substr(dg_cg,1,5)


-- Totals by Hotel on RINVOICE...
select in_hotel, sum(in_a_room)
from rinvoice
where in_ejercicio = 9 and in_period = :per
group by in_hotel


select cc_factura
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 14 and cc_per = :per and cc_tipo = 1 and cc_cuenta like '43001%'
minus
select in_inv_num
from rinvoice
where in_hotel = '01' and in_ejercicio = 14 and in_period = :per

select *
from rinvoice
where in_inv_num = :invoice

select *
from rscharter
where ch_hotel = '09' and ch_charter = 'EXPALAGE'





-- Real invoices   vs... Report by Market....

select in_inv_num
from rinvoice
where in_hotel = '01' and in_inv_num is not null and in_period = 2 and in_arrival > '01-AUG-07'
minus
    select in_inv_num
    from rscharter , rinvoice
    where   ch_charter = in_wholes and
            ch_hotel = in_hotel and
            decode(nvl(in_period,14),2,12,1,11,in_period-2) between to_char(:xd1,'MM') and to_char(:xd2,'MM') and
            trunc(in_arrival,'YEAR') between  trunc(:xd1,'YEAR') and trunc(:xd2,'YEAR') and
            in_inv_num is not null and
            in_inv_num <> '0000000' and
            in_ledger is not null and
            in_wholes != 'COMPS' and
            ch_market in ('NAM','SAM') AND 
			in_hotel = '02'

			
select *
from rinvoice
where in_inv_num = :invoice			

select * 
from rscharter
where ch_charter = 'TVGAR'

select *
from rscharter
where ch_name like '%TRAVEL CE%'


 

 

-- PENDING PREPAYMENTS WITH BALANCE.
select cc_per, cc_cuenta, cc_fecmov, cc_feccon, cc_asi, cc_apu, cc_importe, cc_saldo, cc_quien, cc_clicod
from ccmaes
where cc_emp = '46' and cc_plan = 'A' and cc_tipo = 7 and cc_saldo <> 0 and cc_per <=9
order by cc_cuenta
 
 
-- INVOICES WITH BALANCE.
select cc_per, cc_cuenta, cc_fecmov, cc_feccon, cc_asi, cc_apu, cc_importe, cc_saldo, cc_quien, cc_clicod
from ccmaes
where cc_emp = '46' and cc_plan = 'A' and cc_tipo = 1 and cc_saldo <> 0 and cc_per <=9
order by cc_cuenta


 select sum(in_a_total)
 from rinvoice t
 where in_inv_num = :invoice
-- order by in_ledger
 --in_period = 7 and in_ledger = 1429 and in_arrival > '01-jan-03'
 
 select t.*, t.rowid
 from ccmaes t
 where cc_emp = '60' and cc_plan = 'A' and cc_eje = 9 and cc_per = :per and cc_asi = :asiento--cc_desc like '%Inv 200002%' --cc_asi = :asiento
 
 
 select t.*, t.rowid
 from diag t
 where dg_emp = 60 and dg_eje=9 and dg_per = :per  and dg_asi = :asiento
 
 
-- select t.as_emp, t.as_asi, t.rowid
 SELECT T.*, T.ROWID
 from asto t
 where as_emp = '60' and as_eje = 6 and as_per = 12 and as_asi = :asiento
 
 select t.*, t.rowid
 from numeros t
 where nm_emp = :emp and nm_eje = 6

 
 


-- TOTAL TOTALS BY PERIOD. 
select sum(dg_imp) 
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 6 and dg_per =12 and dg_dh = 'D' and dg_desc like 'Inv %'

select sum(cc_importe)
--select sum(cc_saldo)
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 6 and cc_per = 12 and cc_tipo = 1 --and cc_cuenta = :cuenta

 
 
 select t.*, t.rowid
 from diag t
 where dg_emp = '46' and dg_plan = 'A' and dg_eje = 4 and dg_per = &per and dg_asi =&asiento 
 
 select t.*, t.rowid
 from asto t
 where as_emp = '46' and as_per = 3 and as_asi = 15000
 
 select t.*, t.rowid
 from ccmaes t
 where t.CC_EMP = '46'and cc_per = 12 and cc_asi = 2758
 
select t.*, t.rowid
from ccmaes t
where cc_emp='46' and ltrim(rtrim(cc_factura)) = '45641'
 
 
 desc mares

 
 
 
 
select t.*, t.rowid
from rinvoice t
where  in_inv_num = '&invoiceNumber'


select t.*, t.rowid
from rinvoice t
where in_reserv = '&reservation' and in_hotel = '&hotel'


alter trigger hotel.rinvoice_before_mod disable
 
select t.*, t.rowid
from rinvoice t
where in_period = &period and in_ledger = '&ledger'


alter trigger hotel.rinvoice_before_mod enable



 select *
 from diag
 where dg_emp = '46' and dg_eje = 3 and dg_per =&periodo and dg_asi = '&ledger'
 
 
 select sum(dg_imp)
 from diag
 where dg_emp = '46' and dg_eje = 3 and dg_per = 3
 and dg_dh= 'D'
 and dg_cg like '430010101%'

 desc rscharter
 
 select t.*, t.rowid
 from rscharter T
 where ch_hotel = '&hotel' and ch_charter = '&charter'

 select t.*, t.rowid
 from rscharter T
 where ch_hotel = '&hotel' and ch_name like '&charter%'
 
 select *
 from ctarinchotelconv
 where cn_source_hotel = '57473' and cn_source = 'AP'
 
 select * 
 from ctarincrateconv
 where cv_hotel = '727' and cv_our_rate = 'SR'
 
 
 
select t.*, t.rowid
from ctratedesc t 
where rd_rate = '23'



select *
from cuentas

select *
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 8 and not exists
(select 1 from cuentas where ct_emp = '60' and ct_plan = 'A' and ct_eje = 9 and ct_cg = dg_cg)


desc getAdjusted

select * from all_objects where object_name like '%ADJ%'
 

 
 desc ctroomclose

 
-- GET BAD APPLIED PAYMENTS.
-- 
select cc_asi, cc_apu, cc_per, cc_factura, cc_importe, cc_saldo, getpaid(cc_emp, cc_plan, cc_eje, cc_cuenta, cc_factura),getAdjusted(cc_emp, cc_plan, cc_eje, cc_cuenta, cc_factura) 
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 12
and cc_tipo = 1 
and cc_factura <> '0000000' 
and nvl(cc_importe,0) <> nvl(cc_saldo,0) + nvl(getpaid(cc_emp, cc_plan, cc_eje, cc_cuenta, cc_factura),0) + nvl(getAdjusted(cc_emp, cc_plan, cc_eje, cc_cuenta, cc_factura),0)



select substr(dg_cg,4,9), sum(dg_imp)
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 14 and dg_per =:per and dg_cg like '700%' and dg_dh = 'H'
group by substr(dg_cg,4,9)
minus
select  substr(dg_cg,4,9), sum(dg_imp)
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 14 and dg_Per = :per and dg_cg like '430%' and dg_dh = 'D'
group by substr(dg_cg,4,9)





--- Diferenrcias RSCHARTER CH_ACC_PROD  VS. CH_ACC_INV.....
select ch_hotel, ch_charter, ch_acc_prod, ch_acc_inv
from rscharter
where substr(ch_acc_prod,4,9) <> substr(ch_acc_inv,4,9) and ch_acc_prod is not null and exists (select 1 from rscondet where cd_hotel = ch_hotel and cd_charter = ch_charter and cd_end_sea > sysdate)
order by ch_hotel, ch_charter



select * from rscondet








--- Diferenrcias RSCHARTER CH_ACC_PROD  VS. CH_ACC_INV.....
select ch_hotel, ch_charter, ch_acc_prod, ch_acc_inv
from rscharter
where substr(ch_acc_prod,4,9) <> substr(ch_acc_inv,4,9) and ch_acc_prod is not null and exists (select 1 from rscondet where cd_hotel = ch_hotel and cd_charter = ch_charter and cd_end_sea > sysdate)
order by ch_hotel, ch_charter


-- Rinvoice mTAX.
select in_hotel, in_inv_num, in_ejercicio, in_period, in_ledger, in_a_room, in_a_total, in_a_mtax, t.rowid
from rinvoice t
where in_period = :per and in_ledger = :asi
order by in_ejercicio, in_period, in_ledger



select *
from rinvoice
where in_hotel = '01' and in_ejercicio =9 and in_period = 1 and not exists (
select 1 
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 9 and cc_per = 1 and cc_asi = in_ledger and cc_cuenta not like '43001%'
)



		
select t.*, t.rowid
from diag t
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 9 and dg_per = :per and dg_asi = :asi

select t.*, t.rowid
from ccmaes t
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 8 and cc_per = :per and cc_asi = :asi

select t.*, t.rowid
from rinvoice t
where in_a_total = 686 and in_ejercicio = 8 and in_period = 12--in_inv_num = :invoice
--where in_reserv = :reserv
--where in_period = 9 and in_ledger = :asi		
		
		
-- totals.. RINVOICE		
select sum(nvl(in_a_total,0)) c430, sum(nvl(in_a_room,0)) c700, sum(nvl(in_a_coop,0)) coop
from rinvoice
where in_period = :per and in_ejercicio = 9



-- Check RINVOICE inside differences.
select t.in_hotel, t.in_reserv, t.in_inv_num, t.in_a_room, t.in_a_total, t.in_a_coop, t.in_period, t.in_ledger, t.rowid
from rinvoice t
where in_period = :per and in_ejercicio = 8 and in_a_room <> nvl(in_a_total,0) + nvl(in_a_coop,0)



-- DIAG minus rinvoice.... 430....
select dg_per, dg_asi, dg_imp
from diag
where dg_emp = '60' and dg_eje = 14 and dg_per = :per and dg_dh = 'D' and dg_cg like '430%'
minus
select in_period, in_ledger, sum(in_a_total) in_a_total
from rinvoice
where in_period = :per and in_ejercicio = 14
group by in_period, in_ledger

-- Rinvoice - DIAG...
select in_period, in_ledger, sum(in_a_total) in_a_total
from rinvoice
where in_period = :per and in_ejercicio = 9
group by in_period, in_ledger
minus
select dg_per, dg_asi, dg_imp
from diag
where dg_emp = '60' and dg_eje = 9 and dg_per = :per and dg_dh = 'D' and dg_cg like '430%'






-- DIAG minus rinvoice.... 700....
select dg_per, dg_asi, dg_imp
from diag
where dg_emp = '60' and dg_eje = 14 and dg_per = :per and dg_dh = 'H' and dg_cg like '700%'
minus
select in_period, in_ledger, sum(in_a_room) in_a_total
from rinvoice
where in_period = :per and in_ejercicio = 14
group by in_period, in_ledger

-- RINVOICE - DIAG (700)...

select in_period, in_ledger, sum(in_a_room) in_a_total
from rinvoice
where in_period = :per and in_ejercicio = 14
group by in_period, in_ledger
minus
select dg_per, dg_asi, dg_imp
from diag
where dg_emp = '60' and dg_eje = 14 and dg_per = :per and dg_dh = 'H' and dg_cg like '700%'






-- RINVOICE minus (430 + 657)......
select in_period, in_ledger, sum(in_a_room) in_a_total
from rinvoice
where in_period = :per and in_ejercicio = 9
group by in_period, in_ledger
minus
select a.dg_per, a.dg_asi, sum(a.dg_imp+nvl(b.dg_imp,0))
from diag a, diag b
where  a.dg_emp = '60'
   and a.dg_plan = 'A' 
   and a.dg_eje = 9 
   and a.dg_per = :per 
   and a.dg_dh = 'D' 
   and a.dg_cg like '430%' 
   and b.dg_emp(+) = a.dg_emp
   and b.dg_plan(+) = a.dg_plan 
   and b.dg_eje(+) = a.dg_eje 
   and b.dg_per(+) = a.dg_per 
   and b.dg_asi(+) = a.dg_asi 
   and b.dg_dh(+) = 'D' 
   and b.dg_cg(+) like '657%' 
group by a.dg_per, a.dg_asi


select sum(in_a_coop)
from rinvoice
where in_ejercicio = 9 and in_period = :per

-- The sum must be equal to the sum of the co-op on RSINVOICE otherwise 
-- someone load refunds, or advertising discounts without loading CCMAES entries.
-- check those entries with Mr. Tarazona.
select sum(dg_imp)
from diag
where dg_emp = 60 and dg_plan = 'A' and dg_eje = 14 and dg_per = :per and dg_dh = 'D' and (dg_cg like '657%' or dg_cg like '700%' or dg_cg like '720%') and
not exists (
	select 1
	from ccmaes
	where cc_emp = 60 and cc_plan = 'A' and cc_eje = 14 and cc_per = dg_per and cc_asi = dg_asi and cc_tipo = '8' 
)









select *
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 8 and dg_per = :per and dg_asi = :asi


-- CCMAES minus rinvoice...
select ltrim(cc_factura), cc_importe
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 9 and cc_per = :per and cc_tipo = 1
minus
select in_inv_num, sum(in_a_total) 
from rinvoice
where in_period = :per and in_ejercicio = 9
group by in_ledger,in_inv_num




-- RINVOICE minis CCMAES....
select in_inv_num, sum(in_a_total) 
from rinvoice
where in_period = :per and in_ejercicio = 9
group by in_ledger,in_inv_num
minus
select ltrim(cc_factura), cc_importe
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 9 and cc_per = :per and cc_tipo = 1


select t.*, t.rowid
from ccmaes t
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 9 and cc_per = :per and cc_tipo = 1 and cc_factura like '%'||:invoice||'%'


-- TOTAL..
select sum(cc_importe)
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 8 and cc_per = :per and cc_tipo = 1

select sum(in_a_total)
from rinvoice
where in_ejercicio = 8 and in_period = :per

select sum(dg_imp)
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 8 and dg_per = :per and dg_dh = 'H' and dg_cg like '700%'	  

select sum(dg_imp)
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 8 and dg_per = :per and dg_dh = 'D' and dg_cg like '430%'	  

	  


-- Totals by Hotel on CCMAES...
select substr(cc_cuenta,1,5), sum(cc_importe)
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 9 and cc_per = :per and cc_tipo = 1	  
group by substr(cc_cuenta,1,5)


-- Totals by Hotel on DIAG.....
select substr(dg_cg,1,5), to_char(sum(dg_imp),'9,999,999.09')
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 9 and dg_per = :per and dg_dh = 'H' and dg_cg like '700%'	  
group by substr(dg_cg,1,5)

-- Totals by Hotel on DIAG..
select substr(dg_cg,1,5), to_char(sum(dg_imp),'9,999,999.09')
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 9 and dg_per = :per and dg_dh = 'D' and dg_cg like '430%'	  
group by substr(dg_cg,1,5)


-- Totals by Hotel on RINVOICE...
select in_hotel, sum(in_a_room)
from rinvoice
where in_ejercicio = 9 and in_period = :per
group by in_hotel


select cc_factura
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 8 and cc_per = 2 and cc_tipo = 1 and cc_cuenta like '43001%'
minus
select in_inv_num
from rinvoice
where in_hotel = '01' and in_ejercicio = 8 and in_period = :per

select *
from rinvoice
where in_inv_num = :invoice

select *
from rscharter
where ch_hotel = '09' and ch_charter = 'EXPALAGE'





-- Real invoices   vs... Report by Market....

select in_inv_num
from rinvoice
where in_hotel = '01' and in_inv_num is not null and in_period = 2 and in_arrival > '01-AUG-07'
minus
    select in_inv_num
    from rscharter , rinvoice
    where   ch_charter = in_wholes and
            ch_hotel = in_hotel and
            decode(nvl(in_period,14),2,12,1,11,in_period-2) between to_char(:xd1,'MM') and to_char(:xd2,'MM') and
            trunc(in_arrival,'YEAR') between  trunc(:xd1,'YEAR') and trunc(:xd2,'YEAR') and
            in_inv_num is not null and
            in_inv_num <> '0000000' and
            in_ledger is not null and
            in_wholes != 'COMPS' and
            ch_market in ('NAM','SAM') AND 
			in_hotel = '02'

			
select *
from rinvoice
where in_inv_num = :invoice			

select * 
from rscharter
where ch_charter = 'TVGAR'

select *
from rscharter
where ch_name like '%TRAVEL CE%'


 

 

-- PENDING PREPAYMENTS WITH BALANCE.
select cc_per, cc_cuenta, cc_fecmov, cc_feccon, cc_asi, cc_apu, cc_importe, cc_saldo, cc_quien, cc_clicod
from ccmaes
where cc_emp = '46' and cc_plan = 'A' and cc_tipo = 7 and cc_saldo <> 0 and cc_per <=9
order by cc_cuenta
 
 
-- INVOICES WITH BALANCE.
select cc_per, cc_cuenta, cc_fecmov, cc_feccon, cc_asi, cc_apu, cc_importe, cc_saldo, cc_quien, cc_clicod
from ccmaes
where cc_emp = '46' and cc_plan = 'A' and cc_tipo = 1 and cc_saldo <> 0 and cc_per <=9
order by cc_cuenta


 select sum(in_a_total)
 from rinvoice t
 where in_period = 9 and in_inv_num = :invoice
-- order by in_ledger
 --in_period = 7 and in_ledger = 1429 and in_arrival > '01-jan-03'
 
 select t.*, t.rowid
 from ccmaes t
 where cc_emp = '60' and cc_plan = 'A' and cc_eje = 6 and cc_per = 12 and cc_asi = :asiento--cc_desc like '%Inv 200002%' --cc_asi = :asiento
 
 
 select t.*, t.rowid
 from diag t
 where dg_emp = 60 and dg_eje=7 and dg_per = 9  and dg_asi = :asiento
 
-- select t.as_emp, t.as_asi, t.rowid
 SELECT T.*, T.ROWID
 from asto t
 where as_emp = '6 0' and as_eje = 6 and as_per = 12 and as_asi = :asiento
 
 select t.*, t.rowid
 from numeros t
 where nm_emp = :emp and nm_eje = 6

 
 


-- TOTAL TOTALS BY PERIOD. 
select sum(dg_imp) 
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 6 and dg_per =12 and dg_dh = 'D' and dg_desc like 'Inv %'

select sum(cc_importe)
--select sum(cc_saldo)
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 6 and cc_per = 12 and cc_tipo = 1 --and cc_cuenta = :cuenta

 
 
 select t.*, t.rowid
 from diag t
 where dg_emp = '46' and dg_plan = 'A' and dg_eje = 4 and dg_per = &per and dg_asi =&asiento 
 
 select t.*, t.rowid
 from asto t
 where as_emp = '46' and as_per = 3 and as_asi = 15000
 
 select t.*, t.rowid
 from ccmaes t
 where t.CC_EMP = '46'and cc_per = 12 and cc_asi = 2758
 
select t.*, t.rowid
from ccmaes t
where cc_emp='46' and ltrim(rtrim(cc_factura)) = '45641'
 
 
 desc mares

 
 
 
 
select t.*, t.rowid
from rinvoice t
where  in_inv_num = '&invoiceNumber'


select t.*, t.rowid
from rinvoice t
where in_reserv = '&reservation' and in_hotel = '&hotel'


alter trigger hotel.rinvoice_before_mod disable
 
select t.*, t.rowid
from rinvoice t
where in_period = &period and in_ledger = '&ledger'


alter trigger hotel.rinvoice_before_mod enable



 select *
 from diag
 where dg_emp = '46' and dg_eje = 3 and dg_per =&periodo and dg_asi = '&ledger'
 
 
 select sum(dg_imp)
 from diag
 where dg_emp = '46' and dg_eje = 3 and dg_per = 3
 and dg_dh= 'D'
 and dg_cg like '430010101%'

 desc rscharter
 
 select t.*, t.rowid
 from rscharter T
 where ch_hotel = '&hotel' and ch_charter = '&charter'

 select t.*, t.rowid
 from rscharter T
 where ch_hotel = '&hotel' and ch_name like '&charter%'
 
 select *
 from ctarinchotelconv
 where cn_source_hotel = '57473' and cn_source = 'AP'
 
 select * 
 from ctarincrateconv
 where cv_hotel = '727' and cv_our_rate = 'SR'
 
 
 
select t.*, t.rowid
from ctratedesc t 
where rd_rate = '23'



select *
from cuentas

select *
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 8 and not exists
(select 1 from cuentas where ct_emp = '60' and ct_plan = 'A' and ct_eje = 9 and ct_cg = dg_cg)


 

 
 desc ctroomclose

 
-- GET BAD APPLIED PAYMENTS.
-- 
select cc_asi, cc_apu, cc_per, cc_factura, cc_importe, cc_saldo, getpaid(cc_emp, cc_plan, cc_eje, cc_cuenta, cc_factura),getAdjusted(cc_emp, cc_plan, cc_eje, cc_cuenta, cc_factura) 
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 8
and cc_feccon >= '01-jan-07' and cc_tipo = 1 and 
cc_factura <> '0000000' 
and nvl(cc_importe,0) <> nvl(cc_saldo,0) + nvl(getpaid(cc_emp, cc_plan, cc_eje, cc_cuenta, cc_factura),0) + nvl(getAdjusted(cc_emp, cc_plan, cc_eje, cc_cuenta, cc_factura),0)



select ch_hotel, ch_charter, ch_name, ch_acc_inv, ch_acc_prod
from rscharter
where ch_hotel = '10' and ch_acc_inv not like '43007%' and ch_pri_inv = 'Y'


select unique ch_market
fro



    select in_inv_num
    from rscharter , rinvoice
    where   ch_charter = in_wholes and
            ch_hotel = in_hotel and
            decode(nvl(in_period,14),2,12,1,11,in_period-2) between to_char(:xd1,'MM') and to_char(:xd2,'MM') and
            trunc(in_arrival,'YEAR') between  trunc(:xd1,'YEAR') and trunc(:xd2,'YEAR') and
            in_inv_num is not null and
            in_inv_num <> '0000000' and
            in_ledger is not null and
            in_wholes != 'COMPS' and
            ch_market in ('NAM','SAM') AND 
			in_hotel = '02'


select substr(dg_cg,4,9), sum(dg_imp)
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 8 and dg_per =:per and dg_cg like '700%' and dg_dh = 'H'
group by substr(dg_cg,4,9)
minus
select  substr(dg_cg,4,9), sum(dg_imp)
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 8 and dg_Per = :per and dg_cg like '430%' and dg_dh = 'D'
group by substr(dg_cg,4,9)


--- Diferenrcias RSCHARTER CH_ACC_PROD  VS. CH_ACC_INV.....
select ch_hotel, ch_charter, ch_acc_prod, ch_acc_inv
from rscharter
where substr(ch_acc_prod,4,9) <> substr(ch_acc_inv,4,9) and ch_acc_prod is not null and exists (select 1 from rscondet where cd_hotel = ch_hotel and cd_charter = ch_charter and cd_end_sea > sysdate)
order by ch_hotel, ch_charter



select * from rscondet



select *
from rinvoice
where in_inv_num = :invoice

select *
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 9 and dg_per = 5 and dg_asi = :asi


select t.*, t.rowid
from rinvoice t
where in_inv_num = '1208554'


select * from rsmaes where ma_hotel = :hotel and ma_reserv = :reserv

select t.*, t.rowid from rinvoice t
where in_hotel = :hotel and in_reserv = :reserv



select  in_hotel, in_wholes, in_reserv, in_group,
        trunc(decode(nvl(inv_byArrival,'Y'),'Y',in_arrival, in_depart),'MONTH') myDate,
        in_inv_num--, sum(in_a_total) in_a_total
from rinvoice a, rsopecharter, rsoperator
where   --a.in_hotel = xhotel and
        a.in_inv_num is not null and
        a.in_ledger is null and
        a.in_period is null and
        --a.in_inv_date >= xdate and
        oc_charter = in_wholes and
        op_id = oc_operator and
        a.in_depart <= '31-mar-08'
--group by in_hotel,in_wholes, in_group,  trunc(decode(nvl(inv_byArrival,'Y'),'Y',in_arrival, in_depart),'MONTH'), in_inv_num
--order by in_hotel,in_wholes, in_inv_num;

select *
from rinvoice
where in_inv_num is not null and in_inv_date = '07-apr-08'



select *
from rinvoice
where in_inv_num = :invoice 



select dg_int
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 9 and dg_per = 1 and dg_dh = 'H' and dg_cg like '70001%'
minus
select in_inv_num
from rinvoice
where in_hotel = '01' and in_ejercicio = 9 and in_period = 1






select *
from cuentas
where ct_emp = '60' and ct_plan = 'A' and ct_eje = 9  and upper(ct_desc) like 'ALBA%'

select ch_name, ch_acc_inv, ch_acc_prod
from rscharter
where upper(ch_name) like '%ALBA%'

select unique in_wholes, in_ledger, in_a_total, in_a_room, cc_cuenta
from rinvoice, ccmaes
where in_period = 2 and in_ejercicio = 9 and in_wholes in (select oc_charter from rsopecharter where oc_operator = 'HOLNETAI') and 
      cc_emp = '60' and cc_plan = 'A' and cc_eje = 9 and cc_per = 2 and cc_asi = in_ledger 
order by in_ledger


select * from rsoperator where op_name like '%THOMAS%'

select * from rsopecharter where oc_operator = 'ALBA'


select cc_tipo, cc_cuenta, cc_factura, cc_importe
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 9 and cc_per = 2 and exists
(
select 1
from cuentas
where ct_emp = '60' and ct_plan = 'A' and ct_eje = 9 and 
	  ct_cg = ltrim(rtrim(cc_cuenta)) 
	  and  upper(ct_desc) like '%ALBA%'
)	  
order by cc_tipo




select *
from cuentas
where ct_eje = 9 and ct_cg = :cuenta


select *
from diag a
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 9 and dg_cg like '437010201007' and dg_dh = 'H' and  exists
(
select *
from diag b
where b.dg_emp = '60' and 
	  b.dg_plan = 'A' and 
	  b.dg_eje =9 and
	  b.dg_dh = 'D' and  
	  --b.dg_cg  = '437010201001' and 
	  upper(b.dg_doc) = upper(a.dg_doc)
)




select *
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 9 and dg_cg like '437010201001' and dg_doc in
(



select *
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 9 and dg_per = 2 and dg_cg like '437010201001' and dg_dh = 'H' and exists 
(
select 1
from ccmaes
where cc_emp = '60' and cc_plan ='A' and cc_eje = 9 and cc_tipo in ('6','7') and cc_numero = dg_doc 
)



select *
from diag a
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 16 and dg_cg like '430%01001' and dg_dh = 'H' and 
not exists (
select 1
from diag b
where b.dg_emp = a.dg_emp and
	  b.dg_plan = a.dg_plan and
	  b.dg_eje = a.dg_eje and 
	  b.dg_doc = a.dg_doc and 
	  b.dg_cg like '437%01001' and 
	  b.dg_dh = 'H'
) 







select *
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje =12 and dg_per = :per and dg_asi = :asi






select t.*, t.rowid
from rinvoice t
where in_inv_num = :invoice

select t.*, t.rowid
from ccmaes t
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 12 and cc_per = :per and cc_asi = :asi

select t.*, t.rowid
from diag t
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 12 and dg_per = :per and dg_asi = :asi

select t.*, t.rowid
from asto t
where as_emp = '60' and as_plan = 'A' and as_eje = 12 and as_per  = :per and as_asi = :asi




select t.*, t.rowid
from ccmaes t
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 11 and cc_per = :per and cc_asi = :asi

select t.*, t.rowid
from rinvoice t
where in_period = :per and in_wholes like 'FUNJ%' and in_inv_date > sysdate - 9


select dg_emp, dg_plan, dg_eje, dg_per, dg_asi
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 14 and dg_per = 6 and   
dg_asi in (
select cc_asi  from ccmaes t where cc_tipo = 8 and cc_feccon >= '19-JUN-14'
)
group by dg_emp, dg_plan, dg_eje, dg_per, dg_asi
having count(*) < 2

select * from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 14 and cc_per = 6 and cc_tipo = 8 


-- revert invoicing accounting

select * from rinvoice where in_inv_date = trunc(sysdate)-1 and in_ledger is not null and in_period <> 99 order by in_ledger

select * from asto
where as_emp = '60' and as_plan = 'A' and as_eje = 14 and as_per = 6 and as_asi in (
select in_ledger from rinvoice where in_inv_date = trunc(sysdate)-1 and in_ledger is not null and in_period <> 99
)


select * from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 14 and dg_per = 6 and dg_asi in (
select in_ledger from rinvoice where in_inv_date = trunc(sysdate)-1 and in_ledger is not null and in_period <> 99
)


select * from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 14 and cc_per = 6 and cc_asi in (
select in_ledger from rinvoice where in_inv_date = trunc(sysdate)-1 and in_ledger is not null and in_period <> 99
)

-- Borra p�lizas.

delete from asto
where as_emp = '60' and as_plan = 'A' and as_eje = 14 and as_per = 6 and as_asi in (
select in_ledger from rinvoice where in_inv_date = trunc(sysdate)-1 and in_ledger is not null and in_period <> 99
)

delete from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 14 and dg_per = 6 and dg_asi in (
select in_ledger from rinvoice where in_inv_date = trunc(sysdate)-1 and in_ledger is not null and in_period <> 99
)

delete from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 14 and cc_per = 6 and cc_asi in (
select in_ledger from rinvoice where in_inv_date = trunc(sysdate)-1 and in_ledger is not null and in_period <> 99
)

update rinvoice
set in_period = null,
    in_ledger = null,
    in_ejercicio = null,
    in_voucher_img5 = 'Z'
where in_inv_date = trunc(sysdate)-1 and in_ledger is not null and in_period <> 99   
    






select t.*, t.rowid from ccmaes t where cc_emp = '60' and cc_plan = 'A' and cc_eje =    14 and cc_per = :per and cc_tipo = 8

select * from rsmaes where ma_promo is not null

desc auditAccounting2


delete 
from asto
where as_emp = 60 and as_plan = 'A' and as_eje = 14 and as_per = 11 
and not exists 
(
    select dg_asi
    from diag
    where dg_emp = 60 and dg_plan = 'A' and dg_eje = 14 and dg_per=11 and dg_asi = as_asi
)


select unique cc_factura, cc_importe - cc_saldo wrong_balance
from ccmaes  a
where cc_emp = '60' and cc_plan = 'A' and cc_eje >= :xEje  and cc_tipo = 1 and  cc_importe <> cc_saldo 
--exists( select 1 from ccmaes b where b.cc_emp = '60' and b.cc_plan = 'A' and b.cc_eje = xEje and b.cc_factura = a.cc_factura and b.cc_tipo <> 1) 
minus 
select cc_factura, sum(cc_importe)
from ccmaes 
where cc_emp = '60' and cc_plan = 'A'  and cc_tipo in ('6','8')
group by cc_cuenta, cc_factura;


desc auditAccounting2


execute OasisXLS.generate('02','COPASTD','2018366');


desc OasisXLS


select * from diag where dg_emp = 60 and dg_plan = 'A' and dg_eje = 14 and dg_per = 0


select sum(cc_saldo) from ccmaes where cc_emp = '60' and cc_plan = 'A' and cc_eje = 14 and cc_fecmov between '30-JAN-14' and '07-FEB-14' and cc_tipo = 7


select t.*, t.rowid
from cuentas t
where ct_emp = '60' and ct_plan = 'A' and ct_eje=14 and ct_cg = '700020102087'


select *
from rsmaes
where ma_reserv = :booking

desc rsmaes

select unique dg_asi  from diag t where dg_emp = '60' and dg_plan = 'A' and dg_eje = 14 and dg_per = :per

select t.*, t.rowid  from ccmaes t where ltrim(rtrim(cc_tipo)) = :tipo  and cc_eje = 14 and cc_per = 4




select * from cuentas  where ct_cg = '430020401022'

select * from rscharter where ch_acc_inv = '430010401022'


select '#' || ch_charter || '#'
from rscharter
where ch_charter like  '%JIREOCH%'
order by ch_hotel


select * from freserva_hoteles where rv_mayorista = 'TC' and rv_llegada > '01-jan-14'

select * from freserva_hoteles where rv_agencia = 'SAV%' and rv_llegada > '01-jan-14'


select t.*, t.rowid
from travmarkets t


select unique rv_agencia
from freserva_hoteles
where rv_mayorista = 'DIR' and rv_llegada >= '01-jan-13'
order by rv_agencia

select rv_hotel, rv_reserva, rv_mayorista
from freserva_hoteles
where rv_agencia = 'FITDISC' and rv_llegada > '01-jan-14' 


select * from all_tables where table_name like '%MENU%'

select t.*, t.rowid from contamenu t

select t.*, t.rowid from ccmaes t where cc_tipo = 1 and cc_eje >= 13 and abs(cc_importe) <> abs(cc_impext) and cc_per >= 1

update ccmaes
set cc_importe = cc_impext,    cc_salext = cc_saldo
where cc_tipo = 1 and cc_eje >= 13 and abs(cc_importe) <> abs(cc_impext) and cc_per >= 1    
    

select *
from all_objects
where object_name like '%PROFOR%'

genproformanumber

select * from rsmaes where ma_reserv = '485743'



select sum(decode(dg_dh,'D',dg_imp,0)) D, sum(decode(dg_dh,'H',dg_imp,0)) H
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 14 and dg_per = 8

select substr(dg_cg, 1,3) cta, sum(decode(dg_dh,'D',dg_imp,0)) D, sum(decode(dg_dh,'H',dg_imp,0)) H
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 14 and dg_per = 8
group by substr(dg_cg,1,3)
order by substr(dg_cg,1,3)




select count(*)
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 14 and dg_per = 8 
and dg_cg not in ( select ct_cg from cuentas where ct_emp = dg_emp and  ct_plan = dg_plan and ct_eje = dg_eje)

select * from balancen where ban_emp = 60 and ban_plan = 'A' and ban_eje = 14 and ban_per = 8 and ban_cg like '732%' 


select * from cuentas
where ct_cg = '43001'

select * from clientes
where cl_emp = 60 and cl_plan = 'A' and cl_cliente = '700020201004'


select *
from diag 
where dg_emp = 60 and dg_plan = 'A' and cc_factura in ('6000596','6000582','6000598')

select sum(dg_imp)
from diag
where dg_emp = 80 and dg_plan = 'A' and dg_eje = 14 and dg_per = 10 and dg_cg = '572010101001' and dg_dh = 'H'


select *
from diag
where dg_emp = 80 and dg_plan = 'A' and dg_eje = 14 and dg_imp between 2274 and 2275 


select t.*, t.rowid
from eperiod t
where ep_emp = 80 and ep_eje = 14

insert into eperiod
select 80, ep_plan, ep_eje, ep_per, ep_fini, ep_ffin, ep_situ
from eperiod 
where ep_emp = 60 and ep_eje = 15



insert into cuentas


select ct_emp, ct_plan, 15, ct_cg, ct_desc, ct_sub, ct_tcg, ct_nivel, ct_otcec, ct_fecha, ct_ctady, ct_usua, ct_operator
from cuentas a
where ct_emp = 80 and  ct_eje = 14 
    and not exists  ( 
        select 1 
        from cuentas b 
        where b.ct_emp = 80 and b.ct_plan = 'A' and b.ct_eje = 15 and b.ct_cg = a.ct_cg
) 




select unique cc_factura, cc_importe - cc_saldo wrong_balance
from ccmaes  a
where cc_emp = '60' and cc_plan = 'A' and cc_eje >= (15-1)  and cc_tipo = 1 and  exists 
(
    select 1
    from ccmaes d
    where d.cc_emp = '60' and d.cc_plan = 'A' and  d.cc_factura = a.cc_factura and d.cc_tipo in ('6','8')
) 
minus 
select cc_factura, sum(cc_importe)
from ccmaes 
where cc_emp = 60 and cc_plan = 'A'  and cc_tipo in ('6','8')
group by cc_cuenta, cc_factura;


select *
from diag
where dg_emp = 60 and dg_plan = 'A' and dg_eje = 15 and dg_per = 9 and dg_cg like '640%' and dg_asi in 
(
select dg_asi
from diag
where dg_emp = 60 and dg_plan = 'A' and dg_eje = 15 and dg_per = 9 and dg_cg like '440%'
)


select t.*, t.rowid
from numeros t
where nm_emp = 60 and nm_plan = 'A' and nm_eje = 15

oasisStatement_xls




select *
from ccmaes
where cc_emp = 60 and cc_plan = 'A' and cc_eje = 16 and cc_per = 10 and cc_tipo = 8





select cc_factura, sum(cc_importe)
from ccmaes
where cc_emp = 60 and cc_plan = 'A' and cc_tipo = 1 and cc_cuenta = :cuenta
group by cc_factura
minus
select cc_factura, sum(cc_importe)
from ccmaes
where cc_emp = 60 and cc_plan = 'A' and cc_tipo != 1 and cc_cuenta = :cuenta
group by cc_factura


select cc_factura, sum(cc_importe)
from ccmaes
where cc_emp = 60 and cc_plan = 'A' and cc_tipo != 1 and cc_cuenta = :cuenta
group by cc_factura
minus 
select cc_factura, sum(cc_importe)
from ccmaes
where cc_emp = 60 and cc_plan = 'A' and cc_tipo = 1 and cc_cuenta = :cuenta
group by cc_factura

select dg_per, dg_asi, dg_imp
from diag
where dg_emp = 60 and dg_plan = 'A' and dg_eje = 16 and dg_dh = 'H' and dg_cg = :cuenta
minus 
select cc_per, cc_asi, cc_importe
from ccmaes
where cc_emp = 60 and cc_plan = 'A' and cc_tipo != 1 and cc_cuenta = :cuenta


 
select cc_per, cc_asi, cc_importe
from ccmaes
where cc_emp = 60 and cc_plan = 'A' and cc_eje = 16 and  cc_tipo != 1 and cc_cuenta = :cuenta
minus
select dg_per, dg_asi, dg_imp
from diag
where dg_emp = 60 and dg_plan = 'A' and dg_dh = 'H' and dg_cg = :cuenta




select *
from ccmaes
where cc_emp = 60 and cc_plan = 'A' and cc_eje = 16 and cc_importe = 0.14 and cc_cuenta = :cuenta


select *
from diag 
where dg_cg = '430050101128'




select t.*, t.rowid
from diag  t
where dg_emp = 80 and dg_cg = '430010101002'

select t.*, t.rowid
from asto t
where as_emp = 80 and as_eje = 16 and as_per = 8 and as_asi = 1042

select *
from ccmaes
where cc_emp =80 and cc_plan = 'A' and cc_eje = 16 and cc_per = 8 and cc_asi = 1042


select * 
from cuentas
where ct_emp= 70 and ct_cg = '440010101001' 


getGroupBookings


select t.*, t.rowid  from diag t where dg_emp = '70' and dg_plan = 'A' and dg_eje = 17 and dg_per = :per and dg_asi = :asi;


select * from diag where dg_emp = :company and dg_plan = 'A' and dg_eje = :eje and dg_per = 99


select dg_per, dg_asi, sum(decode(dg_dh, 'H', dg_imp,0)), sum(decode(dg_dh,'D',dg_imp, 0))
from diag
where dg_emp = :company and dg_plan = 'A' and dg_eje = :oldEje and dg_per between 0 and 12
group by dg_per, dg_asi
having sum(decode(dg_dh, 'H', dg_imp,0))-sum(decode(dg_dh,'D',dg_imp, 0)) != 0



select * 
from ccmaes
where cc_emp = 60 and cc_plan = 'A' and cc_eje = 18 and cc_tipo = 6


select *
from diag
where dg_emp = 60 and dg_plan = 'A' and dg_eje = 18 and dg_per = 1 and dg_asi = 4947
;


SELECT * 
FROM DIAG
WHERE dg_emp = 50 AND dg_plan = 'A' AND dg_eje = 18 AND dg_cg = '572010101007'
ORDER BY dg_per, dg_asi;


SELECT *
FROM DIAG
WHERE dg_emp = 70 AND dg_plan = 'A' AND dg_eje = 18 AND dg_per = 0 AND dg_asi = 1
ORDER BY dg_apu;

SELECT t.*, t.rowid
FROM cuentas t
WHERE ct_emp = :emp AND ct_plan = 'A' AND ct_eje = :eje AND ct_cg = :cg;

DELETE FROM cuentas WHERE rowid = 'AAAMmgAATAAANL1AAR';

COMMIT;



SELECT * FROM asto WHERE AS_TIPOL = 'IN';



SELECT * 
FROM DIAG
WHERE dg_emp = 70 AND dg_plan = 'A' AND dg_eje = 18 AND dg_per = 9 AND NOT EXISTS (
	SELECT 1 
	FROM asto
	WHERE 	as_emp = dg_emp
		AND as_plan = dg_plan
		AND as_eje = dg_eje
		AND as_per = dg_per
		AND as_asi = dg_asi
)


/**
 * Ingresa encabezado de facturas manuales... 
 */
INSERT INTO ASTO
SELECT dg_emp, dg_plan, dg_eje, dg_per, dg_asi, to_date('31-aug-18','DD-MON-YY'), 'D', 'SYSTEM', NULL, to_date('31-aug-18','DD-MON-YY'), 'IN' 
FROM DIAG
WHERE dg_emp = 60 AND dg_plan = 'A' AND dg_eje = 18 AND dg_per = 8 AND NOT EXISTS (
	SELECT 1 
	FROM asto
	WHERE 	as_emp = dg_emp
		AND as_plan = dg_plan
		AND as_eje = dg_eje
		AND as_per = dg_per
		AND as_asi = dg_asi
)
GROUP BY dg_emp, dg_plan, dg_eje, dg_per, dg_asi


auditAccounting2



SELECT *
FROM DIAG a
WHERE dg_emp = 70 AND dg_plan = 'A' AND EXISTS (
	SELECT 1
	FROM DIAG b
	WHERE b.dg_emp = b.dg_emp AND b.dg_plan = a.dg_plan AND b.dg_eje = a.dg_eje AND b.dg_per = a.dg_per AND b.dg_asi = a.dg_asi AND b.dg_cg = '600010101014'
)
ORDER BY dg_eje, dg_per, dg_asi, dg_apu;




/**
 * Pagos de facturas en multiples empresas.
 */
SELECT cc_factura
FROM ccmaes
WHERE cc_eje = 18 AND cc_per >= 8
GROUP BY cc_factura
HAVING count(UNIQUE cc_emp) > 1;

COMMIT;


/**
 * Borra apuntes que no están en diario y solo tienen encabezado
 */
DELETE FROM asto
WHERE as_eje = 18 AND as_per >=-  4 AND NOT EXISTS (
	SELECT 1
	FROM diag
	WHERE dg_emp = as_emp
		AND dg_plan = as_plan
		AND dg_eje = as_eje
		AND dg_per = as_per
		AND dg_asi = as_asi
)




/**
 * Checa si hay apuntes sin encabezado
 */
SELECT *
FROM DIAG
WHERE dg_eje = 18 AND dg_per >= 8 AND NOT EXISTS (
	SELECT 1
	FROM ASTO
	WHERE as_emp = DG_EMP
		AND as_plan = DG_PLAN
		AND as_eje = DG_EJE
		AND as_per = DG_PER
		AND as_asi = DG_ASI
)


CREATE TABLE aa
AS SELECT * 
FROM CCMAES
WHERE cc_tipo = 1 AND cc_factura IN (SELECT invoice FROM oo)
ORDER BY cc_emp, cc_plan, cc_eje, cc_per, cc_asi;



SELECT *
FROM aa

DROP TABLE aa;



CREATE table aa
AS SELECT *
FROM CCMAES
WHERE cc_emp = 50 AND cc_tipo = 1 AND cc_factura IN ( SELECT invoice FROM oo)
ORDER BY cc_emp, cc_plan, cc_eje, cc_per, cc_asi



SELECT * FROM ccmaes a
WHERE EXISTS ( SELECT 1 FROM aa b WHERE a.cc_emp = b.cc_emp AND a.cc_plan = b.cc_plan AND a.cc_eje = b.cc_eje AND a.cc_per = b.cc_per AND a.cc_asi = b.cc_asi)
ORDER BY cc_emp, cc_plan, cc_eje, cc_per, cc_factura


UPDATE ccmaes a
SET cc_emp = 60
WHERE EXISTS ( SELECT 1 FROM aa b WHERE a.cc_emp = b.cc_emp AND a.cc_plan = b.cc_plan AND a.cc_eje = b.cc_eje AND a.cc_per = b.cc_per AND a.cc_asi = b.cc_asi)



UPDATE DIAG
SET dg_emp = 60
WHERE EXISTS ( SELECT 1 FROM aa WHERE dg_emp = cc_emp AND dg_plan = cc_plan AND dg_eje = cc_eje AND dg_per = cc_per AND dg_asi = cc_asi)


UPDATE asto
SET as_emp = 60
WHERE EXISTS ( SELECT 1 FROM aa WHERE as_emp = cc_emp AND as_plan = cc_plan AND as_eje = cc_eje AND as_per = cc_per AND as_asi = cc_asi)










SELECT *
FROM ccmaes a
WHERE a.cc_emp = 50 AND a.cc_tipo = 1 AND a.cc_factura IN (SELECT invoice FROM oo) AND 
EXISTS ( SELECT 1 FROM ccmaes b WHERE b.cc_emp = 60 AND a.cc_plan = b.cc_plan AND a.cc_eje = b.cc_eje AND a.cc_per = b.cc_per AND a.cc_asi = b.cc_asi  )




SELECT *
FROM DIAG
WHERE EXISTS (
	SELECT 1
	FROM CCMAES
	WHERE cc_factura IN (SELECT invoice FROM oo)
		AND dg_emp = cc_emp
		AND dg_plan = cc_plan
		AND dg_eje = cc_eje
		AND dg_per = cc_per
		AND dg_asi = cc_asi	
)
ORDER BY dg_doc, dg_per, dg_asi


ROLLBACK;



SELECT t.*, t.rowid
FROM asto t 
WHERE t.as_emp = 60 AND as_plan = 'A' AND as_eje = 18 AND as_per = 8 AND as_asi IN (20035,20005,20020,20031,20032,20033)




COMMIT;



UPDATE CCMAES a
SET cc_emp = 40


UPDATE ccmaes a
SET cc_emp = 60
WHERE EXISTS ( 
	SELECT 1 
	FROM tt b
	WHERE a.cc_emp = 40 AND a.cc_plan = b.cc_plan AND  a.cc_eje = b.cc_eje AND a.cc_per = b.cc_per AND a.cc_asi = b.cc_asi AND a.cc_tipo = b.cc_tipo
)


UPDATE diag
SET dg_emp = 60 
WHERE EXISTS ( SELECT 1 FROM tt WHERE dg_emp = 40 AND dg_plan = cc_plan AND dg_eje = cc_eje AND dg_per = cc_per AND dg_asi = cc_asi)
;




SELECT * 
FROM diag 
WHERE EXISTS ( SELECT 1 FROM tt WHERE dg_emp = cc_emp AND dg_plan = cc_plan AND dg_eje = cc_eje AND dg_per = cc_per AND dg_asi = cc_asi)
;


SELECT * 
FROM asto 
WHERE EXISTS ( SELECT 1 FROM tt WHERE as_emp = cc_emp AND as_plan = cc_plan AND as_eje = cc_eje AND as_per = cc_per AND as_asi = cc_asi)
;




SELECT count(*) FROM tt;


SELECT *
FROM tt a
WHERE EXISTS (
	SELECT 1 FROM diag b
	WHERE  b.dg_emp = 40 AND b.dg_plan = a.cc_plan AND b.dg_eje = a.cc_eje AND b.dg_per = a.cc_per AND b.dg_asi = a.cc_asi
)


SELECT * FROM tt;



SELECT *
FROM CCMAES
WHERE cc_emp = 40 AND cc_tipo = '1'
ORDER BY cc_per, cc_asid


SELECT *
FROM Diag
WHERE dg_emp = 60 AND dg_plan = 'A' AND dg_eje = 18 AND dg_per = 9 AND dg_cg = '572010101007';


SELECT *
FROM diag
WHERE dg_emp = 60 AND dg_plan = 'A' AND dg_eje = 18 AND dg_per = 9 AND dg_asi = 1014



--CREATE table oo as
SELECT *
FROM ccmaes
WHERE cc_emp = 60 AND cc_plan = 'A' AND cc_eje = 18 AND cc_per >= 7 AND cc_tipo = 1 AND cc_factura LIKE '400%' and cc_importe = cc_saldo
ORDER BY cc_emp, cc_plan, cc_eje, cc_per, cc_asi


SELECT * 
FROM oo;


UPDATE ccmaes a
SET cc_emp = 40
WHERE a.cc_emp = 60 AND EXISTS (
	SELECT 1
	FROM oo b
	WHERE  	b.cc_emp = a.cc_emp
		AND b.cc_plan = a.cc_plan
		AND b.cc_eje = a.cc_eje
		AND b.cc_per = a.cc_per
		AND b.cc_asi = a.cc_asi
);


SELECT *
FROM diag 
WHERE dg_emp = 60 AND EXISTS (
	SELECT 1
	FROM oo
	WHERE dg_emp = cc_emp
		AND dg_plan = cc_plan
		AND dg_eje = cc_eje
		AND dg_per = cc_per
		AND dg_asi = cc_asi
)
ORDER BY dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_apu



update diag
SET dg_emp = 40
WHERE dg_emp = 60 AND EXISTS (
	SELECT 1
	FROM oo
	WHERE dg_emp = cc_emp
		AND dg_plan = cc_plan
		AND dg_eje = cc_eje
		AND dg_per = cc_per
		AND dg_asi = cc_asi
)


SELECT *
FROM asto 
WHERE as_emp = 60 AND EXISTS (
	SELECT 1
	FROM oo
	WHERE as_emp = cc_emp
		AND as_plan = cc_plan
		AND as_eje = cc_eje
		AND as_per = cc_per
		AND as_asi = cc_asi
)
ORDER BY as_emp, as_plan, as_eje, as_per, as_asi



update asto
SET as_emp = 40
WHERE as_emp = 60 AND EXISTS (
	SELECT 1
	FROM oo
	WHERE as_emp = cc_emp
		AND as_plan = cc_plan
		AND as_eje = cc_eje
		AND as_per = cc_per
		AND as_asi = cc_asi
)



COMMIT;

SELECT *
FROM ASTO
WHERE AS_EMP = :emp AND AS_PLAN = :plan AND as_eje = :eje AND as_per = :per AND as_asi = :asi;


SELECT *
FROM CCMAES
WHERE cc_emp = 30 AND cc_plan = 'A' AND cc_eje = 18 AND cc_per >= 6 AND  NOT EXISTS (
	SELECT 1
	FROM diag
	WHERE dg_emp = cc_emp
		AND dg_plan = cc_plan
		AND dg_eje = cc_eje
		AND dg_per = cc_per
		AND dg_asi = cc_asi
)
ORDER BY cc_emp, cc_plan, cc_eje, cc_per, cc_asi


COMMIT;

ROLLBACK;

--DELETE 
SELECT a.*, a.rowid
FROM Diag a
WHERE dg_emp = 50 AND dg_plan = 'A' AND dg_eje = 18 AND EXISTS (
	SELECT 1
	FROM diag b
	WHERE b.dg_emp = a.dg_emp
		AND b.dg_plan = a.dg_plan
		AND b.dg_eje = a.dg_eje
		AND b.dg_per = a.dg_per
		AND b.dg_asi = a.dg_asi
		AND b.dg_cg = '437010401387'
)
ORDER BY dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_apu



SELECT *
FROM ccmaes a
WHERE cc_emp = 50 AND cc_plan = 'A' AND cc_eje = 18 AND cc_tipo = '6' AND NOT EXISTS (
	SELECT 1
	FROM ccmaes b
	WHERE a.cc_emp = b.cc_emp
		AND a.cc_plan = b.cc_plan
		AND a.cc_numero = b.cc_numero
		AND b.cc_tipo = '7'
)


SELECT *
FROM ccmaes
WHERE cc_emp = 30 AND cc_plan = 'A' AND cc_eje = 18 AND cc_cuenta = '430020101142'
ORDER BY cc_factura ASC, cc_tipo asc;

SELECT sum(cc_saldo)
FROM ccmaes
WHERE cc_emp = 40 AND cc_tipo = 7 AND cc_saldo > 0 AND substr(cc_cuenta,6,2) = '03';


SELECT *
FROM rinvoice
WHERE to_char(in_arrival,'MM') = '08' AND to_char(in_depart-1,'MM') = '09' AND in_inv_num IS NULL;


SELECT t.rowid, t.*
FROM rsoperator t
WHERE op_name LIKE 'DESPE%';


select * 
from rsmaes where ma_reserv = '706261'
;


select t.*, t.rowid 
from numeros t
where nm_emp = 55 and nm_plan = 'A' and nm_eje = 19;

COMMIT;






SELECT t.*, t.rowid
FROM rshotel t 
WHERE ho_hotel = '05';


select * from numeros where nm_emp = 55;



select *
from banoas;

select * from bancos;



select unique in_empresa, in_divisa
from rinvoice
where in_empresa != 55 and in_inv_num in (
'5012006212','5012006213','5012006214','5013002857','5013002858','5013002859','5013002867','5005002859','5009005714','5014001708','5005002867','5012006252','5013002877','5013002884','5014001749','5014001788','5014001789','5014001790','5012006291','5012006292','5013002897','5005002905','5005002906','5012006322','5013002910','5013002911','5014001880'
)


--select unique in_empresa
update rInvoice
set in_empresa = 55
where in_divisa = 'MEX' and in_inv_num in (
'5012006212','5012006213','5012006214','5013002857','5013002858','5013002859','5013002867','5005002859','5009005714','5014001708','5005002867','5012006252','5013002877','5013002884','5014001749','5014001788','5014001789','5014001790','5012006291','5012006292','5013002897','5005002905','5005002906','5012006322','5013002910','5013002911','5014001880'
)


select unique cc_emp
from ccmaes
where cc_factura in (
'5012006212','5012006213','5012006214','5013002857','5013002858','5013002859','5013002867','5005002859','5009005714','5014001708','5005002867','5012006252','5013002877','5013002884','5014001749','5014001788','5014001789','5014001790','5012006291','5012006292','5013002897','5005002905','5005002906','5012006322','5013002910','5013002911','5014001880'
);

select *
from diag
where dg_int in (
'5005002169','5012004737','5012004738','5013002060','5013002061','5004004625','5005002192','5005002196','5005002197','5005002198','5008000855','5009004643','5012004763'
);



select in_wholes, in_empresa, in_divisa
from rinvoice
where in_inv_num in (
'5002014230','5002014678','5006004192','5002014822','5002014823','5002014824','5002014829','5014000947','5005002700','5012005858','5012005859','5013002701','5013002706','5013002707','5013002708','5013002709','5012005893','5014001053'
)
order by 1,2,3;


update ccmaes
set cc_moneda = 'MXN'
where cc_emp = 55;



update ccmaes
set cc_emp = 55 , cc_moneda = 'MXN'
where cc_factura in (
'5012005205','5012005206','5012005207','5013002408','5009005054','5012005231','5012005232','5012005233','5012005234','5014000038','5014000039','5014000040','5014000041' 
) 
 
update diag 
set dg_emp = 55
 where exists (
    select 1
    from ccmaes
    where cc_factura in (
'5012005205','5012005206','5012005207','5013002408','5009005054','5012005231','5012005232','5012005233','5012005234','5014000038','5014000039','5014000040','5014000041'
  )
        and dg_emp = cc_emp
        and dg_plan = cc_plan
        and dg_eje = cc_eje
        and dg_per = cc_per
        and dg_asi = cc_asi
 )
 
 
update rinvoice
set in_empresa = 55
where in_divisa = 'MEX' and in_inv_num in (
'5009004696','5013002218','5013002226'
) 
 
 
update asto 
set as_emp = 55
 where exists (
    select 1
    from ccmaes
    where cc_factura in (
'5012005205','5012005206','5012005207','5013002408','5009005054','5012005231','5012005232','5012005233','5012005234','5014000038','5014000039','5014000040','5014000041'
  )
        and as_emp = cc_emp
        and as_plan = cc_plan
        and as_eje = cc_eje
        and as_per = cc_per
        and as_asi = cc_asi
 )


select *
from asto
where as_emp = 50 and as_plan = 'A' and as_eje = 19 and not exists (
select 1
from diag
where   dg_emp = as_emp
    and dg_plan = as_plan
    and dg_eje = as_eje
    and dg_per = as_per
    and dg_asi = as_asi
);





 executeauditAccounting2('80','01-jan-19');
 
 
 rinvoice_pckg
 
 
 select t.*, t.rowid
 from numeros t
where nm_emp = 81 and nm_eje = 19;

select *
from diag
where dg_emp = 81 and dg_eje = 19 and dg_per = 9 and dg_asi between 81380 and 81405;

update diag
set dg_per = 10 
where dg_emp = 81 and dg_eje = 19 and dg_per = 9 and dg_asi between 81380 and 81405;

select *
from ccmaes
where cc_emp = 81 and cc_eje = 19 and cc_per = 9 and cc_asi between 81380 and 81405;

update ccmaes
set cc_per = 10
where cc_emp = 81 and cc_eje = 19 and cc_per = 9 and cc_asi between 81380 and 81405;

select *
from asto
where as_emp = 81 and as_eje = 19 and as_per = 9 and as_asi between 81380 and 81405;

update asto 
set as_per = 10
where as_emp = 81 and as_eje = 19 and as_per = 9 and as_asi between 81380 and 81405;



select *
from ccmaes
where ;

update ccmaes
set cc_moneda = 'MXN'
where cc_emp = 55;


select t.*, t.rowid
from email t;

select t.*, t.rowid  from ccmaes t where  cc_emp = :emp and cc_plan = 'A' and cc_eje= :eje and cc_tipo = '7' order by cc_apu;



-- Payments and Prepayments in Balance.
select *
from ccmaes a
where cc_emp = :emp and cc_plan = :plan and cc_cuenta = :cuenta and cc_tipo = 7 and 
cc_importe - (select sum(cc_importe) from ccmaes b where b.cc_emp = a.cc_emp and b.cc_plan = a.cc_plan and a.cc_numero = b.cc_numero and b.cc_tipo <> 7) != cc_saldo
;
 
 


auditAccounting2