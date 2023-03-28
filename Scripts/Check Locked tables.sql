


select a.session_id,a.oracle_username, a.os_user_name, b.owner "OBJECT OWNER", b.object_name,b.object_type,a.locked_mode from 
(select object_id, SESSION_ID, ORACLE_USERNAME, OS_USER_NAME, LOCKED_MODE from v$locked_object) a, 
(select object_id, owner, object_name,object_type from dba_objects) b
where a.object_id=b.object_id


desc REFRESHRSAVAILABLE_SUM_TRG_USO


select t.*, t.rowid
from rsavailable_sum_trg_uso t



execute refreshrsavailable_sum_trg_uso(trunc(sysdate-1,'MONTH'),last_day(add_months(sysdate,4)));


            select rv_hotel, rv_agencia, rv_reserv  
            from freserva_hoteles
            where rv_status != 'C'
                and '01-JUL-13' between rv_llegada and rv_salida  
            order by ho_hotel, rv_agencia;
            
            
            
select count(*) 
from freserva_hoteles 
where rv_hotel = 1 and rv_llegada = trunc(sysdate)            


select count(*) 
from freserva_hoteles@comer03.travamerica.com 
where rv_status = 'C' and rv_llegada = trunc(sysdate)    



select * 
from all_objects
where object_name = 'FRESERVA_HOTELES'


select * from all_synonyms where synonym_name = 'FRESERVA_HOTELES'


desc freserva_hoteles@comer03.travamerica.com


select * from all_db_links where db_link = 'COMER03.TRAVAMERICA.COM'