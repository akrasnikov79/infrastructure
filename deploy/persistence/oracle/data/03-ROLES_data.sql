CONNECT MOBILE/mobile123@//localhost:1521/FREEPDB1;

INSERT INTO ROLES (ID, NAME, TYPE, DESCRIPTION) VALUES (201, 'Полный', 2, 'Стандартный + отправка платежей');
INSERT INTO ROLES (ID, NAME, TYPE, DESCRIPTION) VALUES (202, 'Стандартный', 2, 'Просмотр документов, отчеты, уведомления');
INSERT INTO ROLES (ID, NAME, TYPE, DESCRIPTION) VALUES (205, 'Полн+SWIFT(1)', 2, 'Полный + SWIFT Ввод');
INSERT INTO ROLES (ID, NAME, TYPE, DESCRIPTION) VALUES (206, 'Полн+SWIFT(23)', 2, 'Полный + SWIFT Отправка');
INSERT INTO ROLES (ID, NAME, TYPE, DESCRIPTION) VALUES (207, 'Полн+SWIFT(123)', 2, 'Полный + SWIFT Ввод и отправка');
INSERT INTO ROLES (ID, NAME, TYPE, DESCRIPTION) VALUES (101, 'Admin', 1, 'Админ');
INSERT INTO ROLES (ID, NAME, TYPE, DESCRIPTION) VALUES (102, 'Admin Lite', 1, 'Админ Lite'); 

COMMENT;