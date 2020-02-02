DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop;
USE shop;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');

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
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Заказы';
INSERT INTO orders 
  (user_id)
VALUES
  ('1'),
  ('1'),
  ('2'),
  ('5'),
  ('3'),
  ('1'),
  ('2'),
  ('1'),
  ('1'),
  ('6'),
  ('6');

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Состав заказа';
INSERT INTO orders_products 
  (order_id, product_id, total)
VALUES
  ('1', '2', 4),
  ('2', '2', 0),
  ('3', '4', 6),
  ('4', '7', 2),
  ('5', '7', 3),
  ('6', '7', 3),
  ('7', '5', 6),
  ('8', '3', 3),
  ('9', '5', 2),
  ('10', '2', 1),
  ('11', '1', 1);


DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  product_id INT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0',
  started_at DATETIME,
  finished_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id)
) COMMENT = 'Скидки';

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склады';

INSERT INTO storehouses 
  (name)
VALUES
  ('Главный склад'),
  ('Большой склад');

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO storehouses_products
  (storehouse_id, product_id, value)
VALUES
  ('1', '1', 100),
  ('1', '2', 0),
  ('1', '3', 5),
  ('1', '4', 10),
  ('1', '5', 15),
  ('1', '6', 86),
  ('1', '7', 95),
  ('2', '1', 0),
  ('2', '2', 0),
  ('2', '3', 64),
  ('2', '4', 725),
  ('2', '5', 20),
  ('2', '6', 200),
  ('2', '7', 980);

/* Задача 5.1.1
Пусть в таблице users поля created_at и updated_at
оказались незаполненными. Заполните их текущими датой и временем.
*/

UPDATE users SET created_at=NOW() WHERE created_at IS NULL;
UPDATE users SET updated_at=NOW() WHERE updated_at IS NULL;
/* Задача 5.1.2 
Таблица users была неудачно спроектирована.
Записи created_at и updated_at были заданы типом 
VARCHAR и в них долгое время помещались значения
в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу
DATETIME, сохранив введеные ранее значения.
*/

ALTER TABLE users CHANGE created_at created_at DATETIME;
ALTER TABLE users CHANGE updated_at updated_at DATETIME;


/* Задача 5.1.3
 В таблице складских запасов storehouses_products в поле value 
 могут встречаться самые разные цифры: 0, если товар закончился и выше нуля,
 если на складе имеются запасы. Необходимо отсортировать записи таким образом, 
 чтобы они выводились в порядке увеличения значения value. 
 Однако, нулевые запасы должны выводиться в конце, после всех записей.
 */

SELECT storehouse_id AS 'склад', product_id AS 'id продукта', value AS 'кол-во продуктов' 
FROM storehouses_products ORDER BY 
CASE 
  WHEN value = 0 THEN 1 else 0
END, value;

/* Задача 5.1.4
 (по желанию) Из таблицы users необходимо извлечь пользователей, 
 родившихся в августе и мае. Месяцы заданы в виде списка 
 английских названий ('may', 'august')
 */

SELECT id, name, birthday_at, date(birthday_at) as dt FROM users WHERE MONTHNAME(birthday_at) = 'may' OR MONTHNAME(birthday_at) = 'august'  ;

/* Задача 5.2.1
Подсчитайте средний возраст пользователей в таблице users
*/

SELECT ROUND(AVG(DATEDIFF(NOW(), birthday_at)/365.25)) FROM users;

/* Задача 5.2.2
Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
Следует учесть, что необходимы дни недели текущего года, а не года рождения.
*/

SELECT 
  MAX(WEEKDAY(DATE_ADD(
    birthday_at, INTERVAL YEAR(NOW()) - YEAR(birthday_at) YEAR
  ))) as 'Номер дня недели',
  COUNT(*) as 'кол-во пользователь с д.р. в этот день'
FROM users GROUP BY WEEKDAY(DATE_ADD(birthday_at,
INTERVAL YEAR(NOW()) - YEAR(birthday_at) YEAR));


