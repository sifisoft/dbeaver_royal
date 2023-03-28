
 
-- Uncommited transactions 

SELECT t.start_time, s.sid, s.serial#, s.username, s.status,s.schemaname, s.osuser
   , s.process, s.machine, s.terminal, s.program, s.module
   , to_char(s.logon_time,'DD/MON/YY HH24:MI:SS') logon_time
FROM v$transaction t, v$session s
WHERE s.saddr = t.ses_addr
ORDER BY start_time;


-- Waiting sessions

select sid,sql_text 
from  v$session s,  v$sql q 
where
    sid in (
        select  sid
        from v$session
        where state in ('WAITING')
            and wait_class != 'Idle'
            and event='enq: TX - row lock contention'
            and (q.sql_id = s.sql_id or q.sql_id = s.prev_sql_id)
    );
    

-- Blocking session.

select blocking_session, sid,    serial#, wait_class, seconds_in_wait 
from v$session 
where blocking_session is not NULL
order by  blocking_session;

    