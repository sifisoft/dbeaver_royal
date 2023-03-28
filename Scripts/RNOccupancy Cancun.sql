

refreshrsavailable_sum_trg_mex;

select  * from freserva_hoteles_temp where rv_reserva = '011050251';

select * from freserva_hoteles where rv_reserva = '011050251';

select * from rsavailable_sum_trg  where av_charter = 'SELHOTEL';

select * from rshotel;




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
          -- Incluir DESPEGAR - DIR en produccion Mexico no importando sí el código del operador se factura en ATL. Es la única excepción para los DIRs
          or exists (select 1 from rsopecharter where oc_operator ='DESPEGAI' and oc_charter = rv_agencia and rv_mayorista = 'DIR')
          -- Incluir  Booking usa como DIR a peticion de Paco y Jose son capturadas por Royal rv_origen=TA
          ---- or exists (select 1 from rsopecharter where oc_operator ='BOKINGAI' and oc_charter = rv_agencia and rv_mayorista = 'DIR')
          or rv_mayorista = 'DIRDIR'
          or rv_agencia like 'FIT%' 
          or rv_agencia = 'BOOKNGDI'
        )
    group by 
        ho_hotel, 
        :vPivote,
        decode(rv_mayorista,'MEX', nvl(rv_ag_desc, rv_agencia), rv_agencia),
        rv_mayorista,
        rv_agencia
    order by 1, 3;
 















select ch_hotel, ch_charter, ch_pri_inv,  ch_utl, ch_market 
from rscharter 
where ch_charter = 'DTURP1ET' 
order by ch_charter, ch_hotel;


select * from rsopecharter where oc_charter = 'FUNJPU9S';

select *  from rsoperator where op_id = 'FUNJET';

select * from rscharter where ch_charter = 'SELHOTEL';


select t.*, t.rowid 
from rsmarkets t;
