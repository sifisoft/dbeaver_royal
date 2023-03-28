


execute refreshrsavailable_sum_trg(trunc(sysdate-21,'MONTH'),last_day(add_months(sysdate,12)));

execute refreshrsavailable_trg(trunc(sysdate-21,'MONTH'),last_day(add_months(sysdate,12)));


execute refreshrsavailable_sum_trg_mex('01-jan-19','31-jan-19');

execute refreshrsavailable_sum_trg('01-jan-21','31-mar-21');

commit;

refreshrsavailable_sum_trg

refreshrsavailable_trg

refreshrsavailable_sum_trg_mex

refreshrsavailable_trg_mex

getConvertionUSD

travusd_convertion



-- Checar una agencia porque no sale.. ojo para Agencias BRA.. debe quedar  ch_utl = SUD, ch_market=SUD... o si los número salen del hotel BRA-BRA
 
select *
from rsmaes
where ma_charter = :charter and ma_arrival > sysdate-60 and ma_can_d is null
order by ma_arrival
;

select * from freserva_hoteles where rv_reserva = '220420467';

select * from rsavailable_sum_trg where av_date > sysdate-320 and av_charter like '%DIVERSA%';

select * from rsavailable_sum_trg where av_date = '23-Nov-22';

select * from rsoperator
where exists ( 
    select 1
    from rsopecharter
    where oc_operator = op_id
      and oc_charter = :charter
);

select * from rscharter where ch_hotel = '02' and ch_charter = 'DIVERSA';

select * from rscharter where ch_hotel = '02' and ch_charter like 'CVCBRA';



execute refreshrsavailable_sum_trg(:vPivote,:vPivote);

refreshRSAVAILABLE_SUM_MEXVIEW

                select unique ma_hotel av_hotel,
                        :vPivote av_date,
                         ma_charter av_charter,
                         decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl),
                         sum(1) av_res,
                         99  av_allotment,
                         round(sum((convertToUSD(ma_inp_d, nvl(ma_divisa,'USD'), ma_due_tot) /(decode(ma_nites,null,1,0,1,ma_nites)))),2) av_total,
                         getDeltaArrDep(ma_hotel, ma_charter, :vPivote) av_at_dt,
                         getDeltaArrivals(ma_hotel, ma_charter, :vPivote) av_at_ay,
                         sum(nvl(ma_adult,0)) av_adult,
                         sum(nvl(ma_child,0)) av_child,
                         0,
                         0,
                         round(sum((convertToUSDAccounting(ma_inp_d, nvl(ma_divisa,'USD'), ma_due_tot) /(decode(ma_nites,null,1,0,1,ma_nites)))),2) av_total_account_cur,
                         decode(nvl(oc_operator,'XX'),'COMPS','COR','COMPSUD','COR','COMPSEUR','COR','COMPSCA','COR',decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl))
                from rsmaes , rscharter, rsopecharter
                where ma_can_d is null
                    and :vPivote between ma_arrival and ma_depart-1
                    and ch_hotel = ma_hotel
                    and ch_charter = ma_charter
                    and ch_market in ('NAM','AME','EUR','SUD')
                    and oc_charter = ch_charter
                    and oc_operator <> 'FIT'
                    --and not exists (select 1 from rsopecharter where oc_operator = 'DESPEGAI' and oc_charter = ma_charter and MA_MAYORISTA = 'DIR')
                    --and ch_charter not in (select oc_charter from rsopecharter where oc_operator = 'FIT')           -- Sacar a los FITS de AME.
                    and not (oc_operator = 'DESPEGAI' and ma_mayorista = 'DIR')
                group by
                    ma_hotel,
                    :vPivote,
                    ma_charter,
                    decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl),
                    decode(nvl(oc_operator,'XX'),'COMPS','COR','COMPSUD','COR','COMPSEUR','COR','COMPSCA','COR',decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl))
                order by ma_hotel, ma_charter;

              select unique ma_hotel av_hotel,
                        :vPivote av_date,
                         ma_charter av_charter,
                         decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl),
                         sum(1) av_res,
                         99  av_allotment,
                         round(sum((convertToUSD(ma_inp_d, nvl(ma_divisa,'USD'), ma_due_tot) /(decode(ma_nites,null,1,0,1,ma_nites)))),2) av_total,
                         getDeltaArrDep(ma_hotel, ma_charter, :vPivote) av_at_dt,
                         getDeltaArrivals(ma_hotel, ma_charter, :vPivote) av_at_ay,
                         sum(nvl(ma_adult,0)) av_adult,
                         sum(nvl(ma_child,0)) av_child,
                         0,
                         0,
                         round(sum((convertToUSDAccounting(ma_inp_d, nvl(ma_divisa,'USD'), ma_due_tot) /(decode(ma_nites,null,1,0,1,ma_nites)))),2) av_total_account_cur,
                         decode(nvl(oc_operator,'XX'),'COMPS','COR','COMPSUD','COR','COMPSEUR','COR','COMPSCA','COR',decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl))
                from rsmaes , rscharter, rsopecharter
                where ma_can_d is null
                    and :vPivote between ma_arrival and ma_depart-1
                    and ch_hotel = ma_hotel
                    and ch_charter = ma_charter
                    and ch_market in ('NAM','AME','EUR','SUD')
                    and oc_charter = ch_charter
                    and oc_operator <> 'FIT'
                    --and not exists (select 1 from rsopecharter where oc_operator = 'DESPEGAI' and oc_charter = ma_charter and MA_MAYORISTA = 'DIR')
                    --and ch_charter not in (select oc_charter from rsopecharter where oc_operator = 'FIT')           -- Sacar a los FITS de AME.
                    and not (oc_operator = 'DESPEGAI' and ma_mayorista = 'DIR')
                group by
                    ma_hotel,
                    :vPivote,
                    ma_charter,
                    decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl),
                    decode(nvl(oc_operator,'XX'),'COMPS','COR','COMPSUD','COR','COMPSEUR','COR','COMPSCA','COR',decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl))
                order by ma_charter;









