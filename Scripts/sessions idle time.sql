DECLARE
CURSOR session_cursor IS 
 SELECT username, sid, last_call_et
      FROM v$session
      WHERE username IS NOT NULL AND username NOT IN ('SYS','SYSTEM')
      ORDER BY last_call_et;
  
    num_mins        NUMBER;
    num_mins_sec    NUMBER;
    wait_secs       NUMBER;
    num_hours       NUMBER;
    num_hours_min   NUMBER;
    wait_mins       NUMBER;
   num_days        NUMBER;
    num_days_hours  NUMBER;
    wait_hours      NUMBER;
   wait_char_mins  VARCHAR2(4);
    wait_char_secs  VARCHAR2(4);
  
  BEGIN
  
    DBMS_OUTPUT.PUT_LINE(chr(10));
  
    FOR idle_time IN session_cursor LOOP
  
    -- Total number of seconds waited...
  
      num_mins := trunc(idle_time.last_call_et/60);
      num_mins_sec := num_mins * 60;
      wait_secs := idle_time.last_call_et - num_mins_sec;
  
    -- Total number of minutes waited...
  
      num_hours := trunc(num_mins/60);
      num_hours_min := num_hours * 60;
      wait_mins := num_mins - num_hours_min;
  
    -- Total number of hours waited...
  
      num_days := trunc(num_hours/24);
      num_days_hours := num_days * 24;
      wait_hours := num_hours - num_days_hours;
  
      DBMS_OUTPUT.PUT('User '||idle_time.USERNAME||'('||idle_time.SID||') has been idle for '||num_days||' day(s) '||wait_hours||':');
    
      IF wait_mins < 10 THEN
        wait_char_mins := '0'||wait_mins||'';
        DBMS_OUTPUT.PUT(''||wait_char_mins||':');
       ELSE
        DBMS_OUTPUT.PUT(''||wait_mins||':');
      END IF;
  
      IF wait_secs < 10 THEN
        wait_char_secs := '0'||wait_secs||'';
        DBMS_OUTPUT.PUT(''||wait_char_secs||'');
      ELSE
        DBMS_OUTPUT.PUT(''||wait_secs||'');
      END IF;
    
      DBMS_OUTPUT.NEW_LINE;
  
    END LOOP;
  
  END;