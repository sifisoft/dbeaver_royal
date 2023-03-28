



select t.*, t.rowid from rsfakehotel t


select t.*, t.rowid from rsfakehotel_vs_real t


select t.*, t.rowid from rsfakehotel_rooms t


select t.*, t.rowid from rshotel_report t


drop table rshotel_report;

create table rshotel_report (
    hr_id           number(3),
    hr_nombre       varchar2(240),
    hr_hotel_list   varchar2(640),
    hr_order        number(3),
    hr_availability number(5),
    constraint rshotel_reportPk primary key (hr_id)
)
tablespace hotel
storage (initial 1K next 1K pctincrease 10)
/


create table rsfakehotel (
    xf_fake_hotel   varchar2(6),
    xf_desc         varchar2(640),
    constraint rsfakehotel_key primary key (xf_fake_hotel)
)
tablespace hotel
storage (initial 1K next 1K pctincrease 10)
/

create table rsfakehotel_vs_real(
    xh_fake_hotel   varchar2(6),
    xh_real_hotel   varchar2(6),
    constraint rsfakehotel_vs_realpk primary key (xh_fake_hotel, xh_real_hotel),
    constraint rsfakehotel_vs_realfk foreign key (xh_fake_hotel) references rsfakehotel(xf_fake_hotel)
)    
tablespace hotel
storage (initial 1K next 1K pctincrease 10)
/

create table rsfakehotel_rooms(
    xr_fake_hotel   varchar2(6),
    xr_real_hotel   varchar2(6),
    xr_real_room    varchar2(24),
    constraint rsfakehotel_rooms primary key (xr_fake_hotel, xr_real_hotel, xr_real_room),
    constraint rsfakehotel_roomfk foreign key (xr_fake_hotel, xr_real_hotel) references rsfakehotel_vs_real(xh_fake_hotel, xh_real_hotel)
)    
tablespace hotel
storage (initial 4K next 1K pctincrease 10)
/

insert into rsfakehotel
values (81, 'Paco quiere sumar ocupacion del SKGT con GOT (GDOF y GPLS)')
/

insert into rsfakehotel_vs_real
values (81,'08')
/

insert into rsfakehotel_vs_real
values (81,'10')
/

insert into rsfakehotel_rooms
values (81,'10','GDOF')
/

insert into rsfakehotel_rooms
values (81,'10','GPLS')
/


RSMAES_FAKEHOTEL


-- Atlanta.

select ma_hotel, ma_reserv,ma_room 
from rsmaes
where ma_hotel in ('10','08')
and ma_depart between '01-nov-17' and '30-nov-17'
minus 
select ma_hotel, ma_reserv,ma_room 
from rsmaes_fakehotel
where ma_depart between '01-nov-17' and '30-nov-17'


-- Cancun.... 

select rv_hotel, rv_reserva, rv_tipo_hab 
from freserva_hoteles
where rv_hotel in ('10','15')
and rv_salida between '01-nov-17' and '30-nov-17'
minus 
select rv_hotel, rv_reserva, rv_tipo_hab 
from freserva_hoteles_fakehotel
where rv_salida between '01-nov-17' and '30-nov-17'



/* Mes completo */
select ma_hotel, ma_reserv, ma_charter, ma_arrival, ma_depart, ma_due_tot, ma_room, ch_country, ma_nites, getNumberOfNights(ma_arrival,ma_depart,'1-dec-17') NovNights, to_char((ma_due_tot/ma_nites)*getNumberOfNights(ma_arrival,ma_depart,'1-dec-17'),'999999999999.09') totalNOv, ma_divisa
from rsmaes_fakehotel, rscharter, rsopecharter 
where ma_can_d is null 
    and 
        (
            trunc(ma_depart-1,'MONTH') = '01-dec-17'
            or
            trunc(ma_arrival,'MONTH') = '01-dec-17'
        )
      and ch_hotel = ma_hotel 
      and ch_charter = ma_charter
      and ch_market in ('NAM','AME','EUR','SUD')
      and oc_charter = ch_charter
      and oc_operator <> 'FIT'   
      and ch_country = 'CA'     
order by ma_arrival, ma_charter



/* en algún día en especifico */
select ma_hotel, ma_reserv, ma_charter, ma_arrival, ma_depart, ma_due_tot, ma_room, ch_country, ma_nites, getNumberOfNights(ma_arrival,ma_depart,'1-dec-17') NovNights, to_char((ma_due_tot/ma_nites)*getNumberOfNights(ma_arrival,ma_depart,'1-dec-17'),'999999999999.09') totalNOv, ma_divisa
from rsmaes_fakehotel, rscharter, rsopecharter 
where ma_can_d is null 
    and '01/dec/17' between ma_arrival and ma_depart-1 
      and ch_hotel = ma_hotel 
      and ch_charter = ma_charter
      and ch_market in ('NAM','AME','EUR','SUD')
      and oc_charter = ch_charter
      and oc_operator <> 'FIT'   
      and ch_country = 'CA'     
