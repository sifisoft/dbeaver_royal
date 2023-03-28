
/** Max sessions and processes and utilization **/    
select resource_name, current_utilization, max_utilization, limit_value 
from v$resource_limit 
where resource_name in ('sessions', 'processes');

Select count(*) from v$process where BACKGROUND=1;

/** Open cursors and what is the limit  **/
SELECT  to_char(sum(a.value),'999') as current_open_cur, p.value as max_open_cur 
FROM v$sesstat a, v$statname b, v$parameter p 
WHERE  a.statistic# = b.statistic#  and b.name = 'opened cursors current' and p.name= 'open_cursors' group by p.value;

/** SID of sessions using more open cursors **/    
select a.value, s.username, s.sid, s.serial# 
from v$sesstat a, v$statname b, v$session s 
where a.statistic# = b.statistic#  and s.sid=a.sid and b.name = 'opened cursors current' and s.username is not null
order by value desc;    

/** Which query has more open cursors*/
select  sid ,sql_text, count(*) as "OPEN CURSORS", USER_NAME from v$open_cursor where sid in (:sidNumber) group by sid, sql_text, user_name order by 3 desc;

/** cpu consumption **/
select * from 
(select sql_text, 
cpu_time/1000000 cpu_time, 
elapsed_time/1000000 elapsed_time, 
disk_reads, 
buffer_gets, 
rows_processed 
from v$sqlarea 
order by cpu_time desc, disk_reads desc
) 
where rownum < 30;


/** Session blocking tables **/
SELECT O.OBJECT_NAME, S.SID, S.SERIAL#, P.SPID, S.PROGRAM,S.USERNAME,
S.MACHINE,S.PORT , S.LOGON_TIME,SQ.SQL_FULLTEXT 
FROM V$LOCKED_OBJECT L, DBA_OBJECTS O, V$SESSION S, 
V$PROCESS P, V$SQL SQ 
WHERE L.OBJECT_ID = O.OBJECT_ID 
AND L.SESSION_ID = S.SID AND S.PADDR = P.ADDR 
AND S.SQL_ADDRESS = SQ.ADDRESS;

/** Snapshots refresh times **/
SELECT *
FROM dba_snapshot_refresh_times;

/** Running snap **/
select JOB, BROKEN,LAST_DATE ,substr(WHAT, 1, 100) from dba_jobs order by 3;


select * from dba_ddl_locks where owner = 'HOTEL' order by name;

/** Sesiones activas e inactivas **/
select s.status, count(1), s.username 
from v$process p, v$session s
where paddr(+)=addr
group by s.status,   s.username
order by 1;


/** Modify max open cursors **/
alter system set open_cursors = 2500 scope=both;

alter system set processes = 250 scope=both;

alter system set sessions = 500 scope=both;
