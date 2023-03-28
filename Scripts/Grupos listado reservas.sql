


select *
from rsmaes
where ma_charter like 'GROUP%';


select *
from rsconhed
where ch_charter like 'GROUPS%';


select *
from rscharter
where ch_charter like 'GROUPS%';

select * 
from rsavailable_sum_trg 
where av_charter like '%GROU%'  and av_date between '01-jan-21' and '31-jan-21';

select * 
from rscharter 
where ch_name = 'GROUPS ATLANTA';

select * 
from rsoperator
where op_name = 'GROUPS ATLANTA';

select *
from rsopecharter
where oc_operator = 'GROUPS'


select ma_hotel, ma_charter, ma_arrival, ma_depart, count(*), sum(ma_due_tot) 
from rsmaes
where   ma_depart >= '01-jan-21' 
    and ma_arrival < '01-jan-22'
    and ma_can_d is null
    and ma_can_u is null
    and exists (
        select 1
        from rsopecharter
        where oc_operator = 'GROUPS' 
            and oc_charter = ma_charter
    )
group by ma_hotel, ma_charter, ma_arrival, ma_depart    
order by ma_hotel, ma_charter, ma_arrival, ma_depart