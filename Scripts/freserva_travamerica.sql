create view  freserva_travamerica as
select mf_modulo rv_hotel,
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
        rv_llegada_h, 
        rv_vuelo, 
        rv_linea, 
        rv_tipo_hab, 
        rv_adulto, 
        rv_menor, 
        rv_bebe, 
        travamerica_utils.getPlan(rv_reserva, '1') rv_plan_1,       -- Plan 1
        travamerica_utils.getPlan(rv_reserva, '2') rv_plan_2,       -- Plan 2
        rv_paquete, 
        null rv_servicio,       -- Servicio
        rv_notas, 
        rv_status,     --Status
        null rv_tarifa,   -- tipo tarifa
        rv_importe, 
        rv_deposito, 
        travamerica_utils.getApellido(rv_reserva, '1') rv_apellido_1,   -- apellido 1
        travamerica_utils.getNombre(rv_reserva, '1') rv_nombre_1,   -- nombre 1
        travamerica_utils.getApellido(rv_reserva, '2') rv_apellido_2,   -- apellido 2
        travamerica_utils.getNombre(rv_reserva, '2') rv_nombre_2,   -- nombre 2
        travamerica_utils.getApellido(rv_reserva, '3') rv_apellido_3,   -- apellido 3
        travamerica_utils.getNombre(rv_reserva, '3')  rv_nombre_3, -- nombre 3
        travamerica_utils.getApellido(rv_reserva, '4') rv_apellido_4,   -- apellido 4
        travamerica_utils.getNombre(rv_reserva, '4') rv_nombre_4,   -- nombre 4
        null rv_mayorista_cun,   -- mayorista cun
        rv_habi,  -- habitacion
        rv_voucher,  -- voucher
        null rv_reserva_a,  -- reserva p
        rv_hotel_orig,   -- Hotel orig
        rv_cap_f, 
        rv_can_f, 
        rv_mod_f, 
        null rv_semaforo,  -- semaforo
        null rv_notas_hotel,  -- notas hotel
        null rv_notas_central,  -- notas central
        rv_procede rv_source,  -- source
        null rv_agency_conf,  -- agency conf
        rv_moneda 
from  freserva,frmodfas
where   mf_fase = rv_fase;
