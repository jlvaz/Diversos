 How to Add Control File when Using ASM
Oracle Database » How To Guides » How to Add Control File when Using ASM
Fold
Table of Contents
Background & Overview
Step-By-Step Guide
Background & Overview

This document provides a step by step guide to add extra control files to a database whose storage is on ASM. In this case the database has one control file on diskgroup +DATA01 and the procedure explains how to add an additional control file located on diskgroup +FRA01

This has not been tested on databases prior to version 11g
Step-By-Step Guide

1. Take a backup of your spfile

        sqlplus '/ as sysdba'
        SQL> create pfile='/tmp/spfileBACKUP.ora' from spfile;

2. Update the control_file parameter in the spfile.

        sqlplus '/ as sysdba'
        SQL> select name from v$controlfile;

        NAME
        --------------------------------------------------------------------------------
        +DATA01/MYDB/controlfile/current.200.899418013

        SQL> alter system set control_files='+DATA/dbfeso211g/controlfile/current.276.889977567','+FRA01' scope=spfile sid='*';

3. Restart the database in nomount mode

        sqlplus '/ as sysdba'
        SQL> shutdown immediate;
        SQL> startup nomount;

4. Create the new control file using RMAN.

        rman
        RMAN> connect target /
        RMAN> restore controlfile from '+DATA/dbfeso211g/controlfile/current.276.889977567';

        Starting restore at 09-NOV-12
        allocated channel: ORA_DISK_1
        channel ORA_DISK_1: sid=111 instance=MYDB devtype=DISK

        channel ORA_DISK_1: copied control file copy
        output filename=+DATA/dbfeso211g/controlfile/current.276.889977567
        output filename=+FRA01/MYDB/controlfile/current.200.800418013
        Finished restore at 09-NOV-12

5. Update the spfile with the new control file name

        sqlplus '/ as sysdba'
        SQL> alter system set control_files='+DATA/dbfeso211g/controlfile/current.276.889977567','+FRA01/MYDB/controlfile/current.200.800418013' scope=spfile sid='*';

6. Restart the database and check the new control file

        sqlplus '/ as sysdba'
        SQL> shutdown immediate;
        SQL> startup;
        SQL> select name from v$controlfile;

        NAME
        --------------------------------------------------------------------------------
        +DATA01/MYDB/controlfile/current.200.899418013
        +FRA01/MYDB/controlfile/current.200.800418013

