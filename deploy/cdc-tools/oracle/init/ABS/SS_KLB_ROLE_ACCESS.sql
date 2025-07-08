create table SS_KLB_ROLE_ACCESS
(
    ID        NUMBER(2) not null
        constraint XPK_SS_ROLE_KLB_ACCESS
            primary key,
    ROLE_TYPE NUMBER(1) not null,
    NAME_EN   VARCHAR2(50),
    NAME_RU   VARCHAR2(50),
    NAME_UZ   VARCHAR2(50)
)
/

INSERT INTO INETBANK.SS_KLB_ROLE_ACCESS (ID, ROLE_TYPE, NAME_EN, NAME_RU, NAME_UZ) VALUES (0, 1, 'Полный доступ', 'Полный доступ', 'Полный доступ');
INSERT INTO INETBANK.SS_KLB_ROLE_ACCESS (ID, ROLE_TYPE, NAME_EN, NAME_RU, NAME_UZ) VALUES (1, 1, 'На уровне области', 'На уровне области', 'На уровне области');
INSERT INTO INETBANK.SS_KLB_ROLE_ACCESS (ID, ROLE_TYPE, NAME_EN, NAME_RU, NAME_UZ) VALUES (2, 1, 'На уровне филиала', 'На уровне филиала', 'На уровне филиала');
INSERT INTO INETBANK.SS_KLB_ROLE_ACCESS (ID, ROLE_TYPE, NAME_EN, NAME_RU, NAME_UZ) VALUES (3, 2, 'Данные привязанных юр. лиц', 'Данные привязанных юр. лиц', 'Данные привязанных юр. лиц');
INSERT INTO INETBANK.SS_KLB_ROLE_ACCESS (ID, ROLE_TYPE, NAME_EN, NAME_RU, NAME_UZ) VALUES (4, 2, 'Просмотр данных привязанных юр. лиц', 'Просмотр данных привязанных юр. лиц', 'Просмотр данных привязанных юр. лиц');
INSERT INTO INETBANK.SS_KLB_ROLE_ACCESS (ID, ROLE_TYPE, NAME_EN, NAME_RU, NAME_UZ) VALUES (9, 1, 'Нет доступа', 'Нет доступа', 'Нет доступа');
