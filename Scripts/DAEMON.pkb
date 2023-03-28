CREATE OR REPLACE package body SYS.daemon as

  function execute_system(command varchar2, timeout number default 10)
    return number is

    s              number;
    result         varchar2(20);
    command_code   number;
    pipe_name      varchar2(30);
  begin

    /* Use unique_session_name to generate a unique name for the return
       pipe. We include this as part of the initial message to the daemon,
       and it is send along the pipe named 'daemon'. */
    pipe_name := dbms_pipe.unIque_session_name;

    /* Send the 'SYSTEM' command to the daemon. */
    dbms_pipe.pack_message('SYSTEM');
    dbms_pipe.pack_message(pipe_name);
    dbms_pipe.pack_message(command);
    s := dbms_pipe.send_message('daemon',timeout);

    if s <> 0 then
       raise_application_error(-20010,
         'Execute_system: Error while sending.  Status = '||s);
    end if;

    /* Check for the handshake message. Note we are now listening on
       the pipe which is unique to this session. */
    s := dbms_pipe.receive_message(pipe_name, timeout);
    if s <> 0 then
       raise_application_error(-20011,
         'Execute_system: Error while receiving. Status = '||s);
    end if;

    /* Get the operating system result code, and display it using
       dbms_output.put_line().  */
    dbms_pipe.unpack_message(result);
    if result <> 'done' then
       raise_application_error(-20012,
         'Execute_system: Done not received.');
    end if;

    dbms_pipe.unpack_message(command_code);
    dbms_output.put_line('System command executed.   result = '||
                         command_code);
    return command_code;
  end execute_system;

  function execute_sql(command varchar2, timeout number default 10)
    return number is

    s             number;
    result        varchar2(20);
    command_code  number;
    pipe_name     varchar2(30);

  begin

    /* Use unique_session_name to generate a unique name for the return
       pipe.  We include this as part of the initial message to the
       daemon, and it is send along the pipe.unique_session_name.     */

    /* Send the 'SQL' command to the daemon   */
    dbms_pipe.pack_message('SQL');
    dbms_pipe.pack_message(pipe_name);
    dbms_pipe.pack_message(command);
    s := dbms_pipe.send_message('daemon',timeout);
    if s <> 0 then
       raise_application_error(-20020,
         'Execute_sql: Error while sending.   Status - '||s);
    end if;

    /* Check for the handshake message.  Note that we are now listening on
       the pipe which is unique to this session.  */
    s := dbms_pipe.receive_message(pipe_name,timeout);
    if s <> 0 then
       raise_application_error(-20021,
         'Exectu_sql: Error while receiving.   Status = '||s);
    end if;

    /* Get the result code from the SQL statement, and display it using
       dbms_output.put_line().  */
    dbms_pipe.unpack_message(result);
    if result <> 'done' then
       raise_application_error(-20022,
         'Execute_sql: Done not received.');
    end if;

    dbms_pipe.unpack_message(command_code);
    dbms_output.put_line('SQL command executed.   sqlcode = '||command_code);
    return command_code;
  end execute_sql;

  procedure stop(timeout number default 10) is
    s  number;
  begin

    /* Send the 'STOP' command to the daemon. */
    dbms_pipe.pack_message('STOP');
    s := dbms_pipe.send_message('daemon',timeout);
    if s <> 0 then
       raise_application_error(-20030,
         'Stop: Error while sending.   Status = '||s);
    end if;
  end stop;

end daemon;
/