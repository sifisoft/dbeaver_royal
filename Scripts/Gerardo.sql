


select usr_name, creadas, modificadas, canceladas from  (select usr_name,SUBSTR(usr_name,1,7) usr 
from menu_user 
where usr_name in('NGORDON','MRAMOS','JAGUILAR','AAROSEMENA','ABDIEL','DIANA','RALLEN','MLASSO','YAJAIRA','JMEDINA','KIM','GCASTILLO')) A1
left join ( select SUBSTR(ma_inp_u,1,7) ma_inp_u,count(*) creadas from rsmaes where ma_inp_d=:activityDate group by SUBSTR(ma_inp_u,1,7)) A on A.ma_inp_u like A1.usr||'%' 
left join ( select ma_mod_u,count(*) modificadas from rsmaes where ma_mod_d=:activityDate group by ma_mod_u) B on b.ma_mod_u like A1.usr||'%' 
left join ( select ma_can_u,count(*) canceladas from rsmaes where  ma_can_d=:activityDate group by  ma_can_u) C on c.ma_can_u like A1.usr||'%' 
order by usr_name;


select count(*)
from rsmaes
where trim(ma_inp_u) like trim(substr('AAROSEMENA',1,7)) || '%' and trunc(ma_inp_d) = '6-JUN-22';


with usuarios as (
    select 'NGORDON','MRAMOS','JAGUILAR','AAROSEMENA','ABDIEL','DIANA','RALLEN','MLASSO','YAJAIRA','JMEDINA','KIM','GCASTILLO'
    from dual;
);


select usr_name, 
    (
     select count(*)
     from rsmaes
     where ma_inp_u = usr_name 
        and trunc(ma_inp_d) = :activityDate
    ) newBookings,
    (
     select count(*)
     from rsmaes
     where ma_mod_u = usr_name 
        and trunc(ma_mod_d) = :activityDate
    ) modBookings, 
    (
     select count(*)
     from rsmaes
     where ma_can_u = usr_name 
        and trunc(ma_can_d) = :activityDate
    ) newBookings
from menu_user 
where usr_name in ('NGORDON','MRAMOS','JAGUILAR','AAROSEMENA','ABDIEL','DIANA','RALLEN','MLASSO','YAJAIRA','JMEDINA','KIM','GCASTILLO')
order by usr_name
; 

