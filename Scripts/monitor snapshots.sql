

select * from user_jobs where broken ='Y';

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

alter snapshot frmodfas refresh on demand;

alter snapshot frmodhot refresh on demand;

alter snapshot frfechas refresh on demand;

alter snapshot frtipoca refresh on demand;

alter snapshot frconmaes refresh on demand;

alter snapshot frtarifpl refresh on demand;

alter snapshot frpromoc refresh on demand;

alter snapshot frpromoa refresh on demand;

alter snapshot frtiphab refresh on demand;

alter snapshot frpropina refresh on demand;


begin
--dbms_job.broken(1,TRUE);
dbms_job.broken(12,TRUE);
commit;
end;
/

drop snapshot mv;

CREATE snapshot mv
tablespace hotel
storage (INITIAL 640K NEXT 1M)
refresh on demand
AS SELECT * FROM fragen@oc_comer.travamerica.com;

drop snapshot mv;

select * from frtipoca;

select count(*) from frpromoa;

create materialized view mv 
    refresh fast on demand
    with rowid
    as select t.* from frparam@oc_comer.travamerica.com t;
    
   
select * from frparam@oc_comer.travamerica.com;

execute DBMS_SNAPSHOT.REFRESH( 'frparam','f');



select count(*)
from frconmaes
where cm_fecha_fin >= trunc(sysdate-120,'YEAR');

select count(*) from frconmaes;

select *
from frtarifpl
where cp_fecha_fin >= trunc(sysdate-120,'YEAR');

select * from frpromoc;


select to_char(count(*),'999,999,999')
from frpromoa
where pa_fecha_fin >= trunc(sysdate-120,'MONTH');



GENLIBGOXLS_TRAV

execute genLIBGOXLS_TRAV (sysdate-2);