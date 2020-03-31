USE kinopoisk


-- Выведем имена участников съемочной группы фильма
SELECT GROUP_CONCAT(CONCAT(u.first_name, ' ', u.last_name) SEPARATOR ', '),
  fc.`role`
  FROM film_crews fc 
    JOIN users u
      ON fc.user_id = u.id   
  WHERE film_id  = 359
  GROUP BY fc.`role`;


-- Выведем имена 10 самых неактивных пользователей
-- За критерий активности возьмем 2 параметра: Количество написаных отзывов и количество проставленного рейтинга
-- Введем есовые коэффициенты для каждого критерия
SELECT CONCAT(first_name, ' ', last_name) AS 'user'
FROM users
ORDER BY 
 (SELECT COUNT(*) FROM reviews WHERE user_id = users.id) * 1 +
 (SELECT COUNT(*) FROM rating WHERE user_id = users.id) * 0.5
LIMIT 10;


-- Выведем список ужастиков с сортировкой по рейтингу. 
-- В вывод добавим год, страну и сслыку на обложку
SELECT f.name_ru AS `Имя`,
  f.name_original AS `Name`,
  YEAR(f.`year`) AS `Год`,
  f.country AS `Страна`,
  photo.filename AS `Обложка`,
  AVG(rating.value) AS `Рейтинг`
  FROM films f 
    JOIN genre g 
      ON f.id = g.film_id 
    JOIN photo
      ON f.id = photo.id 
    JOIN rating 
  	  ON f.id = rating.film_id
  WHERE 
    g.genre_enum = 'Horror'
  GROUP BY rating.film_id 
  ORDER BY `Рейтинг` DESC;
   

-- Подсчитаем количество отзывов к 10 самых новым фильмам
SELECT SUM(reviews_total) AS `Итог`
  FROM
   (SELECT COUNT(*) AS reviews_total
    FROM 
    films f 
      JOIN reviews 
        ON f.id = reviews.film_id
    GROUP BY reviews.film_id
    ORDER BY f.`year` 
    DESC LIMIT 10) 
  AS reviews_count;
 

-- Определить, кто больше поставил оценок (всего) - мужчины или женщины
SELECT (CASE(gender)
		WHEN 'm' THEN 'man'
		WHEN 'f' THEN 'woman'
  END) AS gender,
  COUNT(r.film_id) AS rating_count
  FROM rating r
    JOIN profiles 
      ON r.user_id = profiles.user_id 
  GROUP BY profiles.gender
  ORDER BY rating_count
  DESC LIMIT 1;
      
      