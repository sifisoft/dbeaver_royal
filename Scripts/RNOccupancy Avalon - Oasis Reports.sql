




-- Avalon
execute refreshrsavailable_sum_trg_avalon(trunc(trunc(sysdate)-15,'MONTH'),last_day(add_months(trunc(sysdate),0)));

execute refreshrsavailable_trg_avalon(trunc(trunc(sysdate)-15,'MONTH'),last_day(add_months(trunc(sysdate),0)));


-- Facturacion

    -- actualizar Mayorista en rinvoice
update rinvoice
set in_mayorista = (select decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl) from rscharter where ch_hotel = in_hotel and ch_charter = in_wholes)
where in_mayorista is null and in_depart >= sysdate-90;

execute refreshrsavailable_sum_trg_inv(trunc(trunc(sysdate)-15,'MONTH'),last_day(trunc(sysdate)-15));

execute refreshrsavailable_trg_inv(trunc(trunc(sysdate)-15,'MONTH'),last_day(trunc(sysdate)-15));




-- Habitación para determinal el hotel
select * from habitacion_avalon_crs order by hotel;

-- Habitaciones no categorizadas de Avalon,  no se podrá obtener el Hotel correspondiente.. 
select unique ma_room 
from rsmaes_avalon 
where ma_arrival > sysdate 
and not exists (
    select 1
    from habitacion_avalon_crs
    where cod_hab_avalon = ma_room
);



select t.*, t.rowid from travMarkets t;

select * from rshotel_report order by hr_id;

select ho_hotel, ho_desc, ho_name, ho_hotel_cancun, ho_accounting_code from rshotel order by to_number(ho_hotel) 


select * from rsmaes_cielo where ma_arrival > sysdate-120 and ma_arrival < sysdate;

select * from  avfreserpr@oc_comer.travamerica.com where rd_tipo = 'F'



select *
from rsavailable_sum_trg_avalon
where av_date between '01-nov-22' and '30-nov-22';



select *
from rinvoice
where in_hotel = 14 and in_arrival >= '01-feb-23'




select ma_hotel, ma_reserv, ma_line, ma_mayorista, ma_charter, ma_arrival, ma_depart, ma_nites, ma_due_tot, ma_divisa, round(ma_due_tot/ma_nites,2) ma_avg_rate 
from rsmaes_avalon where ma_charter = 'AIR CANADA VACATIONS' and ma_can_d is null order by ma_hotel, ma_arrival

select * from rsavailable_sum_trg_avalon where av_charter = 'AIR CANADA VACATIONS' order by av_hotel, av_date, av_charter;

select sum(av_total) from rsavailable_sum_trg_avalon where av_charter = 'VILLA DEL PALMAR CANCUN';


select ma_charter, ma_mayorista
from rsmaes_avalon
where ma_can_d is null 
    and ma_arrival >= '01-sep-22'
group by ma_charter, ma_mayorista
order by ma_charter, ma_mayorista    

  


-- Summary
		select m.trav_description, m.trav_order, trunc(a.av_date,'MONTH'), 
					 to_char(round(sum(nvl(a.av_total,0)) - sum(nvl(a.av_adj,0)),0),'999999999999990'),   
					 to_char(round(sum(nvl(a.av_adult,0)),0),'999999999999990'),   
					 to_char(round( (sum(nvl(a.av_total,0)) - sum(nvl(a.av_adj,0)) ) /decode(sum(a.av_res),0,1,sum(a.av_res)),0),'999999999999990.09'),   
					 to_char(round(sum(nvl(a.av_res,0)),0),'999999999999990'),   
					 to_char(round(sum(nvl(a.av_adj,0)),0),'999999999999990'),   
					 to_char(round(sum(nvl(a.av_adv,0)),0),'999999999999990')   
					  from Rsavailable_sum_trg_avalon a, travmarkets m     
					  where   a.av_hotel in (14)  
						  and nvl(a.av_market_rn,'USA') not in ( 'COR')  	
						  and trunc(a.av_date,'MONTH') between '01-feb-23' and '28-feb-23'
						  and m.trav_market = a.av_market
					  group by  m.trav_description, m.trav_order, trunc(a.av_date,'MONTH')  
					  order by 2,3;
					  
					  
    select *
    from rsavailable_sum_trg_avalon a
    where av_hotel = 14 and trunc(a.av_date,'MONTH') between '01-feb-23' and '28-feb-23'





