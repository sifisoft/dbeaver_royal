

select * 
from rsavailable_sum_trg
where av_charter = 'DSPGPCUD'
order by av_date desc;

select * 
from rsavailable_sum_trg
where av_charter_code = 'DESPEGMX' and av_date = '01-jan-19'
order by av_date desc;


select sum(av_total) from rsavailable_sum_trg where av_charter = 'BOOKING USA' AND AV_DATE between '01-may-21' and '31-may-21';


commit;

freservas



execute refreshrsavailable_sum_trg_mex(trunc(trunc(sysdate)-20,'MONTH'),last_day(add_months(trunc(sysdate-10),1)));





execute refreshrsavailable_sum_trg_mex('01-jan-19','31-jan-19');

commit;

select * from travmarkets;

select unique rv_origen from freserva_hoteles where rv_mayorista = 'SUD' and rv_llegada between '01-jan-19' and '31-jan-19';

select * from rsopecharter where oc_operator = 'DESPEGAI';

select t.*, t.rowid from rshotel t

select *
from freserva_hoteles_fakehotel
where rv_hotel = 82 and rv_status <> 'C' and rv_mayorista = 'MEX' and rv_llegada > trunc(sysdate)



select * 
from rsfakehotel

select * 
from rsfakehotel_vs_real

select t.*, t.rowid 
from rsfakehotel_rooms t



refreshrsavailable_sum_trg_mex

freserva_hoteles_temp


freserva_hoteles_fakehotel;

select *
from freserva_hoteles_fakehotel;


select *
from rsavailable_sum_trg
where av_hotel = 81 and av_charter_code = 'DSPGPCUS' and av_hotel = 81 and av_date > '01-jan-19'
order by av_date;



select sum(av_total)
from rsavailable_sum_trg
where av_date between '01-jan-19' and '31-jan-19' and exists ( select 1 from rsopecharter where oc_operator = 'DESPEGAI' and oc_charter = av_charter_code)
;


select sum(rv_importe/rv_noches)
from freserva_hoteles 
where rv_agencia = 'DESPCHAR' and '01-jan-19' between rv_llegada and rv_salida-1 and rv_status != 'C'
order by rv_reserva
;



               --create table oo as 
               select ho_hotel av_hotel, 
                       :vPivote av_date, 
                       decode(rv_mayorista,'MEX', nvl(rv_ag_desc, rv_agencia), rv_agencia) av_charter,
                       rv_mayorista,
                       sum(1) av_res,
                       99  av_allotment,
                       round(sum((convertToUSD(rv_cap_f, nvl(rv_moneda,'USD'), rv_importe) /(decode(rv_noches,null,1,0,1,rv_noches)))),2) av_total,
                       0 av_at_dt,
                       0 av_at_ay,
                       sum(nvl(rv_adulto,0)) av_adult,
                       sum(nvl(rv_menor,0)) av_child,
                       0,
                       0,
                       round(sum((convertToUSD(rv_llegada, nvl(rv_moneda,'USD'), rv_importe) /(decode(rv_noches,null,1,0,1,rv_noches)))),2) av_total_account_cur,
                       rv_mayorista,
                       rv_agencia
                from freserva_hoteles_temp , rshotel 
                where :vPivote between rv_llegada and rv_salida-1  
                    and to_number(rv_hotel) = to_number(ho_hotel_cancun)
                    and rv_mayorista in (select trav_code from travmarkets)
                    and (
                      ( -- excluir códigos de ATL.
                            rv_origen not in ('TA','BK')
                        and not exists (select 1 from rscharter where ch_hotel = ho_hotel and ch_charter = rv_agencia and ch_market in ('AME', 'EUR', 'NAM', 'SUD')) 
                      )
                      or ( -- Incluir DESPEGAR - DIR en produccion Mexico no importando s� el código del operador se factura en ATL. Es la única excepción para los DIRs
                            exists (select 1 from rsopecharter where oc_operator ='DESPEGAI' and oc_charter = rv_agencia)
                        and rv_mayorista = 'DIR'
                      )
                      or rv_mayorista = 'DIRDIR'
                      or rv_agencia like 'FIT%' 
                      or rv_agencia = 'BOOKNGDI'
                    )
                    --and not exists (
                            --select 1 
                            --from rscharter 
                            --where   ch_hotel = ho_hotel 
                                --and ch_charter = rv_agencia
                                --and ch_market in ('AME','EUR','SUD','NAM') 
                   --) 
                group by 
                    ho_hotel, 
                    :vPivote,
                    decode(rv_mayorista,'MEX', nvl(rv_ag_desc, rv_agencia), rv_agencia),
                    rv_mayorista,
                    rv_agencia
                order by 1, 3;