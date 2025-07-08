-- Создание пользователя для тестирования
CREATE USER test_user IDENTIFIED BY test_password;

-- Предоставление базовых прав
GRANT CREATE SESSION TO test_user;
GRANT CONNECT TO test_user;
GRANT RESOURCE TO test_user;
GRANT CREATE TABLE TO test_user;
GRANT UNLIMITED TABLESPACE TO test_user;

-- Создание роли для LogMiner
CREATE ROLE logminer_role;
GRANT CREATE SESSION TO logminer_role;
GRANT SET CONTAINER TO logminer_role;
GRANT SELECT ON V_$DATABASE TO logminer_role;
GRANT FLASHBACK ANY TABLE TO logminer_role;
GRANT SELECT ANY TABLE TO logminer_role;
GRANT SELECT_CATALOG_ROLE TO logminer_role;
GRANT EXECUTE_CATALOG_ROLE TO logminer_role;
GRANT SELECT ANY TRANSACTION TO logminer_role;
GRANT SELECT ANY DICTIONARY TO logminer_role;
GRANT LOGMINING TO logminer_role;

-- Предоставление роли пользователю
GRANT logminer_role TO test_user;

-- Дополнительные права для работы с LogMiner
GRANT SELECT ON V_$DATABASE TO test_user;
GRANT SELECT ON V_$LOGMNR_CONTENTS TO test_user;
GRANT SELECT ON V_$ARCHIVED_LOG TO test_user;
GRANT SELECT ON V_$LOG TO test_user;
GRANT SELECT ON V_$LOGFILE TO test_user;
GRANT SELECT ON V_$LOGMNR_LOGS TO test_user;
GRANT SELECT ON V_$LOGMNR_PARAMETERS TO test_user;
GRANT SELECT ON V_$LOGMNR_PROCESS TO test_user;
GRANT SELECT ON V_$LOGMNR_SESSION TO test_user;
GRANT SELECT ON V_$LOGMNR_STATS TO test_user;
GRANT SELECT ON V_$LOGMNR_TRANSACTION TO test_user;

-- Проверка и создание таблицы
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM dba_users WHERE username = 'TEST_USER';
  IF v_count > 0 THEN
    EXECUTE IMMEDIATE 'CREATE TABLE test_user.test_table (
      id NUMBER PRIMARY KEY,
      name VARCHAR2(100),
      created_at TIMESTAMP DEFAULT SYSTIMESTAMP
    )';
    
    EXECUTE IMMEDIATE 'INSERT INTO test_user.test_table (id, name) VALUES (1, ''Test 1'')';
    EXECUTE IMMEDIATE 'INSERT INTO test_user.test_table (id, name) VALUES (2, ''Test 2'')';
    EXECUTE IMMEDIATE 'INSERT INTO test_user.test_table (id, name) VALUES (3, ''Test 3'')';
    
    COMMIT;
    
    -- Дополнительные права для Debezium
    EXECUTE IMMEDIATE 'GRANT SELECT ON test_user.test_table TO test_user';
    EXECUTE IMMEDIATE 'GRANT FLASHBACK ON test_user.test_table TO test_user';
  END IF;
END;
/ 