-- Create MOBILE schema and all tables
-- This script runs first (00- prefix) to ensure tables exist before data loading

-- Connect to FREEPDB1 
ALTER SESSION SET CONTAINER = FREEPDB1;

-- Create MOBILE user and grant privileges
CREATE USER MOBILE IDENTIFIED BY mobile123
  DEFAULT TABLESPACE USERS
  TEMPORARY TABLESPACE TEMP
  QUOTA UNLIMITED ON USERS;

GRANT CONNECT, RESOURCE TO MOBILE;
GRANT DBA TO MOBILE;
GRANT CREATE SESSION TO MOBILE;
GRANT CREATE TABLE TO MOBILE;
GRANT CREATE SEQUENCE TO MOBILE;
GRANT CREATE VIEW TO MOBILE;
GRANT CREATE PROCEDURE TO MOBILE;
GRANT CREATE TRIGGER TO MOBILE;
GRANT SELECT ANY TABLE TO MOBILE;
GRANT FLASHBACK ANY TABLE TO MOBILE;
GRANT EXECUTE_CATALOG_ROLE TO MOBILE;
GRANT SELECT_CATALOG_ROLE TO MOBILE;

-- Create test_user
CREATE USER test_user IDENTIFIED BY test123
  DEFAULT TABLESPACE USERS
  TEMPORARY TABLESPACE TEMP
  QUOTA UNLIMITED ON USERS;

GRANT CONNECT, RESOURCE TO test_user;
GRANT CREATE SESSION TO test_user;
GRANT CREATE TABLE TO test_user;

-- Create all tables in MOBILE schema
CREATE TABLE MOBILE.MODULES
(
    ID          NUMBER not null
        constraint XPK_MODULES
            primary key,
    NAME        VARCHAR2(100),
    DESCRIPTION VARCHAR2(100)
);

CREATE TABLE MOBILE.MODULES_ACT
(
    MODULE_ID NUMBER not null
        constraint XFK_MODULE_ACTIONS
            references MOBILE.MODULES
                on delete cascade,
    ACTION_ID NUMBER not null,
    VALUE     VARCHAR2(100),
    ID        NUMBER
        constraint XUK_MODULE_ACTIONS
            unique,
    constraint XPK_MODULE_ACTIONS
        primary key (MODULE_ID, ACTION_ID)
);

CREATE TABLE MOBILE.ROLES
(
    ID          NUMBER       not null,
    NAME        VARCHAR2(50) not null,
    TYPE        NUMBER(1)    not null,
    DESCRIPTION VARCHAR2(100)
);

COMMENT ON COLUMN MOBILE.ROLES.TYPE IS '1-admin; 2-user';

CREATE UNIQUE INDEX IDX_ROLES ON MOBILE.ROLES (ID, TYPE);

CREATE TABLE MOBILE.ROLES_ACT
(
    ROLE_ID   NUMBER not null,
    ACTION_ID NUMBER not null,
    constraint XPK_ROLE_ACTS
        primary key (ROLE_ID, ACTION_ID)
);

CREATE TABLE MOBILE.CLIENTS
(
    ID      NUMBER                       not null
        constraint XUK_CLIENTS
            unique,
    BRANCH  CHAR(5)                      not null,
    CLIENT  CHAR(8)                      not null,
    CREATED TIMESTAMP(6) default sysdate not null,
    STATE   NUMBER(1)    default 1       not null,
    TARIF   NUMBER,
    ABS     NUMBER       default 1       not null,
    constraint XPK_CLIENTS
        primary key (BRANCH, CLIENT)
);

COMMENT ON COLUMN MOBILE.CLIENTS.ABS IS '1-nci; 2-b2';

CREATE TABLE MOBILE.USERS
(
    ID          NUMBER                           not null
        constraint XUK
            unique,
    LOGIN       VARCHAR2(16)                     not null
        constraint XPK_USERS
            primary key,
    NAME        VARCHAR2(100)                    not null,
    PASSWORD    VARCHAR2(64)                     not null,
    SALT        VARCHAR2(32),
    EMAIL       VARCHAR2(64),
    STATE       NUMBER(1)     default 0          not null,
    CREATED     TIMESTAMP(6)  default sysdate    not null,
    LAST_LOGIN  TIMESTAMP(6)  default sysdate    not null,
    TYPE        NUMBER(1)     default 2          not null,
    PASS_FORMAT NUMBER(1)     default 0          not null,
    PASSPORT    VARCHAR2(16),
    ATTEMPTS    NUMBER(2)     default 0          not null,
    SCBASE64    VARCHAR2(128) default 'MTIzNDU=' not null,
    SCATTEMPTS  NUMBER(2)     default 0          not null,
    PHRASE      VARCHAR2(64),
    SIGN_METHOD NUMBER(1)     default 1          not null,
    BRANCH      CHAR(5)       default '00444'    not null,
    IP          VARCHAR2(150) default '0.0.0.0',
    PINCODE     VARCHAR2(100)
);

COMMENT ON COLUMN MOBILE.USERS.TYPE IS '1- adm; 2-user';
COMMENT ON COLUMN MOBILE.USERS.PASS_FORMAT IS '0-clear; 1-with salt';
COMMENT ON COLUMN MOBILE.USERS.SIGN_METHOD IS '0-без подписи; 1-секретным ключем; 2-эцп';
COMMENT ON COLUMN MOBILE.USERS.IP IS 'IP адреса с которых разрешается пользователю заходить';

CREATE TABLE MOBILE.UC
(
    USER_ID   NUMBER             not null,
    CLIENT_ID NUMBER             not null,
    ROLE_ID   NUMBER default 202 not null
);

CREATE UNIQUE INDEX IDX_UC ON MOBILE.UC (USER_ID, CLIENT_ID);

-- Create test tables
CREATE TABLE test_user.test
(
    ID   NUMBER       not null
        constraint XPK_TEST
            primary key,
    NAME VARCHAR2(50) not null
);

CREATE TABLE MOBILE.MOBILE
(
    ID          NUMBER                       not null,
    BRANCH      CHAR(5)                      not null,
    CLIENT      CHAR(8)                      not null,
    CREATED     TIMESTAMP(6) default sysdate not null,
    STATE       NUMBER(1)    default 1       not null,
    UPDATED     TIMESTAMP(6) default sysdate not null,
    DESCRIPTION VARCHAR2(255),
    constraint XPK_MOBILE
        primary key (BRANCH, CLIENT, ID)
);

-- Enable supplemental logging for CDC
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;

-- Show all created tables
SELECT 'Created MOBILE.' || table_name FROM all_tables WHERE owner = 'MOBILE' ORDER BY table_name;
SELECT 'Created test_user.' || table_name FROM all_tables WHERE owner = 'TEST_USER' ORDER BY table_name; 
COMMIT; 