select * from rshotel;

-- cancun
select * 
from rsavailable_sum_trg_mex
where av_charter_code = 'DIVERSA' --and av_date = '03-jan-19'
order by av_date desc;

select *
from rsavailable_sum_trg
where av_hotel < 20 and nvl(av_charter_code, av_charter) = 'BKINL0PR' --and av_date = '01-jan-19' -- quitar los hoteles complejos 81,82, etc. 
order by av_date desc;

select *
from freserva_hoteles
where rv_agencia = 'BKINL0PR' AND rv_llegada > '01-apr-21' and rv_llegada < '01-may-21'



select * from fragen where ag_agencia = 'BOKINGAI';





-- ATL
--select *
select sum(av_total)
from rsavailable_sum_trg
where av_hotel < 20 and nvl(av_charter_code, av_charter) = 'DESPEGMX' and av_date = '01-jan-19' -- quitar los hoteles complejos 81,82, etc. 
order by to_number(av_hotel) asc;

-- temporal rafa
--select sum(ma_total)
select *
from checa_despegar
where ma_charter = 'DESPEGMX' and ma_date = '01-jan-19';

-- RSMAES
select sum(convertToUSD(ma_inp_d, nvl(ma_divisa,'USD'), ma_due_tot)/ma_nites)
from rsmaes 
where ma_charter = 'DSPGPCMX' and '03-jan-19' between ma_arrival and ma_depart-1 and ma_can_d is null
--group by ma_hotel;
;


-- Total del operador DESPEGAR en RSAVAILABLE_SUM_TRG
select *
from rsavailable_sum_trg
where av_hotel = 12 and av_date between '01-jan-19' and '31-dec-19' and nvl(av_charter_code, av_charter) in (select oc_charter from rsopecharter where oc_operator ='DESPEGAI')
;

