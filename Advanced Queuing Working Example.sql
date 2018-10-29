

DBA Tips Archive for Oracle

  
	
	

Advanced Queuing Working Example - (PL/SQL)

by Jeff Hunter, Sr. Database Administrator

Contents

    Overview
    Setup and Configuration
    Define Payload
    Create Queue Table and Queue
    Enqueue Message
    Dequeue Message
    Dropping All Objects 

Overview

    This article provides a brief overview on configuring and using Oracle's Advanced Queuing features using PL/SQL. This will demonstrate the basic functionality of Oracle Advanced Queuing (AQ). AQ was first introduced in Oracle8 and has been extended and improved on into future versions. 

Setup and Configuration

    Within this section of the article, I provide the steps required to configure our QA environment. This involves creating users and assigning them the privileges required to perform all necessary AQ operations.

    Before creating the users, let's take a look at the two major roles that are provided for performing AQ administration and user operations:

      AQ_ADMINISTRATOR_ROLE

        This role allows for the creation and administration of the queuing infrastructure. 

      AQ_USER_ROLE

        This role allows users to access queues for enqueue and dequeue operations. 

    Now, let's create the following two schemas; one owning the queuing infrastructure and another with access to it:

    create_aq_users.sql


    CONNECT sys/change_on_install as sysdba

    -- -------------------------------------------------------

    DROP USER aq_admin_plsql CASCADE;

    CREATE USER aq_admin_plsql IDENTIFIED BY aq_admin_plsql
      DEFAULT TABLESPACE users
      TEMPORARY TABLESPACE temp;

    ALTER USER aq_admin_plsql QUOTA UNLIMITED ON users;

    GRANT aq_administrator_role TO aq_admin_plsql;
    GRANT connect               TO aq_admin_plsql;
    GRANT create type           TO aq_admin_plsql;
    GRANT create sequence       TO aq_admin_plsql;

    EXECUTE dbms_aqadm.grant_type_access('aq_admin_plsql');

    -- -------------------------------------------------------

    DROP USER aq_user_plsql CASCADE;

    CREATE USER aq_user_plsql IDENTIFIED BY aq_user_plsql
      DEFAULT TABLESPACE users
      TEMPORARY TABLESPACE temp;

    GRANT aq_user_role TO aq_user_plsql;
    GRANT connect      TO aq_user_plsql;

Define Payload

    The content, or payload, of a message is often defined using an OBJECT TYPE. We must define this before creating the queue. We also grant EXECUTE on the payload object type to our AQ user:

    create_payload.sql


    CONNECT aq_admin_plsql/aq_admin_plsql

    CREATE TYPE message_type AS OBJECT (
        message_id     NUMBER(15)
      , subject        VARCHAR2(100)
      , text           VARCHAR2(100)
      , dollar_value   NUMBER(4,2)
    )
    /

    GRANT EXECUTE ON message_type TO aq_user_plsql;

    CREATE SEQUENCE message_seq
           INCREMENT BY 1
           START WITH 1000
           NOMAXVALUE
           NOCYCLE;

    GRANT select ON message_seq TO aq_user_plsql;

Create Queue Table and Queue

    Now that we have the payload created, it is time to create the queuing infrastructure. Queues are implemented using a queue table which can hold multiple queues with the same payload type.

    First the queue table must be defined using the payload type, then the queue can be defined and started. All of these operations can be performed using the DBMS_AQADM package as follows:

    create_queue_table_and_queue.sql


    CONNECT aq_admin_plsql/aq_admin_plsql

    SET SERVEROUTPUT ON

    BEGIN

        -- -------------------------------------------------------

        DBMS_AQADM.CREATE_QUEUE_TABLE (
            queue_table         => 'aq_admin_plsql.msg_qt'
          , queue_payload_type  => 'aq_admin_plsql.message_type'
        );

        -- -------------------------------------------------------

        DBMS_AQADM.CREATE_QUEUE (
            queue_name          => 'msg_queue'
          , queue_table         => 'aq_admin_plsql.msg_qt'
          , queue_type          => DBMS_AQADM.NORMAL_QUEUE
          , max_retries         => 0
          , retry_delay         => 0
          , retention_time      => 1209600
          , dependency_tracking => FALSE
          , comment             => 'Test Object Type Queue'
          , auto_commit         => FALSE
        );

        -- -------------------------------------------------------

        DBMS_AQADM.START_QUEUE('msg_queue');

        -- -------------------------------------------------------

        DBMS_AQADM.GRANT_QUEUE_PRIVILEGE (
            privilege     =>     'ALL'
          , queue_name    =>     'aq_admin_plsql.msg_queue'
          , grantee       =>     'aq_user_plsql'
          , grant_option  =>      FALSE
        );

        -- -------------------------------------------------------

    END;
    /

