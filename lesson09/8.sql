/*
Создайте хранимую функцию hello(), которая будет возвращать приветствие,
в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна
возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу
"Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
*/
DROP DATABASE IF EXISTS lesson9;
CREATE DATABASE lesson9;
USE lesson9;

-- Создаем функцию
DROP FUNCTION IF EXISTS get_version;
CREATE FUNCTION get_version ()
RETURNS TEXT DETERMINISTIC
BEGIN
	IF (SELECT CURTIME() >= "06:00:00" AND CURTIME() < "12:00:00") THEN
		RETURN "Доброе утро"; 
	ELSEIF (SELECT CURTIME() >= "12:00:00" AND CURTIME() < "18:00:00") THEN
		RETURN "Добрый день";
	ELSEIF (SELECT CURTIME() >= "18:00:00" AND CURTIME() < "00:00:00") THEN
		RETURN "Добрый вечер";
	ELSEIF (SELECT CURTIME() >= "00:00:00" AND CURTIME() < "6:00:00") THEN
		RETURN "Доброй ночи";
	ELSE
		RETURN "Здравствуйте";
	END IF;
END;

-- Проверяем
SELECT get_version()

-- =============================================================================
/*В таблице products есть два текстовых поля:
name с названием товара и description с его описанием. 
Допустимо присутствие обоих полей или одно из них. 
Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
Используя триггеры, добейтесь того, 
чтобы одно из этих полей или оба поля были заполнены. 
При попытке присвоить полям NULL-значение необходимо отменить операцию.
*/

DROP DATABASE IF EXISTS lesson9;
CREATE DATABASE lesson9;
USE lesson9;

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  description TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';
INSERT INTO products
  (name, description, price, catalog_id )
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

 
SELECT * FROM products;

DROP TRIGGER IF EXISTS without_2null;
CREATE TRIGGER without_2null AFTER INSERT ON products
FOR EACH ROW
BEGIN 
	IF (NEW.name IS NULL) AND (NEW.description IS NULL) THEN 
		SIGNAL SQLSTATE '45000';
	END IF;
END;

-- тест выдает ошибку
INSERT INTO products  
	(name, description)
VALUES
	(NULL, NULL);

SELECT * FROM products;

-- это должно сработать
INSERT INTO products
	(name, description)
VALUES
	('test', NULL),
	( NULL, 'test');

SELECT * FROM products;

