
DROP VIEW FRESERVA_TRAVAMERICA;



/* Formatted on 1/23/2013 4:25:13 PM (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW FRESERVA_TRAVAMERICA
(
   RV_HOTEL,
   RV_RESERVA,
   RV_MAYORISTA,
   RV_AGENCIA,
   RV_GRUPO,
   RV_PAIS,
   RV_CODPOS,
   RV_TIPO_HUESPED,
   RV_VIP,
   RV_LLEGADA,
   RV_SALIDA,
   RV_NOCHES,
   RV_LLEGADA_H,
   RV_VUELO,
   RV_LINEA,
   RV_TIPO_HAB,
   RV_ADULTO,
   RV_MENOR,
   RV_BEBE,
   RV_PLAN_1,
   RV_PLAN_2,
   RV_PAQUETE,
   RV_SERVICIO,
   RV_NOTAS,
   RV_STATUS,
   RV_TARIFA,
   RV_IMPORTE,
   RV_DEPOSITO,
   RV_APELLIDO_1,
   RV_NOMBRE_1,
   RV_APELLIDO_2,
   RV_NOMBRE_2,
   RV_APELLIDO_3,
   RV_NOMBRE_3,
   RV_APELLIDO_4,
   RV_NOMBRE_4,
   RV_MAYORISTA_CUN,
   RV_HABI,
   RV_VOUCHER,
   RV_RESERVA_A,
   RV_HOTEL_ORIG,
   RV_CAP_F,
   RV_CAN_F,
   RV_MOD_F,
   RV_SEMAFORO,
   RV_NOTAS_HOTEL,
   RV_NOTAS_CENTRAL,
   RV_SOURCE,
   RV_AGENCY_CONF,
   RV_MONEDA
)
AS
   SELECT 
          --NVL (rv_hotel_renta, mf_modulo) rv_hotel,
          --mf_modulo rv_hotel,
          decode(rv_hotel_renta,'6','6',mf_modulo) rv_hotel,
          rv_reserva,
          rv_mayorista,
          rv_agencia,
          rv_grupo,
          rv_pais,
          rv_codpos,
          rv_tipo_huesped,
          rv_vip,
          rv_llegada,
          rv_salida,
          rv_noches,
          REPLACE (rv_llegada_h, ':', NULL) rv_llegada_h,
          rv_vuelo,
          rv_linea,
          rv_tipo_hab,
          rv_adulto,
          rv_menor,
          rv_bebe,
          travamerica_utils.getPlan (rv_reserva, '1') rv_plan_1,     -- Plan 1
          travamerica_utils.getPlan (rv_reserva, '2') rv_plan_2,     -- Plan 2
          rv_paquete,
          NULL rv_servicio,                                        -- Servicio
          rv_notas,
          rv_status,                                                  --Status
          NULL rv_tarifa,                                       -- tipo tarifa
          rv_importe,
          rv_deposito,
          travamerica_utils.getApellido (rv_reserva, '1') rv_apellido_1, -- apellido 1
          travamerica_utils.getNombre (rv_reserva, '1') rv_nombre_1, -- nombre 1
          travamerica_utils.getApellido (rv_reserva, '2') rv_apellido_2, -- apellido 2
          travamerica_utils.getNombre (rv_reserva, '2') rv_nombre_2, -- nombre 2
          travamerica_utils.getApellido (rv_reserva, '3') rv_apellido_3, -- apellido 3
          travamerica_utils.getNombre (rv_reserva, '3') rv_nombre_3, -- nombre 3
          travamerica_utils.getApellido (rv_reserva, '4') rv_apellido_4, -- apellido 4
          travamerica_utils.getNombre (rv_reserva, '4') rv_nombre_4, -- nombre 4
          NULL rv_mayorista_cun,                              -- mayorista cun
          rv_habi,                                               -- habitacion
          rv_voucher,                                               -- voucher
          rv_reserva_p,                                     -- reserva p
          rv_hotel_renta,                                        -- Hotel orig
          rv_cap_f,
          rv_can_f,
          rv_mod_f,
          NULL rv_semaforo,                                        -- semaforo
          NULL rv_notas_hotel,                                  -- notas hotel
          NULL rv_notas_central,                              -- notas central
          rv_origen rv_source,                                       -- source
          NULL rv_agency_conf,                                  -- agency conf
          rv_moneda
     FROM freserva, frmodfas
    WHERE mf_fase = rv_fase;
