-- Вставка новых данных
INSERT INTO test_table (id, name) VALUES (4, 'Test 4');
INSERT INTO test_table (id, name) VALUES (5, 'Test 5');
COMMIT;

-- Обновление существующих данных
UPDATE test_table SET name = 'Updated Test 1' WHERE id = 1;
UPDATE test_table SET name = 'Updated Test 2' WHERE id = 2;
COMMIT;

-- Удаление данных
DELETE FROM test_table WHERE id = 3;
COMMIT; 