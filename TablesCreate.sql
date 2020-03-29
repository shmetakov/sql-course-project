-- База данных популярного сервиса фильмов “Кинопоиск”

CREATE DATABASE IF NOT EXISTS kinopoisk;

USE kinopoisk

SHOW TABLES;

-- Таблица users содержит основную информацию о пользователях. Также в 
-- этой таблице присутствуют актеры, режиссеры и другие участники съемочных групп.  


DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(100) NOT NULL COMMENT 'Имя',
  last_name VARCHAR(100) NOT NULL COMMENT 'Фамилия',
  email VARCHAR(120) NOT NULL COMMENT 'Адрес электронной почты',
  phone VARCHAR(120) NOT NULL COMMENT 'Телефон',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`)  
) COMMENT 'Таблица пользователей';

DESC users;

-- Таблица photo содержит информацию о фотографиях пользователей, о обложках к фильмам и тд.

DROP TABLE IF EXISTS photo;
CREATE TABLE photo (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  filename VARCHAR(255) NOT NULL COMMENT 'Ссылка на фото',
  size INT NOT NULL COMMENT 'Размер',
  metadata JSON COMMENT 'Метаданые',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `filename` (`filename`)  
) COMMENT 'Таблица фотографий';

DESC photo;

-- Таблица profiles содержит дополнительную информацию о пользователях 

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
  user_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  gender ENUM('m', 'f') COMMENT 'Пол m - мужской, f - женский',
  birthday DATE COMMENT 'День рождения',
  city VARCHAR(100) COMMENT 'Город',
  country VARCHAR(100) COMMENT 'Страна',
  photo_id INT UNSIGNED NOT NULL COMMENT 'ID фото профиля',
  link_vk VARCHAR(255) COMMENT 'Ссылка на страницу ВК',
  about TEXT COMMENT 'О себе',
  interests VARCHAR(255) COMMENT 'Интересы',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES users(`id`),
  FOREIGN KEY (`photo_id`) REFERENCES photo(`id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `link_vk` (`link_vk`)
) COMMENT 'Таблица профилей пользователей';

desc profiles;

-- Таблица films содержит основную информацию о фильме, которая выдается 
-- пользователю при просмотре списка фильмов.

DROP TABLE IF EXISTS films;
CREATE TABLE films (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name_ru VARCHAR(100) COMMENT 'Русское название',
  name_original VARCHAR(100) COMMENT 'Оригинальное название',
  photo_id INT UNSIGNED NOT NULL COMMENT 'ID фото профиля',
  year DATE NOT NULL COMMENT 'Дата съемки',
  country VARCHAR(120) NOT NULL COMMENT 'Страна производства',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`photo_id`) REFERENCES photo(`id`),
  UNIQUE KEY `photo_id` (`photo_id`)  
) COMMENT 'Таблица фильмов';

desc profiles;

-- Таблица films_profiles содержит дополнительную информацию о фильмах

DROP TABLE IF EXISTS films_profiles;
CREATE TABLE films_profiles (
  film_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  link VARCHAR(255) COMMENT 'Ссылка на фильм',
  trailer_link VARCHAR(255) NOT NULL COMMENT 'Ссылка трейлер',
  time TIME COMMENT 'Время',
  price DECIMAL (11,2) COMMENT 'Цена за просмотр',
  description TEXT NOT NULL COMMENT 'Описание',
  tagline VARCHAR(255) COMMENT 'Слоган',
  budget INT UNSIGNED COMMENT 'Бюджет',
  premiere_world DATE NOT NULL COMMENT 'Премьера (мир)',
  premiere_ru DATE NOT NULL COMMENT 'Премьера (Россия)',
  premiere_dvd DATE NOT NULL COMMENT 'Премьера (DVD)',
  age INT UNSIGNED NOT NULL COMMENT 'Возраст',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`film_id`) REFERENCES films(`id`),
  UNIQUE KEY `film_id` (`film_id`),
  UNIQUE KEY `link` (`link`),
  UNIQUE KEY `trailer_link` (`trailer_link`)
) COMMENT 'Таблица профилей фильмов';

DESC films_profiles;

