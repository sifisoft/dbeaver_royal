

execute refreshrsavailable_sum_trg(trunc(sysdate-5,'MONTH'),last_day(add_months(sysdate,5)));

execute refreshrsavailable_trg(trunc(sysdate-5,'MONTH'),last_day(add_months(sysdate,5)));


execute refreshrsavailable_sum_trg_uso(trunc(sysdate-5,'MONTH'),last_day(add_months(sysdate,1)));

desc refreshrsavailable_sum_trg_uso

desc countDepartures

select sum(av_arrivals), sum(av_departures) from rsavailable_sum_trg_uso where av_date = '03-jan-13' and av_hotel = '02'


select * 
from all_objects
where object_type = 'FUNCTION'
order by created desc

desc getNightsOccupancy

select rv_mayorista, sum(getNightsOccupancy('FEB', rv_llegada, rv_salida)) RN
from freserva@cun_oc, frmodfas@cun_oc
where rv_status <> 'C' and rv_fase = mf_fase and mf_modulo = 2
group by rv_mayorista
order by 1

select rv_mayorista, sum(getNightsOccupancy('FEB', rv_llegada, rv_salida)) RN
from freserva@cun_op, frmodfas@cun_op
where rv_status <> 'C' and rv_fase = mf_fase and mf_modulo = 9
group by rv_mayorista
order by 1


select rv_mayorista, sum(getNightsOccupancy('FEB', rv_llegada, rv_salida)) RN
from freserva@cun_op, frmodfas@cun_op
where rv_status <> 'C' and rv_fase = mf_fase and mf_modulo = 12
group by rv_mayorista
order by 1


select rv_mayorista, sum(getNightsOccupancy('FEB', rv_llegada, rv_salida)) RN
from freserva@cun_ot, frmodfas@cun_ot
where rv_status <> 'C' and rv_fase = mf_fase and mf_modulo = 10
group by rv_mayorista
order by 1


select * from frmodfas@cun_ot


select * from rshotel




select rv_mayorista, sum(getNightsOccupancy('FEB', rv_llegada, rv_salida)) RN
from freserva_hoteles
where rv_hotel = 2 and nvl(rv_status,'X') <> 'C' and rv_salida between '01-FEB-13' and '01-MAR-13'
group by rv_mayorista

select * from frmodfas@cun_oc






select  
    a.av_hotel, 
    a.av_date, 
    to_char(a.av_date,'dd'), 
    to_char(a.av_date, 'DY'), 
    sum(case when b.trav_description='USA' then nvl(a.av_res,0) else 0 end), sum(case when b.trav_description='CANADA' then nvl(a.av_res,0) else 0 end), 
    sum(case when b.trav_description='EUROPE' then nvl(a.av_res,0) else 0 end), sum(case when b.trav_description='MEXICO' then nvl(a.av_res,0) else 0 end),
    sum(case when b.trav_description='SUDAMERICA' then nvl(a.av_res,0) else 0 end), sum(nvl(a.av_res,0)),  round(sum(nvl(a.av_res,0))*100/736),  
    sum(nvl(a.av_arrivals,0)), 
    sum(nvl(a.av_departures,0)) 
from Rsavailable_sum_trg_uso a, TravMarkets b  
where a.av_hotel in  ('02')  and a.av_date between to_date('01/01/2013','MM/dd/yy') and  to_date('01/31/2013','MM/dd/yy')  and b.trav_code = a.av_market 
 group by av_hotel, av_date
  order by av_hotel, av_date

select    a.av_date, 
            to_char(a.av_date,'dd'), 
            to_char(a.av_date, 'DY'), 
            sum(case when b.trav_description='USA' then nvl(a.av_res,0) else 0 end), 
            sum(case when b.trav_description='CANADA' then nvl(a.av_res,0) else 0 end), 
            sum(case when b.trav_description='EUROPE' then nvl(a.av_res,0) else 0 end), 
            sum(case when b.trav_description='MEXICO' then nvl(a.av_res,0) else 0 end), 
            sum(case when b.trav_description='SUDAMERICA' then nvl(a.av_res,0) else 0 end), 
            sum(nvl(a.av_res,0)),  round(sum(nvl(a.av_res,0))*100/1744),  
            sum(nvl(a.av_arrivals,0)), sum(nvl(a.av_departures,0))  
from Rsavailable_sum_trg_uso a, TravMarkets b  
where  a.av_hotel in  ('01','02')  
    and a.av_date between to_date('01/01/2013','MM/dd/yy') and  to_date('01/31/2013','MM/dd/yy')  
    and b.trav_code = a.av_market 
group  by av_date 
order by av_date




select av_market
from rsavailable_sum_trg_uso
where not exists ( select 1 from TravMarkets where trav_code = av_market)

select t.*, t.rowid
from TravMarkets t 


select * 
from cuentas
where ct_cg like '116%'  and ct_eje  = 12


select *
from ccmaes
where cc_factura = '1202139'