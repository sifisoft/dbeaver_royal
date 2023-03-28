


execute updateAgentActivity(trunc(sysdate-39));



select * 
from rsReservations_agents_activity
where agent = 'BOOK' and trunc(date_hour) = trunc(sysdate);
;



select level - 1 lvl
    from
      dual
    connect by
   level <= (to_date('10-01-2015','dd-mm-yyyy') - to_date('04-01-2016','dd-mm-yyyy'))+ 1;
   
   

select ma_inp_u, TRUNC(sysdate,'HH') - level/24
from reservations_active_users_view
connect by level <= 2
order by 1,2 ;


select *
from rsmaes;




create or replace view reservations_active_users_view as
select unique ma_inp_u
from rsmaes
where ma_inp_u is not null and ma_inp_d > sysdate - 120
order by ma_inp_u;

create table rsReservations_agents_activity (
    agent                varchar2(30),
    date_hour           date,
    reservations_count  integer
)

select agent, date_hour, count(*)
from rsReservations_agents_activity
group by agent, date_hour
having count(*) > 1;


delete from rsReservations_agents_activity;



insert into rsReservations_agents_activity
select ma_inp_u, trunc(to_date(ma_inp_d||' '||ma_inp_t,'dd-mon-yy hh24mi'),'hh'), count(*)
from rsmaes
where trunc(ma_inp_d) = trunc(sysdate-2)
group by ma_inp_u, trunc(to_date(ma_inp_d||' '||ma_inp_t,'dd-mon-yy hh24mi'),'hh')
order by 1,2



select myagent,myhour, (
    select reservations_count
    from rsReservations_agents_activity a
    where   a.agent = myagent
        and a.date_hour = myhour
) conteo
from (
    select agent as myagent
    from rsReservations_agents_activity b
    where trunc(date_hour) = trunc(sysdate-1)
    group by agent
    order by agent
), 
(
    select  TRUNC(sysdate-1) + (level-1)/24 myhour
    from dual
    connect by level <= 24   
)
order by 1, 2 asc;


select sysdate from dual;



select to_char(sysdate,'hh24mi') from dual;




select * from (
    select myagent, (
        select reservations_count
        from rsReservations_agents_activity a
        where   a.agent = myagent
            and a.date_hour = myhour
    ) conteo, to_char(myhour,'hh24mi') my24Hour
    from (
        select agent as myagent
        from rsReservations_agents_activity b
        where trunc(date_hour) = trunc(sysdate-3)
        group by agent
        order by agent
    ), 
    (
        select  TRUNC(sysdate) - level/24 myhour
        from dual
        connect by level <= 24   
    )
)
pivot (
    sum(conteo)
    for my24Hour in ('0000','0100','0200','0300','0400','0500','0600','0700','0800','0900','1000','1100','1200','1300','1400','1500','1600','1700','1800','1900','2000','2100','2200','2300')
)
order by myagent;



select 'ZINV-'||in_user, to_char(in_inv_date,'hh24mi')
from rinvoice
where in_inv_date > sysdate -20 and in_user != 'SYSTEM' and in_inv_num is not null;


    -- Invoices. 
    insert into rsReservations_agents_activity
    select 'INV-' || in_user, trunc(in_inv_date,'hh'), count(*)
    from rinvoice
    where   in_user != 'SYSTEM' 
        and in_inv_num is not null 
        and trunc(in_inv_date) = trunc(sysdate-45)
    group by in_user, trunc(in_inv_date,'hh')
    order by 1,2;
