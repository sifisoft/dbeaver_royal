

/**
            RNOCCUPANCY AVALON FROM  RINVOICE
**/


-- Actualiza Mayorista a rinvoice
update rinvoice
set in_mayorista = (select decode (ch_utl, 'AME' ,decode(ch_country,'CA','CAN','USA'),ch_utl) from rscharter where ch_hotel = in_hotel and ch_charter = in_wholes)
where in_mayorista is null and in_depart >= sysdate-30;

-- Actualiza RNOCCUPANCY_TRG_AVALON
execute refreshrsavailable_sum_trg_inv('06-sep-22','30-sep-22');

-- Reporte Excel de ocupacion de rinvoice
select in_hotel, in_reserv, in_voucher, in_mayorista, getTOName(in_wholes), in_arrival, in_depart, in_nites, in_inv_num, in_a_total, getOccupancyNights('01-sep-22',in_arrival, in_depart, in_nites, in_a_total) OCC_NTS_SEP, in_a_total/in_nites * getOccupancyNights('01-sep-22',in_arrival, in_depart, in_nites, in_a_total) OCC_USD_SEP
from rinvoice
where in_inv_num is not null
      and in_inv_num != '0000000'
      and '01-sep-22' between trunc(in_arrival,'MONTH') and trunc(in_depart-1,'MONTH')
order by 3,4,5      


-- Reporte Excel de ocupacion de RSMAES_CIELO
select ma_hotel, ma_reserv, ma_voucher, ma_mayorista, ma_charter, ma_arrival, ma_depart, ma_nites, ma_invoice, ma_due_tot, getOccupancyNights('01-sep-22',ma_arrival, ma_depart, ma_nites, ma_due_tot) OCC_NTS_SEP, ma_due_tot/ma_nites * getOccupancyNights('01-sep-22',ma_arrival, ma_depart, ma_nites, ma_due_tot) OCC_USD_SEP
from rsmaes_cielo
where '01-sep-22' between trunc(ma_arrival,'MONTH') and trunc(ma_depart-1,'MONTH')
order by 3,4,5





select lpad(ma_hotel,2,'0'), ma_reserv, ma_voucher, ma_mayorista, ma_charter, ma_arrival, ma_depart, ma_nites, ma_invoice, ma_due_tot, getOccupancyNights('01-sep-22',ma_arrival, ma_depart, ma_nites, ma_due_tot) OCC_NTS_SEP, ma_due_tot/ma_nites * getOccupancyNights('01-sep-22',ma_arrival, ma_depart, ma_nites, ma_due_tot) OCC_USD_SEP
from rsmaes_cielo_reserva
where '05-sep-22' between trunc(ma_arrival) and trunc(ma_depart-1)
order by 3,4,5      


select unique ma_mayorista
from rsmaes_cielo
where ma_arrival between '01-sep-22' and '30-sep-22';


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
FROM avfreserpr@oc_comer.travamerica.com            -- facturacion de reservas avalon
WHERE rd_tipo = 'F';



 
union 
select 
     lpad(rv_hotel,2,'0')       ma_hotel
    ,rv_reserva     ma_reserv
    ,1       ma_line
    ,nvl(ag_nombre, rv_agencia)     ma_charter
    ,rv_mayorista   ma_mayorista
    ,rv_llegada     ma_arrival
    ,rv_salida      ma_depart
    ,rv_noches      ma_nites
    ,rv_voucher     ma_voucher
    ,round(convertToUSD(rv_llegada, rv_moneda, rv_importe),2) ma_due_tot
    ,'USD'          ma_currency
    ,''             ma_invoice
    ,rv_adulto      ma_adult
    ,(nvl(rv_menor,0)+nvl(rv_junior,0))       ma_child
    ,rv_bebe        ma_infant
FROM FRESERVA_HOTELES, fragen  
WHERE rv_status != 'C'  -- solo reservas activas
    and ag_mayorista(+) = rv_mayorista
    and ag_agencia(+) = rv_agencia
    and exists ( 
        select 1
        from FRESERPR@oc_comer.travamerica.com          -- Facturacion de viejas reservas
        where   rd_reserva = rv_reserva
            and rd_tipo = 'F'
    )
;     