-- Detalle

    select a.id.av_charter, 1, trunc(a.id.av_date,'MONTH'),  +
				to_char(round(sum(nvl(a.av_total,0))-sum(nvl(a.av_adj,0)),0),'999999999999990'),  + 
				to_char(round(sum(nvl(a.av_adult,0)),0),'999999999999990'),  + 
				to_char(round( (sum(nvl(a.av_total,0)) - sum(nvl(a.av_adj,0)) )/decode(sum(a.av_res),0,1,sum(a.av_res)),0),'999999999999990.09'),  + 
				to_char(round(sum(nvl(a.av_res,0)),0),'999999999999990'),  + 
				to_char(round(sum(nvl(a.av_adj,0)),0),'999999999999990'),  + 
				to_char(round(sum(nvl(a.av_adv,0)),0),'999999999999990')  + 
	from Rsavailable_sum_trg_avalon a  +  
	where a.id.av_hotel in (14)  +
			and trunc(a.id.av_date,'MONTH') between   '01-feb-23' and  '28-feb-23'
			and  nvl(a.av_market_rn,'USA') in (select x.id.trav_code from TravMarkets x where x.trav_description = :mayorista and x.trav_code not in ( 'COR' ))  +	
	group by  a.id.av_charter, 1, trunc(a.id.av_date,'MONTH')  +
	order by 1,3  ;














refreshrsavailable_sum_trg;

refreshrsavailable_sum_trg_mex;


select t.*, t.rowid
from travuser t;


select *
from rsavailable_sum_trg
where av_hotel = '14';


select t.*, t.rowid
from rshotel t
;

execute DBMS_SNAPSHOT.REFRESH( 'rshotel','c');



select t.*, t.rowid
from travMenu t
order by optionid;

select *
from travuserOptions
where optionid = 905;

select * from travmarkets;

select * from conta.rsavilable_sum_trg;


delete from travUserOptions where optionid = :myoption;


-- hotel list of the report
select t.*, t.rowid 
from rshotel_report t


select * 
from cat
where table_name like '%USER%'

select *
from menu_user



insert into travuserhotel
select userid, '27','27' 
from travuserhotel 
where optionid = '3'
order by userid


select *  
from travuserhotel 
where optionid = '24' 
order by userid



-- real hotels
select * from rshotel 





-- Create fake hotel based on real hotels
select * 
from rsfakehotel_vs_real;

-- Fake hotel's reservations
select *
from rsmaes_fakehotel



--  Currency Convertion... 
select *
from TRAVUSD_CONVERTION
order by stamp_date desc

select *
from TRAVUSD_CONVERTION_MONTH
order by stamp_date desc


select T.*, t.rowid  
from travmarkets t






