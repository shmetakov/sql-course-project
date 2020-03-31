USE kinopoisk

SHOW TABLES;

-- users
-- Смотрим содержимое
SELECT * FROM users LIMIT 15;

-- Смотрим структуру
DESC users;

-- Смотрим индексы
SHOW INDEX FROM users;

-- Приводим в порядок даты
UPDATE users SET updated_at = created_at WHERE created_at > updated_at;

-- Добавляем индексы на столбцы first_name и last_name
CREATE INDEX users_first_name_idx ON users(first_name);
CREATE INDEX users_last_name_idx ON users(last_name);



-- photo
-- Смотрим содержимое
SELECT * FROM photo LIMIT 15;

-- Смотрим структуру
DESC photo;

-- Смотрим индексы
SHOW INDEX FROM photo;

-- Дорабатываем метаданные    
UPDATE photo SET metadata = CONCAT('{"owner":"id_', FLOOR(RAND()*(999999-100001))+100000, '"}');
 
-- Возвращаем правильный тип данных для метаданных   
ALTER TABLE photo MODIFY COLUMN metadata JSON; 

-- Улучшаем внешний вид ссылки на файл
UPDATE photo SET filename = CONCAT('https://kinopoisk.ru/photo_', filename); 



-- profiles
-- Смотрим содержимое
SELECT * FROM profiles LIMIT 15;

-- Смотрим структуру
DESC profiles;

-- Смотрим индексы
SHOW INDEX FROM profiles;

-- Улучшаем внешний вид ссылки на vk
UPDATE profiles SET link_vk = CONCAT('https://vk.com/id_', FLOOR(RAND()*(999999-100001))+100000); 

-- Меняем id фото пользователя
UPDATE profiles SET photo_id = FLOOR(RAND()*(5000-2001))+2000;

-- Добавляем индекс на столбец birthday
CREATE INDEX profiles_birthday_idx ON profiles(birthday);



-- films
-- Смотрим содержимое
SELECT * FROM films LIMIT 15;

-- Смотрим структуру
DESC films;

-- Смотрим индексы
SHOW INDEX FROM films;

-- Приводим в порядок даты выходов фильмов
UPDATE films, films_profiles SET films.`year` = films_profiles.premiere_world WHERE films.id = films_profiles.film_id;

-- Добавляем индексы на столбец name_ru, name_original, year, country
CREATE INDEX films_name_ru_idx ON films(name_ru);
CREATE INDEX films_name_original_idx ON films(name_original);
CREATE INDEX films_year_idx ON films(`year`);
CREATE INDEX films_country_idx ON films(country);



-- films_profiles
-- Смотрим содержимое
SELECT * FROM films_profiles LIMIT 15;

-- Смотрим структуру
DESC films_profiles;

-- Смотрим индексы
SHOW INDEX FROM films_profiles;

-- Приводим в порядок даты выходов фильмов
UPDATE 
  films_profiles 
SET 
    premiere_ru = DATE_ADD(premiere_world, INTERVAL 21 DAY),  
    premiere_dvd = DATE_ADD(premiere_world, INTERVAL 90 DAY);
   
-- Улучшаем внешний вид ссылки на фильмы
UPDATE films_profiles SET link = CONCAT('https://kinopoisk.ru/film_', FLOOR(RAND()*(999999-100001))+100000); 
   
-- Улучшаем внешний вид ссылки на трейлеры
UPDATE films_profiles SET trailer_link = CONCAT('https://kinopoisk.ru/trailer_', FLOOR(RAND()*(999999-100001))+100000); 

-- Добавляем индексы на столбецы budget, premiere_world, premiere_ru
CREATE INDEX films_profiles_budget_idx ON films_profiles(budget);
CREATE INDEX films_profiles_premiere_world_idx ON films_profiles(premiere_world);
CREATE INDEX films_profiles_premiere_ru_idx ON films_profiles(premiere_ru);



-- genre
-- Смотрим содержимое
SELECT * FROM genre LIMIT 15;

-- Смотрим структуру
DESC genre;

-- Смотрим индексы
SHOW INDEX FROM genre;



-- reviews
-- Смотрим содержимое
SELECT * FROM reviews LIMIT 15;

-- Смотрим структуру
DESC reviews;

-- Смотрим индексы
SHOW INDEX FROM reviews;

-- Приводим в порядок даты
UPDATE reviews SET updated_at = created_at WHERE created_at > updated_at;



-- rating
-- Смотрим содержимое
SELECT * FROM rating LIMIT 15;

-- Смотрим структуру
DESC rating;

-- Смотрим индексы
SHOW INDEX FROM rating;



-- film_crews
-- Смотрим содержимое
SELECT * FROM film_crews LIMIT 15;

-- Смотрим структуру
DESC film_crews;

-- Смотрим индексы
SHOW INDEX FROM film_crews;



-- awards
-- Смотрим содержимое
SELECT * FROM awards LIMIT 15;

-- Смотрим структуру
DESC awards;

-- Смотрим индексы
SHOW INDEX FROM awards;