select *
from rsmaes
where ma_hotel = 12  and ma_depart-1 between '01-jan-19' and '31-jan-19'  and ma_charter in (select oc_charter from rsopecharter where oc_operator ='DESPEGAI') and ma_can_d is null;


select * 
from rsavailable_sum_trg
where nvl(av_charter_code, av_charter) = 'DSPGPCUD'
order by av_date desc;

select rv_agenciam from freserva_hoteles where rv_reserva = '885063';

select * from freserva_hoteles where rv_reserva = '885063';


select * from rinvoice where in_reserv = '335030';










select ma_date, ma_charter, sum(ma_total)
from checa_despegar
group by ma_date, ma_charter
order by ma_date, ma_charter
--where ma_charter = 'DESPEGMX' and ma_date = '01-jan-19';
;

select av_date, nvl(av_charter_code, av_charter), sum(av_total)
from rsavailable_sum_trg
where av_hotel < 20 and nvl(av_charter_code, av_charter) in (select oc_charter from rsopecharter where oc_operator ='DESPEGAI') and av_date between '01-jan-19' and '31-jan-19'
group by av_date, nvl(av_charter_code, av_charter)
order by av_date, nvl(av_charter_code, av_charter);




select *
from rsavailable_sum_trg
where av_date >= '01-jan-19' and  av_charter_code like 'DESPCHAR%'
order by av_date;


select sum(av_total)
from rsavailable_sum_trg
where av_date between '01-jan-19' and '31-dec-19' and av_charter in (select oc_charter from rsopecharter where oc_operator ='DESPEGAI')
;


select * from rsoperator where op_name like 'DESPE%';



-- AME
execute refreshrsavailable_sum_trg(trunc(trunc(sysdate)-5,'MONTH'),last_day(add_months(trunc(sysdate),6)));
execute refreshrsavailable_trg(trunc(trunc(sysdate)-5,'MONTH'),last_day(add_months(trunc(sysdate),6)));
-- MEX
execute refreshRSAVAILABLE_SUM_MEXVIEW(trunc(trunc(sysdate)-5,'MONTH'),last_day(add_months(trunc(sysdate),6)));
EOF
echo "End:  $(date)"





select * from travusd_convertion order by stamp_date desc

select unique currency  from travusd_convertion

select * from rsavailable_sum_trg2


select t.*, t.rowid
from travmarkets t
order  by trav_code

select trav_code 
from travmarkets where trav_market in ('DIRDIR', 'MEX','TC')
order by trav_code



select *
from rsavailable_sum_trg
where av_charter like 'SUW%'  


freserva_hoteles
  

select * 
from freserva_hoteles 
where rv_agencia = 'DIRECTOS' 


select *
from rsavailable_sum_trg
where av_charter like 'ACADEMIC' and av_date between '01-May-14' and '31-may-14'

select rv_llegada, rv_salida, rv_importe
from freserva_temp
where rv_agencia = 'ACADEMIC' AND (
    rv_llegada between '01-may-14' and '31-may-14'  or 
      rv_salida between '01-may-14' and '30-may-14'
     ) and rv_status != 'C'


select rv_llegada, rv_salida, rv_importe
from freserva_hoteles
where rv_agencia = 'ACADEMIC' AND (
    rv_llegada between '01-may-14' and '31-may-14'  or 
      rv_salida between '01-may-14' and '31-may-14'
     ) and rv_status != 'C'


execute refreshrsavailable_sum_trg_mex('01-mar-14','31-mar-14')




select *
from freserva_hoteles
where rv_agencia = 'FITDISC' AND rv_llegada > '01-jan-14'




select av_charter, sum(av_res)
from rsavailable_sum_trg
where av_market = 'DIRDIR' and av_date >= '01-jan-14' 
group by av_charter
order by av_charter



