DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;


DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия', 
    email VARCHAR(120) UNIQUE,
    phone BIGINT, 
    INDEX users_phone_idx(phone), 
    INDEX users_firstname_lastname_idx(firstname, lastname)
);

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	user_id SERIAL PRIMARY KEY,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(id) 
    	ON UPDATE CASCADE 
    	ON DELETE restrict 
);


DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(), 
    INDEX messages_from_user_id (from_user_id),
    INDEX messages_to_user_id (to_user_id),
    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('requested', 'approved', 'unfriended', 'declined'),
	requested_at DATETIME DEFAULT NOW(),
	confirmed_at DATETIME,	
	INDEX (initiator_user_id), 
    INDEX (target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)
);
ALTER TABLE friend_requests add primary key  (initiator_user_id, target_user_id); 

DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL PRIMARY KEY,
	name VARCHAR(150),
	INDEX communities_name_idx(name)
);

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (user_id, community_id), 
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (community_id) REFERENCES communities(id)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL PRIMARY KEY,
    media_type_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
  	body text,
    filename VARCHAR(255),
    size INT,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX (user_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW()
);

DROP TABLE IF EXISTS `photo_albums`;
CREATE TABLE `photo_albums` (
	`id` SERIAL,
	`name` varchar(255) DEFAULT NULL,
    `user_id` BIGINT UNSIGNED DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
  	PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `photos`;
CREATE TABLE `photos` (
	id SERIAL PRIMARY KEY,
	`album_id` BIGINT unsigned NOT NULL,
	`media_id` BIGINT unsigned NOT NULL,
	FOREIGN KEY (album_id) REFERENCES photo_albums(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);


INSERT INTO `users` VALUES ('1','Demetris','Ritchie','awisozk@example.org','1'),
('2','Roger','Doyle','bfeil@example.net','667'),
('3','Jace','Nicolas','linwood.batz@example.net','1'),
('4','Rogelio','Miller','verner.funk@example.com','603961'),
('5','Missouri','Bartell','imaggio@example.net','9569357153'),
('6','Mylene','Shields','miracle72@example.net','7912351722'),
('7','Isabel','Corwin','wthompson@example.org','510'),
('8','Ruthe','Collins','hirthe.adrianna@example.net','143'),
('9','Jefferey','Olson','sharon36@example.net','62'),
('10','Kitty','Langosh','hyatt.mose@example.org','0'),
('11','Christian','Mohr','kohler.bettye@example.com','0'),
('12','Nicole','Huel','august00@example.com','1'),
('13','Jamal','Wisoky','corwin.priscilla@example.org','41'),
('14','Janick','Kunde','jrussel@example.net','1'),
('15','Josue','Ernser','jose04@example.net','0'),
('16','Augustine','Gutkowski','keara.carter@example.com','26'),
('17','Lera','Bauch','queen46@example.net','0'),
('18','Vincent','Barrows','dibbert.katelynn@example.net','0'),
('19','Sherman','Shanahan','jackson87@example.net','0'),
('20','Abbigail','Kautzer','margret.pagac@example.net','360');



INSERT INTO `profiles` VALUES ('1',NULL,'1978-11-18','1','2016-04-20 18:12:38',NULL),
('2',NULL,'1999-10-22','2','1997-12-14 10:31:15',NULL),
('3',NULL,'1995-12-18','3','1974-03-05 10:35:22',NULL),
('4',NULL,'1987-08-27','4','1987-03-05 11:58:30',NULL),
('5',NULL,'1982-07-12','5','1991-04-25 08:12:55',NULL),
('6',NULL,'1985-12-17','6','2000-01-22 21:26:59',NULL),
('7',NULL,'2003-04-16','7','1984-01-13 20:59:52',NULL),
('8',NULL,'1990-08-23','8','1974-09-25 10:39:57',NULL),
('9',NULL,'2014-04-08','9','2007-10-10 16:53:35',NULL),
('10',NULL,'1987-10-01','10','1983-12-27 05:34:00',NULL),
('11',NULL,'1974-12-12','11','2017-02-17 11:49:06',NULL),
('12',NULL,'1984-07-05','12','2010-02-28 15:19:55',NULL),
('13',NULL,'2012-05-02','13','1972-04-29 01:54:42',NULL),
('14',NULL,'1996-10-09','14','2004-08-05 13:19:50',NULL),
('15',NULL,'1992-01-08','15','1975-05-02 04:37:45',NULL),
('16',NULL,'1990-10-19','16','1988-12-15 17:10:21',NULL),
('17',NULL,'1975-01-28','17','2001-12-01 21:31:44',NULL),
('18',NULL,'1983-10-22','18','1997-05-16 10:21:11',NULL),
('19',NULL,'1979-05-19','19','2007-11-15 10:09:54',NULL),
('20',NULL,'2006-06-23','20','1974-02-10 23:08:27',NULL); 

INSERT INTO `messages` VALUES ('1','1','1','Recusandae quis consequatur natus repellat qui eos. Recusandae placeat et nostrum commodi id. Ea molestias quos alias possimus reiciendis atque.','2017-06-22 04:16:35'),
('2','2','2','Aut rerum quo voluptatem laboriosam qui accusantium. Occaecati qui cupiditate sequi ut delectus. Harum veritatis tempore nihil saepe.','1975-12-08 17:05:37'),
('3','3','3','Quidem perferendis vero dolor natus fuga ea. Non esse deserunt odio voluptatem ratione dignissimos quis. Ut perspiciatis veritatis eos explicabo. Mollitia maxime nobis ut qui neque alias quibusdam. Est libero aliquid tempore id.','2012-05-01 15:44:30'),
('4','4','4','Ea velit assumenda tenetur est aspernatur pariatur vel. Alias praesentium voluptas dolores aliquam. Voluptate rerum soluta nihil facere quis ut et. Blanditiis nobis et vel dolores culpa dolore necessitatibus.','1994-01-08 10:40:27'),
('5','5','5','Non id laboriosam dignissimos necessitatibus repellendus. Enim voluptas odio et earum ut veritatis et.','2005-04-23 01:35:33'),
('6','6','6','Rerum ipsum natus temporibus ea nesciunt. Cupiditate veritatis dolorem ut veniam. Iste non quo fugit et voluptatem.','2018-06-02 11:42:55'),
('7','7','7','Dolor et debitis fuga et. Inventore saepe ea ratione accusamus molestias libero. Veritatis eos doloremque sed.','2008-08-03 15:01:54'),
('8','8','8','Non ipsum sit doloremque est aut molestias omnis. Consectetur illum rem qui nemo odit suscipit quia. Nemo exercitationem qui placeat ea nostrum. Aut ut aut nostrum vel eveniet nisi repudiandae.','1975-05-24 09:26:03'),
('9','9','9','Amet dolore voluptates dolore magnam dolorum. Culpa esse et sunt quidem debitis dolor sequi doloribus.','1991-09-29 14:02:35'),
('10','10','10','Qui vitae eveniet exercitationem ea voluptatem. Debitis ipsum exercitationem facere ipsum. Eum aut autem nisi numquam nihil exercitationem.','2012-04-28 13:06:46'),
('11','11','11','Voluptates blanditiis soluta laudantium fugit. Dolores earum maiores asperiores qui est reprehenderit neque. Sed reprehenderit quibusdam harum delectus facere et. Animi eum totam perspiciatis quia sunt reiciendis mollitia.','1986-08-09 22:56:45'),
('12','12','12','Iste optio omnis quo dignissimos ipsam cum unde. Iure autem placeat accusantium. Eum cupiditate nostrum nesciunt aut repellendus. Odio harum alias quia voluptas.','1994-12-01 00:47:58'),
('13','13','13','Occaecati ut at possimus tenetur doloremque in qui. Iste doloribus ducimus tenetur architecto at. Est qui quia est nihil quia numquam qui. Adipisci velit repudiandae ullam autem.','1972-08-05 02:50:39'),
('14','14','14','Nobis dolor deleniti natus voluptate labore commodi. Architecto dignissimos soluta expedita at. Explicabo praesentium ratione deleniti dolores nobis.','2015-10-10 02:30:42'),
('15','15','15','Eius et repudiandae et tempore quisquam. Eligendi dolores eveniet nisi beatae quis eaque. Sit facilis aperiam eveniet eos voluptatem sit. Fuga qui quibusdam fugit non exercitationem et.','2004-12-23 19:44:55'),
('16','16','16','Quo nemo molestiae repellat nihil vel voluptate commodi. Earum veniam sapiente sit culpa ratione cupiditate repudiandae. Est atque aut ut quo odit.','1972-10-11 08:18:26'),
('17','17','17','Aut rerum quia quas aut tempore omnis. Inventore accusantium dignissimos accusantium est natus molestiae. Voluptas non ipsum soluta fuga suscipit delectus quas.','2013-10-08 22:18:21'),
('18','18','18','Nisi aperiam quam sapiente sapiente non rerum quod magnam. Qui assumenda aut maxime est id. Provident non libero veniam aut soluta illum. Qui sunt omnis est eius sunt.','2011-12-22 02:42:29'),
('19','19','19','Velit voluptatibus omnis consequatur debitis ut. Dignissimos voluptatem sit ex tempore sed exercitationem sed. Id exercitationem blanditiis magni earum molestiae. Voluptatum itaque reprehenderit excepturi consequatur nobis.','1994-08-28 22:06:14'),
('20','20','20','Omnis assumenda et ipsa totam reprehenderit excepturi possimus et. Hic magni et laborum nobis qui autem. Esse pariatur ut nihil porro et sed similique.','1994-06-27 21:25:43'); 
INSERT INTO `friend_requests` VALUES ('1','1','declined','1999-02-25 04:52:29','2019-07-13 18:02:13'),
('2','2','requested','2006-12-16 17:58:13','1977-05-04 21:09:58'),
('3','3','declined','1993-03-05 09:25:49','2018-07-11 15:35:46'),
('4','4','declined','1977-10-16 10:55:38','1975-11-20 17:54:46'),
('5','5','requested','1996-12-17 05:31:37','1991-06-11 22:03:05'),
('6','6','approved','2010-01-15 02:17:40','1994-01-19 08:32:01'),
('7','7','declined','2016-02-25 05:34:47','1978-01-20 22:06:07'),
('8','8','declined','1999-08-25 18:27:07','2006-05-06 19:30:32'),
('9','9','requested','2015-03-07 01:17:33','2015-10-01 21:55:20'),
('10','10','declined','1970-11-09 23:43:00','2004-06-10 19:08:11'),
('11','11','declined','2006-02-18 02:38:44','1997-04-26 23:49:40'),
('12','12','declined','2008-09-21 10:55:15','2004-08-29 08:26:05'),
('13','13','declined','1975-10-14 09:46:38','1975-01-29 07:22:17'),
('14','14','unfriended','1976-03-02 23:51:06','2012-03-09 10:25:18'),
('15','15','unfriended','1983-03-01 04:02:14','1999-02-01 12:06:34'),
('16','16','requested','2014-12-30 12:14:56','2001-07-03 19:59:50'),
('17','17','unfriended','2009-12-19 07:43:28','2003-12-29 12:01:26'),
('18','18','unfriended','1980-07-15 15:11:18','1975-03-11 06:47:44'),
('19','19','unfriended','1978-07-23 18:45:32','2019-09-28 13:01:23'),
('20','20','declined','2005-03-04 20:51:50','1979-01-16 20:10:59'); 

INSERT INTO `communities` VALUES ('12','adipisci'),
('17','aut'),
('11','debitis'),
('2','enim'),
('10','eos'),
('14','et'),
('7','eveniet'),
('3','explicabo'),
('4','ipsa'),
('1','laboriosam'),
('18','laudantium'),
('16','maxime'),
('20','nesciunt'),
('6','quasi'),
('19','rerum'),
('13','sunt'),
('9','tempora'),
('8','voluptas'),
('5','voluptate'),
('15','voluptatum');

INSERT INTO `users_communities` VALUES ('1','1'),
('2','2'),
('3','3'),
('4','4'),
('5','5'),
('6','6'),
('7','7'),
('8','8'),
('9','9'),
('10','10'),
('11','11'),
('12','12'),
('13','13'),
('14','14'),
('15','15'),
('16','16'),
('17','17'),
('18','18'),
('19','19'),
('20','20'); 


INSERT INTO `media_types` VALUES ('1','corporis','1990-08-15 08:31:26','2019-09-27 22:15:00'),
('2','excepturi','1988-09-11 18:55:38','2000-11-23 12:36:32'),
('3','sint','2012-12-25 22:25:26','2002-12-03 05:29:53'),
('4','adipisci','1984-09-17 01:10:08','1983-09-18 10:11:25'),
('5','laborum','1991-06-18 01:09:22','2000-03-22 22:59:56'),
('6','sunt','1971-11-19 13:54:16','1971-03-16 17:42:09'),
('7','veritatis','2018-08-09 00:26:50','1993-12-30 18:18:40'),
('8','cumque','1972-09-09 11:06:52','2014-07-24 01:58:31'),
('9','modi','1998-08-13 13:30:22','1980-10-24 15:46:39'),
('10','necessitatibus','1980-04-20 09:33:23','2009-08-19 01:01:41'),
('11','quaerat','1994-01-11 03:11:58','1986-05-08 18:42:28'),
('12','consequatur','1996-08-02 00:57:13','1999-10-06 03:31:14'),
('13','dolor','2007-12-02 15:36:33','1979-04-04 01:10:22'),
('14','eum','1997-01-22 00:56:14','2006-09-17 12:04:45'),
('15','quibusdam','2019-04-13 22:36:39','1975-04-07 22:52:12'),
('16','ea','1984-05-16 23:57:38','2000-02-04 05:03:47'),
('17','atque','1991-11-13 22:34:10','1987-06-19 08:25:11'),
('18','perspiciatis','1983-09-23 03:46:49','1994-09-14 21:07:37'),
('19','molestiae','1972-08-17 16:25:25','2019-11-14 10:12:18'),
('20','et','1980-11-29 04:30:56','1988-07-25 06:31:15'); 

INSERT INTO `media` VALUES ('1','1','1','Velit quia reprehenderit maxime reprehenderit omnis ea animi. Quasi quidem qui officiis ut optio. Similique sit minima beatae eligendi consequatur repellendus.','earum','941338321','2013-09-09 17:08:43','2008-08-05 14:40:36'),
('2','2','2','Rerum quis modi voluptates qui omnis voluptatem dolorem. Aliquid autem minima vero soluta tenetur ut. Voluptatem delectus commodi eos animi eos. Distinctio omnis aut molestiae qui reprehenderit nam voluptatem dolore.','similique','7','2009-01-24 14:43:23','2013-05-11 10:31:30'),
('3','3','3','Vel odio aspernatur ipsum molestias. Enim maxime blanditiis cupiditate quis corporis doloribus atque est. Ut ex ducimus ea quidem expedita et aut quas. Et dolor eaque id quaerat non.','quis','518716118','1997-02-19 01:24:16','2018-10-23 16:32:11'),
('4','4','4','Et est culpa aperiam. Consectetur aut iure dolorem fugiat. Sit corporis reiciendis maxime nesciunt harum.','reprehenderit','3','1972-09-18 15:24:32','2006-07-31 10:32:58'),
('5','5','5','Molestiae nam esse totam voluptatem omnis quas. Quis et alias ab vel consequatur nobis. Sed itaque est voluptatem. Ut voluptatum et repellat architecto quis.','accusantium','71614256','1978-10-03 03:45:42','1990-10-28 23:22:27'),
('6','6','6','Sequi in ea sint ut aut. Rerum et earum itaque minima occaecati doloremque omnis dolores. Adipisci voluptas sed exercitationem qui magni voluptas.','optio','66','1995-06-09 16:14:46','2009-07-06 18:19:20'),
('7','7','7','Et qui labore ad in quisquam eveniet. Sit libero adipisci rerum voluptate sint at dolores. Eligendi alias quod qui soluta voluptatem atque. Impedit adipisci sapiente ducimus nihil.','veritatis','49','2002-04-26 02:54:38','2012-11-15 05:40:35'),
('8','8','8','Culpa sed officiis eos. Ullam iure minus dolores. Quasi in aut cumque quam aut corporis. Fugiat nisi suscipit est quam dolor.','velit','107350537','2003-03-05 13:37:38','1976-08-21 00:48:51'),
('9','9','9','Voluptas praesentium molestias in consequatur. Aut aut magnam fuga vel ut modi laudantium. Esse pariatur quo odit. Soluta quia vitae numquam laudantium nisi repellendus sunt.','possimus','5','2015-08-07 02:27:37','2018-08-13 10:52:13'),
('10','10','10','Mollitia fugit ipsum maxime. Voluptatem fugiat laborum ab ipsa iste ut quam beatae. Pariatur eos quae cum vel vel est. Sint voluptatem cum quia dicta id accusamus.','inventore','39','1980-05-04 12:28:27','2000-01-21 14:02:18'),
('11','11','11','Sed ipsa assumenda dolorum iusto est laboriosam autem. Voluptates vitae quia ut nihil ex reiciendis. Unde quisquam laudantium dolor nobis assumenda aperiam.','unde','64','1991-11-01 01:56:06','1982-07-31 01:35:05'),
('12','12','12','In et corporis et molestiae hic laudantium numquam. Id eligendi dolor sit veniam voluptatem. Voluptatibus earum aliquid fuga aperiam molestias ducimus.','laboriosam','0','1997-03-03 17:51:55','2015-05-25 03:45:43'),
('13','13','13','Quis accusamus ipsa veritatis doloribus tenetur quisquam temporibus. Voluptas rerum odio atque quae. Quo rerum ut beatae illum aut exercitationem nesciunt. Dolores dolores tempora voluptate nihil enim sint cupiditate voluptates.','asperiores','6','2007-11-30 19:47:54','2001-11-22 02:39:36'),
('14','14','14','Ad quis quibusdam numquam quisquam eum dolorum nihil. Earum est consequatur culpa id praesentium sint. Dolore asperiores quos provident voluptas est reiciendis vitae.','impedit','68','1998-08-14 10:34:56','2000-06-29 10:40:37'),
('15','15','15','Omnis reiciendis id occaecati eius neque ipsa consequatur. Non itaque ipsum ducimus accusamus ipsam praesentium. Doloremque tenetur omnis ullam voluptatem. Tenetur expedita amet inventore nesciunt minima qui commodi.','dolorem','215499964','2003-01-09 14:07:53','1979-01-18 19:57:50'),
('16','16','16','Pariatur fugiat esse et minus. Vitae sit sed enim ut dolore facere. Quas aut inventore ut omnis rerum saepe praesentium.','non','614148','2007-09-19 18:08:14','1981-04-27 18:11:43'),
('17','17','17','Est rerum quam placeat repellendus commodi veritatis aut aspernatur. Sit ex animi voluptates blanditiis. Asperiores sint ipsam vitae sed. Eius iste blanditiis sequi ut doloribus et unde.','deserunt','458787161','2015-05-23 23:55:32','2001-06-01 11:53:18'),
('18','18','18','Eos officia optio occaecati in qui. Animi omnis quae repellat sed sed et minima nisi. Perferendis aut itaque quisquam labore consequatur quis at.','eius','57510','1996-02-11 21:33:25','2010-05-31 06:57:37'),
('19','19','19','Doloribus et provident ullam cupiditate. Quos expedita pariatur optio sit incidunt dolores natus amet. Aut qui reprehenderit ut et.','beatae','1044','1979-11-27 13:49:04','2009-09-27 07:59:17'),
('20','20','20','Ut alias omnis omnis provident dignissimos. Ratione ea optio ratione incidunt nam cumque tenetur. Ut voluptatem quis et quia.','sint','69','1984-08-14 19:57:50','2011-11-03 09:39:10'); 


INSERT INTO `likes` VALUES ('1','1','1','1986-08-03 20:50:57'),
('2','2','2','1974-01-13 18:24:22'),
('3','3','3','2001-01-09 05:01:36'),
('4','4','4','1979-10-17 05:08:35'),
('5','5','5','1978-12-27 20:52:38'),
('6','6','6','2019-01-16 12:30:00'),
('7','7','7','1979-05-02 19:52:12'),
('8','8','8','1995-10-20 08:14:25'),
('9','9','9','2015-03-19 10:08:22'),
('10','10','10','2003-07-26 08:50:53'),
('11','11','11','2014-10-05 09:24:33'),
('12','12','12','1994-12-25 15:05:15'),
('13','13','13','2013-01-24 19:27:36'),
('14','14','14','1992-02-13 20:13:44'),
('15','15','15','2009-06-22 04:23:15'),
('16','16','16','1982-02-07 17:55:07'),
('17','17','17','1984-07-06 05:28:32'),
('18','18','18','1983-07-02 23:21:44'),
('19','19','19','1991-08-12 05:27:56'),
('20','20','20','2015-05-19 04:00:39'); 

INSERT INTO `photo_albums` VALUES ('1','ut','1'),
('2','et','2'),
('3','dolores','3'),
('4','sit','4'),
('5','sed','5'),
('6','aut','6'),
('7','eveniet','7'),
('8','veniam','8'),
('9','similique','9'),
('10','inventore','10'),
('11','non','11'),
('12','porro','12'),
('13','qui','13'),
('14','quia','14'),
('15','dolor','15'),
('16','facilis','16'),
('17','dolorem','17'),
('18','assumenda','18'),
('19','cupiditate','19'),
('20','suscipit','20'); 

INSERT INTO `photos` VALUES ('1','1','1'),
('2','2','2'),
('3','3','3'),
('4','4','4'),
('5','5','5'),
('6','6','6'),
('7','7','7'),
('8','8','8'),
('9','9','9'),
('10','10','10'),
('11','11','11'),
('12','12','12'),
('13','13','13'),
('14','14','14'),
('15','15','15'),
('16','16','16'),
('17','17','17'),
('18','18','18'),
('19','19','19'),
('20','20','20'); 

/* Задача 5
1)Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
2)Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
3)В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.
*/












