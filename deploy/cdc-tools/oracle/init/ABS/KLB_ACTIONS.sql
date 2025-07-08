create table KLB_ACTIONS
(
    ID          NUMBER        not null,
    MID         NUMBER        not null,
    NAME        VARCHAR2(160) not null,
    ICON        VARCHAR2(360),
    DEAL_ID     NUMBER        not null,
    REP_TYPE_ID NUMBER,
    constraint XPK_KLB_ACTIONS
        primary key (ID, MID, DEAL_ID)
)
/

INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (1, 9, 'Добавить', '/images/+.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (2, 9, 'Редактировать', '/images/+.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (3, 9, 'Утвердить', '/images/checkall.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (4, 9, 'Отправить в банк', '/images/save.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (5, 9, 'Удалить', '/images/-.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (6, 9, 'Добавить документ по шаблону', '/images/+.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (7, 9, 'Сохранить как шаблон', '/images/+.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (8, 9, 'Сделать копию документа', '/images/+.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (9, 9, 'Загрузка документов из файла', '/images/down3-.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (10, 9, 'Сохранить и создать новый документ', '/images/save.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (11, 9, 'История действий по документу', '/images/getreport.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (1, 10, 'Сохранить как шаблон', '/images/+.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (2, 10, 'Сделать копию документа', '/images/+.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (3, 10, 'История действий по документу', '/images/getreport.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (11, 42, 'Ввести SWIFT', '/images/+.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (12, 42, 'Проверить SWIFT', '/images/+.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (1, 42, 'Утвердить SWIFT', '/images/checkall.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (12, 9, 'Распечатать документ', '/images/getreport.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (12, 9815, 'Отправит в банк', '/images/checkall.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (1, 9815, 'Ввести заявку', '/images/+.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (11, 9815, 'Утвердить заявку', '/images/checkall.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (1, 50, 'Добавить', '/images/+.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (2, 50, 'Редактировать', '/images/+.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (3, 50, 'Утвердить', '/images/checkall.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (4, 50, 'Отправить в банк', '/images/save.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (5, 50, 'Удалить', '/images/-.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (6, 50, 'Добавить документ по шаблону', '/images/+.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (7, 50, 'Сохранить как шаблон', '/images/+.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (8, 50, 'Сделать копию документа', '/images/+.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (9, 50, 'Загрузка документов из файла', '/images/down3-.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (10, 50, 'Сохранить и создать новый документ', '/images/save.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (11, 50, 'История действий по документу', '/images/getreport.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (12, 50, 'Распечатать документ', '/images/getreport.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (1, 9866, 'Создать', '/images/+.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (2, 9866, 'Удалить', '/images/-.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (3, 9866, 'Отправить', '/images/+.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (4, 9866, 'Отозвать', '/images/-.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (5, 9866, 'Корректировать', '/images/+.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (6, 9866, 'Запросить статус', '/images/+.png', 1, null);
INSERT INTO INETBANK.KLB_ACTIONS (ID, MID, NAME, ICON, DEAL_ID, REP_TYPE_ID) VALUES (3, 9866, 'Запросить статус', '/images/+.png', 2, null);