select rv_moneda, count(*)
from freserva_hoteles
where rv_salida between '01-jan-14' and '31-jan-14' and rv_status != 'C'
group by rv_moneda


truncate table freserva_temp

insert into freserva_temp
select * 
from freserva_hoteles 
where rv_status != 'C'
    and rv_mayorista not in ('AME','EUR','SUD','SAM') 
    and rv_salida > '01-feb-14'
    and rv_llegada <= '28-feb-14'
    
    
    
execute refreshrsavailable_sum_trg_mex('01-feb-14', '28-feb-14')


select unique av_market
from rsavailable_sum_trg
order by av_market


select t.*, t.rowid
from travmarkets t
order by trav_code

select * 
from kkk
where rv_agencia = 'FITSTD'




select * from rsavailable_sum_trg    


select unique rv_agencia
from kkk
where rv_mayorista = 'DIR'.

select * from rscharter
where ch_charter = 'BOKINGAR'


select unique ch_market
from rscharter 


select av_charter, sum(av_res)
from rsavailable_sum_trg
where av_market = 'MEX' and av_date between '01-jan-14' and '31-jan-14'
group by av_charter
order by av_charter

select * from rsavailable_sum_trg



create  table freserva_temp
as select * from kkk where rownum < 1




select *
from rsavaialable_sum_trg@cun_oc.travamerica.com



create or replace public synonym rsavailable_sum_trg_mex for rsavailable_sum_trg@cun_oc.travamerica.com

select * 
from rsavailable_sum_trg_mex
where av_date between '01-mar-15' and '31-mar-15' and av_market = 'MEX'
order by av_hotel, av_date, av_charter


select *
from all_db_links

select *
from rsavailable_sum_trg@cun_oc.travamerica.com;











              select unique ma_hotel av_hotel,
                        :vPivote av_date,
                         ma_charter av_charter,
                         decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl),
                         sum(1) av_res,
                         99  av_allotment,
                         round(sum((convertToUSD(ma_inp_d, nvl(ma_divisa,'USD'), ma_due_tot) /(decode(ma_nites,null,1,0,1,ma_nites)))),2) av_total,
                         getDeltaArrDep(ma_hotel, ma_charter, :vPivote) av_at_dt,
                         getDeltaArrivals(ma_hotel, ma_charter, :vPivote) av_at_ay,
                         sum(nvl(ma_adult,0)) av_adult,
                         sum(nvl(ma_child,0)) av_child,
                         0,
                         0,
                         round(sum((convertToUSDAccounting(ma_inp_d, nvl(ma_divisa,'USD'), ma_due_tot) /(decode(ma_nites,null,1,0,1,ma_nites)))),2) av_total_account_cur,
                         decode(nvl(oc_operator,'XX'),'COMPS','COR','COMPSUD','COR','COMPSEUR','COR','COMPSCA','COR',decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl))
                from rsmaes , rscharter, rsopecharter
                where ma_can_d is null
                    and :vPivote between ma_arrival and ma_depart-1
                    and ch_hotel = ma_hotel
                    and ch_charter = ma_charter
                    and ch_market in ('NAM','AME','EUR','SUD')
                    and oc_charter = ch_charter
                    and oc_operator <> 'FIT'
                    --and not exists (select 1 from rsopecharter where oc_operator = 'DESPEGAI' and oc_charter = ma_charter and MA_MAYORISTA = 'DIR')
                    --and ch_charter not in (select oc_charter from rsopecharter where oc_operator = 'FIT')           -- Sacar a los FITS de AME.
                    and not (oc_operator = 'DESPEGAI' and ma_mayorista = 'DIR')
                group by
                    ma_hotel,
                    :vPivote,
                    ma_charter,
                    decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl),
                    decode(nvl(oc_operator,'XX'),'COMPS','COR','COMPSUD','COR','COMPSEUR','COR','COMPSCA','COR',decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl))
                order by ma_charter;



