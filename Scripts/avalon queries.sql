


rsmaes_avalon

select * from rsmaes_avalon where ma_arrival > sysdate;


select getHotelCodeFromAvalon('01','SKMS') 
from dual;

select *
from habitacion_avalon_crs@royal
where cod_hab_avalon = 'SKMS';

-- Reservas Panama que no están en externas ni valoradas..
select *
from RecReservas r 
     left outer join RecReservasPreciosExterno pe on pe.Reserva = r."Reserva" and pe.Linea = r."Linea" 
     left outer join RecReservasValoracion_panama rvp on rvp.Reserva = r."Reserva" and rvp.Linea = r."Linea"
where   r."Segmento" in ('USA','ALG','CAN','SUD','EUR') 
    and "Linea" > 0 
    and "CancelacionFecha" is null
    and pe.Reserva is null  
    and rvp.Reserva is null
order by r."LlegadaDia"    


-- Reservas en cero... 
select ma_reserv, ma_line, ma_mayorista, ma_charter, ma_hotel
from rsmaes_avalon_new
where ma_can_d is null and nvl(ma_due_tot,0) = 0 and ma_mayorista in ('EUR','ALG','CAN','SUD','EUR')
order by ma_arrival;




select unique "Segmento"  from RecReservas where trunc("AltaFecha") = to_date('9/4/22','mm/dd/yy') 

-- Esta forma es mas eficiente...
select * from RecReservas where "AltaFecha" between '9/4/22 00:00:00 AM' and '9/4/22 11:59:59 PM' ;

-- Esta forma cuesta mas al servidor... 
select * from RecReservas where trunc("AltaFecha") = to_date('9/4/22','mm/dd/yy') order by "AltaFecha" ;



select * from RecReservasClientes;



select ma_due_tot, t.* from rsmaes_avalon t where ma_reserv = :avalonBooking;

select * from RecReservas where "Reserva" = :avalonBooking;

select * from RecReservasDetalle where "Reserva" = :avalonBooking;

select * from ProDetalleEstancia  where Reserva = :avalonBooking;

select * from RecReservasPreciosExterno where Reserva = :avalonBooking;

select * from RecReservasPreciosExterno@Avalon where "Reserva" = :avalonBooking;

select * from RecReservasDiario@Avalon where "Reserva"= :avalonBooking;

select * from RECReservasValoracion@Avalon_panama where "Reserva" = :avalonBooking;

select * from RecReservasValoracion@Avalon_mexico where "Reserva" = :avalonBooking;

select * from RecReservasValoracion_mexico where reserva = :avalonBooking and linea = :linea;

select unique "DivisaFac" from RECReservasValoracion@Avalon_mexico where "Reserva" = :avalonBooking and "LineaReserva" = :linea;


select * from RECReservasValoracion@Avalon where "Reserva" = :avalonBooking

select * from RecReservasValoracion where Reserva = :avalonBooking;

select * from entidad_negocio_avalon@avalon;


select ma_reserv, ma_line, ma_due_tot, ma_divisa, ma_inp_d from rsmaes_avalon where ma_reserv = :avalonBooking;



with agrupados as (
select "Reserva", "LineaReserva", "DivisaFac"
from RECReservasValoracion@Avalon_panama
group by "Reserva", "LineaReserva", "DivisaFac"
)
select "Reserva","LineaReserva", count(*)
from agrupados
group by "Reserva","LineaReserva"
having count(*) > 1

;



-- Reservas NO Valoradas
select *
from RecReservas r
where r."Linea" >= 1 and r."Segmento" in ('USA','ALG','CAN','SUD','EUR') and r."CancelacionFecha" is null and  r."LlegadaDia" between to_date('01-sep-22','dd-mon-yy') and to_date('31-oct-22','dd-mon-yy') and  not exists (
    select 1
    from RecReservasValoracion_panama rvp
    where   rvp.Reserva = r."Reserva"
        and rvp.Linea = r."Linea"
);





select * from all_db_links;

select * from RECReservasValoracion@Avalon_PANAMA;

select * from RECReservasValoracion@Avalon;

select

select * from usuarios@avalon_panama;

create view RecReservasValoracion_panama as select * from RecReservasValoracion@avalon_panama;


select * from RecReservasValoracion_panama;

select * from RecReservasValoracion_mexico;


