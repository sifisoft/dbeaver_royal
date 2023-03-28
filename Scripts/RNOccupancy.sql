



refreshrsavailable_sum_trg_avalon;

refreshrsavailable_sum_trg_mex;

refreshrsavailable_sum_trg_inv;

rscharter

rsmaes_cielo



select t.*, t.rowid
from entidad_avalon_crs t
where mercado_avalon like 'DIR/DIR%';

update entidad_avalon_crs
set mercado_crs = 'DIR/DIR'
where mercado_avalon = 'DIR/DIR';
  

select *
from rshotel;

execute refreshrsavailable_sum_trg_avalon ('01-feb-23', '31-mar-23');


select count(*) from rsmaes_cielo where ma_arrival >= '01-jan-23' and ma_hotel = '06';


select * from rsmaes_cielo where ma_hotel  = '06' and ma_arrival >= '01-jan-23'



select *
from rsmaes_avalon
where ma_charter = 'CORTESIA FAMILY STE ' and ma_depart-1 >= '01-jan-23'



select t.*, t.rowid from travMarkets t;

select t.*, t.rowid from rshotel_report t order by hr_id;

select ho_avail,  t.*, t.rowid from rshotel t order by to_number(ho_hotel); 
select m.trav_description, m.trav_order, trunc(a.av_date,'MONTH'),
    to_char(round(sum(nvl(a.av_total,0)) - sum(nvl(a.av_adj,0)),0),'999999999999990'),  
    to_char(round(sum(nvl(a.av_adult,0)),0),'999999999999990'),  
    to_char(round( (sum(nvl(a.av_total,0)) - sum(nvl(a.av_adj,0)) ) /decode(sum(a.av_res),0,1,sum(a.av_res)),0),'999999999999990.09'),  
    to_char(round(sum(nvl(a.av_res,0)),0),'999999999999990'),  
    to_char(round(sum(nvl(a.av_adj,0)),0),'999999999999990'),  
    to_char(round(sum(nvl(a.av_adv,0)),0),'999999999999990')  
from Rsavailable_sum_trg a, travMarkets m 		
where   a.av_hotel in ('06') 
    and nvl(a.av_market_rn,'USA') not in (' CORTESIAS ') 
    and trunc(a.av_date,'MONTH') between to_date(:inicio) and to_date(:fin)
    and a.av_market_rn = m.trav_code
    and m.trav_code not in ('CORTESIAS') 
group by  m.trav_description, m.trav_order, trunc(a.av_date,'MONTH') 
order by 2,3;




select nvl(o.op_short_name, op_name), 1, trunc(a.av_date,'MONTH'),  
    to_char(round(sum(nvl(a.av_total,0))-sum(nvl(a.av_adj,0)),0),'999999999999990'),  
    to_char(round(sum(nvl(a.av_adult,0)),0),'999999999999990'),  
    to_char(round( (sum(nvl(a.av_total,0))-sum(nvl(a.av_adj,0))) /decode(sum(a.av_res),0,1,sum(a.av_res)),0),'999999999999990.09'),  
    to_char(round(sum(nvl(a.av_res,0)),0),'999999999999990'),   
    to_char(round(sum(nvl(a.av_adj,0)),0),'999999999999990'),  
    to_char(round(sum(nvl(a.av_adv,0)),0),'999999999999990')  
from Rsavailable_sum_trg a, Rsopecharter c, Rsoperator o   
where a.av_hotel in (:hotel) 
    and trunc(a.av_date,'MONTH') between to_date(:inicio) and to_date(:fin) 
    and  nvl(a.av_market_rn,'USA') in (select Trav_code from TravMarkets m where m.trav_description = :marketName and m.trav_code not in('CORTESIAS'))  
    and  c.oc_charter = nvl(a.av_charter_code, a.av_charter) 
    and  o.op_id = c.oc_operator 
group by  nvl(o.op_short_name,op_name), 1, trunc(a.av_date,'MONTH') 
order by 1,3 
;

select a.*, a.rowid
from rsavailable_sum_trg a
where av_hotel = '06'
    and av_date between :inicio and :fin
    and nvl(a.av_market_rn,'USA') in (select Trav_code from TravMarkets m where m.trav_description = :marketName and m.trav_code not in('CORTESIAS'))


select *
from rscharter
where ch_charter = 'CATIVA'

select * from rsmaes where ma_charter = 'CATIVA'

select t.*, t.rowid 
from rssegments t;

select unique ch_utl from rscharter;


select t.*, t.rowid 
from rsmarkets t;

select * from rsmaes where ma_reserv = '011050251';

select * from freserva_hoteles where rv_reserva = '011050251';

select * from rsavailable_sum_trg  where av_charter_code = 'SELHOTEL';

select * from rshotel;

select ch_hotel, ch_charter, ch_pri_inv,  ch_utl, ch_market 
from rscharter 
where ch_charter = 'DTURP1ET' 
order by ch_charter, ch_hotel;


select * from rsopecharter where oc_charter = 'FUNJPU9S';

select *  from rsoperator where op_id = 'FUNJET';

select * from rscharter where ch_charter = 'SELHOTEL';

select ch_hotel, ch_charter, ch_name, ch_pri_inv, ch_market
from rscharter 
where ch_market is null or ch_utl is null
order by ch_charter, ch_hotel


select unique ch_market
from rscharter;


select ch_hotel hotel, ch_charter to_code, ch_name TO_name, ch_pri_inv Invoice, ch_utl market, ch_acc_inv acc_invoice, ch_acc_prod acc_production, ch_inp_date input_date
from rscharter
where trunc(ch_inp_date) >= trunc(sysdate-5)
order by ch_charter, ch_hotel;



select * from ooo;


select * from zz;

drop table zz;

create table zz  (
    hotel   varchar2(2),
    charter varchar2(25),
    invoice varchar2(1),
    market  varchar2(3)
)


select *
from zz
where market = 'SUD';

update rscharter
set ch_market = 'SUD', ch_utl = 'SUD', ch_pri_inv = 'N'
where exists ( 
select 1
from zz
where hotel = ch_hotel
    and charter = ch_charter
    and market = 'SUD'
)



delete from zz where market is null;


select *
from rshotel




select * from cat where table_name like 'RSAVAILABLE_SUM_TRG%';

DELETE FROM RSAVAILABLE_SUM_TRG_AVALON_BCKSEP2022;

ALTER TABLE RSAVAILABLE_SUM_TRG_AVALON_BCKSEP2022 MODIFY AV_CHARTER VARCHAR2(50);

CREATE TABLE RSAVAILABLE_SUM_TRG_AVALON_BCKSEP2022_V2
AS SELECT * FROM RSAVAILABLE_SUM_TRG_AVALON
WHERE AV_DATE BETWEEN '01-SEP-22' AND '30-SEP-22';



create table rsIgnore_outrange_bookings
(
ig_avalon        varchar2(100),
ig_line          varchar2(4)
);

genAvalonOutOfRangeBookingsXLS


