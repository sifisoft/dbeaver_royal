select u."Usuario",
(select count(*) from recreservas@xe r, RECReservasDetalle@xe rd where r."Reserva"=rd."Reserva" and rd."Linea" = r."Linea" and r."AltaUsuario"= u."Usuario" and to_date(r."AltaFecha",'DD/MM/YY') = to_date(pDate,'MM/DD/YY')) as Nuevas,
(select count(distinct ra."ClaveActual") from RegistroAplicacion@xe ra where ra."Tabla" in ('RECRESERVAS','RECReservasDetalle') and  to_date(ra."Fecha",'DD/MM/YY') = to_date(pDate,'MM/DD/YY') and ra."Operacion"='UPDATE' and ra."Usuario"=u."Usuario" and ra."ClaveActual" like '%||-1%') as Modificadas,
(select count(*) from recreservas@xe  r, RECReservasDetalle@xe  rd where r."Reserva"=rd."Reserva" and rd."Linea" = r."Linea" and rd."AnulacionUsuario" =u."Usuario" and to_date(rd."AnulacionFecha",'DD/MM/YY') = to_date(pdate,'MM/DD/YY')) as Canceladas
from Usuarios@xe  u
where 
 "Ubicacion"='Panama' and 
 "PerfilAcceso" like '%RESE%' and 
 "PerfilAcceso" like 'PMA%' and 
 "FechaBaja" is null
 ;



(select count(distinct ra."ClaveActual") from RegistroAplicacion ra where ra."Tabla" in ('RECRESERVAS','RECReservasDetalle') and  to_date(ra."Fecha",'DD/MM/YY') = to_date(:pDate,'MM/DD/YY') and ra."Operacion"='UPDATE' and ra."Usuario"=u."Usuario" and ra."ClaveActual" like '%||-1%') as Modificadas,


select u."Usuario",
(select count(distinct ra."ClaveActual") from RegistroAplicacion@xe ra where ra."Tabla" in ('RECRESERVAS','RECReservasDetalle') and  to_date(ra."Fecha",'DD/MM/YY') = to_date(:pDate,'MM/DD/YY') and ra."Operacion"='UPDATE' and ra."Usuario"=u."Usuario" and ra."ClaveActual" like '%||-1%') as Modificadas,
from Usuarios@xe  u
where 
 "Ubicacion"='Panama' and 
 "PerfilAcceso" like '%RESE%' and 
 "PerfilAcceso" like 'PMA%' and 
 "FechaBaja" is null
 ;
 
 select *
 from registroAplicacion
 
 
 calcUserActivity