-- Таблица genre это жанры фильмов. Создан уникальный ключ на 2 столбца  `film_id` и `genre_enum`. 
-- Один фильм может быть в разных жанрах, но не в одном и том же.

DROP TABLE IF EXISTS genre;
CREATE TABLE genre (
  film_id INT UNSIGNED NOT NULL,
  genre_enum ENUM(
    'Russian', 
    'Soviet', 
    'American', 
    'Cartoons', 
    'Comedy',
    'Dramas', 
    'Melodramas', 
    'Horror', 
    'Militants', 
    'Fantasy', 
    'Thrillers', 
    'Detectives'
  ) COMMENT 'Жанры фильмов',
  FOREIGN KEY (`film_id`) REFERENCES films(`id`),
  UNIQUE KEY `film_id_genre_enum` (`film_id`, `genre_enum`) 
) COMMENT 'Таблица жанров';

DESC genre;

-- Таблица reviews - это таблица отзывов к фильмам. Один пользователь 
-- может оставить только один отзыв к фильму. 
-- Поэтому создан уникальный ключ на 2 столбца `user_id` и `film_id`.

DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INT UNSIGNED NOT NULL COMMENT 'ID пользователя',
  film_id INT UNSIGNED NOT NULL COMMENT 'ID фильма',
  heading VARCHAR(255) NOT NULL COMMENT 'Заголовок',
  body TEXT NOT NULL COMMENT 'Тело отзыва', 
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) REFERENCES users(`id`),
  FOREIGN KEY (`film_id`) REFERENCES films(`id`),
  UNIQUE KEY `user_id_film_id` (`user_id`, `film_id`)
) COMMENT 'Таблица отзывов';

DESC reviews;

-- Таблица rating - это таблица оценок фильмов. Один пользователь может 
-- поставить только одну оценку к фильму.
-- Поэтому создан уникальный ключ на 2 столбца `user_id` и `film_id`.

DROP TABLE IF EXISTS rating;
CREATE TABLE rating (
  user_id INT UNSIGNED NOT NULL COMMENT 'ID пользователя',
  film_id INT UNSIGNED NOT NULL COMMENT 'ID фильма', 
  value INT UNSIGNED NOT NULL COMMENT 'Оценка', 
  FOREIGN KEY (`user_id`) REFERENCES users(`id`),
  FOREIGN KEY (`film_id`) REFERENCES films(`id`),
  UNIQUE KEY `user_id_film_id` (`user_id`, `film_id`)
) COMMENT 'Таблица рейтинга';

DESC rating;

-- Таблица film_crews - это таблица пользователей, входящих в съемочную группу. 
-- Продюсеры, операторы, актеры и тд. Один участник может быть в одном фильме и продюсером и актером, 
-- поэтому создан уникальный ключ на 3 столбца `user_id`, `film_id` и `role`. 

DROP TABLE IF EXISTS film_crews;
CREATE TABLE film_crews (
  user_id INT UNSIGNED NOT NULL COMMENT 'ID пользователя',
  film_id INT UNSIGNED NOT NULL COMMENT 'ID фильма',
  role ENUM ('producer', 'scenario', 'actor', 'operator', 'composer', 'painter'),
  FOREIGN KEY (`user_id`) REFERENCES users(`id`),
  FOREIGN KEY (`film_id`) REFERENCES films(`id`),
  UNIQUE KEY `user_id_film_id_role` (`user_id`, `film_id`, `role`)
) COMMENT 'Таблица пользователей, входящих в съемочную группу';

DESC film_crews;

-- Таблица awards содержит информацию о наградах, которые получают фильмы

DROP TABLE IF EXISTS awards;
CREATE TABLE awards (
  film_id INT UNSIGNED NOT NULL COMMENT 'ID фильма',
  nominations VARCHAR(255) NOT NULL COMMENT 'Название номинации',
  `type` VARCHAR(100) NOT NULL COMMENT 'Тип кинопремии',
  `date` DATE NOT NULL COMMENT 'Дата вручения кинопремии',
  FOREIGN KEY (`film_id`) REFERENCES films(`id`)
) COMMENT 'Таблица наград фильмов';

DESC awards;

SHOW tables;


