

select  decode(ch_utl, 'EUR', 'EUR', decode(ch_country, 'US','USA','CA','CAN', ch_utl))  in_market, in_wholes, in_arrival, in_depart, in_reserv, in_voucher, in_nites, in_adult, in_child, in_room, in_a_total, in_inv_Num, in_inv_date, in_period, in_ledger
from rinvoice, rscharter
where in_hotel = '04' and in_inv_num is not null and ch_hotel = in_hotel and ch_charter = in_wholes and in_ejercicio = 12 and in_period in (5,6)
order by  in_period, 1,  in_wholes, in_arrival


select decode(ch_utl, 'EUR', 'EUR', decode(ch_country, 'US','USA','CA','CAN', ch_utl)) market , ma_charter, ma_arrival, ma_depart, ma_reserv, ma_nites, ma_adult, ma_child, ma_due_tot, ma_prev_hotel, ma_prev_reserv
from rsmaes , rscharter
where ma_hotel = '04' 
    and ma_depart between '01-may-12' and '01-jul-12' 
    and ma_can_d is null
    and ma_prev_hotel is not null 
    and ch_hotel = ma_hotel 
    and ch_charter = ma_charter 
    and ch_pri_inv = 'Y'  
    and not exists (
select 1
from rinvoice
where in_hotel  = ma_hotel
    and in_reserv = ma_reserv
)    
order by 1, ma_depart



select  in_hotel, 
        add_months(to_date('01'||'-'||in_period||'-'||in_ejercicio, 'dd-mm-yy'),0), 
        in_wholes, 
        sum(nvl(in_a_room,0)), 
        sum((in_adult+nvl(in_child,0))*in_nites) ,      
        sum(nvl(in_nites,0)),
        sum(in_adult*in_nites)                  ,
        decode(ch_utl, 'EUR', 'EUR', decode(ch_country, 'US','USA','CA','CAN', ch_utl)) ch_utl
from rinvoice , rscharter
where   in_ejercicio = to_char(add_months(trunc(sysdate-10),0),'YY') 
    and in_period = 5 
    and ch_hotel = in_hotel and ch_charter = in_wholes
    and in_hotel = '04'
group by  in_hotel, to_date('01'||'-'||in_period||'-'||in_ejercicio, 'dd-mm-yy'), in_wholes, 
        decode(ch_utl, 'EUR', 'EUR', decode(ch_country, 'US','USA','CA','CAN', ch_utl)) 
order by  8       
        




select unique ch_country
from rscharter


select * from rsoperator




select * 
from rshotel

select *
from rsbysegment



delete from rsbysegment
where by_month >= '01-MAY-12' and by_market in ('USA','CAN','EUR') AND BY_HOTEL = '04'
/

insert into rsbysegment 
select  in_hotel, 
        add_months(to_date('01'||'-'||in_period||'-'||in_ejercicio, 'dd-mm-yy'),0), 
        in_wholes, 
        sum(nvl(in_a_room,0)), 
        sum((in_adult+nvl(in_child,0))*in_nites) ,      
        sum(nvl(in_nites,0)),
        sum(in_adult*in_nites)                  ,
        decode(ch_utl, 'EUR', 'EUR', decode(ch_country, 'US','USA','CA','CAN', 'EUR')) ch_utl
from rinvoice , rscharter
where   in_ejercicio >= to_char(add_months(trunc(sysdate-10),0),'YY') 
    and in_period >= 5 
    and ch_hotel = in_hotel and ch_charter = in_wholes
    and in_hotel = '04'
group by  in_hotel, to_date('01'||'-'||in_period||'-'||in_ejercicio, 'dd-mm-yy'), in_wholes, 
        decode(ch_utl, 'EUR', 'EUR', decode(ch_country, 'US','USA','CA','CAN', 'EUR')) 
/


select *
from rsbysegment
where by_hotel = '04' and by_month = '01-may-12'
order by by_market

select unique ch_utl, ch_country, ch_market
from rscharter



select *
from rscharter
where ch_utl = 'AME' and ch_country = 'US' and ch_market = 'EUR'

select unique ch_charter, ch_country, ch_utl, ch_market
from rscharter
where ch_utl = 'EUR' and ch_country = 'US' and ch_market = 'EUR'
union
select unique ch_charter, ch_country, ch_utl, ch_market
from rscharter
where ch_utl = 'AME' and ch_country = 'ME' and ch_market = 'NAM'
union
select unique ch_charter, ch_country, ch_utl, ch_market
from rscharter
where ch_utl = 'AME' and ch_country = 'US' and ch_market = 'EUR'
order by ch_charter


select *
from rsoperator


select op_name, oc_charter
from rsopecharter , rsoperator
where oc_operator = op_id
order by op_name


select op_name
from rsoperator


select in_hotel, in_reser 
from rinvoice
where in_arrival < '01-may-12' and in_depart > '01-may-12' and in_hotel = '04'  and in_inv_num is not null and in_inv_num <> '0000000'



select *
from rsmaes
where ma_prev_hotel  = '04' and ma_can_d is null and ma_depart between '01-may-12' and '30-jun-12'





select unique ch_charter
from rsmaes, rscharter
where in_hotel = '04' and in_period = 6
    and ch_hotel = ma_hotel
    and ch_charter = ma_charter
and not exists (
    select 1
    from rsmaes
    where ma_hotel = '04' and ma_reserv = in_reserv and ma_depart between '01-may-12' and '31-may-12' and ma_can_d is null
)
--order by in_hotel, in_depart


select ma_reserv, ma_charter, ma_arrival, ma_depart, ma_nites, ma_due_tot, ma_prev_hotel, ma_prev_reserv, in_inv_num, in_period, in_ledger
from rsmaes, rscharter, rinvoice
where ma_hotel = '04' and trunc(ma_depart,'MONTH') = '01-jun-12' and ma_can_d is null and not exists ( select 1 from rinvoice where in_hotel = ma_hotel and in_reserv = ma_reserv and in_period = 6)
    and ch_hotel  = ma_hotel
    and ch_charter = ma_charter
    and ch_market in ('EUR','NAM')
    and in_hotel (+) = ma_hotel 
    and in_reserv(+) = ma_reserv
order by ma_prev_hotel     



select ma_reserv, ma_charter, ma_arrival, ma_depart, ma_nites, ma_due_tot, ma_prev_hotel, ma_prev_reserv
from rinvoice
where in_hotel = '04' and in_period = 6
and not exists (
    select 1
    from rsmaes
    where ma_hotel = '04' and ma_reserv = in_reserv and ma_depart between '01-jun-12' and '30-jun-12' and ma_can_d is null
)
order by in_hotel, in_depart


desc gds



select t.*, t.rowid 
from travmenu t
order by optionid


select t.*, t.rowid
from travuseroptions t
where optionid = 211


update travuseroptions
set optionid = 140
where optionid = 212