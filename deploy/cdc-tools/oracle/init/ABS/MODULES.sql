create table MODULES
(
    ID          NUMBER not null
        constraint XPK_MODULES
            primary key,
    NAME        VARCHAR2(30),
    DESCRIPTION VARCHAR2(50)
)
/

INSERT INTO MOBILE.MODULES (ID, NAME, DESCRIPTION) VALUES (208, 'Зарплата', 'Загрузка ЗП на ПК');
INSERT INTO MOBILE.MODULES (ID, NAME, DESCRIPTION) VALUES (202, 'Счета', 'Просмотр счетов');
INSERT INTO MOBILE.MODULES (ID, NAME, DESCRIPTION) VALUES (203, 'Шаблоны', 'Управление шаблонами документов');
INSERT INTO MOBILE.MODULES (ID, NAME, DESCRIPTION) VALUES (204, 'Отчеты', 'Отчёты');
INSERT INTO MOBILE.MODULES (ID, NAME, DESCRIPTION) VALUES (205, 'Справочники', 'Справочники ЦБ');
INSERT INTO MOBILE.MODULES (ID, NAME, DESCRIPTION) VALUES (201, 'Документы', 'Создание платежей');
INSERT INTO MOBILE.MODULES (ID, NAME, DESCRIPTION) VALUES (206, 'Уведомления', 'Разрешние на использование службы уведомлений');
INSERT INTO MOBILE.MODULES (ID, NAME, DESCRIPTION) VALUES (207, 'SWIFT', 'Отправка распоряжений по системе SWIFT');
INSERT INTO MOBILE.MODULES (ID, NAME, DESCRIPTION) VALUES (212, 'Импортные контракты', 'Импортные контракты');
INSERT INTO MOBILE.MODULES (ID, NAME, DESCRIPTION) VALUES (103, 'Состояние ОД', 'Состояние опер. дня');
INSERT INTO MOBILE.MODULES (ID, NAME, DESCRIPTION) VALUES (209, 'Покупка/Продажа', 'Заявки на покупку/продажу валюты');
INSERT INTO MOBILE.MODULES (ID, NAME, DESCRIPTION) VALUES (210, 'Корпоративные ПК', 'Корпоративные пластиковые карты');
INSERT INTO MOBILE.MODULES (ID, NAME, DESCRIPTION) VALUES (211, 'Регулярные платежи', 'Регулярные платежи');
INSERT INTO MOBILE.MODULES (ID, NAME, DESCRIPTION) VALUES (214, 'Подключение услуг', 'Подключение услуг');
INSERT INTO MOBILE.MODULES (ID, NAME, DESCRIPTION) VALUES (215, 'Платёжные требования', 'Платёжные требования');
INSERT INTO MOBILE.MODULES (ID, NAME, DESCRIPTION) VALUES (216, 'Картотека 1', 'Картотека 1');
INSERT INTO MOBILE.MODULES (ID, NAME, DESCRIPTION) VALUES (217, 'Кассовые ордера', 'Заявки на расходные кассовые ордера');
