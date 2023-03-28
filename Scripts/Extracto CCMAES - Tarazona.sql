





select cc_emp, cc_plan, cc_eje, cc_per, sum(cc_importe)
from ccmaes
where   cc_emp =50 
    and cc_plan ='A' 
    and cc_eje = 18 
    and cc_tipo = 1
    --and substr(cc_cuenta,6,2) != '04'
group by cc_emp, cc_plan, cc_eje, cc_per
order by cc_per, cc_emp;


select cc_emp, cc_plan, cc_eje, cc_per, sum(cc_importe)
from ccmaes
where cc_emp in (30,60) and cc_plan = 'A' and cc_eje = 18 and cc_tipo = 1 and substr(cc_cuenta,6,2) != '04'
group by cc_emp, cc_plan, cc_eje, cc_per
order by cc_per, cc_emp;



select cc_emp, cc_plan, cc_eje, cc_per, cc_cuenta, ct_desc, cc_factura, cc_feccon, cc_asi, cc_apu, cc_importe, cc_saldo
from ccmaes, cuentas
where   cc_emp = '50'
        and cc_plan = 'A' 
        and cc_eje = 18 
        and cc_per = :per
        and substr(cc_cuenta,6,2) != '04'
        and cc_tipo = 1
        and ct_emp = cc_emp
        and ct_plan = cc_plan
        and ct_eje = cc_eje
        and ct_cg = cc_cuenta
order by cc_emp, cc_factura;





select *
from rsoperator
order by op_name;


select *
from rsopecharter
order by oc_operator;

select ch_charter, ch_hotel, ch_acc_prod, ch_acc_inv
from rscharter
where nvl(ch_pri_inv,'N') = 'Y' and ch_acc_prod is not null
order by ch_charter, ch_hotel
;

select *
from rshotel
where nvl(ho_activ,'N') = 'Y'
order by ho_hotel;



select oa_market, ccmaes.*
from ccmaes, oasAging_aux
where cc_emp = 30 
    and cc_plan = 'A' 
    and cc_tipo = 1 
    and cc_saldo != 0
    and cc_cuenta like oa_account||'%'
    and oa_market = 'SOUTH AMERICA'
    ;


select *
from diag
where dg_emp = 30 and dg_plan = 'A' and dg_eje = 19 and dg_cg = '437010301042';


select *
from ccmaes where cc_emp = 30 and cc_plan = 'A' and cc_eje = 19 and cc_per = 1 and cc_cuenta in (
'437010201022',
'437010301041',
'437010301042',
'437010401347',
'437010401378',
'437010401389',
'437010401391',
'437010401403'
);



select cc_emp, cc_plan, cc_eje, cc_per, cc_cuenta, cc_factura, cc_fecmov, cc_tipo, cc_asi, cc_numero, cc_importe, cc_saldo, nvl(cc_moneda,'USD'), getTOData(cc_factura,'1') to_name, getTOData(cc_factura,'2') to_address1, getTOData(cc_factura,'2') to_address2, getTOData(cc_factura,'3') to_address3, getTOData(cc_factura,'4') to_country
from ccmaes
where cc_emp = 30 and cc_plan = 'A' and cc_eje = 19 and cc_per = 1;





select dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_doc, dg_imp
from diag
where dg_emp = 60 and dg_plan = 'A' and dg_eje = 18 and dg_per = 8 and dg_cg like '700%' and dg_dh = 'H' 
minus 
select cc_emp, cc_plan, cc_eje, cc_per, cc_asi, cc_factura, cc_importe
from ccmaes
where cc_emp = 60 and cc_plan = 'A' and cc_eje = 18 and cc_per = 8 and cc_tipo = 1
;


select *
from ccmaes
where cc_emp = 60 and cc_plan ='A' and cc_eje = 18 and cc_factura = :factura and cc_tipo =1;


select in_a_room, in_a_coop, in_a_total
from rinvoice
where in_inv_num = :factura;















create or replace function getTOData(invoiceNumber in varchar2, dataID in varchar2) return varchar2 is 
cursor c1 is 
select *
from rinvoice
where in_inv_num = invoiceNumber;

cursor c2 (xCharter varchar2) is 
select b.*
from rsopecharter a, rsoperator b
where   oc_charter = xCharter
    and op_id = oc_operator;

vc1     c1%rowtype;
vc2     c2%rowtype;
begin
    open c1;
    fetch c1 into vc1;
    if c1%notfound then
        close c1;
        return '';
    end if;
    close c1;
    
    open c2(vc1.in_wholes);
    fetch c2 into vc2;
    close c2;
    
    case dataID 
        when '1' then return vc2.op_name;
        when '2' then return vc2.op_address_1;
        when '3' then return vc2.op_address_2;
        when '4' then return vc2.op_country;
        else return '';
    end case;
end;
/