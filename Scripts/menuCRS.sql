


select *
from menu_user;


select *
from user_options;

select count(*) from fragen;

select count(*) from rsoperator;

select * from travMarkets;

select t.*, t.rowid
from crs3_menu t
order by me_id;


select t.*, t.rowid from crs3_user_options t where uo_usuario like 'PCA%';

select t.*, t.rowid from crs3_user_options t where uo_usuario like 'JTA%';

COMMIT;


delete from crs3_user_options
where uo_usuario = 'NGORDON';

insert into crs3_user_options
select 'JTARAZONA',uo_opcion
from crs3_user_options
where uo_usuario = 'MRAMOS';

commit;





java.sql.SQLException: ORA-20001: Invoice total is different to room + coop  room=729.1 total=692.65 coop=36.46 Booking= 757394


select t.*, t.rowid
from rinvoice t
where in_reserv = '918813';

select *
from rsmaes
where ma_reserv = '757394';
