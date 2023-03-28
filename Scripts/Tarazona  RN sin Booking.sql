


select *
from rshotel_report;

select to_char(av_date, 'MM') MONTH, to_char(sum(av_total),'999,999,999.00') PROD
from rsavailable_sum_trg
where av_market in ('USA') and av_date between '01-nov-21' and '30-nov-21'
    and not exists (
        select 1
        from rsopecharter
        where oc_charter = av_charter
            and oc_operator in ('BKINGAI','BOOKING','BOOKNGDI','BOKINGAI')
    )
group by to_char(av_date,'MM')    
order by 1;



select *
from rsavailable_sum_trg
where av_market in ('USA') and av_date between '01-nov-21' and '30-nov-21'
    and not exists (
        select 1
        from rsopecharter
        where oc_charter = av_charter
            and oc_operator in ('BKINGAI','BOOKING','BOOKNGDI','BOKINGAI')
    )
order by 1,2,3;




select *
from rsoperator 
where op_name like '%BOOKING%';