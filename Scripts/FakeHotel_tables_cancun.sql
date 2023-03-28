


select * from rsfakehotel

select * from rsfakehotel_vs_real

select * from rsfakehotel_rooms


select * from freserva_hoteles_fakehotel where rv_hotel = 82 and rv_llegada > sysdate and rv_status <> 'C' and rv_tipo_hab = 'GSTE' and rv_mayorista <> 'AME'

refreshrsavailable_sum_trg_mex

select * from rsavailable_sum_trg where av_hotel = '82' and av_market = 'TC'


select trav_code from travmarkets





create table rsfakehotel (
    xf_fake_hotel   varchar2(6),
    xf_desc         varchar2(640),
    constraint rsfakehotel_key primary key (xf_fake_hotel)
)
storage (initial 1K next 1K pctincrease 10)
/

create table rsfakehotel_vs_real(
    xh_fake_hotel   varchar2(6),
    xh_real_hotel   varchar2(6),
    constraint rsfakehotel_vs_realpk primary key (xh_fake_hotel, xh_real_hotel),
    constraint rsfakehotel_vs_realfk foreign key (xh_fake_hotel) references rsfakehotel(xf_fake_hotel)
)    
storage (initial 1K next 1K pctincrease 10)
/

create table rsfakehotel_rooms(
    xr_fake_hotel   varchar2(6),
    xr_real_hotel   varchar2(6),
    xr_real_room    varchar2(24),
    constraint rsfakehotel_rooms primary key (xr_fake_hotel, xr_real_hotel, xr_real_room),
    constraint rsfakehotel_roomfk foreign key (xr_fake_hotel, xr_real_hotel) references rsfakehotel_vs_real(xh_fake_hotel, xh_real_hotel)
)    
storage (initial 4K next 1K pctincrease 10)
/

insert into rsfakehotel
values (81, 'Paco quiere sumar ocupacion del SKGT con GOT (GDOF y GPLS)')
/

insert into rsfakehotel_vs_real
values (81,'15')
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




/* Formatted on 11/25/2017 1:30:58 PM (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW FRESERVA_HOTELES_FAKEHOTEL
AS
        select 
            XF_FAKE_HOTEL RV_HOTEL,
            RV_SIGLAS,
            RV_RESERVA,
            RV_STATUS,
            RV_MAYORISTA,
            RV_AGENCIA,
            RV_AG_DESC,
            RV_GRUPO,
            RV_NOMBRE,
            RV_LLEGADA,
            RV_SALIDA,
            RV_NOCHES,
            RV_ADULTO,
            RV_MENOR,
            RV_BEBE,
            RV_TARIFA,
            RV_IMPORTE,
            RV_MONEDA,
            RV_TC,
            RV_PROMOCION,
            RV_DEPOSITO,
            RV_PREPAGO_F,
            RV_PREPAGO_I,
            RV_HABI,
            RV_TIPO_HAB,
            RV_VOUCHER,
            RV_CAP_U,
            RV_CAP_F,
            RV_CAP_H,
            RV_MOD_U,
            RV_MOD_F,
            RV_MOD_H,
            RV_CAN_U,
            RV_CAN_F,
            RV_CAN_H,
            RV_HOTEL_RENTA,
            RV_HOTEL_DEST,
            RV_RESERVA_P,
            RV_ORIGEN,
            RV_SALIDA_PREV,
            RV_NOTAS
    from freserva_hoteles, rsfakehotel 
    WHERE     EXISTS
                 (SELECT 1
                    FROM rsfakehotel_vs_real
                   WHERE     xh_fake_hotel = xf_fake_hotel
                         AND xh_real_hotel = rv_hotel)
          --and ma_can_d is null
          --and trunc(sysdate) between ma_arrival and ma_depart-1
          AND (   NOT EXISTS
                         (SELECT 1
                            FROM rsfakehotel_rooms
                           WHERE     xr_fake_hotel = xf_fake_hotel
                                 AND xr_real_hotel = rv_hotel)
               OR EXISTS
                     (SELECT 1
                        FROM rsfakehotel_rooms
                       WHERE     xr_fake_hotel = xf_fake_hotel
                             AND xr_real_hotel = rv_hotel
                             AND xr_real_room = rv_tipo_hab));




select * 
from freserva_hoteles_fakehotel;