Enqueue Message

    Use the DBMS_AQ.ENQUEUE procedure to write messages to the queue:

    enqueue_message.sql


    CONNECT aq_user_plsql/aq_user_plsql

    SET SERVEROUTPUT ON

    DECLARE

      enqueue_options      dbms_aq.enqueue_options_t;
      message_properties   dbms_aq.message_properties_t;
      message_handle       RAW(16);
      message              aq_admin_plsql.message_type;
      message_id           NUMBER;

    BEGIN

        -- -------------------------------------------------------

        SELECT  aq_admin_plsql.message_seq.nextval
        INTO    message_id
        FROM    dual;

        -- -------------------------------------------------------

        message := AQ_ADMIN_PLSQL.MESSAGE_TYPE (
                         message_id
                       , 'Subject: EXAMPLE MESSAGE'
                       , 'Message: THIS IS A SAMPLE MESSAGE.'
                       , 10.2
                   );

        -- -------------------------------------------------------

        enqueue_options.VISIBILITY           := DBMS_AQ.ON_COMMIT;
        enqueue_options.SEQUENCE_DEVIATION   := null;

        -- -------------------------------------------------------

        message_properties.PRIORITY            := -5;
        message_properties.DELAY               := DBMS_AQ.NO_DELAY;
        message_properties.EXPIRATION          := DBMS_AQ.NEVER;
        message_properties.CORRELATION         := 'TEST MESSAGE';

        -- -------------------------------------------------------

        DBMS_AQ.ENQUEUE (
              queue_name         => 'aq_admin_plsql.msg_queue'
            , enqueue_options    => enqueue_options
            , message_properties => message_properties
            , payload            => message
            , msgid              => message_handle
        );

        -- -------------------------------------------------------

        COMMIT;

        -- -------------------------------------------------------

    END;
    /

Dequeue Message

    Use the DBMS_AQ.DEQUEUE procedure to read messages from the queue:

    dequeue_message.sql


    CONNECT aq_user_plsql/aq_user_plsql

    SET SERVEROUTPUT ON

    DECLARE

        dequeue_options      dbms_aq.dequeue_options_t;
        message_properties   dbms_aq.message_properties_t;
        message_handle       RAW(16);
        message              aq_admin_plsql.message_type;

    BEGIN

        -- -------------------------------------------------------

        dequeue_options.CONSUMER_NAME           := NULL;
        dequeue_options.DEQUEUE_MODE            := DBMS_AQ.REMOVE;
        dequeue_options.NAVIGATION              := DBMS_AQ.NEXT_MESSAGE;
        dequeue_options.VISIBILITY              := DBMS_AQ.IMMEDIATE;
        dequeue_options.WAIT                    := DBMS_AQ.FOREVER;
        dequeue_options.MSGID                   := null;
        dequeue_options.CORRELATION             := 'TEST MESSAGE';

        -- -------------------------------------------------------

        DBMS_AQ.DEQUEUE (
            queue_name         => 'aq_admin_plsql.msg_queue'
          , dequeue_options    => dequeue_options
          , message_properties => message_properties
          , payload            => message
          , msgid              => message_handle
        );

        -- -------------------------------------------------------

        dbms_output.put_line('+-----------------+');
        dbms_output.put_line('| MESSAGE PAYLOAD |');
        dbms_output.put_line('+-----------------+');
        dbms_output.put_line('- Message ID   := ' || message.message_id);
        dbms_output.put_line('- Subject      := ' || message.subject);
        dbms_output.put_line('- Message      := ' || message.text);
        dbms_output.put_line('- Dollar Value := ' || message.dollar_value);

        -- -------------------------------------------------------

        COMMIT;

        -- -------------------------------------------------------

    END;
    /

    Script Output

    Connected.
    +-----------------+
    | MESSAGE PAYLOAD |
    +-----------------+
    - Message ID   := 1000
    - Subject      := Subject: EXAMPLE MESSAGE
    - Message      := Message: THIS IS A SAMPLE MESSAGE.
    - Dollar Value := 10.2

    PL/SQL procedure successfully completed.

Dropping All Objects

    drop_aq_objects.sql


    connect aq_admin_plsql/aq_admin_plsql

    EXECUTE dbms_aqadm.stop_queue(queue_name => 'aq_admin_plsql.msg_queue');
    EXECUTE dbms_aqadm.drop_queue(queue_name => 'aq_admin_plsql.msg_queue');
    EXECUTE dbms_aqadm.drop_queue_table(queue_table => 'aq_admin_plsql.msg_qt');

    DROP TYPE aq_admin_plsql.message_type;

    DROP SEQUENCE aq_admin_plsql.message_seq;

    connect sys/change_on_install as sysdba

    DROP USER aq_user_plsql CASCADE;
    DROP USER aq_admin_plsql CASCADE;


Copyright (c) 1998-2016 Jeffrey M. Hunter. All rights reserved.

All articles, scripts and material located at the Internet address of http://www.idevelopment.info is the copyright of Jeffrey M. Hunter and is protected under copyright laws of the United States. This document may not be hosted on any other site without my express, prior, written permission. Application to host any of the material elsewhere can be made by contacting me at jhunter@idevelopment.info.

I have made every effort and taken great care in making sure that the material included on my web site is technically accurate, but I disclaim any and all responsibility for any loss, damage or destruction of data or any other property which may arise from relying on it. I will in no case be liable for any monetary damages arising from such loss, damage or destruction.

Last modified on
Saturday, 18-Sep-2010 17:31:21 EDT
Page Count: 33707