select  case when a.id.av_charter like 'FIT%' then 'USA' else m.trav_description_manuel end,  case when a.id.av_charter like 'FIT%' then 1 else m.trav_order_manuel end,  trunc(a.id.av_date,'MONTH'), to_char(round(sum(nvl(a.av_total,0)) - sum(nvl(a.av_adj,0)),0),'999999999999990'),  to_char(round(sum(nvl(a.av_adult,0)),0),'999999999999990'),  to_char(round( (sum(nvl(a.av_total,0)) - sum(nvl(a.av_adj,0)) ) /decode(sum(a.av_res),0,1,sum(a.av_res)),0),'999999999999990'),  to_char(round(sum(nvl(a.av_res,0)),0),'999999999999990'),  to_char(round(sum(nvl(a.av_adj,0)),0),'999999999999990'),  to_char(round(sum(nvl(a.av_adv,0)),0),'999999999999990')  from com.intsol.springsecurity.domain.Rsavailable_sum_trg a, com.intsol.springsecurity.domain.TravMarkets m  where   a.id.av_hotel in ('01','02','03','04','05','07','08','09','10','11','12')  and trunc(a.id.av_date,'MONTH') between   to_date('01/01/14','MM/dd/yy') and  to_date('07/01/14','MM/dd/yy')  a.id.av_market = m.trav_description_manuel  group by   case when a.id.av_charter like 'FIT%' then 'USA' else m.trav_description_manuel end,  case when a.id.av_charter like 'FIT%' then 1 else m.trav_order_manuel end,  trunc(a.id.av_date,'MONTH')  order by 2,3]; nested exception is org.hibernate.hql.ast.QuerySyntaxException: unexpected token: a near line 1, column 953 [ select  case when a.id.av_charter like 'FIT%' then 'USA' else m.trav_description_manuel end,  case when a.id.av_charter like 'FIT%' then 1 else m.trav_order_manuel end,  trunc(a.id.av_date,'MONTH'), to_char(round(sum(nvl(a.av_total,0)) - sum(nvl(a.av_adj,0)),0),'999999999999990'),  to_char(round(sum(nvl(a.av_adult,0)),0),'999999999999990'),  to_char(round( (sum(nvl(a.av_total,0)) - sum(nvl(a.av_adj,0)) ) /decode(sum(a.av_res),0,1,sum(a.av_res)),0),'999999999999990'),  to_char(round(sum(nvl(a.av_res,0)),0),'999999999999990'),  to_char(round(sum(nvl(a.av_adj,0)),0),'999999999999990'),  to_char(round(sum(nvl(a.av_adv,0)),0),'999999999999990')  from com.intsol.springsecurity.domain.Rsavailable_sum_trg a, com.intsol.springsecurity.domain.TravMarkets m  where   a.id.av_hotel in ('01','02','03','04','05','07','08','09','10','11','12')  and trunc(a.id.av_date,'MONTH') between   to_date('01/01/14','MM/dd/yy') and  to_date('07/01/14','MM/dd/yy')  a.id.av_market = m.trav_description_manuel  group by   case when a.id.av_charter like 'FIT%' then 'USA' else m.trav_description_manuel end,  case when a.id.av_charter like 'FIT%' then 1 else m.trav_order_manuel end,  trunc(a.id.av_date,'MONTH')  order by 2,3

select unique ch_charter, ch_market, ch_utl
from rscharter 
where ch_charter like 'FIT%'

update rscharter 
set ch_market = 'AME'
where ch_charter like 'FIT%'

select * from rsavailable_sum_trg where av_charter like 'FIT%' and av_date > sysdate



select m.trav_description, m.trav_order, trunc(a.id.av_date,'MONTH'),
                    to_char(round(sum(nvl(a.av_total,0)),0),'999999999999990'),  
                    to_char(round(sum(nvl(a.av_adult,0)),0),'999999999999990'),  
                    to_char(round(sum(nvl(a.av_total,0))/decode(sum(a.av_res),0,1,sum(a.av_res)),0),'999999999999990'), 
                    to_char(round(sum(nvl(a.av_res,0)),0),'999999999999990')  
                     from Rsavailable_sum_trg a   
                     where   a.id.av_hotel in ('01','02')
                     and trunc(a.id.av_date,'MONTH') between '01-jul-13' and '30-jul-13' 
                     group by  m.trav_description, m.trav_order, trunc(a.id.av_date,'MONTH') 
                     order by 2,3




select a.av_charter, 1, trunc(a.av_date,'MONTH'),
                        to_char(round(sum(nvl(a.av_total,0)),0),'999999999999990'), 
                        to_char(round(sum(nvl(a.av_adult,0)),0),'999999999999990'),  
                        to_char(round(sum(nvl(a.av_total,0))/decode(sum(a.av_res),0,1,sum(a.av_res)),0),'999999999999990'),  
                        to_char(round(sum(nvl(a.av_res,0)),0),'999999999999990') 
                   from Rsavailable_sum_trg a
                   where a.av_hotel in ('01','02')
                          and trunc(a.av_date,'MONTH') between '01-jul-13' and '31-jul-13' 
                        and  a.av_market in (select x.trav_code from TravMarkets x where x.trav_description = 'USA') 
                  group by  a.av_charter, 1, trunc(a.av_date,'MONTH') 
                  order by 1,3




select unique ch_market from rscharter




select t.*, t.rowid
from travmenu t
order by optionId




select * from rsavailable_sum_trg



select ma_hotel, ma_reserv, ma_charter, ma_arrival, ma_depart, ma_due_tot, to_char(ma_due_tot/ma_nites/ma_adult,'999,999,999.09') avgRate_USD
from rsmaes, rscharter
where ch_hotel = ma_hotel and  
      ch_charter = ma_charter and 
      ma_can_d is null and 
      ma_due_tot/ma_nites/ma_adult > 135 and 
      ma_nites > 0 and 
      ma_adult > 0 and 
      nvl(ma_divisa,'USD') = 'USD' and 
      ch_utl = 'MEX' and 
      ma_arrival >= trunc(sysdate)
order by ma_charter, ma_arrival
      
      
select ma_hotel, ma_reserv, ma_charter, ma_arrival, ma_depart, ma_due_tot, to_char(ma_due_tot/ma_nites/ma_adult,'999,999,999.09') avgRate_MEX
from rsmaes, rscharter
where ch_hotel = ma_hotel and  
      ch_charter = ma_charter and 
      ma_can_d is null and 
      ma_due_tot/ma_nites/ma_adult > 1600 and 
      ma_nites > 0 and 
      ma_adult > 0 and 
      nvl(ma_divisa,'USD') in ('MEX','MXN') and 
      ch_utl = 'MEX' and 
      ma_arrival >= trunc(sysdate)
order by ma_charter, ma_arrival

      
select unique ma_divisa from rsmaes      
      
      
      






-- Portrait Ocupational Report.
select av_hotel, av_date,to_char(av_date, 'DY') week_day,  
    sum(decode(trav_description,'USA',nvl(av_res,0),0)) USA,
    sum(decode(trav_description,'CANADA',nvl(av_res,0),0)) CAN,
    sum(decode(trav_description,'EUROPE',nvl(av_res,0),0)) EUR,
    sum(decode(trav_description,'MEXICO',nvl(av_res,0),0)) MEX,
    sum(decode(trav_description,'SUDAMERICA',nvl(av_res,0),0)) SUD,
    sum(nvl(av_arrivals,0)) ARR, 
    sum(nvl(av_departures,0)) DEP
from rsavailable_sum_trg, travmarkets
where av_date > sysdate
    and trav_code = av_market
group by av_hotel, av_date
order by av_date, av_hotel


select av_hotel, 
         av_date, 
         to_char(av_date,'dd'),to_char(av_date, 'DY') week_day,
         sum(decode(trav_description,'USA',nvl(av_res,0),0)) , 
         sum(decode(trav_description,'CANADA',nvl(av_res,0),0)), 
         sum(decode(trav_description,'EUROPE',nvl(av_res,0),0)), 
         sum(decode(trav_description,'MEXICO',nvl(av_res,0),0)), 
         sum(decode(trav_description,'SUDAMERICA',nvl(av_res,0),0)), 
         sum(nvl(av_res,0)), round(sum(nvl(av_res,0))*100/736), 
         sum(nvl(av_arrivals,0)),
         sum(nvl(av_departures,0))
from rsavailable_sum_trg, travmarkets where av_hotel in ('02') and av_date between to_date('01/01/2013','MM/dd/yy') and to_date('01/31/2013','MM/dd/yy') and trav_code = av_market group by av_hotel, av_date order by av_hotel, av_date

select * 
from rsavailable_sum_trg


          
select * from rshotel where ho_complex_id = :complex          

select t.*, t.rowid from rscomplexes t  order by comp_order

select t.*, t.rowid
from rsmis t
where mis_rep_date = trunc(sysdate-2)


delete from rsmis
where mis_rep_date = trunc(sysdate)

insert into rsmis
(mis_rep_date, mis_rep_type, mis_market, mis_market, mis_complex, mis_day, mis_month)
select trunc(sysdate), report, market, complex, round(getMISdata(report,market,complex,'D',sysdate),2) as D, round(getMISdata(report,market,complex,'M',sysdate),2) as M 
from mis_view


alter table rsmis
add constraint rsmis_pk primary key (mis_rep_date, mis_rep_type, mis_market, mis_complex)


select * from rsmis


select *
from rsmis, rscomplexes
where comp_id = mis_complex
order by mis_rep_date, mis_rep_type, decode(mis_market, 'USA',1,'CAN',2,3), comp_order 






-- TOP 10..
select rownum, sysdate + rownum -1,  ma_hotel, ma_reserv from 
(
select ma_hotel, ma_reserv
from rsmaes
where ma_hotel = '01' and ma_charter like 'APPLE%' and ma_arrival > trunc(sysdate)
)
where rownum < 11


create or replace view MIS_view 
as 
select 
    tipo.rep as report,
    market.item as market,
    comp_id as complex,
    comp_order as complex_order
from dual , ( 
        select 'USA' as item, 1 as orden from dual
        union
        select 'CAN' as item, 2 as orden from dual
        union
        select 'EUR' as item, 3 as orden from dual
    ) market,
    (
        select 'RN' as rep from dual
        union
        select 'RRA' as rep from dual
        union
        select 'USD' as rep from dual
    ) tipo, rscomplexes
order by 1,market.orden, comp_order     



select * from mis_view


select * from kk2

select *
from kk2
where exists ( select 1 from rinvoice where in_hotel = hotel and in_reserv = reserv and in_inv_num <> '0000000')

select in_hotel, in_reserv, in_inv_num, in_wholes, in_arrival, in_depart
from rinvoice
where nvl(in_inv_num,'XX') <> '0000000' and exists  ( select 1 from kk2 where hotel = in_hotel and reserv = in_reserv) and 
        

select ho_hotel, ho_desc
from rshotel



desc invoices_statement_xls


select ma_market , ma_hotel, ma_reserv, ma_charter, ma_arrival, ma_depart, ma_guest, ma_due_tot, ma_inp_d, ma_inp_u, ma_mod_d, ma_mod_u, ma_can_d, ma_can_u, ma_status, getRNOccupancy(:pivotDate, ma_arrival, ma_depart) , getUSDOccupancy(:pivotDate, ma_arrival, ma_depart, ma_due_tot) from Reserva_hoteles_avalon a where ma_status = :ma_status and  ma_hotel in ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24') and ( ma_arrival between :pivotDate and last_day(:pivotDate) or ma_depart-1 between :pivotDate and last_day(:pivotDate) )  order by ma_market, ma_hotel, ma_charter, ma_arrival, ma_depart

select a.av_charter, 1
,trunc(a.av_date,'MONTH')
, to_char(round(sum(nvl(a.av_total,0))-sum(nvl(a.av_adj,0)),0),'999999999999990')
,  to_char(round(sum(nvl(a.av_adult,0)),0),'999999999999990')
,  to_char(round( (sum(nvl(a.av_total,0)) - sum(nvl(a.av_adj,0)) )/decode(sum(a.av_res),0,1,sum(a.av_res)),0),'999999999999990.09')
,  to_char(round(sum(nvl(a.av_res,0)),0),'999999999999990'),  to_char(round(sum(nvl(a.av_adj,0)),0),'999999999999990')
,  to_char(round(sum(nvl(a.av_adv,0)),0),'999999999999990')  from Rsavailable_sum_trg_avalon a  
where a.av_hotel in ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24')  
and trunc(a.av_date,'MONTH') between   to_date('09/01/22','MM/dd/yy') and  to_date('09/01/22','MM/dd/yy')  
and  nvl(a.av_market,'USA') in (select x.trav_code from TravMarkets x where x.trav_description = 'MEXICO' and x.trav_code not in ('COR','USO'))  
group by  a.av_charter, 1, trunc(a.av_date,'MONTH')  order by 1,3;
 

select x.trav_code from TravMarkets x where x.trav_description = 'MEXICO' and x.trav_code not in ('COR','USO')


update rsavailable_sum_trg_avalon
set av_market_rn = av_market;




-- Avalon
execute refreshrsavailable_sum_trg_avalon('01-nov-22','30-nov-22');

execute refreshrsavailable_trg_avalon(trunc(trunc(sysdate)-1,'MONTH'),last_day(add_months(trunc(sysdate),1)));


-- Facturacion
execute refreshrsavailable_sum_trg_inv('01-oct-22','31-dec-22');

execute refreshrsavailable_trg_inv('01-oct-22','31-dec-22');


select * from rsavailable_sum_trg_avalon where av_date >= '01-oct-22'

select * from rsavailable_sum_trg_avalon where av_charter = 'EXPEDIA INC.' and av_date between '01-sep-22' and '30-sep-22'

update rsavailable_sum_trg_avalon 
set av_market = 'USA', AV_MARKET_RN = 'USA'
where av_charter = 'EXPEDIA INC.' and av_date between '01-sep-22' and '30-sep-22' AND AV_MARKET != 'USA'



select * from rsmaes_avalon where ma_charter = 'VILLAS DEL PALMAR';




select *
from rinvoice
where in_hotel = 14 and in_arrival >= '01-feb-23'

select *
from rscharter
where ch_hotel = 14 and ch_charter = 'AIRCAI'



