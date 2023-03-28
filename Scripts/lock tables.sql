



select a.sid||'|'|| a.serial#||'|'|| a.process
 from v$session a, v$locked_object b, dba_objects c
 where b.object_id = c.object_id
 and a.sid = b.session_id
 and OBJECT_NAME=upper('&TABLE_NAME');



select *
from freserva_hoteles
where rv_reserva = '220405665';