create or replace view RecReservasValoracion_panama as
select "Reserva" Reserva, "LineaReserva" Linea, 
case when count(unique "DivisaFac") > 1 then 
    sum(
        case when "DivisaFac" = 'MXN' then "PrecioFac"/20 
        else "PrecioFac" 
        end
    ) 
    else sum("PrecioFac") 
end Importe,
case 
    when count(unique "DivisaFac") > 1 then 'USD' 
    else max(to_char("DivisaFac")) 
end Divisa
from RECReservasValoracion@Avalon_panama
where "PrecioFac" > 0
group by "Reserva", "LineaReserva"
;


create or replace view RecReservasValoracion_mexico as
select "Reserva" Reserva, "LineaReserva" Linea, 
case when count(unique "DivisaFac") > 1 then 
    sum(
        case when "DivisaFac" = 'MXN' then "PrecioFac"/20 
        else "PrecioFac" 
        end
    ) 
    else sum("PrecioFac") 
end Importe,
case 
    when count(unique "DivisaFac") > 1 then 'USD' 
    else max(to_char("DivisaFac")) 
end Divisa
from RECReservasValoracion@Avalon_mexico
where "PrecioFac" > 0
group by "Reserva", "LineaReserva"
;


CREATE OR REPLACE FORCE VIEW RecReservasValoracion
AS
SELECT "Reserva"    Reserva,  "LineaReserva" LineaReserva,
    case when count(unique "DivisaFac") > 1 then 
    sum(
        case when "DivisaFac" = 'MXN' then "PrecioFac"/20 
        else "PrecioFac" 
        end
    ) 
    else sum("PrecioFac") 
end Importe,
case 
    when count(unique "DivisaFac") > 1 then 'USD' 
    else max(to_char("DivisaFac")) 
end Divisa
FROM RecReservasValoracion@Avalon
where "PrecioFac" > 0
GROUP BY "Reserva", "LineaReserva"
;


select * from recReservasValoracion@avalon_panama;


create or replace view RecReservasDiario as
select "Reserva" Reserva, "Linea" Linea, 
case when count(unique "Divisa") > 1 then 
    sum(
        case when "Divisa" = 'MXN' then "PrecioManual"/20 
        else "PrecioManual" 
        end
    ) 
    else sum("PrecioManual") 
end Importe,
case 
    when count(unique "Divisa") > 1 then 'USD' 
    else max(to_char("Divisa")) 
end Divisa
from RECReservasDiario@Avalon
where "PrecioManual" > 0
group by "Reserva", "Linea"
;





create or replace view RecReservasPreciosExterno as
select "Reserva" Reserva, "Linea" Linea, 
case when count(unique "Divisa") > 1 then 
    sum(
        case when "Divisa" = 'MXN' then "Importe"/20 
        else "Importe" 
        end
    ) 
    else sum("Importe") 
end Importe,
case 
    when count(unique "Divisa") > 1 then 'USD' 
    else max(to_char("Divisa")) 
end Divisa
from RecReservasPreciosExterno@Avalon
where "Importe" > 0
group by "Reserva", "Linea"
;


drop view PRODETALLEESTANCIA2;



CREATE OR REPLACE FORCE VIEW PRODETALLEESTANCIA
AS
SELECT "Reserva"    Reserva,  "LineaReserva" LineaReserva,
    case when count(unique "Divisa") > 1 then 
    sum(
        case when "Divisa" = 'MXN' then "Precio"/20 
        else "Precio" 
        end
    ) 
    else sum("Precio") 
end Precio,
case 
    when count(unique "Divisa") > 1 then 'USD' 
    else max(to_char("Divisa")) 
end Divisa
FROM ProDetalleEstancia@Avalon
where "Precio" > 0
GROUP BY "Reserva", "LineaReserva";




select * from proDetalleEstancia;








select * from RecReservasValoracion@Avalon;



-- reservas NO Valoradas
select sum(precioFAC) 
from dbo.RECReservasValoracion 
where Reserva=r.Reserva and LineaReserva=r.linea 
group by  Reserva,LineaReserva;




-- Tour Operators 

select * from RECReservasValoracion@Avalon;

select * from rsmaes_avalon_2 where ma_reserv = 'GOCRS220003989'

select * from rsmaes_avalon where ma_reserv = 'GOCRS220003989'

select * from rsmaes_avalon 

select * from rsmanames_avalon


