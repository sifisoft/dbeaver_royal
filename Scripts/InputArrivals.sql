
insert into rsinput_statistics
select 
    ma_hotel,
    trunc(ma_inp_d),
    ma_charter,
    decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl),
    sum(decode(to_char(:fecha,'mmyyyy'), to_char(ma_arrival,'mmyyyy'),1,0) ) a,
    sum(decode(to_char(add_months(:fecha,1),'mmyyyy'), to_char(ma_arrival,'mmyyyy'),1,0) ) b,
    sum(decode(to_char(add_months(:fecha,2),'mmyyyy'), to_char(ma_arrival,'mmyyyy'),1,0) ) c,
    sum(decode(to_char(add_months(:fecha,3),'mmyyyy'), to_char(ma_arrival,'mmyyyy'),1,0) ) d,
    sum(decode(to_char(add_months(:fecha,4),'mmyyyy'), to_char(ma_arrival,'mmyyyy'),1,0) ) e,
    sum(decode(to_char(add_months(:fecha,5),'mmyyyy'), to_char(ma_arrival,'mmyyyy'),1,0) ) f,
    sum(decode(to_char(add_months(:fecha,6),'mmyyyy'), to_char(ma_arrival,'mmyyyy'),1,0) ) g,
    sum(decode(to_char(add_months(:fecha,7),'mmyyyy'), to_char(ma_arrival,'mmyyyy'),1,0) ) h,
    sum(decode(to_char(add_months(:fecha,8),'mmyyyy'), to_char(ma_arrival,'mmyyyy'),1,0) ) i,
    sum(decode(to_char(add_months(:fecha,9),'mmyyyy'), to_char(ma_arrival,'mmyyyy'),1,0) ) j,    
    sum(decode(to_char(add_months(:fecha,10),'mmyyyy'), to_char(ma_arrival,'mmyyyy'),1,0) ) k,
    sum(decode(to_char(add_months(:fecha,11),'mmyyyy'), to_char(ma_arrival,'mmyyyy'),1,0) ) l
from rsmaes, rscharter
where ma_inp_d = trunc(:fecha)
  and ch_hotel = ma_hotel 
  and ch_charter = ma_charter
group by ma_hotel, trunc(ma_inp_d), ma_charter,    decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl)


execute kk9

delete from rsinput_statistics

select *  from rsinput_statistics
where in_date = trunc(sysdate-3)


select max(in_date) from rsinput_statistics


create table rsInput_statistics 
(
    in_hotel    varchar2(2),
    in_date     date,
    in_charter  varchar2(30),
    in_market   varchar2(8),
    in_1        number(4),
    in_2        number(4),
    in_3        number(4),
    in_4        number(4),
    in_5        number(4),
    in_6        number(4),
    in_7        number(4),
    in_8        number(4),
    in_9        number(4),
    in_10       number(4),
    in_11       number(4),
    in_12       number(4)
)
tablespace hotel
storage (initial 100M next 20M pctincrease 20)


select t.*, t.rowid
from travmenu t
order by optionid


desc refreshrsavailable_sum_trg


select m.trav_description, m.trav_order, a.in_date, 
        to_char(sum(nvl(a.in_1,0)),'999999999999990'),  
        to_char(sum(nvl(a.in_2,0)),'999999999999990'),  
        to_char(sum(nvl(a.in_3,0)),'999999999999990'),  
        to_char(sum(nvl(a.in_4,0)),'999999999999990'),  
        to_char(sum(nvl(a.in_5,0)),'999999999999990'),  
        to_char(sum(nvl(a.in_6,0)),'999999999999990'),  
        to_char(sum(nvl(a.in_7,0)),'999999999999990'),  
        to_char(sum(nvl(a.in_8,0)),'999999999999990'),  
        to_char(sum(nvl(a.in_9,0)),'999999999999990'),  
        to_char(sum(nvl(a.in_10,0)),'999999999999990'),  
        to_char(sum(nvl(a.in_11,0)),'999999999999990'),  
        to_char(sum(nvl(a.in_12,0)),'999999999999990')  
from Rsinput_statistics a, travmarkets m  
where   a.in_hotel in ('01','02','03','04','05','07','08','09','10','11','12')  and a.in_date between   to_date('12/11/2013','MM/dd/yy') and  to_date('12/11/2013','MM/dd/yy')
    and M.TRAV_MARKET = a.in_market  
group by  m.trav_description, m.trav_order, a.in_date  order by 2,3
