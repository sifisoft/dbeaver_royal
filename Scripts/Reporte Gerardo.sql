select 
u.Nombre||' '||u.PrimerApellido,
(select count(*) from recreservas r, RECReservasDetalle rd where r.Reserva=rd.Reserva and rd.Linea = r.Linea and r.AltaUsuario= u.Usuario and r.AltaFecha = :activityDate) as Nuevas,
(select count(distinct ClaveActual) from RegistroAplicacion ra where Tabla in('RECRESERVAS','RECReservasDetalle') and  to_date(Fecha,'DD/MM/YY') = :activityDate and Operacion='UPDATE' and ra.Usuario=u.Usuario and ClaveActual like '%||-1%') as Modificadas,
(select count(*) from recreservas  r, RECReservasDetalle  rd where r.Reserva=rd.Reserva and rd.Linea = r.Linea and rd.AnulacionUsuario =u.Usuario and to_date(rd.AnulacionFecha,'DD/MM/YY') = :activityDate) as Canceladas
from Usuarios  u
where 
 Ubicacion='Panama' and 
 PerfilAcceso like '%RESE%' and 
 PerfilAcceso like 'PMA%' and 
 FechaBaja is null;
 
 


select u.Nombre||' '||u.PrimerApellido,(select count(*) from recreservas r, RECReservasDetalle rd where r.Reserva=rd.Reserva and rd.Linea = r.Linea and r.AltaUsuario= u.Usuario and to_date(r.AltaFecha,'DD/MM/YY') = :activityDate) as Nuevas,(select count(distinct ClaveActual) from RegistroAplicacion ra where Tabla in('RECRESERVAS','RECReservasDetalle') and  to_date(Fecha,'DD/MM/YY') = :activityDate and Operacion='UPDATE' and ra.Usuario=u.Usuario and ClaveActual like '%||-1%') as Modificadas,(select count(*) from recreservas  r, RECReservasDetalle  rd where r.Reserva=rd.Reserva and rd.Linea = r.Linea and rd.AnulacionUsuario =u.Usuario and to_date(rd.AnulacionFecha,'DD/MM/YY') = :activityDate) as Canceladasfrom Usuarios  uwhere  Ubicacion='Panama' and  PerfilAcceso like '%RESE%' and  PerfilAcceso like 'PMA%' and  FechaBaja is null

create view registroAplicacion as select 
"Fecha" fecha
, "Tabla" tabla
, "Operacion" operacion
, "Usuario" usuario
, "Secuencia" secuencia
, "ClaveActual" claveActual
, "ClaveAnterior" claveAnterior
from registroAplicacion@xe;


drop public synonym registroAplicacion;


select * from recReservas

select * from usuarios
