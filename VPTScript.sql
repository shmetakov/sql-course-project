USE kinopoisk


-- Представления

-- Представление top_films_50 выводит Топ 50 лучших фильмов 
-- по рейтингу Кинопоиска. Является аналогом Топ 250

CREATE OR REPLACE VIEW top_films_50 AS
SELECT films.name_ru AS `Имя`, 
  films.name_original AS `Name`,
  photo.filename AS `Обложка`,
  YEAR(films.year) AS `Год`, 
  films.country AS `Страна`,
  AVG(rating.value) AS `Рейтинг`
  FROM films
    JOIN photo 
      ON films.photo_id = photo.id 
  	JOIN rating 
  	  ON films.id = rating.film_id
  GROUP BY rating.film_id 
  ORDER BY `Рейтинг` DESC
  LIMIT 50;
  

SELECT * FROM top_films_50 ;
 
-- Представление detaile_info_films выводит подробную информацию о фильме

CREATE OR REPLACE VIEW detaile_info_films AS
SELECT films.id,
  films.name_ru AS `Имя`,
  films.name_original AS `Name`,
  photo.filename AS `Обложка`,
  YEAR(films.year) AS `Год`, 
  films.country AS `Страна`,
  AVG(rating.value) AS `Рейтинг`,
  films_profiles.`time` AS `Время`,
  films_profiles.trailer_link AS `Трейлер`,
  films_profiles.price AS `Цена`,
  films_profiles.description AS `Описание`,
  films_profiles.tagline AS `Девиз`,
  films_profiles.budget AS `Бюджет`,
  films_profiles.premiere_world AS `Премьера (мир)`,
  films_profiles.premiere_ru AS `Премьера (Россия)`,
  films_profiles.premiere_dvd AS `Премьера (DVD)`,
  films_profiles.age AS `Возраст`,
  tmp.gen AS `Жанр`
  FROM films
    JOIN photo 
      ON films.photo_id = photo.id 
  	JOIN rating 
  	  ON films.id = rating.film_id
  	JOIN films_profiles 
  	  ON films.id = films_profiles.film_id
 	JOIN (SELECT film_id AS id, 
 	        GROUP_CONCAT(genre_enum) AS gen 
 	        FROM genre 
 	      GROUP BY film_id) 
 	      AS tmp 
 	  ON films.id = tmp.id 
  GROUP BY rating.film_id;
 
SELECT * FROM detaile_info_films WHERE id = 1;

-- Тригеры

-- Добавляем новую запись в profiles при создании нового пользователя

DELIMITER //

DROP TRIGGER IF EXISTS profiles_users_insert;
CREATE TRIGGER profiles_users_insert AFTER INSERT ON users
FOR EACH ROW 
BEGIN 
	INSERT INTO profiles (user_id, photo_id) VALUES (NEW.id, 1);
END//

DELIMITER ;

-- При удалении пользователя удаляется вся его информация в талицах profiles, rating, reviews

DELIMITER //

DROP TRIGGER IF EXISTS users_delete;
CREATE TRIGGER users_delete BEFORE DELETE ON users
FOR EACH ROW 
BEGIN 
	DELETE FROM profiles WHERE user_id = OLD.id;
	DELETE FROM reviews WHERE user_id = OLD.id;
	DELETE FROM rating WHERE user_id = OLD.id;
END//

DELIMITER ;

-- При удалении фильма удаляется вся его информация в таблицах films_profiles, film_crews
-- reviews, rating, awards, genre

DELIMITER //

DROP TRIGGER IF EXISTS films_delete;
CREATE TRIGGER films_delete BEFORE DELETE ON films
FOR EACH ROW 
BEGIN 
	DELETE FROM films_profiles WHERE film_id = OLD.id;
	DELETE FROM film_crews WHERE film_id = OLD.id;
	DELETE FROM reviews WHERE film_id = OLD.id;
	DELETE FROM rating WHERE film_id = OLD.id;
	DELETE FROM awards WHERE film_id = OLD.id;
	DELETE FROM genre WHERE film_id = OLD.id;
END//

DELIMITER ;


-- Создаём процедуру

-- Формирование формы вида "Возможно, вам будет интересно посмотреть..."
-- Варианты:
-- одинаковый жанр
-- один режисер
-- схожий актерский состав
-- Из выборки показываем 5 фильмов в случайной комбинации.

DROP PROCEDURE IF EXISTS films_offers;

DELIMITER //

CREATE PROCEDURE films_offers (IN for_film_id INT)
  BEGIN 
    (
      SELECT DISTINCT g2.film_id 
        FROM genre g1
          JOIN genre g2
            ON g1.genre_enum = g2.genre_enum 
        WHERE g1.film_id = for_film_id 
        
      UNION        
      
      SELECT DISTINCT fc2.film_id
        FROM film_crews fc1 
          JOIN film_crews fc2
            ON fc1.user_id = fc2.user_id 
        WHERE fc1.film_id = for_film_id AND fc2.`role` = 'composer'
        
      UNION
      
      SELECT DISTINCT fc2.film_id
        FROM film_crews fc1 
          JOIN film_crews fc2
            ON fc1.user_id = fc2.user_id 
        WHERE fc1.film_id = for_film_id AND fc2.`role` = 'actor'
    )
    
    ORDER BY RAND()
    LIMIT 5;
   
END//
  
DELIMITER ;

