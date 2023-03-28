

execute DBMS_SNAPSHOT.REFRESH( 'rscharter','c');


select ch_utl, ch_market
from rscharter
where ch_charter in ( 
    select oc_charter from rsopecharter where oc_operator = 'BOKINGAI'
)
group by ch_utl, ch_market



 refreshrsavailable_sum_trg_mex
 
 
 
select *
from rsavailable_sum_trg
where av_charter = 'BKINLSTU';

select *
from rscharter
where ch_charter = 'BKINLSTU';


execute refreshrsavailable_sum_trg_mex(trunc(trunc(sysdate)-21,'MONTH'),last_day(add_months(trunc(sysdate),12)));


execute DBMS_SNAPSHOT.REFRESH( 'rsoperator, rscharter, rsopecharter, rshotel','c');
