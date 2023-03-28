

select t.*, t.rowid
from travmenu t
order by optionid;


select t.*, t.rowid
from travuser t
order by userid;


select t.*, t.rowid
from rshotel_report t;



select t.*, t.rowid 
from travuseroptions t
--where userid = :userid;

select * from rshotel_report;


select *
from travuserhotel
where optionid = 21
--where userid = :userid;


delete from travuserhotel 
where optionid = 21;


select * from rsmaes_fakehotel;


refreshRSAVAILABLE_SUM_TRg


update travuseroptions
set userid = :newUser
where userid = :userid;

update travuserhotel
set userid = :newUser
where userid = :userid;

delete from travuserhotel
where userid = :userid;

select * from cat where table_name like 'TRAVUSER%';



select *
from conta_user;