order by ma_charter





select *
from rsavailable_sum_trg
where av_hotel = 81 and av_date between '01-dec-17' and '31-dec-17' and av_market = 'CAN'
order by av_date, av_charter, av_market




select *
from rsmaes_fakehotel 
where ma_can_d is null 
    and 
        (
            trunc(ma_depart-1,'MONTH') = '01-nov-17'
            or
            trunc(ma_arrival,'MONTH') = '01-nov-17'
        )


select * 
from rscharter
where ch_charter = 'SUNWPE3P'

select *
from rsopecharter
where oc_charter = 'SUNWPE3P'





                select unique ma_fake_hotel av_hotel, 
                         :vPivote av_date, 
                         ma_charter av_charter,
                         decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl),
                         sum(1) av_res,
                         99  av_allotment,
                         round(sum((convertToUSD(ma_inp_d, nvl(ma_divisa,'USD'), ma_due_tot) /(decode(ma_nites,null,1,0,1,ma_nites)))),2) av_total,
                         getDeltaArrDepFakeHotel(ma_fake_hotel, ma_charter, :vPivote) av_at_dt,
                         getDeltaArrivalsFakeHotel(ma_fake_hotel, ma_charter, :vPivote) av_at_ay,
                         sum(nvl(ma_adult,0)) av_adult,
                         sum(nvl(ma_child,0)) av_child,
                         0,
                         0,
                         round(sum((convertToUSDAccounting(ma_inp_d, nvl(ma_divisa,'USD'), ma_due_tot) /(decode(ma_nites,null,1,0,1,ma_nites)))),2) av_total_account_cur,
                         decode(nvl(oc_operator,'XX'),'COMPS','COR','COMPSUD','COR','COMPSEUR','COR',decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl))
                from rsmaes_fakehotel, rscharter, rsopecharter 
                where ma_can_d is null
                    and :vPivote between ma_arrival and ma_depart-1  
                    and ch_hotel = ma_hotel 
                    and ch_charter = ma_charter
                    and ch_market in ('NAM','AME','EUR','SUD')
                    and oc_charter = ch_charter
                    and oc_operator <> 'FIT'
                    --and ch_charter not in (select oc_charter from rsopecharter where oc_operator = 'FIT')           -- Sacar a los FITS de AME.
                group by 
                    ma_fake_hotel, 
                    :vPivote,
                    ma_charter,
                    decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl),
                    decode(nvl(oc_operator,'XX'),'COMPS','COR','COMPSUD','COR','COMPSEUR','COR',decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl))
                order by ma_fake_hotel, ma_charter;


                select * from rsmaes where ma_reserv = '828947'

                select   ma_reserv, ma_fake_hotel av_hotel,  ma_charter,
                         decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl),
                         decode(nvl(oc_operator,'XX'),'COMPS','COR','COMPSUD','COR','COMPSEUR','COR',decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl)),
                         :vPivote av_date, 
                         ma_charter av_charter,
                         decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl),
                         1 av_res,
                         99  av_allotment,
                         round((convertToUSD(ma_inp_d, nvl(ma_divisa,'USD'), ma_due_tot) /(decode(ma_nites,null,1,0,1,ma_nites))),2) av_total,
                         getDeltaArrDepFakeHotel(ma_fake_hotel, ma_charter, :vPivote) av_at_dt,
                         getDeltaArrivalsFakeHotel(ma_fake_hotel, ma_charter, :vPivote) av_at_ay,
                         nvl(ma_adult,0) av_adult,
                         nvl(ma_child,0) av_child,
                         0,
                         0,
                         round((convertToUSDAccounting(ma_inp_d, nvl(ma_divisa,'USD'), ma_due_tot) /(decode(ma_nites,null,1,0,1,ma_nites))),2) av_total_account_cur,
                         decode(nvl(oc_operator,'XX'),'COMPS','COR','COMPSUD','COR','COMPSEUR','COR',decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl))
                from rsmaes_fakehotel, rscharter, rsopecharter 
                where ma_can_d is null
                    and :vPivote between ma_arrival and ma_depart-1  
                    and ch_hotel = ma_hotel 
                    and ch_charter = ma_charter
                    and ch_market in ('NAM','AME','EUR','SUD')
                    and oc_charter = ch_charter
                    and oc_operator <> 'FIT'
                    --and ch_charter not in (select oc_charter from rsopecharter where oc_operator = 'FIT')           -- Sacar a los FITS de AME.
                order by ma_fake_hotel, ma_charter;




refreshRSAVAILABLE_SUM_TRg


select getNumberOfNights('01-nov-17','3-nov-17','1-nov-17')
from dual;


select *
from rsmaes
where ma_hotel = '04' and ma_room = 'GSTE'


select unique ma_hotel, ma_room
from rsmaes_fakehotel
where ma_arrival > '30-nov-17' and ma_hotel = '04'