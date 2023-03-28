





execute DBMS_SNAPSHOT.REFRESH( 'rsoperator, rscharter, rsopecharter, rshotel','c');


select count(*)
from rscharter
where ch_utl != 'DIR' and  exists ( 
    select 1 from rsopecharter where oc_operator = 'BOKINGAI' and oc_charter = ch_charter
    )



select sum(av_total)
from rsavailable_sum_trg
where av_date between '01-may-21' and '31-may-21' and av_charter = 'BOOKING USA';

