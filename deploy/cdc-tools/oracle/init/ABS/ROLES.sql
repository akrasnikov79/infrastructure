create table ROLES
(
    ID          NUMBER       not null,
    NAME        VARCHAR2(50) not null,
    TYPE        NUMBER(1)    not null,
    DESCRIPTION VARCHAR2(100)
)
/

comment on column ROLES.TYPE is '1-admin; 2-user'
/

create unique index IDX_ROLES
    on ROLES (ID, TYPE)
/

INSERT INTO MOBILE.ROLES (ID, NAME, TYPE, DESCRIPTION) VALUES (201, 'Полный', 2, 'Стандартный + отправка платежей');
INSERT INTO MOBILE.ROLES (ID, NAME, TYPE, DESCRIPTION) VALUES (202, 'Стандартный', 2, 'Просмотр документов, отчеты, уведомления');
INSERT INTO MOBILE.ROLES (ID, NAME, TYPE, DESCRIPTION) VALUES (205, 'Полн+SWIFT(1)', 2, 'Полный + SWIFT Ввод');
INSERT INTO MOBILE.ROLES (ID, NAME, TYPE, DESCRIPTION) VALUES (206, 'Полн+SWIFT(23)', 2, 'Полный + SWIFT Отправка');
INSERT INTO MOBILE.ROLES (ID, NAME, TYPE, DESCRIPTION) VALUES (207, 'Полн+SWIFT(123)', 2, 'Полный + SWIFT Ввод и отправка');
INSERT INTO MOBILE.ROLES (ID, NAME, TYPE, DESCRIPTION) VALUES (101, 'Admin', 1, 'Админ');
INSERT INTO MOBILE.ROLES (ID, NAME, TYPE, DESCRIPTION) VALUES (102, 'Admin Lite', 1, 'Админ Lite');
