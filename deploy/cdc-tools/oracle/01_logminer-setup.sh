#!/bin/sh

# Set Oracle SID for XE
ORACLE_SID=XE
export ORACLE_SID

echo "▶ Enabling archive log mode and preparing database..."
sqlplus /nolog <<-EOF
CONNECT sys/top_secret AS SYSDBA
WHENEVER SQLERROR EXIT SQL.SQLCODE

ALTER SYSTEM SET db_recovery_file_dest_size = 10G;
ALTER SYSTEM SET db_recovery_file_dest = '/opt/oracle/oradata/recovery_area' SCOPE=SPFILE;
SHUTDOWN IMMEDIATE
STARTUP MOUNT
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;
ARCHIVE LOG LIST;
EXIT;
EOF

echo "▶ Enabling required settings for LogMiner..."
sqlplus sys/top_secret@//localhost:1521/XE AS SYSDBA <<-EOF
WHENEVER SQLERROR EXIT SQL.SQLCODE

ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;
ALTER PROFILE DEFAULT LIMIT FAILED_LOGIN_ATTEMPTS UNLIMITED;
EXIT;
EOF

echo "▶ Creating LogMiner tablespace..."
sqlplus sys/top_secret@//localhost:1521/XE AS SYSDBA <<-EOF
WHENEVER SQLERROR EXIT SQL.SQLCODE

CREATE TABLESPACE LOGMINER_TBS DATAFILE '/opt/oracle/oradata/XE/logminer_tbs.dbf' SIZE 25M REUSE AUTOEXTEND ON MAXSIZE UNLIMITED;
EXIT;
EOF

echo "▶ Creating c##dbzuser with required privileges..."
sqlplus sys/top_secret@//localhost:1521/XE AS SYSDBA <<-EOF
WHENEVER SQLERROR EXIT SQL.SQLCODE

CREATE USER c##dbzuser IDENTIFIED BY dbz DEFAULT TABLESPACE LOGMINER_TBS QUOTA UNLIMITED ON LOGMINER_TBS;

GRANT CREATE SESSION TO c##dbzuser;
GRANT SELECT ON V_\$DATABASE TO c##dbzuser;
GRANT FLASHBACK ANY TABLE TO c##dbzuser;
GRANT SELECT ANY TABLE TO c##dbzuser;
GRANT SELECT_CATALOG_ROLE TO c##dbzuser;
GRANT EXECUTE_CATALOG_ROLE TO c##dbzuser;
GRANT SELECT ANY TRANSACTION TO c##dbzuser;
GRANT SELECT ANY DICTIONARY TO c##dbzuser;
GRANT LOGMINING TO c##dbzuser;

GRANT CREATE TABLE TO c##dbzuser;
GRANT LOCK ANY TABLE TO c##dbzuser;
GRANT CREATE SEQUENCE TO c##dbzuser;

GRANT EXECUTE ON DBMS_LOGMNR TO c##dbzuser;
GRANT EXECUTE ON DBMS_LOGMNR_D TO c##dbzuser;
GRANT SELECT ON V_\$LOGMNR_LOGS TO c##dbzuser;
GRANT SELECT ON V_\$LOGMNR_CONTENTS TO c##dbzuser;
GRANT SELECT ON V_\$LOGFILE TO c##dbzuser;
GRANT SELECT ON V_\$ARCHIVED_LOG TO c##dbzuser;
GRANT SELECT ON V_\$ARCHIVE_DEST_STATUS TO c##dbzuser;

EXIT;
EOF

echo "▶ Creating application user debezium..."
sqlplus sys/top_secret@//localhost:1521/XE AS SYSDBA <<-EOF
WHENEVER SQLERROR EXIT SQL.SQLCODE

CREATE USER debezium IDENTIFIED BY dbz;
GRANT CONNECT TO debezium;
GRANT CREATE SESSION TO debezium;
GRANT CREATE TABLE TO debezium;
GRANT CREATE SEQUENCE TO debezium;
ALTER USER debezium QUOTA 100M ON USERS;
EXIT;
EOF

echo "✅ Oracle XE setup for Debezium completed successfully."