select ma_hotel, ma_reserv, ma_line, ma_mayorista, ma_due_tot, ma_divisa from rsmaes_avalon_new where ma_can_d is null;


rsmaes_avalon


/* Formatted on 10/19/2022 10:40:34 AM (QP5 v5.313) */
CREATE OR REPLACE FORCE VIEW HOTEL.RSMAES_AVALON
(
    MA_HOTEL,
    MA_RESERV,
    MA_LINE,
    MA_CHARTER,
    MA_SUBCHAR,
    MA_GROUP,
    MA_COUNTRY,
    MA_CITY,
    MA_ADRESS1,
    MA_ADRESS2,
    MA_GUEST,
    MA_VIP,
    MA_SOURCE,
    MA_CONT_N,
    MA_CONT_T,
    MA_ARRIVAL,
    MA_DEPART,
    MA_NITES,
    MA_ARR_TIME,
    MA_FLIGHT,
    MA_CARRIER,
    MA_ROOM,
    MA_RATE,
    MA_ADULT,
    MA_CHILD,
    MA_INFANT,
    MA_PLAN_1,
    MA_PLAN_2,
    MA_PACKAGE,
    MA_FIRST,
    MA_REM_USER,
    MA_REM_SYS,
    MA_INP_U,
    MA_INP_D,
    MA_INP_T,
    MA_CAN_D,
    MA_CAN_U,
    MA_CAN_T,
    MA_CAN_C,
    MA_MOD_U,
    MA_MOD_D,
    MA_MOD_T,
    MA_TRANS,
    MA_ROOMING,
    MA_VOUCHER,
    MA_DUE_TOT,
    MA_DEP_REC,
    MA_DEP_TOT,
    MA_AGCY_CNF,
    MA_SPECIAL,
    MA_A_RATE,
    MA_ROOM_NUM,
    MA_PREV_HOTEL,
    MA_PREV_RESERV,
    MA_CRS,
    MA_PEN_AGEN,
    MA_DIVISA,
    MA_MAYORISTA,
    MA_LAST_N,
    MA_FIRST_N
)
AS
    SELECT REPLACE (r."HotelFactura", 'HT', '')   ma_hotel,
           r."Reserva"      ma_reserv,
           d."Linea"
               ma_line,
           r."EntidadNegocio"
               ma_charter,
           r."EntidadNegocio"
               ma_subchar,
           r."Grupo"
               ma_group,
           ''
               ma_country,
           ''
               ma_city,
           ''
               ma_adress1,
           ''
               ma_adress2,
           ''
               ma_guest,
           ''
               ma_vip,
           ''
               ma_source,
           ''
               ma_cont_n,
           ''
               ma_cont_t,
           d."FechaEntrada"
               ma_arrival,
           d."FechaSalida"
               ma_depart,
           d."Noches"
               ma_nites,
           ''
               ma_arr_time,
           ''
               ma_flight,
           ''
               ma_carrier,
           d."THUso"
               ma_room,
           '01'
               ma_rate,
           d."AD"
               ma_adult,
           d."NI" + d."JR"
               ma_child,
           d."CU"
               ma_infant,
           d."RegimenUso"
               ma_plan_1,
           ''
               ma_plan_2,
           ''
               ma_package,
           ''
               ma_first,
           r."TextoReserva"
               ma_rem_user,
           ''
               ma_rem_sys,
           r."AltaUsuario"
               ma_inp_u,
           trunc(CAST (r."AltaFecha" AS DATE))   ma_inp_d,
           ''
               ma_inp_t,
           CASE d."Estado"
               WHEN 3 THEN trunc(nvl(NVL(r."CancelacionFecha", r."ModificacionFecha"),trunc(d."FechaEntrada"))) -- no-show
               WHEN 4 THEN trunc(nvl(NVL(r."CancelacionFecha", r."ModificacionFecha"),trunc(d."FechaEntrada"))) -- cxl
               ELSE NULL
           END
               ma_can_d,
           CASE d."Estado"
               WHEN 3
               THEN
                   NVL (r."CancelacionUsuario", r."ModificacionUsuario") -- no-show
               WHEN 4
               THEN
                   NVL (r."CancelacionUsuario", r."ModificacionUsuario") -- cxl
               ELSE
                   NULL
           END
               ma_can_u,
           ''
               ma_can_t,
           ''
               ma_can_c,
           r."ModificacionUsuario"
               ma_mod_u,
           trunc(r."ModificacionFecha") ma_mod_d,
           ''
               ma_mod_t,
           ''
               ma_trans,
           ''
               ma_rooming,
           NVL (r."Localizador", r."Bono")
               ma_voucher,
           CASE
               WHEN r."Segmento" IN ('USA',
                                     'ALG',
                                     'CAN',
                                     'SUD',
                                     'EUR')
               THEN
                   NVL (NVL (NVL (pe.Importe, rvp.Importe), rv.Importe), 0)
               ELSE
                   NVL (NVL (rvm.Importe, rv.Importe), 0)
           END
               ma_due_tot,
           0
               ma_dep_rec,
           0
               ma_dep_tot,
           ''
               ma_agcy_cnf,
           ''
               ma_special,
           0
               ma_a_rate,
           d."Habitacion"
               ma_room_num,
           ''
               ma_prev_hotel,
           ''
               ma_prev_reserv,
           ''
               ma_crs,
           ''
               ma_pen_agen,
           CASE
               WHEN r."Segmento" IN ('USA','ALG','CAN','SUD','EUR')
               THEN NVL (NVL (pe.Divisa, rvp.Divisa), rv.Divisa)
               ELSE NVL (rvm.Divisa, rv.Divisa)
           END
               ma_divisa,
           r."Segmento"
               ma_mayorista,
           SUBSTR (r."NombreContacto",
                   0,
                   INSTR (r."NombreContacto", ',') - 1)
               ma_last_n,
           SUBSTR (r."NombreContacto",
                   INSTR (r."NombreContacto", ',', -1) + 1)
               ma_first_n
      FROM RecReservas                   r,
           RecReservasDetalle            d,
           RecReservasPreciosExterno     pe,
           RecReservasValoracion_panama  rvp,
           RecReservasValoracion_mexico  rvm,
           RecReservasValoracion         rv
     WHERE     r."Reserva" = d."Reserva"
           AND r."Linea" = d."Linea"
           AND r."Linea" > 0
           AND rvp.Reserva(+) = r."Reserva"
           AND rvp.Linea(+) = r."Linea"
           AND rvm.Reserva(+) = r."Reserva"
           AND rvm.Linea(+) = r."Linea"
           AND rv.Reserva(+) = r."Reserva"
           AND rv.LineaReserva(+) = r."Linea"
           AND pe.Reserva(+) = r."Reserva"
           AND pe.Linea(+) = r."Linea";

       
   
   
   
   
   
