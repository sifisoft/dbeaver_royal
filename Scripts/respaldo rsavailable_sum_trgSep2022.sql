









        select *
        from rsavailable_sum_trg_avalon
        where   av_market in (
                        select trav_code 
                        from travmarkets
                        where   trav_market in ('MEX') 
                            or trav_code in('BRA','BR1')
                    )
            and av_date between '01-sep-22' and '05-sep-22'
        order by av_date, av_hotel, av_charter
        


        delete from rsavailable_sum_trg_avalon
        where   av_market in (
                        select trav_code 
                        from travmarkets
                        where   trav_market in ('MEX') 
                            or trav_code in('BRA','BR1')
                    )
            and av_date between '01-sep-22' and '05-sep-22'
            ;

        insert into rsavailable_sum_trg_avalon
        select *
        from rsavailable_sum_trg_avalon_bcksep2022
        where   av_market in (
                        select trav_code 
                        from travmarkets
                        where   trav_market in ('MEX') 
                            or trav_code in('BRA','BR1')
                    )
            and av_date between '01-sep-22' and '05-sep-22'





select * from cat where table_name like '%RSAVAILABLE%';


drop table rsavailable_sum_trg_avalon_bcksep2022;

create table rsavailable_sum_trg_avalon_bcksep2022
as select * from rsavailable_sum_trg where av_date between '01-sep-22' and '30-sep-22';




select *
from freserva_hoteles
where rv_reserva = 'GOCRS220006107'
;

select * 
from rsmaes_cielo_reserva where ma_reserv = '220488910';

select  * from travmarkets
-- where trav_market = 'MEX'


create or replace view rsmaes_cielo_reserva as 
select 
 rv_hotel       ma_hotel
,rv_reserva     ma_reserv
,1              ma_line
,nvl(ag_nombre, rv_agencia)     ma_charter
,rv_mayorista   ma_mayorista
,rv_llegada     ma_arrival
,rv_salida      ma_depart
,rv_noches      ma_nites
,rv_voucher     ma_voucher
,round(convertToUSD(rv_llegada, rv_moneda, rv_importe),2) ma_due_tot
,'USD'          ma_currency
,''     ma_invoice
,rv_adulto      ma_adult
,(nvl(rv_menor,0)+nvl(rv_junior,0))       ma_child
,rv_bebe        ma_infant
FROM freserva_hoteles, fragen 
WHERE rv_mayorista in ('MEX','BRA')
    and ag_mayorista(+) = rv_mayorista
    and ag_agencia(+) = rv_agencia
    and rv_status != 'C'
ORDER BY rv_llegada;


select *
from all_db_links;

select * from fragen@cun_oc.travamerica.com;



select * from fragen;



create or replace view rsmaes_cielo as 
select 
 lpad(rd_hotel,2,'0')       ma_hotel
,rd_reserva     ma_reserv
,rd_linea       ma_line
,rd_agencia     ma_charter
,rd_mayorista   ma_mayorista
,rd_llegada     ma_arrival
,rd_salida      ma_depart
,rd_noches      ma_nites
,rd_voucher     ma_voucher
,round(convertToUSD(rd_llegada, rd_moneda, rd_total),2) ma_due_tot
,'USD'          ma_currency
,rd_factura     ma_invoice
,rd_adulto      ma_adult
,(nvl(rd_menor,0)+nvl(rd_junior,0))       ma_child
,rd_bebe        ma_infant
FROM avfreserpr@oc_comer.travamerica.com 
WHERE rd_tipo = 'F' 
ORDER BY rd_llegada;



select *
from rsmaes_cielo
where ma_arrival between '01-sep-22' and '30-sep-22';



                select unique ma_hotel av_hotel,
                        :vPivote av_date,
                         ma_charter av_charter,
                         ma_mayorista,
                         sum(1) av_res,
                         99  av_allotment,
                         round(sum(ma_due_tot/ma_nites),2) av_total,
                         0 av_at_dt,
                         0 av_at_ay,
                         sum(nvl(ma_adult,0)) av_adult,
                         sum(nvl(ma_child,0)) av_child,
                         0,
                         0,
                         round(sum(ma_due_tot/ma_nites),2),
                         ma_mayorista
                from rsmaes_cielo
                where  :vPivote between ma_arrival and ma_depart-1
                group by
                    ma_hotel,
                    :vPivote,
                    ma_charter,
                    ma_mayorista
                order by 1, 3;


                        select * 
                        from travmarkets
                        where   trav_market in ('MEX') 
                             or trav_code in('BRA','BR1')
