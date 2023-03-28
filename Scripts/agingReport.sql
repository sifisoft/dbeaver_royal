









select oa_market, 
        sum(decode(sign(trunc(sysdate)-trunc(cc_feccon)-15),-1, nvl(cc_saldo,0),0, nvl(cc_saldo,0),0)) oa_10, 
		sum(decode(sign(trunc(sysdate)-trunc(cc_feccon)-15), 1, decode(sign(trunc(sysdate)-trunc(cc_feccon)-30), -1, nvl(cc_saldo,0),0,nvl(cc_saldo,0),0),0))   oa_30,
		sum(decode(sign(trunc(sysdate)-trunc(cc_feccon)-30), 1, decode(sign(trunc(sysdate)-trunc(cc_feccon)-45), -1, nvl(cc_saldo,0),0,nvl(cc_saldo,0),0),0))   oa_45,
		sum(decode(sign(trunc(sysdate)-trunc(cc_feccon)-45), 1, decode(sign(trunc(sysdate)-trunc(cc_feccon)-60), -1, nvl(cc_saldo,0),0,nvl(cc_saldo,0),0),0))   oa_60,
		sum(decode(sign(trunc(sysdate)-trunc(cc_feccon)-60), 1, decode(sign(trunc(sysdate)-trunc(cc_feccon)-90), -1, nvl(cc_saldo,0),0,nvl(cc_saldo,0),0),0))   oa_90,
		sum(decode(sign(trunc(sysdate)-trunc(cc_feccon)-90),1, nvl(cc_saldo,0),0))  oa_m90, 
		sum(nvl(cc_saldo,0)) oa_total, 
            (select sum(nvl(cc_saldo,0)) 
			from ccmaes, oasAging_aux 
			where   cc_emp 	 = :company 
				and cc_plan = :plan 
				and cc_tipo in ('6','7') 
				and cc_factura = '0000000' 
				and	oa_market = d.oa_market 
				and oa_account like '437%' 
				and cc_cuenta like oa_account||'%'
            ) as payment 
from ccmaes, oasAging_aux d 
where   cc_emp   = :company
	and cc_plan   = :plan 
	and cc_cuenta like  d.oa_account||'%' 
	and cc_tipo = '1'                 
	and cc_factura <> '0000000' 
	and d.oa_market is not null 
	and d.oa_hotel is not null 
group by d.oa_market, oa_market 
having sum(nvl(cc_saldo,0)) > 0 
order by d.oa_market desc ;


select oa_market,
       cc_emp,
       cc_plan,
       cc_eje,
       cc_per,
       cc_asi,
       cc_apu,
       cc_factura,
       cc_cuenta,
       cc_importe,
       cc_saldo
from ccmaes, oasAging_aux d 
where   cc_emp   = :company
	and cc_plan   = :plan 
	and cc_cuenta like  d.oa_account||'%' 
	and cc_tipo = '1'                 
	and cc_factura <> '0000000' 
	and d.oa_market is not null 
	and d.oa_hotel is not null 
order by d.oa_market desc ;





select *
from oasaging_aux
order by substr(oa_hotel,4,2), oa_account;


select *
from ccmaes
where cc_emp = 83;



select unique substr(dg_cg,1,7)
from diag
where dg_eje >= 19 and (dg_cg like '430%' or dg_cg like '437%') and substr(dg_cg, 4,2) < 80 and 
not exists (
    select 1
    from oasaging_aux
    where oa_account = substr(dg_cg,1,7)
)
order by 1;




    select ccmaes.*
    from ccmaes,oasAging_aux, cuentas
    where   cc_emp    = 60
        and cc_plan   = 'A'
        and cc_eje > 0
        and cc_cuenta like  oa_account||'%'
        and cc_tipo  =  '1'                     -- Facturas
        and cc_factura <> '0000000'
        and oa_market = 'USA'
        and ct_emp = cc_emp
        and ct_plan = cc_plan
        and ct_eje  = cc_eje
        and ct_cg = cc_cuenta
        and cc_cuenta = '430120101014'
        and cc_saldo > 0
        and cc_feccon < trunc(sysdate-90)
    order by cc_emp, cc_plan, cc_eje, cc_per, cc_asi        
    
    
    
 
    select * from rinvoice where in_inv_num = '1200618'