CREATE OR REPLACE FORCE VIEW HOTEL.RECRESERVASPRECIOSEXTERNO
(
    RESERVA,
    LINEA,
    IMPORTE,
    DIVISA
)
AS
      SELECT "Reserva"     Reserva,
             "Linea"       Linea,
             SUM ("Importe") Importe,
             "Divisa"      Divisa
        FROM RecReservasPreciosExterno@Avalon
    GROUP BY "Reserva", "Linea", "Divisa";   
   

CREATE OR REPLACE FORCE VIEW HOTEL.RECRESERVASPRECIOSEXTERNO
(
    RESERVA,
    LINEA,
    IMPORTE,
    DIVISA
)
AS
      SELECT "Reserva"     Reserva,
             "Linea"       Linea,
             SUM("Importe") Importe,
             "Divisa"      Divisa
        FROM RecReservasPreciosExterno@Avalon
    GROUP BY "Reserva", "Linea", "Divisa";   




CREATE DATABASE LINK AVALON_PANAMA  CONNECT TO ROYAL  IDENTIFIED BY "Royal2022**"  USING 'AVALON_PANAMA';

CREATE DATABASE LINK AVALON_MEXICO  CONNECT TO ROYAL  IDENTIFIED BY "Royal2022**"  USING 'AVALON_MEXICO';



select *
from rsmaes_avalon_sintotal
where ma_arrival = trunc(sysdate);


drop public synonym registroAplicacion;


create view registroAplicacion as select 
"Fecha" fecha
, "Tabla" tabla
, "Operacion" operacion
, "Usuario" usuario
, "Secuencia" secuencia
, "ClaveActual" claveActual
, "ClaveAnterior" claveAnterior
from registroAplicacion@avalon;


select *
from registroAplicacion@avalon;

drop view registroAplicacion;

create public synonym registroAplicacion  for registroAplicacion@Avalon;

registroAplicacion