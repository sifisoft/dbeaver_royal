
select t.*, t.rowid 
from contamenu t
order by optionid;

select t.*, t.rowid
from contauser t
order by userid;


Select t.*, t.rowid 
from contauseroptions t
where userid = 'BLEZCANO';

insert into contauseroptions
select optionid, :newuser
from contauseroptions
where userid = 'BLEZCANO';


DELETE FROM CONTAUSEROPTIONS WHERE USERID = :newuser;

delete from contauser_emp where us_username = :newuser;

delete from contauser where userid = :newuser;





select 0,1,2,3,4 from dual where 1=1;

INSERT INTO contauser_emp
select us_username, 55
from contauser_emp
where em_emp = 50;

insert into contauser_emp
select us_username, 30
from contauser_emp
where em_emp = 60;

COMMIT;

select * from cuentas

delete from contauser_emp
where em_emp = 40


delete from cuentas
where ct_emp= 80 and ct_eje = 14 and ct_nivel = 5

select count(*) from cuentas 
where ct_emp = 80 and ct_eje = 14 



select t.*, t.rowid 
from contauseroptions t
where userid = 'BLEZCANO';

select t.*, t.rowid
from CONTAUSER t;

delete from contauseroptions
where optionid = 100304


select count(*) from rinvoice where trunc(in_inv_date) = trunc(sysdate)


select *
from rsoperator
where op_name like '%APPLE%'



select * from cuentas



select *
from balancen, cuentas
where ban_emp = 60 and ban_plan = 'A' and ban_eje = 18 and ban_per between 0 and 6 and substr(ct_ctady,1,16) = '430 01020100%'
     and ct_emp = ban_emp
     and ct_plan = ban_plan
     and ct_cg = ban_eje
     and ct_cg = ban_cg
     


select sum(case when ban_per < :month then ban_d-ban_h end) BalanceInicial, sum(case when ban_per = :month then ban_d end) debe, sum(case when ban_per = :month then ban_h end) haber    
from balancen 
        where ban_emp = 60
          and ban_plan = 'A' 
          and ban_eje = 18
          and ban_per between 0 and (:month)
          and ban_cg = '430080101143' 
group by ban_cg          



SELECT t.*, t.rowid FROM email t;

COMMIT;

