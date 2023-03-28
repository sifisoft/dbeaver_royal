

select * from freserva_hoteles where rv_reserva = '901282';

select count(*)
from rsavailable_sum_trg
where av_date = trunc(sysdate);

select unique av_market from rsavailable_sum_trg where av_date = trunc(sysdate) ;--and av_market = 'SUD';

select * from rsavailable_sum_trg where av_date = trunc(sysdate) and av_market = 'SUD'

select unique av_charter  from rsavailable_sum_trg_historic where av_market = 'SUD';

select * from rsavailable_monthly_view;


drop sequence rsavailable_sum_trg_hist_seq;

CREATE SEQUENCE RSAVAILABLE_SUM_TRG_HIST_SEQ;

EXECUTE SAVE_HISTORIC_RSAVAILABLE_SUM;


select * from rsavailable_sum_trg_historic;

select unique av_date from rsavailable_sum_trg_historic;

SELECT *
FROM RSAVAILABLE_SUM_TRG_HISTORIC;

delete from rsavailable_sum_trg_historic;

delete from rsavailable_monthly_view;


select nvl(op_short_name,op_name), trav_description, to_char(sum(nvl(av_total,0)),'999,999,999.00')
from rsavailable_sum_trg, travmarkets, rsoperator, rsopecharter
where trunc(av_date) between '01-jun-19' and '30-jun-19'
      and av_market_rn = trav_code
      and av_market_rn = 'USA'
      and oc_charter = av_charter
      and op_id = oc_operator
group by nvl(op_short_name,op_name),  trav_description
order by 1;



select av_hotel, av_date, av_charter, av_market_rn, count(*) 
from rsavailable_sum_trg 
where av_date between '01-jun-19' and '30-jun-19'
group by av_hotel, av_date, av_charter, av_market_rn
having count(*) > 1;


select * from travmarkets;


select sum(av_total)
from rsavailable_sum_trg
where av_date between '01-jul-19' and '31-jul-19';

select unique av_charter, av_charter_code
from rsavailable_sum_trg
where av_date >= '01-jan-19' and av_market in ('USA','CAN','EUR','SUD') and  
not exists (
    select 1
    from rsopecharter
    where oc_charter = av_charter
);
    
    
select *
from travmarkets;    



select *
from rshotel 
where ho_hotel not in (
    select to_number(hotelid)
    from travuserhotel
    where userid = 'pcarrera'
) ;


select *
from travuserhotel
where optionid = 17;

select * from rshotel;

select *
from travuserhotel
where userid = 'pcarrera';

select t.*, t.rowid
from rshotel_report t;


select nvl(o.op_short_name, op_name)
    , 1
    , trunc(a.av_date,'MONTH')
    ,   to_char(round(sum(nvl(a.av_total,0))-sum(nvl(a.av_adj,0)),0),'999999999999990')
    ,  to_char(round(sum(nvl(a.av_adult,0)),0),'999999999999990')
    ,  to_char(round( (sum(nvl(a.av_total,0))-sum(nvl(a.av_adj,0))) /decode(sum(a.av_res),0,1,sum(a.av_res)),0),'999999999999990.09')
    ,  to_char(round(sum(nvl(a.av_res,0)),0),'999999999999990')
    ,  to_char(round(sum(nvl(a.av_adj,0)),0),'999999999999990')
    ,  to_char(round(sum(nvl(a.av_adv,0)),0),'999999999999990')  
 from Rsavailable_sum_trg a, Rsopecharter c, Rsoperator o  
 where --a.av_hotel in ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24')  
    trunc(a.av_date,'MONTH') between   to_date('06/01/19','MM/dd/yy') and  to_date('06/01/19','MM/dd/yy')  
    --and  nvl(a.av_market_rn,'USA') in (select trav_code from TravMarkets m where m.trav_description = 'USA' and m.trav_code not in('COR','USO'))
    and a.av_market = 'USA'  
    and  c.oc_charter = a.av_charter  
    and  o.op_id = c.oc_operator  
 group by  nvl(o.op_short_name,op_name), 1, trunc(a.av_date,'MONTH')  
 order by 1,3
 
 
 select unique av_hotel
 from Rsavailable_sum_trg_historic a
 where --a.av_hotel in ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24')  
    trunc(a.av_date,'MONTH') between   to_date('06/01/19','MM/dd/yy') and  to_date('06/01/19','MM/dd/yy')  
    and a.av_market = 'USA'
    --and av_hotel not in ('81')  
 