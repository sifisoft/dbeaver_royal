

-- Apuntes con cuenta incorrecta 700
select * from rsbyEmpresa_invoicing where re_empresa = 83 and re_market = 'XXX'

select * from diag where dg_emp = 40 and dg_eje = 21 and dg_cg like '700%' and  dg_per between 1 and 12 and substr(dg_cg,6,2) is null


    

-- Refresh Reporte Real Invoicing.
delete from rsbyEmpresa_invoicing where re_empresa = :empresa and re_month = :myDate;

insert into rsbyEmpresa_invoicing
(re_empresa, re_market, re_hotel, re_charter, re_month, re_total, re_adjustment, re_advertising)
select 
        dg_emp,
        case
        when dg_cg like '657%' then
            case
                when dg_cg like '_______01%' then 'USA'
                when dg_cg like '_______02%' then 'CAN'
                when dg_cg like '_______03%' then 'EUR'
                when dg_cg like '_______04%' then 'SUD'
                else 'YYY'
            end
        else
            case
                when dg_cg like '_____01%' then 'USA'
                when dg_cg like '_____02%' then 'CAN'
                when dg_cg like '_____03%' then 'EUR'
                when dg_cg like '_____04%' then 'SUD'
                when dg_cg like '_____06%' then 'MEX'
                else 'XXX'
            end
        end  market,
       nvl(ho_hotel,'01'),
       ct_desc,
       :myDate,
       sum(case when dg_cg like '700%' and dg_dh = 'H' then dg_imp else 0 end) ,
       sum(case when dg_cg like '700%' and dg_dh = 'D' then dg_imp else 0 end) ,
       sum(case when dg_cg like '657%' and dg_dh = 'D' then dg_imp else 0 end)
from diag, cuentas, rshotel
where   --dg_emp in ('80','81','82','83','40') and 
        dg_emp = :empresa
    and dg_plan ='A'
    and dg_eje = to_char(:myDate,'YY')
    and dg_per = to_char(:myDate,'MM')
    and (dg_cg like '700%' or dg_cg like '657%')
    and ct_emp = dg_emp
    and ct_plan = dg_plan
    and ct_eje = dg_eje
    and ct_cg = dg_cg
    and ho_accounting_code(+) = substr(dg_cg,4,2)
    and nvl(ho_activ(+),'N') = 'Y'
group by
        dg_emp,
        case
        when dg_cg like '657%' then
            case
                when dg_cg like '_______01%' then 'USA'
                when dg_cg like '_______02%' then 'CAN'
                when dg_cg like '_______03%' then 'EUR'
                when dg_cg like '_______04%' then 'SUD'
                else 'YYY'
            end
        else
            case
                when dg_cg like '_____01%' then 'USA'
                when dg_cg like '_____02%' then 'CAN'
                when dg_cg like '_____03%' then 'EUR'
                when dg_cg like '_____04%' then 'SUD'
                when dg_cg like '_____06%' then 'MEX'
                else 'XXX'
            end
        end,
       nvl(ho_hotel,'01'),
       ct_desc,
       :myDate
order by 1,2,3
;




-- Solo USA y CAN (Reporte Tarazona).
select dg_emp company, dg_plan plan, dg_eje year, dg_per period, ct_cg account, ct_desc tour_operator, dg_doc invoice, dg_fdoc invoice_date, dg_asi entry, dg_apu line, dg_imp total
from diag, cuentas
where dg_emp = :empresa and dg_plan ='A' and dg_eje = 21 and dg_per between 1 and 12 and dg_cg like '700%' and dg_dh = 'H'  
    --and (dg_cg like '_____01%' or dg_cg like '_____02%')
    and ct_emp = dg_emp
    and ct_plan = dg_plan
    and ct_eje = dg_eje
    and ct_cg = dg_cg 
order by dg_per, dg_asi, dg_apu;



-- Facturas manuales para Dreams, Sunscape, Noecu
select * from diag where dg_emp = :empresa and dg_plan = 'A' and dg_eje = 19 and dg_per = :mes and dg_asi  in 
(
select to_char(dg_asi) from diag where dg_emp = :empresa and dg_plan = 'A' and dg_eje = 19 and dg_per = :mes and dg_cg like '700%' and dg_dh = 'H'
minus 
select to_char(in_entry) from rinvoice_dreams where in_emp = :empresa and in_eje = 19 and in_per = :mes
)
order by dg_asi





select sum(dg_imp)
from diag
where dg_emp = 82 and dg_plan ='A' and dg_eje = 19 and dg_per = 6 and dg_dh = 'H' and dg_cg like '700%';




select a.re_month, to_char(round(sum(nvl(a.re_total,0)),0),'999999999999990'),  to_char(round(sum(nvl(a.re_adjustment,0)),0),'999999999999990'),  to_char(round(sum(nvl(a.re_advertising,0)),0),'999999999999990'),  to_char(round(sum(nvl(a.re_total,0) - nvl(a.re_adjustment,0) - nvl(a.re_advertising,0)  ),0),'999999999999990')  
from Rsbyempresa_invoicing a  
where a.re_empresa = '82' 
    --and a.re_hotel in ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24')  
    and a.re_month between   to_date('11/01/19','MM/dd/yy') and  to_date('11/01/19','MM/dd/yy')  
group by  a.re_month  order by 2,3




select *
from travuserhotel;

select t.*, t.rowid 
from rshotel_report t
order by hr_id;


select * from empresas;






