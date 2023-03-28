
select re_market, sum(re_total) 
from rsbyEmpresa_invoicing 
where re_empresa = 82 and re_month = '1-Mar-22'
group by re_market

delete from rsbyEmpresa_invoicing
where re_month between '01-jan-22' and '31-dec-22' --= trunc(:myMonth,'MONTH')
;

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
       trunc(:myMonth,'MONTH'),
       sum(case when dg_cg like '700%' and dg_dh = 'H' then dg_imp else 0 end) ,
       sum(case when dg_cg like '700%' and dg_dh = 'D' then dg_imp else 0 end) ,
       sum(case when dg_cg like '657%' and dg_dh = 'D' then dg_imp else 0 end)
from diag, cuentas, rshotel
where   --dg_emp in ('80','81','82','83','40') and
        dg_plan ='A'
    and dg_eje = to_char(:myMonth, 'YY')
    and dg_per = to_char(:myMonth, 'MM')
    and (dg_cg like '700%' or dg_cg like '657%')
    and ct_emp = dg_emp
    and ct_plan = dg_plan
    and ct_eje = dg_eje
    and ct_cg = dg_cg
    and ho_accounting_code(+) = substr(dg_cg,4,2)
    and nvl(ho_activ(+),'Y') = 'Y'
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
       trunc(:myMonth,'MONTH')
order by 1,2,3
;
























delete from rsbyinvoicing
where re_month = trunc(:myMonth,'MONTH')
;

insert into rsbyInvoicing
(re_market, re_hotel, re_charter, re_month, re_total, re_adjustment, re_advertising)
select
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
       ho_hotel,
       ct_desc,
       trunc(:myMonth,'MONTH'),
       sum(case when dg_cg like '700%' and dg_dh = 'H' then dg_imp else 0 end) ,
       sum(case when dg_cg like '700%' and dg_dh = 'D' then dg_imp else 0 end) ,
       sum(case when dg_cg like '657%' and dg_dh = 'D' then dg_imp else 0 end)
from diag, cuentas, rshotel
where   dg_emp in ('30','40','50','60')
    and dg_plan ='A'
    and dg_eje = to_char(:myMonth, 'YY')
    and dg_per = to_char(:myMonth, 'MM')
    and (dg_cg like '700%' or dg_cg like '657%')
    and ct_emp = dg_emp
    and ct_plan = dg_plan
    and ct_eje = dg_eje
    and ct_cg = dg_cg
    and ho_accounting_code(+) = substr(dg_cg,4,2)
    and nvl(ho_activ,'Y') = 'Y'
group by
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
       ho_hotel,
       ct_desc,
       trunc(:myMonth,'MONTH')
order by 1,2,3
;



select *
from diag
where dg_emp = :emp and dg_plan = 'A' 
    and dg_eje = to_char(:myMonth, 'YY')
    and dg_per between 1 and 12
    --and dg_per = to_char(:myMonth, 'MM')
    and (dg_cg like '700%' or dg_cg like '657%')
    and dg_cg not like '_____01%'
    and dg_cg not like '_____02%'
    and dg_cg not like '_____03%'
    and dg_cg not like '_____04%'
    and dg_cg not like '_____06%'
;